import 'bridge_interface.dart';

import 'native_bridge.dart' if (dart.library.js_interop) 'web_bridge.dart';

// Instancia global exportada segun target de compilacion web o nativo.
final IPQDIFBridge pqdifBridge = createBridge();
