import 'package:flutter/material.dart';

class ExportProgressOverlay extends StatelessWidget {
  final double progress;
  final String statusText;

  const ExportProgressOverlay({
    super.key,
    required this.progress,
    required this.statusText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5),
      child: Center(
        child: Card(
          elevation: 10,
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Exportando PQDIF", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  width: 250,
                  child: LinearProgressIndicator(value: progress),
                ),
                const SizedBox(height: 10),
                Text(statusText),
                const SizedBox(height: 10),
                Text("${(progress * 100).toStringAsFixed(1)}%"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
