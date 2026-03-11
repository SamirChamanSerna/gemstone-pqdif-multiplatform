import 'bridge_interface.dart';

// Implementacion Stub para plataformas IO (iOS, Android, Windows, Mac, Linux)
// En el hito actual solo es para prevenir fallos de compilacion con js_interop.
class StubPQDIFBridge implements IPQDIFBridge {
  @override
  Future<void> initialize() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada (Hito 1 es solo Web).');
  }

  @override
  Future<double> add(double a, double b) async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada (Hito 1 es solo Web).');
  }

  @override
  Future<String> getRuntimeInfo() async {
    throw UnsupportedError('La plataforma nativa todavia no esta soportada (Hito 1 es solo Web).');
  }
}

// Selector exportado que llama internamente en modo nativo/IO
IPQDIFBridge createBridge() => StubPQDIFBridge();
