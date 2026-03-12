// Importa el motor de .NET y lo inicializa.
import { dotnet } from './dotnet.js';

const { setModuleImports, getAssemblyExports, getConfig } = await dotnet
    .withDiagnosticTracing(false)
    .create();

const config = getConfig();
const exports = await getAssemblyExports(config.mainAssemblyName);

window.dotnetPQDIF = {
    getFileMetadata: (fileBytes, filePath) => exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetFileMetadata(fileBytes, filePath),
    getRuntimeInfo: () => exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetRuntimeInfo()
};

console.log('.NET WASM Runtime initialized for PQDIF Wrapper.');