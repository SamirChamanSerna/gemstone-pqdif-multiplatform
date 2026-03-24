import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bridge/bridge_selector.dart';
import '../generated/series_data.pb.dart';

final wasmBridgeProvider = FutureProvider<void>((ref) async {
  await pqdifBridge.initialize();
});

class PqdifAnalysisResult {
  final FileMetadataResponse metadata;
  final Duration executionTime;
  final int fileSize;
  final PlatformFile file;

  PqdifAnalysisResult({
    required this.metadata,
    required this.executionTime,
    required this.fileSize,
    required this.file,
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
        metadata: response,
        executionTime: stopwatch.elapsed,
        fileSize: size,
        file: file,
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