import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pqdif_series_provider.dart';
import '../../generated/series_data.pb.dart';

class WaveformView extends ConsumerStatefulWidget {
  final FileMetadataResponse metadata;
  final int observationIndex;

  const WaveformView({
    Key? key,
    required this.metadata,
    required this.observationIndex,
  }) : super(key: key);

  @override
  ConsumerState<WaveformView> createState() => _WaveformViewState();
}

class _WaveformViewState extends ConsumerState<WaveformView> {
  final List<Color> _colors = [
    Colors.cyanAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.pinkAccent,
    Colors.yellowAccent,
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pqdifSeriesProvider);

    return Column(
      children: [
        if (state.isLoading)
           const LinearProgressIndicator(),
           
        Expanded(
          child: Builder(
            builder: (context) {
              final data = state.valueOrNull;
              
              if (state.hasError) {
                return Center(child: Text('Error: ${state.error}'));
              }
              
              if (data == null && state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (data == null || data.channelData.isEmpty) {
                return const Center(child: Text('Sin datos o canales no cargados.'));
              }
              
              int totalPoints = data.channelData.values.first.length;
              String resolutionText = data.currentBucketSize > 1 
                  ? 'Min-Max (1:${data.currentBucketSize})' 
                  : 'Cruda (1:1)';
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Puntos: $totalPoints', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Res: $resolutionText', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Latencia render: ${data.executionTimeMs} ms', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      child: Container(
                        width: double.infinity,
                        color: Colors.black,
                        child: CustomPaint(
                          painter: _MultiWaveformPainter(
                            data.channelData, 
                            data.currentBucketSize > 1, 
                            _colors,
                            widget.metadata.observations[widget.observationIndex]
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MultiWaveformPainter extends CustomPainter {
  final Map<int, Float64List> channels;
  final bool isMinMax;
  final List<Color> colors;
  final ObservationSummary observationSummary;

  _MultiWaveformPainter(this.channels, this.isMinMax, this.colors, this.observationSummary);

  @override
  void paint(Canvas canvas, Size size) {
    if (channels.isEmpty) return;

    int colorIndex = 0;
    
    // Dibujar malla/grid básica
    final gridPaint = Paint()..color = Colors.grey.withValues(alpha: 0.3)..strokeWidth = 1;
    canvas.drawLine(Offset(0, size.height / 2), Offset(size.width, size.height / 2), gridPaint);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), gridPaint);
    
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    for (final entry in channels.entries) {
      final chIdx = entry.key;
      final points = entry.value;
      
      double cMin = double.infinity;
      double cMax = double.negativeInfinity;
      
      for (int i = 0; i < points.length; i++) {
         if (points[i] < cMin) cMin = points[i];
         if (points[i] > cMax) cMax = points[i];
      }
      
      if (cMin == double.infinity) continue;
      
      double originalMin = cMin;
      double originalMax = cMax;
      
      if (cMin == cMax) {
        cMin -= 1.0;
        cMax += 1.0;
      }
      
      double range = cMax - cMin;
      if (range < 0.000001) {
          cMin -= 1.0;
          cMax += 1.0;
          range = cMax - cMin;
      }
      
      final color = colors[colorIndex % colors.length];
      final paint = Paint()
        ..color = color
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      final path = Path();
      
      if (isMinMax) {
         int numPairs = points.length ~/ 2;
         double dx = size.width / (numPairs > 1 ? numPairs - 1 : 1);
         
         for (int i = 0; i < numPairs; i++) {
            double x = i * dx;
            double pMin = points[i * 2];
            double pMax = points[i * 2 + 1];
            
            double yMin = size.height - ((pMin - cMin) / range) * size.height;
            double yMax = size.height - ((pMax - cMin) / range) * size.height;
            
            path.moveTo(x, yMin);
            path.lineTo(x, yMax);
         }
      } else {
         double dx = size.width / (points.length > 1 ? points.length - 1 : 1);
         for (int i = 0; i < points.length; i++) {
            double x = i * dx;
            double y = size.height - ((points[i] - cMin) / range) * size.height;
            if (i == 0) path.moveTo(x, y);
            else path.lineTo(x, y);
         }
      }
      
      canvas.drawPath(path, paint);
      
      String chName = 'Ch $chIdx';
      try {
        final chDef = observationSummary.channels.firstWhere((c) => c.channelIndex == chIdx);
        chName = '${chDef.channelName} [${chDef.quantityType}]';
      } catch (_) {}
      
      textPainter.text = TextSpan(
        text: '$chName Max: ${originalMax.toStringAsFixed(2)}',
        style: TextStyle(color: color, fontSize: 11, backgroundColor: Colors.black87),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, colorIndex * 35.0 + 5));
      
      textPainter.text = TextSpan(
        text: 'Min: ${originalMin.toStringAsFixed(2)}',
        style: TextStyle(color: color, fontSize: 11, backgroundColor: Colors.black87),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(5, size.height - (colorIndex * 35.0 + 15)));
      
      colorIndex++;
    }
  }

  @override
  bool shouldRepaint(covariant _MultiWaveformPainter oldDelegate) {
    return true; 
  }
}
