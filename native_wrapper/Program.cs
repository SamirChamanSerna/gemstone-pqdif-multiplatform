using System;
using System.Text;

public class Program
{
    public static void Main()
    {
        Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);
        Console.WriteLine("PQDIF WASM Module Initialized with CodePagesSupport.");
    }
}