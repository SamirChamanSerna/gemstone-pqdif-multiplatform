# Referencia Técnica: gemstone-pqdif-multiplatform

Bienvenido a la referencia técnica detallada del proyecto. Este documento explica paso a paso, archivo por archivo, la arquitectura y el propósito de cada componente del código fuente.

## Índice

1. [Módulo 1: Native Wrapper (.NET WASM)](#módulo-1-native-wrapper-net-wasm)
   - [PQDIFWrapper.csproj](#pqdifwrappercsproj)
   - [Program.cs](#programcs)
   - [Operations.cs](#operationscs)
   - [Models/PqdifResponse.cs](#modelspqdifresponsecs)
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
   - [pqdif_analysis_provider.dart](#pqdif_analysis_providerdart)
   - [wasm_status_widget.dart](#wasm_status_widgetdart)
   - [views/metadata_view.dart](#viewsmetadata_viewdart)

---

## Módulo 1: Native Wrapper (.NET WASM)

**Ubicación:** `/native_wrapper/`

Este directorio contiene el proyecto "Backend" escrito en C# (.NET 8.0) que se compila a WebAssembly (WASM). En el Hito 2, este motor dejó de ser una prueba de concepto para integrar completamente la librería **Gemstone.PQDIF**, sirviendo como un extractor de metadatos de archivos de calidad de energía (IEEE 1159.3) de alto rendimiento aislado del entorno de Flutter.

### `PQDIFWrapper.csproj`
**Propósito:** Es el archivo de configuración estructural del proyecto .NET. Define cómo el compilador debe interpretar y construir la aplicación, así como sus dependencias externas.

**Funcionalidad Clave:**
*   **Dependencias de NuGet (`<PackageReference>`)**: Incorpora `Gemstone.PQDIF` (el motor principal para leer el formato binario) y `System.Text.Encoding.CodePages` (crucial para decodificar cadenas de texto legadas dentro de archivos antiguos).
*   **`Sdk="Microsoft.NET.Sdk.WebAssembly"`**: Indica que el proyecto utiliza el SDK específico para compilar hacia WebAssembly.
*   **`<AllowUnsafeBlocks>true</AllowUnsafeBlocks>`**: Requerido por la arquitectura interna de Gemstone.PQDIF para el manejo de punteros y análisis de estructuras binarias.
*   **`<TrimMode>partial</TrimMode>`**: Configura el "Trimming" (recorte) en modo parcial. Esto es vital porque Gemstone.PQDIF utiliza reflexión (Reflection) internamente para descubrir registros (Records). Un trimming completo (full) eliminaría código necesario, rompiendo la funcionalidad en tiempo de ejecución.
*   **`<WasmMainJSPath>main.js</WasmMainJSPath>`**: Asigna el script de inicialización del entorno WebAssembly.

### `Program.cs`
**Propósito:** Es el punto de entrada inicial del ciclo de vida de la aplicación .NET en el navegador.

**Funcionalidad Clave:**
*   **Registro de Codificación (Encodings)**: Ejecuta `Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);`. Al compilar hacia WebAssembly o Native AOT, .NET elimina los diccionarios de codificación antiguos para ahorrar peso. Dado que el formato PQDIF puede utilizar tablas de caracteres heredadas, es obligatorio registrar este proveedor en el arranque para prevenir fallos (exceptions) durante el escaneo del archivo.

### `Operations.cs`
**Propósito:** Es el corazón lógico del análisis de los archivos. Define los métodos que se exponen directamente a JavaScript y coordina la ingesta de bytes y la serialización de resultados.

**Funcionalidad Clave:**
*   **`[JSExport] GetFileMetadata`**: Método asíncrono que recibe los datos de Flutter, ya sea como un array de bytes en memoria (`MemoryStream` para la Web) o una ruta física de archivo (`FileStream` para aplicaciones nativas).
*   **Extracción Resiliente**: Utiliza `LogicalParser` para abrir el flujo de datos. Implementa bloques `try-catch` individualizados por propiedad (ej. `DataSourceOwner`, `DataSourceName`) porque la librería lanza excepciones en tiempo de ejecución si el archivo físico carece de las etiquetas opcionales. En caso de error, recurre inmediatamente a extraer los GUIDs obligatorios (`VendorID`, `EquipmentID`).
*   **Serialización JSON AOT (`PqdifJsonContext`)**: Implementa `JsonSerializerContext` (Source Generation). Al compilar hacia WASM (donde la reflexión es costosa y propensa a recortes), esta técnica pre-genera el código de serialización del DTO en tiempo de compilación, asegurando máxima velocidad de conversión de C# a String.

### `Models/PqdifResponse.cs`
**Propósito:** Define la estructura de datos que se enviará desde C# hasta Dart.

**Funcionalidad Clave:**
*   **Data Transfer Object (DTO)**: Clase pura que almacena `VendorName`, `EquipmentName`, `ObservationCount`, y campos de control (`IsSuccess`, `ErrorMessage`). Su diseño permite expandir fácilmente los metadatos a extraer en futuros hitos sin romper la firma del puente `main.js`.

### `main.js`
**Propósito:** Es el código "pegamento" (Glue Code) y el orquestador principal del lado del navegador que une el motor WASM compilado con el contexto de la página web.

**Funcionalidad Clave:**
*   **Arranque asíncrono e Inyección:** Utiliza `await dotnet.create()` para descargar, parsear y arrancar el motor de WebAssembly sin bloquear el hilo principal.
*   **Manejo de Buffers (`Uint8Array`)**: Expone la función `extractPqdifMetadata` globalmente. Acepta arrays de bytes (`JSUint8Array` desde Dart) y delega la ejecución al método intermedio de C#, asegurando una transferencia de memoria plana sin duplicaciones costosas en el ecosistema JS.

---

## Módulo 2: Flutter Bridge e Interoperabilidad Dart

**Ubicación:** `/lib/src/bridge/`

Este módulo actúa como la capa de abstracción y comunicación bidireccional. Su objetivo es permitir que el código Dart invoque las funciones del módulo .NET WASM de forma tipada y segura, gestionando la transferencia eficiente de grandes volúmenes de datos (archivos físicos) y la diferencia de ecosistemas entre la Web y las futuras plataformas nativas.

### `bridge_interface.dart`
**Propósito:** Define el contrato (interfaz abstracta) que todas las implementaciones del puente deben cumplir, independientemente de la plataforma.

**Funcionalidad Clave:**
*   **`IPQDIFBridge`**: Expone los métodos `initialize()`, `getMetadata()` y `getRuntimeInfo()`. La firma de `getMetadata` permite recibir bytes en memoria (`Uint8List`) o rutas físicas (`String path`), haciendo que el puente sea verdaderamente multiplataforma.
*   **`PqdifMetadataResponse`**: Una Data Class (clase de datos pura) en Dart que sirve como el equivalente estricto del DTO de C#. Desacopla la UI de los formatos JSON de transporte.

### `js_bindings.dart`
**Propósito:** Mapear las funciones expuestas en el objeto global de JavaScript (`window.dotnetPQDIF`) para que sean accesibles y tipadas dentro de Dart usando la nueva especificación JS Interop.

**Funcionalidad Clave:**
*   **`@JS('dotnetPQDIF')`**: Utiliza `dart:js_interop` (Dart 3+) para indicarle al compilador que confíe en la existencia de este objeto.
*   **Extension Types (Zero-Cost Abstraction)**: Implementa `DotnetPQDIFBindings` envolviendo objetos `JSObject` sin sobrecarga de rendimiento. Define las firmas asíncronas mapeando `Task<string>` de C# a `JSPromise<JSString>` en Dart.
*   **Parseo JSON Nativo**: Expone el envoltorio `@JS('JSON.parse')` para delegar el parseo del string recibido desde C# directamente al motor V8 del navegador, en lugar de gastar ciclos de CPU usando librerías de Dart.

### `web_bridge.dart`
**Propósito:** Es la implementación real del puente diseñada exclusivamente para el entorno del navegador (Web).

**Funcionalidad Clave:**
*   **Carga Dinámica y Segura (`Completer`)**: Inyecta programáticamente el script `dotnet_runtime/main.js` en el DOM. Asegura que el proceso sea *idempotente*, encolando las llamadas de la interfaz si el motor aún está descargándose.
*   **Transferencia de Memoria Zero-Copy**: Convierte el archivo `Uint8List` de Dart a un `JSUint8Array` (`bytes.toJS`). Esta conversión es crítica para aplicaciones WebAssembly de alto rendimiento porque pasa la referencia de la memoria directamente al heap de JavaScript/WASM, evitando copias costosas y congelamientos de UI al leer archivos grandes.
*   **Mapeo de DTOs**: Espera la promesa de JS, parsea el string usando el interop de JSON nativo y mapea las propiedades resultantes hacia la clase limpia `PqdifMetadataResponse`.

### `stub_bridge.dart`
**Propósito:** Proporciona una implementación vacía (Stub) para plataformas distintas a la Web (iOS, Android, Windows, Mac, Linux).

**Funcionalidad Clave:**
*   Lanza un `UnsupportedError` en todos sus métodos.
*   Evita que la aplicación en plataformas no soportadas (por ahora) intente interactuar con el ecosistema de JS. Esto es necesario porque las librerías `dart:js_interop` y `package:web` fallan al compilar en aplicaciones nativas de escritorio/móvil.

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

Este módulo representa la capa superior de la aplicación en Flutter. En el Hito 2, se rediseñó para soportar el flujo asíncrono de selección, lectura y análisis de archivos físicos utilizando las mejores prácticas de **Riverpod** (`AsyncNotifier`).

**Ubicación:** `/lib/src/providers/` y `/lib/src/presentation/`

### `pqdif_analysis_provider.dart`
**Propósito:** Define los estados globales y orquesta la lógica de negocio asíncrona del análisis de archivos, protegiendo a la aplicación de desbordamientos de memoria.

**Funcionalidad Clave:**
*   **`wasmBridgeProvider`**: Un `FutureProvider` global que coordina la descarga del motor .NET (`initialize()`). Funciona como el "semáforo" principal de la aplicación.
*   **Gestión de Estado (`AsyncNotifier`)**: `PqdifAnalysisNotifier` maneja el ciclo de vida del análisis (Idle -> Loading -> Data/Error). Esto permite que la interfaz de usuario reaccione automáticamente mostrando _spinners_ o tarjetas de error sin gestionar booleanos manuales.
*   **Bloqueo de Seguridad (OOM Protection)**: Implementa una barrera arquitectónica crítica para entornos Web. Antes de cargar el archivo en el puente, verifica su tamaño; si excede los **500MB**, aborta inmediatamente la operación. Esto previene que el navegador cierre la pestaña abruptamente por quedarse sin memoria RAM en el heap de WebAssembly.
*   **Métricas Estrictas (`Stopwatch`)**: Captura en milisegundos (ms) el tiempo exacto que toma la transferencia de bytes, el parseo en C# y la decodificación JSON en Dart.

### `wasm_status_widget.dart`
**Propósito:** Widget reutilizable que informa visualmente al usuario sobre la salud y el estado del motor de .NET en el navegador.

**Funcionalidad Clave:**
*   **Feedback Reactivo**: Escucha directamente a `wasmBridgeProvider` y dibuja indicadores de progreso circulares ("Descargando Runtime...") o íconos de éxito/fracaso, garantizando que el usuario entienda si el motor pesado ya está listo para trabajar.

### `views/metadata_view.dart`
**Propósito:** Es el "Dashboard" principal del Hito 2, permitiendo al ingeniero o usuario cargar archivos y visualizar los datos extraídos en su forma más pura.

**Funcionalidad Clave:**
*   **Selector Industrial (`FilePicker`)**: Utiliza `FilePicker.platform.pickFiles` filtrando por extensiones `.pqd` y `.pqdif`. Activa la bandera `withData: true` crucial en la Web para recuperar los buffers en memoria en lugar de intentar leer rutas de disco inexistentes en el navegador.
*   **Vista RAW Selectable**: Imprime los valores extraídos del archivo (`Vendor` y `Equipment`) utilizando `SelectableText`. Al no intentar traducir ni adivinar diccionarios, sirve como una herramienta de depuración vital para que los desarrolladores inspeccionen los verdaderos GUIDs o textos corruptos ocultos dentro del PQDIF.
*   **Visualización de Latencia y Tamaño**: Expone de manera transparente el tamaño original del archivo procesado y el tiempo invertido por la librería `Gemstone.PQDIF`.
