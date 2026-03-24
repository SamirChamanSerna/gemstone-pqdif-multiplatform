using System;
using System.Reflection;
using Gemstone.PQDIF.Logical;

class Program {
    static void Main() {
        Console.WriteLine("Methods in LogicalWriter:");
        foreach (var m in typeof(LogicalWriter).GetMethods()) if (m.Name.Contains("Write")) Console.WriteLine(" - " + m.ReturnType.Name + " " + m.Name + " (" + string.Join(", ", Array.ConvertAll(m.GetParameters(), p => p.ParameterType.Name)) + ")");
    }
}
