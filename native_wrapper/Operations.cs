#nullable enable
using System;
using System.IO;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.JavaScript;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Linq;
using Google.Protobuf;
using Gemstone.PQDIF.Logical;
using Gemstone.PQDIF.Wasm.Models;

namespace Gemstone.PQDIF.Wasm;

[JsonSerializable(typeof(PqdifMetadataResponse))]
internal partial class PqdifJsonContext : JsonSerializerContext { }

public partial class PqdifOperations
{
    [JSExport]
    public static async Task<string> GetFileMetadata(byte[]? fileBytes, string? filePath)
    {
        var response = new PqdifMetadataResponse();
        try
        {
            Stream? stream = null;
            if (fileBytes != null && fileBytes.Length > 0)
            {
                stream = new MemoryStream(fileBytes);
            }
            else if (!string.IsNullOrEmpty(filePath))
            {
                stream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            }
            else
            {
                throw new ArgumentException("Must provide either fileBytes or filePath");
            }

            using (stream)
            {
                using (var parser = new LogicalParser())
                {
                    await parser.OpenAsync(stream, false);
                    
                    int observationCount = 0;
                    while (await parser.HasNextObservationRecordAsync())
                    {
                        await parser.NextObservationRecordAsync();
                        observationCount++;
                    }

                    var dataSources = parser.DataSourceRecords;
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        var dsRecord = dataSources.FirstOrDefault();
                        if (dsRecord != null)
                        {
                            // Extracción segura del Fabricante (Vendor)
                            try
                            {
                                response.VendorName = string.IsNullOrWhiteSpace(dsRecord.DataSourceOwner) 
                                    ? dsRecord.VendorID.ToString() 
                                    : dsRecord.DataSourceOwner;
                            }
                            catch (Exception)
                            {
                                // Si el campo físico 'DataSourceOwner' no existe, la propiedad lanza excepción.
                                try { response.VendorName = dsRecord.VendorID.ToString(); }
                                catch { response.VendorName = "UNKNOWN_VENDOR_ID"; }
                            }
                            
                            // Extracción segura del Equipo (Equipment)
                            try
                            {
                                response.EquipmentName = string.IsNullOrWhiteSpace(dsRecord.DataSourceName) 
                                    ? dsRecord.EquipmentID.ToString() 
                                    : dsRecord.DataSourceName;
                            }
                            catch (Exception)
                            {
                                // Si el campo físico 'DataSourceName' no existe, la propiedad lanza excepción.
                                try { response.EquipmentName = dsRecord.EquipmentID.ToString(); }
                                catch { response.EquipmentName = "UNKNOWN_EQUIPMENT_ID"; }
                            }
                        }
                    }
                    else
                    {
                        response.VendorName = "NO-DATASOURCE-RECORD";
                        response.EquipmentName = "NO-DATASOURCE-RECORD";
                    }
                    
                    response.ObservationCount = observationCount;
                    response.IsSuccess = true;
                }
            }
        }
        catch (Exception ex)
        {
            response.IsSuccess = false;
            response.ErrorMessage = ex.Message;
        }

        return JsonSerializer.Serialize(response, PqdifJsonContext.Default.PqdifMetadataResponse);
    }

    [JSExport]
    public static string GetRuntimeInfo()
    {
        return "1.0.0-pqdif";
    }

    [JSExport]
    public static byte[] GetSeriesWindowWasm(byte[]? fileBytes, string? filePath, int obsIdx, int chIdx, int start, int end, int targetPoints)
    {
        Stream? stream = null;
        if (fileBytes != null && fileBytes.Length > 0)
        {
            stream = new MemoryStream(fileBytes);
        }
        else if (!string.IsNullOrEmpty(filePath))
        {
            stream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
        }
        else
        {
            var errResp = new GemstonePqdif.SeriesWindowResponse { IsSuccess = false, ErrorMessage = "Must provide either fileBytes or filePath" };
            return errResp.ToByteArray();
        }

        using (stream)
        {
            var response = TimeSeriesExtractor.GetSeriesWindowAsync(stream, obsIdx, chIdx, start, end, targetPoints).GetAwaiter().GetResult();
            return response.ToByteArray();
        }
    }

    [UnmanagedCallersOnly(EntryPoint = "get_series_window_native")]
    public static unsafe int GetSeriesWindowNative(IntPtr filePathPtr, int obsIdx, int chIdx, int start, int end, int targetPoints, IntPtr* outBufferPtr, int* outBufferLen)
    {
        if (outBufferPtr != null) *outBufferPtr = IntPtr.Zero;
        if (outBufferLen != null) *outBufferLen = 0;
        try
        {
            string filePath = Marshal.PtrToStringUTF8(filePathPtr) ?? "";
            using var stream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            var response = TimeSeriesExtractor.GetSeriesWindowAsync(stream, obsIdx, chIdx, start, end, targetPoints).GetAwaiter().GetResult();
            
            byte[] buffer = response.ToByteArray();
            if (outBufferLen != null) *outBufferLen = buffer.Length;
            if (outBufferPtr != null)
            {
                *outBufferPtr = Marshal.AllocHGlobal(buffer.Length);
                Marshal.Copy(buffer, 0, *outBufferPtr, buffer.Length);
            }
            
            return 0;
        }
        catch (Exception ex)
        {
            var errResp = new GemstonePqdif.SeriesWindowResponse { IsSuccess = false, ErrorMessage = ex.Message };
            byte[] errBuffer = errResp.ToByteArray();
            if (outBufferLen != null) *outBufferLen = errBuffer.Length;
            if (outBufferPtr != null)
            {
                *outBufferPtr = Marshal.AllocHGlobal(errBuffer.Length);
                Marshal.Copy(errBuffer, 0, *outBufferPtr, errBuffer.Length);
            }
            return -1;
        }
    }

    [UnmanagedCallersOnly(EntryPoint = "free_series_buffer")]
    public static void FreeSeriesBuffer(IntPtr ptr)
    {
        if (ptr != IntPtr.Zero)
        {
            Marshal.FreeHGlobal(ptr);
        }
    }
}