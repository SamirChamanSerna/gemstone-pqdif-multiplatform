/**
 * Definiciones de tipo para el Interop de .NET WASM (Gemstone PQDIF).
 * Este archivo describe la interfaz expuesta al objeto global 'window'.
 */

export interface DotnetPQDIF {
    /**
     * Realiza la suma de dos números de punto flotante.
     * @param a Primer número.
     * @param b Segundo número.
     * @returns El resultado de la suma.
     */
    add(a: number, b: number): number;

    /**
     * Retorna información sobre el entorno de ejecución (Runtime) de .NET.
     * Útil para verificar que el motor cargó correctamente.
     * @returns Cadena de texto con la versión (ej. "1.0.0-poc").
     */
    getRuntimeInfo(): string;
}

declare global {
    interface Window {
        /**
         * Instancia global del puente con .NET WASM.
         */
        dotnetPQDIF: DotnetPQDIF;
    }
}
