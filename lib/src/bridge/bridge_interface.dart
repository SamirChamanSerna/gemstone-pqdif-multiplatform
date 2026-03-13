import 'dart:typed_data';
import '../generated/series_data.pb.dart';

class PqdifMetadataResponse {
  final String vendorName;
  final String equipmentName;
  final int observationCount;
  final bool isSuccess;
  final String errorMessage;

  PqdifMetadataResponse({
    required this.vendorName,
    required this.equipmentName,
    required this.observationCount,
    required this.isSuccess,
    required this.errorMessage,
  });
}

abstract class IPQDIFBridge {
  Future<void> initialize();
  Future<PqdifMetadataResponse> getMetadata({Uint8List? bytes, String? path});
  Future<String> getRuntimeInfo();
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path});
}

extension SeriesDataMapping on SeriesWindowResponse {
  Float64List get samples {
    final bytes = samplesBinary as Uint8List;
    return bytes.buffer.asFloat64List(
      bytes.offsetInBytes, 
      bytes.lengthInBytes ~/ 8
    );
  }
}