// Importa el motor de .NET y lo inicializa.
import { dotnet } from './dotnet.js';

const { setModuleImports, getAssemblyExports, getConfig } = await dotnet
    .withDiagnosticTracing(false)
    .create();

const config = getConfig();
const exports = await getAssemblyExports(config.mainAssemblyName);

window.dotnetPQDIF = {
    getFileMetadataWasm: (fileBytes, filePath) => exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetFileMetadataWasm(fileBytes, filePath),
    getRuntimeInfo: () => exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetRuntimeInfo(),
    getSeriesWindowWasm: (fileBytes, filePath, requestBytes) => 
        exports.Gemstone.PQDIF.Wasm.PqdifOperations.GetSeriesWindowWasm(fileBytes, filePath, requestBytes)
};

console.log('.NET WASM Runtime initialized for PQDIF Wrapper.');