import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/pqdif_analysis_provider.dart';
import '../../providers/pqdif_series_provider.dart';
import '../wasm_status_widget.dart';
import 'waveform_view.dart';
import '../widgets/fault_box.dart';

class DashboardView extends ConsumerStatefulWidget {
  const DashboardView({super.key});

  @override
  ConsumerState<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  int _selectedObservation = 0;

  @override
  Widget build(BuildContext context) {
    final bridgeState = ref.watch(wasmBridgeProvider);
    final analysisState = ref.watch(pqdifAnalysisProvider);
    final seriesState = ref.watch(pqdifSeriesProvider);
    
    final isReady = !bridgeState.isLoading && !bridgeState.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Gemstone PQDIF Analizador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const WasmStatusWidget(),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: isReady ? _pickFile : null,
              icon: const Icon(Icons.folder_open),
              label: const Text('Seleccionar Archivo PQDIF'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            const SizedBox(height: 16),
            if (analysisState.value != null) ...[
              _buildFileFaultsOverview(analysisState.value!),
              const SizedBox(height: 16),
              _buildMetadataAndControls(analysisState.value!),
              const SizedBox(height: 16),
            ],
            if (analysisState.value != null && seriesState.value != null && seriesState.value!.faults.isNotEmpty)
               FaultBox(faults: seriesState.value!.faults),
            if (analysisState.value != null)
              Expanded(
                child: WaveformView(
                  metadata: analysisState.value!.metadata,
                  observationIndex: _selectedObservation,
                ),
              ),
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
      ref.read(pqdifAnalysisProvider.notifier).analyzeFile(result.files.first);
      ref.read(pqdifSeriesProvider.notifier).clearChannels();
      setState(() {
        _selectedObservation = 0;
      });
    }
  }

  Widget _buildFileFaultsOverview(PqdifAnalysisResult result) {
    final observations = result.metadata.observations;
    final observationsWithFaults = observations.where((o) => o.disturbanceCategory.isNotEmpty && o.disturbanceCategory != 'None').toList();
    
    if (observations.isEmpty) {
      return Card(
        color: Colors.blue.shade50,
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: Colors.blue),
              SizedBox(width: 8),
              Expanded(child: Text('No se encontraron observaciones en el archivo.', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.blueGrey.shade50,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(observationsWithFaults.isNotEmpty ? Icons.warning : Icons.list_alt, 
                     color: observationsWithFaults.isNotEmpty ? Colors.red : Colors.blueGrey),
                const SizedBox(width: 8),
                Text(
                  'Observaciones: ${observations.length} (Fallas pre-calculadas: ${observationsWithFaults.length})', 
                  style: TextStyle(fontWeight: FontWeight.bold, color: observationsWithFaults.isNotEmpty ? Colors.red : Colors.blueGrey, fontSize: 16)
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...observations.map((obs) {
               final isFault = obs.disturbanceCategory.isNotEmpty && obs.disturbanceCategory != 'None';
               return Padding(
                 padding: const EdgeInsets.only(bottom: 8.0),
                 child: Row(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Icon(isFault ? Icons.error_outline : Icons.check_circle_outline, 
                          color: isFault ? Colors.red : Colors.green, size: 18),
                     const SizedBox(width: 8),
                     Expanded(
                       child: Text(
                         '[Obs ${obs.observationIndex}] ${obs.observationName}\n  Inicio: ${obs.startTime}' + 
                         (isFault ? '\n  Falla: ${obs.disturbanceCategory} (${obs.disturbanceDescription})' : ''),
                         style: const TextStyle(color: Colors.black87),
                       ),
                     ),
                   ],
                 ),
               );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataAndControls(PqdifAnalysisResult result) {
    if (result.metadata.observations.isEmpty) return const Text('Sin observaciones');

    if (_selectedObservation >= result.metadata.observations.length) {
      _selectedObservation = 0;
    }
    final obs = result.metadata.observations[_selectedObservation];
    final selectedChannels = ref.watch(pqdifSeriesProvider.select((s) => s.valueOrNull?.selectedChannels ?? {}));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Vendor: ${result.metadata.manufacturer} | Equipment: ${result.metadata.equipmentModel}'),
            Text('Tamaño: ${(result.fileSize / 1024).toStringAsFixed(2)} KB | Latencia Análisis: ${result.executionTime.inMilliseconds} ms', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Observación: '),
                DropdownButton<int>(
                  value: _selectedObservation,
                  items: List.generate(
                    result.metadata.observations.length,
                    (index) => DropdownMenuItem(
                      value: index,
                      child: Text('Obs $index: ${result.metadata.observations[index].observationName}'),
                    ),
                  ),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() => _selectedObservation = val);
                      ref.read(pqdifSeriesProvider.notifier).clearChannels();
                    }
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: selectedChannels.isNotEmpty ? () {
                    ref.read(pqdifSeriesProvider.notifier).fetchWindow(
                      file: result.file,
                      obsIdx: _selectedObservation,
                      startIdx: 0,
                      endIdx: 1000000,
                      targetPoints: 2000,
                    );
                  } : null,
                  child: const Text('Cargar Canales'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: obs.channels.map((ch) {
                final isSelected = selectedChannels.contains(ch.channelIndex);
                return FilterChip(
                  label: Text('${ch.channelName} (${ch.phase})'),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    ref.read(pqdifSeriesProvider.notifier).toggleChannel(ch.channelIndex);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
