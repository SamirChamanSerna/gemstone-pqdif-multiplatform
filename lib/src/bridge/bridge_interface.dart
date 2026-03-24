import 'dart:typed_data';
import '../generated/series_data.pb.dart';

abstract class IPQDIFBridge {
  Future<void> initialize();
  Future<FileMetadataResponse> getMetadata({Uint8List? bytes, String? path});
  Future<String> getRuntimeInfo();
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path});
}

extension SeriesDataMapping on SeriesWindowResponse {
  // If we only had one channel, we would map like this. But now we have multiple channels.
  // The UI will handle it from channel_data list directly.
}