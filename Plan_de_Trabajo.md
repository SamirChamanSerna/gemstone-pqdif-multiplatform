---

### 1. Prompt de Comportamiento para el Agente Desarrollador (Implementador)

**Rol:** Eres un Ingeniero de Software Senior especializado en Sistemas de Misión Crítica, Procesamiento Digital de Señales (DSP) e Interoperabilidad de Bajo Nivel. Tu misión es transformar el blueprint del Arquitecto en código de producción altamente optimizado para la escritura de archivos binarios complejos.

**Directrices de Ejecución:**
*   **Eficiencia de Memoria:** La escritura de archivos PQDIF puede involucrar millones de muestras. Debes priorizar el uso de `ReadOnlySpan<T>` y `MemoryMarshal` en C# para evitar duplicaciones en el heap. En Dart, utiliza `Uint8List.view` para el mapeo de buffers.
*   **Seguridad en el Stream:** El estándar IEEE 1159.3 es jerárquico. Debes garantizar que los registros se escriban en el orden correcto (`Container` -> `DataSource` -> `Settings` -> `Observations`) para evitar archivos corruptos.
*   **Agnosticismo de Plataforma:** El motor de escritura en C# debe ser agnóstico. La distinción entre `FileStream` (Nativo) y `MemoryStream` (WASM) se gestiona exclusivamente en la capa de inicialización de la sesión.
*   **Restricciones AOT:** Está prohibido el uso de reflexión o serialización dinámica. Todo el intercambio de metadatos debe realizarse mediante Protobuf pre-generado.
*   **Gestión de Recursos:** Implementa obligatoriamente el patrón `IDisposable` en C# y asegúrate de que Dart llame a la liberación de memoria manual en plataformas nativas para evitar fugas (Leaks).

---

### 2. Resumen General de la Implementación (Hito 4)

**Objetivo:** Implementar un motor de exportación de archivos PQDIF (IEEE 1159.3) multiplataforma que permita salvar datos de calidad de energía desde Flutter hacia el sistema de archivos (Nativo) o descarga del navegador (Web).

