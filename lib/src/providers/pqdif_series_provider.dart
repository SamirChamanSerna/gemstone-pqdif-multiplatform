import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bridge/bridge_selector.dart';
import '../generated/series_data.pb.dart';

class SeriesState {
  final Map<int, Float64List> channelData;
  final List<FaultEvent> faults;
  final double executionTimeMs;
  final int currentBucketSize;
  final Set<int> selectedChannels;

  SeriesState({
    required this.channelData,
    required this.faults,
    required this.executionTimeMs,
    required this.currentBucketSize,
    required this.selectedChannels,
  });

  SeriesState copyWith({
    Map<int, Float64List>? channelData,
    List<FaultEvent>? faults,
    double? executionTimeMs,
    int? currentBucketSize,
    Set<int>? selectedChannels,
  }) {
    return SeriesState(
      channelData: channelData ?? this.channelData,
      faults: faults ?? this.faults,
      executionTimeMs: executionTimeMs ?? this.executionTimeMs,
      currentBucketSize: currentBucketSize ?? this.currentBucketSize,
      selectedChannels: selectedChannels ?? this.selectedChannels,
    );
  }
}

class PqdifSeriesNotifier extends AutoDisposeAsyncNotifier<SeriesState> {
  Timer? _debounceTimer;

  @override
  FutureOr<SeriesState> build() {
    return SeriesState(
      channelData: {},
      faults: [],
      executionTimeMs: 0.0,
      currentBucketSize: 1,
      selectedChannels: {},
    );
  }

  void toggleChannel(int channelIndex) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    
    final newSelected = Set<int>.from(currentState.selectedChannels);
    if (newSelected.contains(channelIndex)) {
      newSelected.remove(channelIndex);
    } else {
      newSelected.add(channelIndex);
    }
    
    state = AsyncData(currentState.copyWith(selectedChannels: newSelected));
  }

  void clearChannels() {
    final currentState = state.valueOrNull;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(selectedChannels: {}));
  }

  void fetchWindow({
    required PlatformFile file,
    required int obsIdx,
    required int startIdx,
    required int endIdx,
    required int targetPoints,
  }) {
    final currentState = state.valueOrNull;
    if (currentState == null || currentState.selectedChannels.isEmpty) return;

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _executeFetch(file, obsIdx, currentState.selectedChannels.toList(), startIdx, endIdx, targetPoints);
    });
  }

  Future<void> _executeFetch(
    PlatformFile file,
    int obsIdx,
    List<int> channelIndices,
    int startIdx,
    int endIdx,
    int targetPoints,
  ) async {
    final previousState = state.valueOrNull ?? SeriesState(channelData: {}, faults: [], executionTimeMs: 0, currentBucketSize: 1, selectedChannels: channelIndices.toSet());
    
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
        channelIndices: channelIndices,
        startIndex: startIdx,
        endIndex: endIdx,
        targetPoints: targetPoints,
      );

      SeriesWindowResponse response = await pqdifBridge.getSeriesWindow(
        request: request,
        bytes: bytes,
        path: path,
      );

      stopwatch.stop();

      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }

      final newChannelData = <int, Float64List>{};
      for (var chData in response.channelData) {
        final bytes = Uint8List.fromList(chData.samplesBinary);
        final floatData = Float64List(bytes.length ~/ 8);
        final byteData = ByteData.view(bytes.buffer);
        for (int i = 0; i < floatData.length; i++) {
          floatData[i] = byteData.getFloat64(i * 8, Endian.little);
        }
        newChannelData[chData.channelIndex] = floatData;
      }

      state = AsyncData(previousState.copyWith(
        channelData: newChannelData,
        faults: response.faults,
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