using System;
using Gemstone.PQDIF.Logical;

class Program {
    static void Main() {
        var t = typeof(Gemstone.PQDIF.Logical.ObservationRecord);
        Console.WriteLine("--- Methods ---");
        var cats = typeof(DisturbanceCategory).GetMethods(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Static);
        foreach(var c in cats) {
            if (c.Name == "GetInfo") {
                Console.WriteLine($"{c.ReturnType.Name} {c.Name}");
                var p = c.GetParameters();
                foreach(var param in p) {
                    Console.WriteLine($" - {param.ParameterType.Name} {param.Name}");
                }
            }
        }
        
        Console.WriteLine("--- DisturbanceCategory.GetInfo Return Type ---");
        var ri = typeof(Gemstone.PQDIF.Logical.DisturbanceCategory).GetMethod("GetInfo")?.ReturnType;
        if (ri != null) {
            foreach (var p in ri.GetProperties()) Console.WriteLine($"{p.PropertyType.Name} {p.Name}");
        }
    }
}