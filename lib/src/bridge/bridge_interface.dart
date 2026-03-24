import 'dart:typed_data';
import '../generated/series_data.pb.dart';
import '../generated/pqdif_writer.pb.dart';

abstract class IPQDIFBridge {
  Future<void> initialize();
  Future<FileMetadataResponse> getMetadata({Uint8List? bytes, String? path});
  Future<String> getRuntimeInfo();
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path});
}

abstract class IPQDIFWriterBridge {
  Future<WriteResponse> initWriteSession(WriteInitRequest request);
  Future<WriteResponse> addObservation(WriteObservationRequest request);
  Future<WriteResponse> finalizeWriteSession();
}