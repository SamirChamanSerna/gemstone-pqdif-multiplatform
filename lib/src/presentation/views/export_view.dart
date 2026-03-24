import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/pqdif_writer_provider.dart';
import '../../providers/pqdif_series_provider.dart';
import '../widgets/export_progress_overlay.dart';

class ExportView extends ConsumerStatefulWidget {
  const ExportView({super.key});

  @override
  ConsumerState<ExportView> createState() => _ExportViewState();
}

class _ExportViewState extends ConsumerState<ExportView> {
  final _siteNameController = TextEditingController(text: "Site 1");
  final _equipmentIdController = TextEditingController(text: "Equipment 1");
  final _vendorNameController = TextEditingController(text: "Gemstone PQDIF Multiplatform");

  @override
  void dispose() {
    _siteNameController.dispose();
    _equipmentIdController.dispose();
    _vendorNameController.dispose();
    super.dispose();
  }

  void _onExportPressed() {
    final seriesState = ref.read(pqdifSeriesProvider).valueOrNull;
    if (seriesState == null || seriesState.selectedChannels.isEmpty) return;

    ref.read(pqdifWriterProvider.notifier).exportFile(
      filePath: "", // Web will ignore this, Native needs a real path (left empty for demo since we're mostly web)
      siteName: _siteNameController.text,
      equipmentId: _equipmentIdController.text,
      vendorName: _vendorNameController.text,
      selectedChannelIds: seriesState.selectedChannels.toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final writerState = ref.watch(pqdifWriterProvider);
    final seriesState = ref.watch(pqdifSeriesProvider).valueOrNull;

    ref.listen(pqdifWriterProvider, (prev, next) {
      if (next.status == ExportStatus.done) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Exportacion exitosa')));
        Navigator.of(context).pop();
      } else if (next.status == ExportStatus.error) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error de exportacion'),
            content: Text(next.errorMessage ?? 'Error desconocido'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))
            ],
          ),
        );
      }
    });

    final bool isExporting = writerState.status == ExportStatus.working;
    final bool hasSelection = seriesState != null && seriesState.selectedChannels.isNotEmpty;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text("Exportar PQDIF")),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Metadatos del Equipo", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextField(controller: _siteNameController, decoration: const InputDecoration(labelText: 'Site Name')),
                TextField(controller: _equipmentIdController, decoration: const InputDecoration(labelText: 'Equipment ID')),
                TextField(controller: _vendorNameController, decoration: const InputDecoration(labelText: 'Vendor / Manufacturer')),
                const SizedBox(height: 20),
                const Text("Canales Seleccionados", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (seriesState != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: seriesState.selectedChannels.length,
                      itemBuilder: (context, index) {
                        final channelId = seriesState.selectedChannels.elementAt(index);
                        return ListTile(
                          title: Text('Canal $channelId'),
                          leading: const Icon(Icons.check_box),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: hasSelection && !isExporting ? _onExportPressed : null,
                    child: const Text("Exportar"),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExporting)
          ExportProgressOverlay(
            progress: writerState.progress,
            statusText: "Procesando observaciones...",
          )
      ],
    );
  }
}
