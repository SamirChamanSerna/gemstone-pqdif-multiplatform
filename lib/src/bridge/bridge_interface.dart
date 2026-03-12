import 'dart:typed_data';

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
}