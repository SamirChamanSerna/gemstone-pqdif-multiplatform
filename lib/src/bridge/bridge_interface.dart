// Interfaz de abstraccion para llamar al backend de .NET WASM
abstract class IPQDIFBridge {
  Future<void> initialize();
  Future<double> add(double a, double b);
  Future<String> getRuntimeInfo();
}
