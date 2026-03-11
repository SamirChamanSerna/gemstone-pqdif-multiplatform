import 'dart:js_interop';

// Extension Type para mapear los bindings estaticos generados en main.js de .NET WASM
@JS('dotnetPQDIF')
extension type DotnetPQDIFBindings._(JSObject _) implements JSObject {
  external JSNumber add(JSNumber a, JSNumber b);
  external JSString getRuntimeInfo();
}

// Expone el objeto inyectado en la variable global window
@JS('window.dotnetPQDIF')
external DotnetPQDIFBindings? get dotnetPQDIF;
