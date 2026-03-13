import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pqdif_analysis_provider.dart';

class WasmStatusWidget extends ConsumerWidget {
  const WasmStatusWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Escucha el estado del FutureProvider del WASM
    final bridgeState = ref.watch(wasmBridgeProvider);

    return bridgeState.when(
      data: (_) => const Chip(
        label: Text('.NET WASM Activo'),
        backgroundColor: Colors.green,
        labelStyle: TextStyle(color: Colors.white),
      ),
      loading: () => const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 8),
          Text('Descargando Runtime .NET...'),
        ],
      ),
      error: (err, stack) => Container(
        padding: const EdgeInsets.all(8),
        color: Colors.red.shade100,
        child: Column(
          children: [
            Text('Error: $err', style: const TextStyle(color: Colors.red)),
            ElevatedButton(
              onPressed: () => ref.refresh(wasmBridgeProvider),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
