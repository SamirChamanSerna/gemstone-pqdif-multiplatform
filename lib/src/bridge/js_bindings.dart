import 'dart:js_interop';

@JS('dotnetPQDIF')
extension type DotnetPQDIFBindings._(JSObject _) implements JSObject {
  external JSUint8Array getFileMetadataWasm(JSUint8Array? fileBytes, JSString? filePath);
  external JSString getRuntimeInfo();
  external JSUint8Array getSeriesWindowWasm(
    JSUint8Array? fileBytes, 
    JSString? filePath, 
    JSUint8Array requestBytes
  );
}

@JS('window.dotnetPQDIF')
external DotnetPQDIFBindings? get dotnetPQDIF;