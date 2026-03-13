import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/pqdif_analysis_provider.dart';
import '../../providers/pqdif_series_provider.dart';
import '../wasm_status_widget.dart';
import 'waveform_view.dart';

class MetadataDashboard extends ConsumerStatefulWidget {
  const MetadataDashboard({super.key});

  @override
  ConsumerState<MetadataDashboard> createState() => _MetadataDashboardState();
}

class _MetadataDashboardState extends ConsumerState<MetadataDashboard> {
  PlatformFile? _currentFile;

  @override
  Widget build(BuildContext context) {
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
              onPressed: isReady ? _pickFile : null,
              icon: const Icon(Icons.folder_open),
              label: const Text('Seleccionar Archivo PQDIF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              flex: 1,
              child: _buildDashboard(analysisState),
            ),
            if (_currentFile != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                   ref.read(pqdifSeriesProvider.notifier).fetchWindow(
                     file: _currentFile!,
                     obsIdx: 0,
                     chIdx: 0,
                     startIdx: 0,
                     endIdx: 1000000, // Simulamos una gran cantidad de puntos para probar el diezmado MinMax
                     targetPoints: 2000,
                   );
                },
                icon: const Icon(Icons.show_chart),
                label: const Text('Cargar Forma de Onda (Obs 0, Ch 0)'),
              ),
              const SizedBox(height: 16),
              const Expanded(
                flex: 2,
                child: WaveformView(channelIndex: 0),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pqd', 'pqdif'],
      withData: true,
    );

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _currentFile = result.files.first;
      });
      ref.read(pqdifAnalysisProvider.notifier).analyzeFile(_currentFile!);
    }
  }

  Widget _buildDashboard(AsyncValue<PqdifAnalysisResult?> state) {
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
            child: ListView(
              children: [
                const Text('Metadatos del Archivo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Vendor'),
                  subtitle: SelectableText(rawFormat(result.vendor)),
                ),
                ListTile(
                  leading: const Icon(Icons.devices),
                  title: const Text('Equipment'),
                  subtitle: SelectableText(rawFormat(result.equipment)),
                ),
                ListTile(
                  leading: const Icon(Icons.data_exploration),
                  title: const Text('Total de Observaciones'),
                  subtitle: Text(
                    result.observationCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.blueAccent),
                  ),
                ),
                const Divider(),
                Text('Tamaño: ${(result.fileSize / 1024 / 1024).toStringAsFixed(2)} MB', style: const TextStyle(color: Colors.grey)),
                Text('Tiempo de lectura: ${result.executionTime.inMilliseconds} ms', style: const TextStyle(color: Colors.grey)),
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