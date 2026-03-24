import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

import 'bridge_interface.dart';
import 'js_bindings.dart';
import '../generated/series_data.pb.dart';

class WebPQDIFBridge implements IPQDIFBridge {
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitializing = false;

  @override
  Future<void> initialize() async {
    if (_initCompleter.isCompleted || _isInitializing) {
      return _initCompleter.future;
    }
    _isInitializing = true;

    try {
      if (dotnetPQDIF != null) {
        _initCompleter.complete();
        return;
      }

      final script = web.HTMLScriptElement()
        ..type = 'module'
        ..src = 'dotnet_runtime/main.js';

      script.onload = () {
        _initCompleter.complete();
      }.toJS;

      script.onerror = (web.Event e) {
        _initCompleter.completeError(Exception('Error cargando main.js del WASM.'));
      }.toJS;

      web.document.head!.appendChild(script);
    } catch (e) {
      _initCompleter.completeError(Exception('Fallo al inicializar: $e'));
    }

    return _initCompleter.future;
  }

  @override
  Future<FileMetadataResponse> getMetadata({Uint8List? bytes, String? path}) async {
    await _waitForInit();
    try {
      JSUint8Array? jsBytes = bytes?.toJS;
      JSString? jsPath = path?.toJS;

      final jsResult = dotnetPQDIF!.getFileMetadataWasm(jsBytes, jsPath);
      final resultBytes = jsResult.toDart;
      
      final response = FileMetadataResponse.fromBuffer(resultBytes);
      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }
      return response;
    } catch (e) {
      throw Exception('Excepcion interna al llamar a GetFileMetadata() de C#: $e');
    }
  }

  @override
  Future<String> getRuntimeInfo() async {
    await _waitForInit();
    try {
      final result = dotnetPQDIF!.getRuntimeInfo();
      return result.toDart;
    } catch (e) {
      throw Exception('Excepcion interna al llamar a GetRuntimeInfo() de C#: $e');
    }
  }

  @override
  Future<SeriesWindowResponse> getSeriesWindow({required SeriesWindowRequest request, Uint8List? bytes, String? path}) async {
    await _waitForInit();
    try {
      final jsBytes = bytes?.toJS;
      final jsPath = path?.toJS;
      final jsRequestBytes = request.writeToBuffer().toJS;

      final jsResult = dotnetPQDIF!.getSeriesWindowWasm(
        jsBytes,
        jsPath,
        jsRequestBytes,
      );

      final resultBytes = jsResult.toDart;
      final response = SeriesWindowResponse.fromBuffer(resultBytes);
      if (!response.isSuccess) {
        throw Exception(response.errorMessage);
      }
      return response;
    } catch (e) {
      throw Exception('Excepcion interna al llamar a GetSeriesWindow() de C#: $e');
    }
  }

  Future<void> _waitForInit() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
    if (dotnetPQDIF == null) {
      throw Exception('El motor .NET se cargo pero no expuso las funciones esperadas.');
    }
  }
}

IPQDIFBridge createBridge() => WebPQDIFBridge();
