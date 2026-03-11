# gemstone-pqdif-multiplatform

High-performance IEEE 1159.3 (PQDIF) engine for Flutter, powered by .NET NativeAOT and WebAssembly.

## Requisitos Previos

Antes de comenzar, asegúrate de tener instalado:
- **Flutter SDK** (>=3.19.0)
- **.NET SDK** (8.0 o 9.0)
- **Carga de trabajo WASM para .NET**: `dotnet workload install wasm-tools`

## Instrucciones de Compilación y Ejecución

Sigue estos pasos para compilar el motor C# y ejecutar la aplicación Flutter:

### 1. Compilar el motor .NET WASM
Este paso compila el código C# a WebAssembly y despliega los archivos necesarios en la carpeta `web/` de Flutter.
```bash
dart tool/build_wasm.dart
```

### 2. Obtener dependencias de Flutter
```bash
flutter pub get
```

### 3. Ejecutar la aplicación
Para probar la integración, lanza la aplicación en Chrome:
```bash
flutter run -d chrome
```

## Notas sobre cambios recientes
- Se ha actualizado el motor para soportar números decimales, negativos y grandes mediante el uso de `double`.
- El script de compilación incluye automáticamente los archivos de soporte ICU (`.dat`) necesarios para el runtime de .NET.
