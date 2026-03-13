import 'dart:typed_data';
import 'bridge_interface.dart';

class StubPQDIFBridge implements IPQDIFBridge {
  @override
  Future<void> initialize() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<PqdifMetadataResponse> getMetadata({Uint8List? bytes, String? path}) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<String> getRuntimeInfo() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }
}

IPQDIFBridge createBridge() => StubPQDIFBridge();