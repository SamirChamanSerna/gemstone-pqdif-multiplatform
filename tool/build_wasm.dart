import 'dart:io';

Future<void> main() async {
  print('Iniciando compilacion de .NET WASM...');

  final targetDir = Directory('web/dotnet_runtime');

  // 1. Compilacion .NET a WASM
  final result = await Process.run(
    'dotnet',
    [
      'publish',
      '-c',
      'Release'
    ],
    workingDirectory: 'native_wrapper',
  );

  if (result.exitCode != 0) {
    print('Error en compilacion de .NET:');
    print(result.stdout);
    print(result.stderr);
    exit(1);
  }
  print('Compilacion .NET completada con exito.');

  // 2. Limpieza de runtime antiguo
  if (targetDir.existsSync()) {
    targetDir.deleteSync(recursive: true);
  }
  targetDir.createSync(recursive: true);

  // 3. Extraccion y despliegue del _framework
  // Asumimos net8.0 para esta ruta segun las especificaciones.
  final frameworkDir = Directory('native_wrapper/bin/Release/net8.0/publish/wwwroot/_framework');
  
  if (!frameworkDir.existsSync()) {
    print('Error: Directorio de framework no existe en ${frameworkDir.path}');
    exit(1);
  }

  // Copiamos los archivos de soporte y binarios WASM requeridos por dotnet.
  final entities = frameworkDir.listSync(recursive: true);
  for (final entity in entities) {
    if (entity is File) {
      final fileName = entity.uri.pathSegments.last;
      // Archivos esenciales del runtime y la app:
      if (fileName.endsWith('.js') || fileName.endsWith('.wasm') || fileName.endsWith('.json') || fileName.endsWith('.dat')) {
        entity.copySync('${targetDir.path}/$fileName');
      }
    }
  }

  // 4. Copiar main.js de inicializacion (Glue code)
  final mainJsFile = File('native_wrapper/main.js');
  if (mainJsFile.existsSync()) {
    mainJsFile.copySync('${targetDir.path}/main.js');
    print('Despliegue de artefactos WASM y JS completado en ${targetDir.path}.');
  } else {
    print('Error: No se encontro el orquestador JS en native_wrapper/main.js');
    exit(1);
  }
}
