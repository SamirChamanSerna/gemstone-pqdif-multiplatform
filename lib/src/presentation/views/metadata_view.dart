import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/pqdif_analysis_provider.dart';
import '../wasm_status_widget.dart';

class MetadataDashboard extends ConsumerWidget {
  const MetadataDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bridgeState = ref.watch(wasmBridgeProvider);
    final analysisState = ref.watch(pqdifAnalysisProvider);
    
    final isReady = !bridgeState.isLoading && !bridgeState.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Gemstone PQDIF Analizador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WasmStatusWidget(),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: isReady ? () => _pickFile(ref) : null,
              icon: const Icon(Icons.folder_open),
              label: const Text('Seleccionar Archivo PQDIF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildDashboard(analysisState),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pqd', 'pqdif'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      ref.read(pqdifAnalysisProvider.notifier).analyzeFile(file);
    }
  }

  Widget _buildDashboard(AsyncValue<PqdifAnalysisResult?> state) {
    // RAW FORMAT: Imprime exactamente lo que el C# extrajo del binario para fines de depuración y desarrollo.
    String rawFormat(String rawValue) {
      if (rawValue.isEmpty) return '(Valor Vacío en C#)';
      return rawValue; 
    }

    return state.when(
      data: (result) {
        if (result == null) {
          return const Center(child: Text('Seleccione un archivo para analizar.'));
        }
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Datos RAW Extraídos (Desarrollo)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Vendor RAW'),
                  subtitle: SelectableText(rawFormat(result.vendor)),
                ),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Equipment RAW'),
                  subtitle: SelectableText(rawFormat(result.equipment)),
                ),
                ListTile(
                  leading: const Icon(Icons.data_exploration),
                  title: const Text('Total de Observaciones/Eventos'),
                  subtitle: Text(
                    result.observationCount.toString(),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  ),
                ),
                const Spacer(),
                const Divider(),
                Text('Tamaño del archivo: ${(result.fileSize / 1024 / 1024).toStringAsFixed(2)} MB', style: const TextStyle(color: Colors.grey)),
                Text('Tiempo de procesamiento: ${result.executionTime.inMilliseconds} ms', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        );
      },
      error: (err, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 64),
            const SizedBox(height: 16),
            Text('Error: $err', style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
          ],
        ),
      ),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Procesando archivo...'),
          ],
        ),
      ),
    );
  }
}