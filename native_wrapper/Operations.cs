using System;
using System.Runtime.InteropServices.JavaScript;

namespace Gemstone.PQDIF.Wasm;

public partial class PqdifOperations
{
    // Realiza la suma de enteros
    [JSExport]
    public static double Add(double a, double b)
    {
        return a + b;
    }

    // Retorna la versión del entorno para diagnóstico
    [JSExport]
    public static string GetRuntimeInfo()
    {
        return "1.0.0-poc";
    }
}
