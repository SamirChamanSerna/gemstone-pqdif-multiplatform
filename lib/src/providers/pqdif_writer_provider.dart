import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:js_interop';
import 'package:fixnum/fixnum.dart';
import 'package:web/web.dart' as web;

import '../bridge/bridge_selector.dart';
import '../generated/pqdif_writer.pb.dart';
import 'pqdif_series_provider.dart';

enum ExportStatus { idle, working, done, error }

class PqdifWriterState {
  final ExportStatus status;
  final double progress;
  final String? errorMessage;
  final String? resultPath;

  const PqdifWriterState({
    this.status = ExportStatus.idle,
    this.progress = 0.0,
    this.errorMessage,
    this.resultPath,
  });

  PqdifWriterState copyWith({
    ExportStatus? status,
    double? progress,
    String? errorMessage,
    String? resultPath,
  }) {
    return PqdifWriterState(
      status: status ?? this.status,
      progress: progress ?? this.progress,
      errorMessage: errorMessage ?? this.errorMessage,
      resultPath: resultPath ?? this.resultPath,
    );
  }
}

class PqdifWriterNotifier extends AutoDisposeNotifier<PqdifWriterState> {
  @override
  PqdifWriterState build() => const PqdifWriterState();

  Future<void> exportFile({
    required String filePath,
    required String siteName,
    required String equipmentId,
    required String vendorName,
    required List<int> selectedChannelIds,
  }) async {
    state = state.copyWith(status: ExportStatus.working, progress: 0.1, errorMessage: null);

    try {
      // 1. Init Session
      final initReq = WriteInitRequest(
        filePath: filePath,
        equipmentName: equipmentId,
        vendorName: vendorName,
        channels: selectedChannelIds.map((id) => ChannelDefinition(
          channelId: id,
          name: 'Channel $id',
        )),
      );

      final initRes = await pqdifWriterBridge.initWriteSession(initReq);
      if (!initRes.isSuccess) throw Exception(initRes.errorMessage);

      state = state.copyWith(progress: 0.3);

      // 2. Write Observation
      final seriesState = ref.read(pqdifSeriesProvider).valueOrNull;
      if (seriesState == null) throw Exception("No series data available.");

      final obsReq = WriteObservationRequest(
        timestampMs: Int64(DateTime.now().millisecondsSinceEpoch),
        samples: selectedChannelIds.map((id) {
          final floatList = seriesState.channelData[id];
          if (floatList == null) throw Exception("Missing data for channel $id");
          
          final bytes = floatList.buffer.asUint8List(floatList.offsetInBytes, floatList.lengthInBytes);
          return WriteChannelData(
            channelId: id,
            dataRaw: bytes,
          );
        }),
      );

      final obsRes = await pqdifWriterBridge.addObservation(obsReq);
      if (!obsRes.isSuccess) throw Exception(obsRes.errorMessage);

      state = state.copyWith(progress: 0.7);

      // 3. Finalize
      final finalRes = await pqdifWriterBridge.finalizeWriteSession();
      if (!finalRes.isSuccess) throw Exception(finalRes.errorMessage);

      state = state.copyWith(progress: 1.0, status: ExportStatus.done, resultPath: filePath);

      if (kIsWeb && finalRes.fileResult.isNotEmpty) {
        // Blob Management
        final bytes = Uint8List.fromList(finalRes.fileResult);
        final jsArray = bytes.toJS;
        final blob = web.Blob([jsArray].toJS);
        final url = web.URL.createObjectURL(blob);
        
        final anchor = web.HTMLAnchorElement()
          ..href = url
          ..download = "export_${DateTime.now().millisecondsSinceEpoch}.pqd";
        
        anchor.click();
        web.URL.revokeObjectURL(url);
      }

    } catch (e) {
      state = state.copyWith(status: ExportStatus.error, errorMessage: e.toString());
    }
  }
}

final pqdifWriterProvider = AutoDisposeNotifierProvider<PqdifWriterNotifier, PqdifWriterState>(() {
  return PqdifWriterNotifier();
});
