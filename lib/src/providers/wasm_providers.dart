import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bridge/bridge_selector.dart';

// Proveedor asincrono para manejar el ciclo de carga del motor WASM
final wasmBridgeProvider = FutureProvider<void>((ref) async {
  await pqdifBridge.initialize();
});

// Modelo inmutable para el estado del calculo
class CalculationResult {
  final double? result;
  final int latencyMicroseconds;
  final String? error;

  CalculationResult({this.result, this.latencyMicroseconds = 0, this.error});
}

// Notificador de estado de la operacion actual (Suma)
class CalculationNotifier extends Notifier<CalculationResult> {
  @override
  CalculationResult build() => CalculationResult();

  Future<void> add(double a, double b) async {
    final stopwatch = Stopwatch()..start();
    try {
      final res = await pqdifBridge.add(a, b);
      stopwatch.stop();
      state = CalculationResult(
          result: res, latencyMicroseconds: stopwatch.elapsedMicroseconds);
    } catch (e) {
      stopwatch.stop();
      state = CalculationResult(
          error: e.toString(),
          latencyMicroseconds: stopwatch.elapsedMicroseconds);
    }
  }
}

// Proveedor reactivo del estado del calculo
final calculationProvider =
    NotifierProvider<CalculationNotifier, CalculationResult>(
        () => CalculationNotifier());
