// Importa el motor de .NET y lo inicializa.
import { dotnet } from './dotnet.js';

// Usamos top-level await para configurar y ejecutar el engine.
// Se asume que estos archivos se servirán desde la carpeta 'dotnet_runtime/' o la raíz definida en Flutter.
const { setModuleImports, getAssemblyExports, getConfig } = await dotnet
    .withDiagnosticTracing(false)
    .create();

const config = getConfig();
// Obtiene las funciones exportadas del assembly.
const exports = await getAssemblyExports(config.mainAssemblyName);

// Exporta las funciones de C# al objeto global window.
// Esto permite que el bridge de Dart pueda invocarlas a través de JSInterop.
window.dotnetPQDIF = {
    add: (a, b) => exports.Gemstone.PQDIF.Wasm.PqdifOperations.Add(a, b),
    getRuntimeInfo: () => exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetRuntimeInfo()
};

console.log('.NET WASM Runtime initialized for PQDIF Wrapper.');
