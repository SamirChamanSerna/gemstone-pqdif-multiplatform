import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:ffi/ffi.dart';

import 'bridge_interface.dart';
import '../generated/series_data.pb.dart';

typedef GetFileMetadataNativeC = Int32 Function(Pointer<Utf8> filePathPtr, Pointer<Pointer<Uint8>> outBufferPtr, Pointer<Int32> outBufferLen);
typedef GetFileMetadataNativeDart = int Function(Pointer<Utf8> filePathPtr, Pointer<Pointer<Uint8>> outBufferPtr, Pointer<Int32> outBufferLen);

typedef GetSeriesWindowNativeC = Int32 Function(Pointer<Utf8> filePathPtr, Pointer<Uint8> requestBytesPtr, Int32 requestBytesLen, Pointer<Pointer<Uint8>> outBufferPtr, Pointer<Int32> outBufferLen);
typedef GetSeriesWindowNativeDart = int Function(Pointer<Utf8> filePathPtr, Pointer<Uint8> requestBytesPtr, int requestBytesLen, Pointer<Pointer<Uint8>> outBufferPtr, Pointer<Int32> outBufferLen);

typedef FreeSeriesBufferC = Void Function(Pointer<Uint8> ptr);
typedef FreeSeriesBufferDart = void Function(Pointer<Uint8> ptr);

class NativePQDIFBridge implements IPQDIFBridge {
  late DynamicLibrary _dylib;
  late GetFileMetadataNativeDart _getFileMetadataNative;
  late GetSeriesWindowNativeDart _getSeriesWindowNative;
  late FreeSeriesBufferDart _freeSeriesBuffer;

  @override
  Future<void> initialize() async {
    if (Platform.isWindows) {
      _dylib = DynamicLibrary.open('PQDIFWrapper.dll');
    } else if (Platform.isMacOS) {
      _dylib = DynamicLibrary.open('libPQDIFWrapper.dylib');
    } else {
      _dylib = DynamicLibrary.open('libPQDIFWrapper.so');
    }

    _getFileMetadataNative = _dylib.lookupFunction<GetFileMetadataNativeC, GetFileMetadataNativeDart>('get_file_metadata_native');
    _getSeriesWindowNative = _dylib.lookupFunction<GetSeriesWindowNativeC, GetSeriesWindowNativeDart>('get_series_window_native');
    _freeSeriesBuffer = _dylib.lookupFunction<FreeSeriesBufferC, FreeSeriesBufferDart>('free_series_buffer');
  }

  @override
  Future<FileMetadataResponse> getMetadata({Uint8List? bytes, String? path}) async {
    if (path == null) {
      throw Exception('Native bridge requires a file path.');
    }

    final pathPtr = path.toNativeUtf8();
    final outBufferPtr = calloc<Pointer<Uint8>>();
    final outBufferLen = calloc<Int32>();

    try {
      final result = _getFileMetadataNative(pathPtr, outBufferPtr, outBufferLen);
      
      if (outBufferLen.value > 0 && outBufferPtr.value != nullptr) {
        final buffer = outBufferPtr.value.asTypedList(outBufferLen.value);
        final copy = Uint8List.fromList(buffer);
        _freeSeriesBuffer(outBufferPtr.value);
        
        final response = FileMetadataResponse.fromBuffer(copy);
        if (result != 0 || !response.isSuccess) {
          throw Exception('Native error: ${response.errorMessage}');
        }
        return response;
      }
      throw Exception('Native returned empty buffer');
    } finally {
      calloc.free(pathPtr);
      calloc.free(outBufferPtr);
      calloc.free(outBufferLen);
    }
  }

  @override
  Future<String> getRuntimeInfo() async {
    return "Native Platform";
  }

  @override
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path}) async {
    if (path == null) {
      throw Exception('Native bridge requires a file path.');
    }

    final pathPtr = path.toNativeUtf8();
    final outBufferPtr = calloc<Pointer<Uint8>>();
    final outBufferLen = calloc<Int32>();
    
    final requestBytes = request.writeToBuffer();
    final requestBytesPtr = calloc<Uint8>(requestBytes.length);
    final requestBytesList = requestBytesPtr.asTypedList(requestBytes.length);
    requestBytesList.setAll(0, requestBytes);

    try {
      final result = _getSeriesWindowNative(pathPtr, requestBytesPtr, requestBytes.length, outBufferPtr, outBufferLen);
      
      if (outBufferLen.value > 0 && outBufferPtr.value != nullptr) {
        final buffer = outBufferPtr.value.asTypedList(outBufferLen.value);
        final copy = Uint8List.fromList(buffer);
        _freeSeriesBuffer(outBufferPtr.value);
        
        final response = SeriesWindowResponse.fromBuffer(copy);
        if (result != 0 || !response.isSuccess) {
          throw Exception('Native error: ${response.errorMessage}');
        }
        return response;
      }
      throw Exception('Native returned empty buffer');
    } finally {
      calloc.free(pathPtr);
      calloc.free(outBufferPtr);
      calloc.free(outBufferLen);
      calloc.free(requestBytesPtr);
    }
  }
}

IPQDIFBridge createBridge() => NativePQDIFBridge();
