import 'package:flutter/material.dart';
import '../../generated/series_data.pb.dart';

class FaultBox extends StatelessWidget {
  final List<FaultEvent> faults;

  const FaultBox({super.key, required this.faults});

  @override
  Widget build(BuildContext context) {
    if (faults.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Eventos de Falla Detectados:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
          const SizedBox(height: 8),
          ...faults.map((f) => Text('- [${f.eventType}] Magnitud: ${f.magnitude.toStringAsFixed(2)}, Duración: ${f.durationMs.toStringAsFixed(2)}ms, Ch: ${f.channelIndex} (${f.description})')),
        ],
      ),
    );
  }
}
