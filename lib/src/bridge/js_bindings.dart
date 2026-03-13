import 'dart:js_interop';

@JS('JSON.parse')
external JSObject parseJson(JSString str);

extension type PqdifMetadataResponseJS._(JSObject _) implements JSObject {
  external JSString get VendorName;
  external JSString get EquipmentName;
  external JSNumber get ObservationCount;
  external JSBoolean get IsSuccess;
  external JSString get ErrorMessage;
}

@JS('dotnetPQDIF')
extension type DotnetPQDIFBindings._(JSObject _) implements JSObject {
  external JSPromise<JSString> getFileMetadata(JSUint8Array? fileBytes, JSString? filePath);
  external JSString getRuntimeInfo();
  external JSUint8Array getSeriesWindowWasm(
    JSUint8Array? fileBytes, 
    JSString? filePath, 
    JSNumber obsIdx, 
    JSNumber chIdx, 
    JSNumber start, 
    JSNumber end, 
    JSNumber targetPoints
  );
}

@JS('window.dotnetPQDIF')
external DotnetPQDIFBindings? get dotnetPQDIF;