**Alcance Técnico:**
1.  **Contrato de Escritura (Protobuf):** Definición de un esquema binario para transferir metadatos de configuración del equipo y ráfagas de series de tiempo de forma eficiente.
2.  **Motor de Persistencia Jerárquica (C#):** Desarrollo de un `WriterSession` que abstrae la complejidad de la librería `Gemstone.PQDIF`, permitiendo una escritura incremental (Streaming) por observaciones.
3.  **Puente de Interoperabilidad Dual:**
    *   **Web (WASM):** Generación en memoria y transferencia de un `byte[]` final hacia Dart para su descarga vía Blobs de JS.
    *   **Nativo (FFI):** Escritura directa a disco mediante rutas de archivo, minimizando el uso de RAM en dispositivos móviles.
4.  **Orquestador de Exportación (Dart/Riverpod):** Lógica en Flutter que transforma el estado de la UI y los buffers de señales en registros estructurados, manejando el progreso y las excepciones de escritura.

---

### Módulo 4.1: Contrato de Datos (Protobuf)
**Ubicación:** `proto/pqdif_writer.proto`

#### Propósito:
Definir los esquemas binarios necesarios para inicializar una sesión de escritura y transferir múltiples observaciones (formas de onda) de manera estructurada y eficiente.

#### Instrucciones de Implementación para el Agente Desarrollador:

**A. Mensaje de Inicialización (`WriteInitRequest`):**
1.  **`string file_path`**: Ruta absoluta donde se creará el archivo (solo requerido en plataformas Nativas). En Web, este campo será ignorado.
2.  **`string equipment_name`**: Nombre que se registrará en el `DataSourceRecord`.
3.  **`string vendor_name`**: Nombre del fabricante.
4.  **`repeated ChannelDefinition channels`**: Lista de configuraciones técnicas para cada canal que contendrá el archivo.

**B. Definición de Canal (`ChannelDefinition`):**
1.  **`int32 channel_id`**: Identificador numérico único dentro de la sesión.
2.  **`string name`**: Etiqueta del canal (ej. "Voltage A").
3.  **`int32 quantity_type`**: Enum o constante que mapee a Voltaje, Corriente, etc., según el estándar IEEE 1159.3.
4.  **`int32 quantity_units`**: Enum para Volts, Amps, etc.
5.  **`double nominal_value`**: Valor nominal para cálculos de base (pu).

**C. Mensaje de Observación (`WriteObservationRequest`):**
1.  **`int64 timestamp_ms`**: Marca de tiempo UTC en milisegundos para el inicio de la observación.
2.  **`repeated ChannelData samples`**: Lista de buffers de datos para los canales definidos previamente.

**D. Datos de Canal (`ChannelData`):**
1.  **`int32 channel_id`**: Referencia al ID definido en el `WriteInitRequest`.
2.  **`bytes data_raw`**: **Campo Crítico.** Contendrá el buffer de `double` (Float64) serializado como bytes crudos.
    *   *Restricción:* No usar `repeated double`. El desarrollador debe asegurar que Dart envíe `Uint8List.view` de la memoria y C# reciba `ReadOnlySpan<double>` mediante `MemoryMarshal.Cast`.

**E. Respuesta de Operación (`WriteResponse`):**
1.  **`bool is_success`**: Estado de la operación.
2.  **`string error_message`**: Detalle técnico si la validación jerárquica falla.
3.  **`bytes file_result`**: (Solo Web) Contendrá el buffer completo del archivo `.pqd` una vez finalizada la sesión.

---

**Crítica del Arquitecto para el Desarrollador:**
El diseño del campo `bytes data_raw` es innegociable. Cualquier intento de usar tipos `repeated` en Protobuf para series de tiempo será rechazado por ineficiencia de CPU. El implementador debe garantizar que el orden de los canales en `WriteObservationRequest` sea consistente con la definición inicial para evitar errores de punteros en el `LogicalWriter` de C#.

---

Este es el **Módulo 4.2: Sesión de Escritura y Lógica de Gemstone (C# / Wrapper)**. 

Este componente es el motor de ejecución que traduce las peticiones de Dart en registros binarios siguiendo el estándar IEEE 1159.3.

---

### Módulo 4.2: Motor de Persistencia y Gestión de Sesión (C#)
**Ubicación:** `native_wrapper/Writer/PqdifWriterService.cs`

#### Propósito:
Encapsular la complejidad del `LogicalWriter` de Gemstone y proporcionar una interfaz simplificada para la creación incremental de archivos PQDIF, optimizando el uso de memoria RAM mediante el volcado inmediato a disco o buffers controlados.

#### Instrucciones de Implementación para el Agente Desarrollador:

**A. Gestión del Ciclo de Vida (`PqdifWriterSession`):**
1.  **Estado de Sesión:** Implementar una clase que mantenga de forma privada:
    *   `LogicalWriter _writer`: Instancia activa del motor.
    *   `DataSourceRecord _dataSource`: Cache de metadatos del equipo.
    *   `MonitorSettingsRecord _settings`: Configuración técnica de canales.
    *   `Stream _outputStream`: Flujo de datos (`FileStream` o `MemoryStream`).
2.  **Inicialización (`InitSession`):**
    *   Si el `file_path` en el Protobuf no es nulo/vacío, abrir un `FileStream` (Modo Nativo).
    *   Si es nulo, inicializar un `MemoryStream` (Modo Web).
    *   **Registro Obligatorio:** Crear y escribir inmediatamente el `ContainerRecord` (versión 1.0) y el `DataSourceRecord` (usando los metadatos de la petición).
    *   **Configuración de Canales:** Mapear cada `ChannelDefinition` de Protobuf a una instancia de `ChannelDefinition` de Gemstone dentro de un `MonitorSettingsRecord`.

**B. Procesamiento de Muestras (`AddObservation`):**
1.  **Conversión Zero-copy:**
    *   Recibir el `bytes data_raw` del Protobuf.
    *   Utilizar `MemoryMarshal.Cast<byte, double>(request.Samples[i].DataRaw.Span)` para reinterpretar los bytes como un array de dobles sin realizar copias de memoria en el heap administrado.
2.  **Construcción del Registro:**
    *   Instanciar un `ObservationRecord`.
    *   Crear una `Series` para cada canal recibido, inyectando los valores de `double` obtenidos en el paso anterior.
    *   **Escritura Incremental:** Llamar a `_writer.WriteRecord(observationRecord)` inmediatamente para permitir que el GC libere la memoria de las muestras tras la escritura física en el stream.

**C. Finalización (`FinalizeSession`):**
1.  **Cierre Seguro:** Invocar `_writer.Dispose()` para asegurar que todos los encabezados y registros de cierre del estándar PQDIF se escriban correctamente.
2.  **Retorno de Datos:**
    *   En **Web**: Convertir el `MemoryStream` resultante a `byte[]` para enviarlo a Dart.
    *   En **Nativo**: Cerrar el archivo y retornar éxito.

**D. Exportaciones Interop (Exports.cs):**
1.  **WASM:** `[JSExport] byte[] WriteFullPqdifWasm(byte[] protoData)`.
2.  **Native:** `[UnmanagedCallersOnly] int write_pqdif_native(IntPtr protoPtr, int length, out IntPtr outPtr, out int outLen)`.

---

**Crítica del Arquitecto para el Desarrollador:**
El implementador debe tener especial cuidado con los **GUIDs**. El `SourceID` y `SettingID` deben ser generados de forma determinista o persistente para evitar colisiones en bases de datos industriales. Además, para la versión **WASM**, se debe validar que el `MemoryStream` no exceda los límites críticos del heap del navegador (recomiendo un tope de 256MB por seguridad antes de disparar una excepción controlada).

*Aviso de Compatibilidad (Gemstone.PQDIF):* La escritura del estándar es estrictamente secuencial; el `ContainerRecord` DEBE inicializarse y escribirse antes de cualquier otro registro (incluyendo el `DataSourceRecord`). Adicionalmente, existen bugs internos en la librería al usar factorías estáticas (`ChannelDefinition.CreateChannelDefinition`); el implementador debe preferir el uso de métodos de inicialización sobre la instancia padre (ej. `_dataSource.AddNewChannelDefinition()`) para evitar excepciones (`MoreThanOneMatchException`) al forzar la cardinalidad 1:1 de `SeriesDefinitions`. Finalmente, los puentes WASM/Nativos deben capturar y exponer el `ex.StackTrace` de C# hacia Dart para facilitar la depuración de estructuras binarias fallidas.

---

### Módulo 4.3: Puente de Escritura y Gestión de Estado (Dart / Flutter)
**Ubicación:** `lib/src/bridge/pqdif_writer_bridge.dart` y `lib/src/providers/pqdif_writer_provider.dart`

#### Propósito:
Orquestar la transferencia de series de tiempo desde la memoria de Dart hacia el motor C#, gestionando el ciclo de vida de la escritura (Init -> Stream -> Finalize) y proporcionando feedback visual al usuario sobre el progreso de la exportación.

#### Instrucciones de Implementación para el Agente Desarrollador:

**A. Implementación del Puente (`IPQDIFWriterBridge`):**
1.  **Adaptador Web (`web_writer_bridge.dart`):**
    *   Utilizar `dart:js_interop` para invocar la función `WriteFullPqdifWasm` expuesta por el runtime de .NET.
    *   **Conversión de Salida:** El `byte[]` devuelto por C# (el archivo .pqd completo) debe convertirse en un `Uint8List` para su procesamiento en Dart.
2.  **Adaptador Nativo (`native_writer_bridge.dart`):**
    *   Definir la signatura FFI: `typedef NativeWrite = Int32 Function(Pointer<Uint8>, Int32, Pointer<Pointer<Uint8>>, Pointer<Int32>)`.
    *   **Isolates:** Ejecutar la llamada al bridge nativo dentro de un `Isolate.run` (o `compute`) para evitar que la serialización de Protobuf y el IO de disco congelen el hilo de la UI.

**B. Notifier de Riverpod (`PqdifWriterNotifier`):**
1.  **Estado de Exportación:** Definir una clase `PqdifWriterState` que contenga:
    *   `ExportStatus status` (idle, working, done, error).
    *   `double progress` (0.0 a 1.0).
    *   `String? errorMessage`.
2.  **Método `exportFile`:**
    *   Recibe una lista de observaciones y la configuración del equipo.
    *   **Fase 1 (Init):** Crea el `WriteInitRequest` de Protobuf.
    *   **Fase 2 (Streaming):** Mapea las series de tiempo de Dart a `ChannelData`. 
        *   *Técnica Crítica:* Usar `samples.buffer.asUint8List(samples.offsetInBytes, samples.lengthInBytes)` para inyectar los bytes directamente en el Protobuf sin copiar el array de `double`.
    *   **Fase 3 (Finalize):** Solicita el cierre del archivo.

**C. Lógica de Descarga (Web):**
1.  **Blob Management:** Si la plataforma es Web, tras recibir el `Uint8List` final:
    *   Crear un `Blob` usando `package:web`.
    *   Generar una `URL.createObjectURL(blob)`.
    *   Crear un elemento `<a>` temporal, asignarle la URL y ejecutar `.click()` programáticamente para disparar el diálogo "Guardar como" del navegador.
    *   **Limpieza:** Llamar a `URL.revokeObjectURL(url)` inmediatamente después para liberar memoria.

---

**Crítica del Arquitecto para el Desarrollador:**
El implementador debe validar el **Endianness** al convertir `Float64List` a `Uint8List`. Gemstone.PQDIF espera Little-endian por defecto (estándar IEEE). Si el dispositivo es Big-endian (raro en hardware moderno pero posible), la conversión de bytes crudos fallará silenciosamente. Además, para la versión **Nativo**, el desarrollador debe asegurarse de que la ruta de archivo proporcionada por `path_provider` sea válida y tenga permisos de escritura antes de invocar a C#.

---

### Módulo 4.4: Dashboard de Configuración y Exportación (Flutter)
**Ubicación:** `lib/src/presentation/views/export_view.dart` y `widgets/export_progress_overlay.dart`

#### Propósito:
Proporcionar una interfaz intuitiva para definir el contexto del archivo PQDIF (Metadata de ingeniería) y disparar el motor de escritura de alto rendimiento, asegurando que el usuario tenga visibilidad total del progreso y el destino del archivo.

#### Instrucciones de Implementación para el Agente Desarrollador:

**A. Formulario de Metadatos Industriales:**
1.  **Campos de Entrada (`TextFormField`):**
    *   `Site Name`: Nombre de la subestación o punto de medición.
    *   `Equipment ID`: Identificador alfanumérico (debe validarse contra caracteres especiales).
    *   `Vendor / Manufacturer`: Nombre del fabricante (por defecto: "Gemstone PQDIF Multiplatform").
2.  **Selector de Canales (`CheckboxListTile`):**
    *   Permitir al usuario filtrar qué canales de la sesión actual se incluirán en el archivo final.
    *   **Validación:** Deshabilitar el botón de "Exportar" si no hay al menos un canal seleccionado.

**B. Orquestación con Riverpod:**
1.  **Acción `onExportPressed`:**
    *   Recopila los datos del formulario y los canales seleccionados.
    *   Obtiene las series de tiempo (muestras) desde el `pqdifSeriesProvider` (Hito 3).
    *   Invoca al método `exportFile` del `pqdifWriterProvider` (Módulo 4.3).
2.  **Observación de Estado:**
    *   Utilizar `ref.listen` para reaccionar a cambios en el estado de exportación:
        *   `Status.working`: Mostrar un `Overlay` bloqueante con un `LinearProgressIndicator`.
        *   `Status.done`: Mostrar un `SnackBar` de éxito con el nombre del archivo generado.
        *   `Status.error`: Mostrar un `AlertDialog` con el detalle técnico del fallo proveniente de C#.

**C. Manejo de Salida por Plataforma:**
1.  **Web (Download Flow):**
    *   Al finalizar con éxito, el widget no requiere acción adicional del usuario, ya que el Bridge dispara automáticamente la descarga del Blob.
2.  **Nativo (File Actions):**
    *   Utilizar el paquete `open_filex` o similar para ofrecer un botón de "Abrir Archivo" o "Compartir" una vez que el motor de C# confirme la escritura en disco.

**D. Widget de Progreso (`ExportProgressOverlay`):**
1.  **UI:** Un `Stack` que cubra la pantalla con un fondo semi-transparente.
2.  **Detalle de Tarea:** Mostrar texto dinámico: *"Escribiendo Observación X de Y..."* o *"Finalizando estructura PQDIF..."*.

---

**Crítica del Arquitecto para el Desarrollador:**
El implementador debe evitar pasar los buffers de datos masivos a través del constructor del Widget de UI. La vista debe pasar únicamente los **IDs de los canales** y los metadatos de configuración al Provider; el Provider será el encargado de extraer los datos pesados directamente del estado de la aplicación (Hito 3) y enviarlos al motor C#. Esto previene fugas de memoria por mantener referencias duplicadas en la capa de presentación.

---
