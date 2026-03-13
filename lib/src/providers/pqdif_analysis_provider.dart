import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bridge/bridge_selector.dart';

final wasmBridgeProvider = FutureProvider<void>((ref) async {
  await pqdifBridge.initialize();
});

class PqdifAnalysisResult {
  final String vendor;
  final String equipment;
  final int observationCount;
  final Duration executionTime;
  final int fileSize;

  PqdifAnalysisResult({
    required this.vendor,
    required this.equipment,
    required this.observationCount,
    required this.executionTime,
    required this.fileSize,
  });
}

class PqdifAnalysisNotifier extends AsyncNotifier<PqdifAnalysisResult?> {
  @override
  FutureOr<PqdifAnalysisResult?> build() {
    return null;
  }

  Future<void> analyzeFile(PlatformFile file) async {
    state = const AsyncLoading();
    final stopwatch = Stopwatch()..start();

    try {
      final size = file.size;
      String? path;
      Uint8List? bytes;

      if (kIsWeb) {
        if (file.bytes == null) {
          throw Exception("No se encontraron bytes en la web.");
        }
        if (size > 500 * 1024 * 1024) {
          throw Exception("Archivo demasiado grande para el entorno web (>500MB).");
        }
        bytes = file.bytes;
      } else {
        path = file.path;
        if (path == null) {
          throw Exception("Ruta de archivo no disponible.");
        }
      }

      final response = await pqdifBridge.getMetadata(bytes: bytes, path: path);

      stopwatch.stop();

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      state = AsyncData(PqdifAnalysisResult(
        vendor: response.vendorName,
        equipment: response.equipmentName,
        observationCount: response.observationCount,
        executionTime: stopwatch.elapsed,
        fileSize: size,
      ));
    } catch (e, st) {
      stopwatch.stop();
      state = AsyncError(e, st);
    }
  }
}

final pqdifAnalysisProvider = AsyncNotifierProvider<PqdifAnalysisNotifier, PqdifAnalysisResult?>(() {
  return PqdifAnalysisNotifier();
});