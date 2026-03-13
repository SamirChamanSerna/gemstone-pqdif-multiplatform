import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pqdif_series_provider.dart';

class WaveformView extends ConsumerStatefulWidget {
  final int channelIndex;
  
  const WaveformView({
    Key? key, 
    required this.channelIndex,
  }) : super(key: key);

  @override
  ConsumerState<WaveformView> createState() => _WaveformViewState();
}

class _WaveformViewState extends ConsumerState<WaveformView> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(pqdifSeriesProvider);

    return Column(
      children: [
        if (state.isLoading)
           const LinearProgressIndicator(),
           
        Expanded(
          child: state.when(
            data: (data) {
              final points = data.channelData[widget.channelIndex];
              if (points == null || points.isEmpty) {
                return const Center(child: Text('Sin datos o canal no cargado.'));
              }
              
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Puntos: ${points.length}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Resolución (Bucket): ${data.currentBucketSize}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Latencia: ${data.executionTimeMs} ms', style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: RepaintBoundary(
                      child: Container(
                        width: double.infinity,
                        color: Colors.black,
                        child: CustomPaint(
                          painter: _WaveformPainter(points, data.currentBucketSize > 1),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: Text('Error: $e')),
          ),
        ),
      ],
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final Float64List points;
  final bool isMinMax;

  _WaveformPainter(this.points, this.isMinMax);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paint = Paint()
      ..color = Colors.cyanAccent
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    double minV = double.infinity;
    double maxV = double.negativeInfinity;
    
    for (int i = 0; i < points.length; i++) {
       if (points[i] < minV) minV = points[i];
       if (points[i] > maxV) maxV = points[i];
    }
    
    if (minV == maxV) {
      minV -= 1.0;
      maxV += 1.0;
    }
    
    double range = maxV - minV;
    final path = Path();
    
    if (isMinMax) {
       int numPairs = points.length ~/ 2;
       double dx = size.width / (numPairs > 1 ? numPairs - 1 : 1);
       
       for (int i = 0; i < numPairs; i++) {
          double x = i * dx;
          double pMin = points[i * 2];
          double pMax = points[i * 2 + 1];
          
          double yMin = size.height - ((pMin - minV) / range) * size.height;
          double yMax = size.height - ((pMax - minV) / range) * size.height;
          
          path.moveTo(x, yMin);
          path.lineTo(x, yMax);
       }
    } else {
       double dx = size.width / (points.length > 1 ? points.length - 1 : 1);
       for (int i = 0; i < points.length; i++) {
          double x = i * dx;
          double y = size.height - ((points[i] - minV) / range) * size.height;
          if (i == 0) path.moveTo(x, y);
          else path.lineTo(x, y);
       }
    }
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.isMinMax != isMinMax;
  }
}
