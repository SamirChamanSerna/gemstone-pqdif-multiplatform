import 'dart:typed_data';
import 'bridge_interface.dart';
import '../generated/series_data.pb.dart';
import '../generated/pqdif_writer.pb.dart';

class StubPQDIFBridge implements IPQDIFBridge {
  @override
  Future<void> initialize() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<FileMetadataResponse> getMetadata({Uint8List? bytes, String? path}) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<String> getRuntimeInfo() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path}) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }
}

class StubPQDIFWriterBridge implements IPQDIFWriterBridge {
  @override
  Future<WriteResponse> initWriteSession(WriteInitRequest request) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<WriteResponse> addObservation(WriteObservationRequest request) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }

  @override
  Future<WriteResponse> finalizeWriteSession() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada.');
  }
}

IPQDIFBridge createBridge() => StubPQDIFBridge();
IPQDIFWriterBridge createWriterBridge(IPQDIFBridge mainBridge) => StubPQDIFWriterBridge();