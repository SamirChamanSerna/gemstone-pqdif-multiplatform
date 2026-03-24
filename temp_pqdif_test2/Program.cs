using System;
using System.Reflection;

class Program {
    static void Main() {
        var t = typeof(Gemstone.PQDIF.Logical.SeriesValueType);
        if (t != null) {
            foreach (var p in t.GetProperties(BindingFlags.Public | BindingFlags.Static)) 
                Console.WriteLine($"{p.PropertyType.Name} {p.Name}");
        } else {
            Console.WriteLine("SeriesValueType not found.");
        }
    }
}