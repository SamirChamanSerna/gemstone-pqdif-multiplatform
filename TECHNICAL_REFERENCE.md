# Referencia Técnica: gemstone-pqdif-multiplatform

Bienvenido a la referencia técnica detallada del proyecto. Este documento explica paso a paso, archivo por archivo, la arquitectura y el propósito de cada componente del código fuente.

## Índice

1. [Módulo 1: Native Wrapper (.NET WASM)](#módulo-1-native-wrapper-net-wasm)
   - [PQDIFWrapper.csproj](#pqdifwrappercsproj)
   - [Program.cs](#programcs)
   - [Operations.cs](#operationscs)
   - [main.js](#mainjs)
2. [Módulo 2: Flutter Bridge e Interoperabilidad Dart](#módulo-2-flutter-bridge-e-interoperabilidad-dart)
   - [bridge_interface.dart](#bridge_interfacedart)
   - [js_bindings.dart](#js_bindingsdart)
   - [web_bridge.dart](#web_bridgedart)
   - [stub_bridge.dart](#stub_bridgedart)
   - [bridge_selector.dart](#bridge_selectordart)
3. [Módulo 3: Orquestador de Build y Automatización](#módulo-3-orquestador-de-build-y-automatización)
   - [build_wasm.dart](#build_wasmdart)
4. [Módulo 4: UI y Gestión de Estado (Riverpod)](#módulo-4-ui-y-gestión-de-estado-riverpod)
   - [wasm_providers.dart](#wasm_providersdart)
   - [wasm_status_widget.dart](#wasm_status_widgetdart)
   - [calculator_view.dart](#calculator_viewdart)

---

## Módulo 1: Native Wrapper (.NET WASM)

**Ubicación:** `/native_wrapper/`

Este directorio contiene el proyecto "Backend" escrito en C# (.NET 8.0) que se compila a WebAssembly (WASM). Su propósito es servir como un motor de cálculo de alto rendimiento, ejecutándose nativamente dentro del navegador, aislado de Flutter, pero exponiendo métodos para que el frontend pueda consumirlos.

### `PQDIFWrapper.csproj`
**Propósito:** Es el archivo de configuración estructural del proyecto .NET. Define cómo el compilador debe interpretar y construir la aplicación.

**Funcionalidad Clave:**
*   **`Sdk="Microsoft.NET.Sdk.WebAssembly"`**: Indica que el proyecto utiliza el SDK específico para compilar hacia WebAssembly en lugar de crear un binario tradicional de escritorio o de servidor (como un `.exe` o `.dll` normal).
*   **`<TargetFramework>net8.0</TargetFramework>`**: Define la versión del motor de .NET utilizada.
*   **`<AllowUnsafeBlocks>true</AllowUnsafeBlocks>`**: Permite el uso de código no seguro (manejo manual de punteros en memoria). Es una preparación técnica para futuros hitos, donde la manipulación directa de memoria será obligatoria para leer archivos binarios pesados de forma ultra-rápida.
*   **`<PublishTrimmed>true</PublishTrimmed>`**: Activa el "Trimming" (recorte). Durante la compilación, el compilador analiza el código y elimina toda la parte de la biblioteca estándar de .NET que no se esté utilizando. Esto reduce drásticamente el tamaño final del archivo `.wasm` para que el usuario no tenga que descargar megabytes innecesarios al abrir la página web.
*   **`<WasmMainJSPath>main.js</WasmMainJSPath>`**: Le indica al compilador de .NET cuál es el archivo JavaScript de inicialización ("glue code") personalizado que orquestará el arranque del motor en el navegador.

### `Program.cs`
**Propósito:** Es el punto de entrada estándar del ciclo de vida de la aplicación .NET.

**Funcionalidad Clave:**
*   Contiene el método `Main()`. En el contexto de WASM, este método se ejecuta automáticamente justo después de que el motor de .NET termina de inicializarse en el navegador y está listo para recibir comandos.
*   Actualmente, su función es imprimir `Console.WriteLine("PQDIF WASM Module Initialized.");`. Esto resulta sumamente útil para propósitos de diagnóstico, ya que permite ver en la consola de Google Chrome (DevTools) la confirmación visual de que el runtime "despertó" correctamente en el entorno de WebAssembly sin errores silenciosos.

### `Operations.cs`
**Propósito:** Es el corazón lógico del Hito 1. Aquí reside la lógica de negocio (operaciones matemáticas y validaciones) que ejecutaremos desde la interfaz de Flutter.

**Funcionalidad Clave:**
*   **Atributo `[JSExport]`**: Proviene del paquete `System.Runtime.InteropServices.JavaScript`. Este atributo es "mágico": le indica al compilador de WebAssembly que genere código intermedio adicional para que esa función de C# específica pueda ser llamada directamente desde el mundo de JavaScript.
*   **Métodos Estáticos**: Define funciones como `public static double Add(double a, double b)`. Se requieren métodos estáticos porque la interoperabilidad entre WebAssembly y JavaScript no tiene una forma nativa o eficiente de instanciar clases completas de objetos complejos en memoria compartida. Llamar a métodos estáticos de entrada y salida directa es la forma más limpia, rápida y de menor sobrecarga computacional.

### `main.js`
**Propósito:** Es el código "pegamento" (Glue Code) y el orquestador principal del lado del navegador. C# por sí solo no puede hablar con el navegador; necesita este script mediador.

**Funcionalidad Clave:**
*   **Importación del motor:** Importa `dotnet` desde el script base (`dotnet.js`) que el compilador genera automáticamente.
*   **Arranque asíncrono:** Llama a `await dotnet.create()` para descargar, parsear y arrancar el motor de WebAssembly en el navegador de manera asíncrona (sin congelar la interfaz del usuario).
*   **Recuperación de exportaciones:** Utiliza `getAssemblyExports` para pedirle al motor de .NET que le entregue una lista de todas las funciones de C# que nosotros marcamos previamente con `[JSExport]`.
*   **El Puente Vital:** Toma esas funciones obtenidas de C# y las "pega" en el objeto global del navegador, creando la variable `window.dotnetPQDIF`. Al hacer esto, disfraza el código de C# como si fueran simples funciones nativas de JavaScript. Esto es crucial, porque deja la mesa puesta para que Flutter (Dart) simplemente llame a estas funciones como lo haría con cualquier otra librería web.

---

## Módulo 2: Flutter Bridge e Interoperabilidad Dart

**Ubicación:** `/lib/src/bridge/`

Este módulo actúa como la capa de abstracción y comunicación. Su objetivo es permitir que el código Dart invoque las funciones del módulo .NET WASM de forma tipada y segura, gestionando la diferencia de ecosistemas entre la Web y las futuras plataformas nativas.

### `bridge_interface.dart`
**Propósito:** Define el contrato (interfaz abstracta) que todas las implementaciones del puente deben cumplir, independientemente de la plataforma.

**Funcionalidad Clave:**
*   Contiene la clase `IPQDIFBridge` con los métodos abstractos `initialize()`, `add()` y `getRuntimeInfo()`.
*   Garantiza que el resto de la aplicación Flutter (UI, Providers) no dependa directamente de integraciones específicas (como JS o JNI), cumpliendo con el principio de Inversión de Dependencias (Clean Architecture).

### `js_bindings.dart`
**Propósito:** Mapear las funciones expuestas en el objeto global de JavaScript (`window.dotnetPQDIF`) para que sean accesibles y tipadas dentro de Dart.

**Funcionalidad Clave:**
*   **`@JS('dotnetPQDIF')`**: Utiliza `dart:js_interop` para decirle al compilador de Dart que confíe en la existencia de este objeto en JavaScript.
*   **Extension Type (`DotnetPQDIFBindings`)**: Es la nueva forma recomendada (Dart 3+) de envolver objetos JS sin costo de rendimiento en tiempo de ejecución (zero-cost abstraction). Mapea los tipos de Dart a tipos JS estandarizados (como `JSNumber`, `JSString`).
*   Expone el getter global `dotnetPQDIF` para que el resto del módulo pueda invocar los métodos reales del motor C# cargado en memoria.

### `web_bridge.dart`
**Propósito:** Es la implementación real del puente diseñada exclusivamente para el entorno del navegador (Web).

**Funcionalidad Clave:**
*   Implementa `IPQDIFBridge`.
*   **Carga Dinámica:** Su método `initialize()` inyecta programáticamente el script `dotnet_runtime/main.js` en el DOM (`web.document.head!.appendChild`). Esto permite que el motor de .NET no se cargue hasta que Flutter se lo pida explícitamente.
*   **Manejo de Ciclo de Vida (`Completer`)**: Asegura que el proceso de inicialización sea *idempotente*. Si el motor tarda en descargar, cualquier llamada de la interfaz a `add()` quedará en pausa (`await _waitForInit()`) en lugar de fallar por objeto nulo, previniendo crashes o condiciones de carrera.
*   **Conversión de Tipos:** Se encarga de traducir los datos de Dart a JS (`.toJS`) antes de enviarlos a C#, y traducir las respuestas de vuelta a Dart (`.toDartDouble`, `.toDart`).

### `stub_bridge.dart`
**Propósito:** Proporciona una implementación vacía (Stub) para plataformas distintas a la Web (iOS, Android, Windows, Mac, Linux).

**Funcionalidad Clave:**
*   Lanza un `UnsupportedError` en todos sus métodos.
*   Evita que la aplicación en plataformas no soportadas (en este Hito 1) intente interactuar con el ecosistema de JS. Esto es necesario porque las librerías `dart:js_interop` y `package:web` fallan al compilar en aplicaciones nativas de escritorio/móvil.

### `bridge_selector.dart`
**Propósito:** Decide en tiempo de compilación qué puente utilizar (Web o Stub) dependiendo de la plataforma de despliegue.

**Funcionalidad Clave:**
*   **Conditional Exports:** Utiliza la instrucción `export 'web_bridge.dart' if (dart.library.js_interop)` para inyectar automáticamente la implementación `WebPQDIFBridge` si detecta que la aplicación está siendo compilada para el navegador.
*   Exporta una función fábrica `createBridge()` que oculta la complejidad de la selección a los Providers de Riverpod.

---

## Módulo 3: Orquestador de Build y Automatización

**Ubicación:** `/tool/`

Este módulo contiene la lógica de automatización necesaria para unir los ecosistemas de .NET y Flutter. Sin este orquestador, el despliegue de la aplicación requeriría múltiples pasos manuales propensos a errores.

### `build_wasm.dart`
**Propósito:** Script en Dart encargado de compilar el código C#, recolectar los artefactos binarios generados y desplegarlos en la ubicación correcta para que Flutter Web los pueda servir.

**Funcionalidad Clave:**
*   **Compilación .NET:** Ejecuta de forma programática el comando `dotnet publish` con configuración de `Release`.
*   **Gestión de Directorios:** Limpia la carpeta de destino `web/dotnet_runtime/` para asegurar que no queden versiones obsoletas o corruptas del motor.
*   **Filtrado de Artefactos:** Analiza el directorio de salida del compilador de .NET y extrae únicamente los archivos esenciales:
    *   `.js`: Scripts del runtime.
    *   `.wasm`: El binario lógico del motor.
    *   `.json`: Archivos de configuración de carga.
    *   `.dat`: Archivos de datos ICU para soporte de globalización (como el formato de números decimales).
*   **Despliegue de Glue Code:** Copia el archivo `main.js` personalizado (definido en el Módulo 1) a la carpeta de destino, asegurando que el puente entre JS y WASM esté disponible.

---

## Módulo 4: UI y Gestión de Estado (Riverpod)

Este módulo representa la capa superior de la aplicación. Utiliza **Riverpod** para manejar la asincronía del motor WASM y proporcionar una interfaz de usuario reactiva.

**Ubicación:** `/lib/src/providers/` y `/lib/src/presentation/`

### `wasm_providers.dart`
**Propósito:** Define los estados globales y la lógica de negocio asíncrona de la aplicación.

**Funcionalidad Clave:**
*   **`wasmBridgeProvider`**: Un `FutureProvider` que se encarga de llamar a `initialize()` en el puente. Es el punto central que coordina la descarga del motor .NET. La UI se suscribe a este proveedor para saber si debe mostrar una pantalla de carga o la aplicación lista.
*   **`CalculationResult`**: Un modelo de datos inmutable que almacena el resultado de la operación, el error (si ocurre) y la latencia medida.
*   **`calculationProvider`**: Un `Notifier` que expone la función `add()`. Al ser llamado, inicia un cronómetro (`Stopwatch`), invoca al bridge de .NET, mide el tiempo de respuesta en microsegundos (μs) y actualiza el estado de la UI automáticamente.

### `wasm_status_widget.dart`
**Propósito:** Widget reutilizable que informa visualmente al usuario sobre el estado de salud del motor de .NET.

**Funcionalidad Clave:**
*   Escucha al `wasmBridgeProvider`.
*   Muestra un indicador de carga ("Descargando Runtime...") mientras el `.wasm` baja del servidor.
*   Muestra un mensaje de éxito ("Activo") o de error técnico si algo falla (ej. si el navegador no soporta WASM o faltan archivos).

### `calculator_view.dart`
**Propósito:** Pantalla principal de la Prueba de Concepto (PoC).

**Funcionalidad Clave:**
*   **Entrada de Datos:** Utiliza `TextFormField` configurados específicamente para permitir números decimales y signos negativos (`signed: true, decimal: true`).
*   **Validación de UI:** El botón de cálculo se habilita o deshabilita automáticamente basándose en si el motor WASM ha terminado de inicializarse.
*   **Visualización de Latencia:** Muestra cuánto tiempo tardó la instrucción en viajar de Dart a C# y regresar, validando el alto rendimiento de la integración.
