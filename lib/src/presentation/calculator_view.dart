import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/wasm_providers.dart';
import 'wasm_status_widget.dart';

class CalculatorView extends ConsumerStatefulWidget {
  const CalculatorView({super.key});

  @override
  ConsumerState<CalculatorView> createState() => _CalculatorViewState();
}

class _CalculatorViewState extends ConsumerState<CalculatorView> {
  final _aController = TextEditingController();
  final _bController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bridgeState = ref.watch(wasmBridgeProvider);
    final calcState = ref.watch(calculationProvider);
    
    // El boton se habilita unicamente si la promesa del WASM termino y no hay error
    final isReady = !bridgeState.isLoading && !bridgeState.hasError;

    return Scaffold(
      appBar: AppBar(title: const Text('Gemstone PQDIF WASM PoC')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WasmStatusWidget(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _aController,
                    decoration: const InputDecoration(labelText: 'Valor A'),
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _bController,
                    decoration: const InputDecoration(labelText: 'Valor B'),
                    keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: isReady ? _performAdd : null,
              child: const Text('Sumar en C#'),
            ),
            const SizedBox(height: 24),
            const Text('Resultados:', style: TextStyle(fontWeight: FontWeight.bold)),
            if (calcState.error != null)
              Text(
                'Error: ${calcState.error}', 
                style: const TextStyle(color: Colors.red),
              )
            else if (calcState.result != null)
              Text(
                'Resultado: ${calcState.result}\nLatencia: ${calcState.latencyMicroseconds} μs',
              ),
          ],
        ),
      ),
    );
  }

  void _performAdd() {
    final a = double.tryParse(_aController.text);
    final b = double.tryParse(_bController.text);
    if (a != null && b != null) {
      ref.read(calculationProvider.notifier).add(a, b);
    }
  }

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    super.dispose();
  }
}
