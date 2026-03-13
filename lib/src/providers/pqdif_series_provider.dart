import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bridge/bridge_selector.dart';
import '../bridge/bridge_interface.dart';
import '../generated/series_data.pb.dart';

class SeriesState {
  final Map<int, Float64List> channelData;
  final double executionTimeMs;
  final int currentBucketSize;

  SeriesState({
    required this.channelData,
    required this.executionTimeMs,
    required this.currentBucketSize,
  });

  SeriesState copyWith({
    Map<int, Float64List>? channelData,
    double? executionTimeMs,
    int? currentBucketSize,
  }) {
    return SeriesState(
      channelData: channelData ?? this.channelData,
      executionTimeMs: executionTimeMs ?? this.executionTimeMs,
      currentBucketSize: currentBucketSize ?? this.currentBucketSize,
    );
  }
}

class PqdifSeriesNotifier extends AutoDisposeAsyncNotifier<SeriesState> {
  Timer? _debounceTimer;

  @override
  FutureOr<SeriesState> build() {
    return SeriesState(
      channelData: {},
      executionTimeMs: 0.0,
      currentBucketSize: 1,
    );
  }

  void fetchWindow({
    required PlatformFile file,
    required int obsIdx,
    required int chIdx,
    required int startIdx,
    required int endIdx,
    required int targetPoints,
  }) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _executeFetch(file, obsIdx, chIdx, startIdx, endIdx, targetPoints);
    });
  }

  Future<void> _executeFetch(
    PlatformFile file,
    int obsIdx,
    int chIdx,
    int startIdx,
    int endIdx,
    int targetPoints,
  ) async {
    final previousState = state.valueOrNull ?? SeriesState(channelData: {}, executionTimeMs: 0, currentBucketSize: 1);
    
    // Maintain previous state to avoid flickering (Z-fighting prevention)
    state = AsyncLoading<SeriesState>().copyWithPrevious(AsyncData(previousState));

    final stopwatch = Stopwatch()..start();

    try {
      String? path;
      Uint8List? bytes;

      if (kIsWeb) {
        if (file.bytes == null) {
          throw Exception("No se encontraron bytes en la web.");
        }
        bytes = file.bytes;
      } else {
        path = file.path;
        if (path == null) {
          throw Exception("Ruta de archivo no disponible.");
        }
      }

      final request = SeriesWindowRequest(
        observationIndex: obsIdx,
        channelIndex: chIdx,
        startIndex: startIdx,
        endIndex: endIdx,
        targetPoints: targetPoints,
      );

      SeriesWindowResponse response;

      if (!kIsWeb) {
        // En nativo idealmente se usa compute, pero primero validaremos la arquitectura WASM
        // Se usaría: response = await compute(_fetchNativeIsolate, {...});
        response = await pqdifBridge.getSeriesWindow(
          request: request,
          bytes: bytes,
          path: path,
        );
      } else {
        response = await pqdifBridge.getSeriesWindow(
          request: request,
          bytes: bytes,
          path: path,
        );
      }

      stopwatch.stop();

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      final newChannelData = Map<int, Float64List>.from(previousState.channelData);
      newChannelData[chIdx] = response.samples;

      state = AsyncData(previousState.copyWith(
        channelData: newChannelData,
        executionTimeMs: stopwatch.elapsedMilliseconds.toDouble(),
        currentBucketSize: response.bucketSize,
      ));
    } catch (e, st) {
      stopwatch.stop();
      state = AsyncError<SeriesState>(e, st).copyWithPrevious(AsyncData(previousState));
    }
  }
}

final pqdifSeriesProvider = AsyncNotifierProvider.autoDispose<PqdifSeriesNotifier, SeriesState>(() {
  return PqdifSeriesNotifier();
});