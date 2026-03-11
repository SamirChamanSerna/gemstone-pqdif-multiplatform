import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

import 'bridge_interface.dart';
import 'js_bindings.dart';

// Implementacion web que maneja el ciclo de vida del script principal
class WebPQDIFBridge implements IPQDIFBridge {
  final Completer<void> _initCompleter = Completer<void>();
  bool _isInitializing = false;

  @override
  Future<void> initialize() async {
    // Es idempotente: solo inicializa una vez.
    if (_initCompleter.isCompleted || _isInitializing) {
      return _initCompleter.future;
    }
    _isInitializing = true;

    try {
      if (dotnetPQDIF != null) {
        _initCompleter.complete();
        return;
      }

      // Inyectar el orquestador JS del sdk .NET 
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
  Future<double> add(double a, double b) async {
    await _waitForInit();
    try {
      final result = dotnetPQDIF!.add(a.toJS, b.toJS);
      return result.toDartDouble;
    } catch (e) {
      throw Exception('Excepcion interna al llamar a Add() de C#: $e');
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

  Future<void> _waitForInit() async {
    if (!_initCompleter.isCompleted) {
      await _initCompleter.future;
    }
    if (dotnetPQDIF == null) {
      throw Exception('El motor .NET se cargo pero no expuso las funciones esperadas.');
    }
  }
}

// Selector exportado que llama internamente en modo web
IPQDIFBridge createBridge() => WebPQDIFBridge();
