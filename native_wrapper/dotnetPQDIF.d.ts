export interface DotnetPQDIF {
    getFileMetadata(fileBytes: Uint8Array | null, filePath: string | null): string;
    getRuntimeInfo(): string;
}

declare global {
    interface Window {
        dotnetPQDIF: DotnetPQDIF;
    }
}