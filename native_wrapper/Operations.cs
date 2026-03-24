#nullable enable
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.JavaScript;
using Gemstone.PQDIF.Logical;
using GemstonePqdif;
using Google.Protobuf;

namespace Gemstone.PQDIF.Wasm;

public partial class PqdifOperations
{
    private static async Task<FileMetadataResponse> GetFileMetadataInternal(byte[]? fileBytes, string? filePath)
    {
        var response = new FileMetadataResponse();
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
                    
                    int obsIndex = 0;
                    while (await parser.HasNextObservationRecordAsync())
                    {
                        var obsRecord = await parser.NextObservationRecordAsync();
                        var obsSum = new ObservationSummary
                        {
                            ObservationIndex = obsIndex,
                            ObservationName = obsRecord.Name ?? $"Observation {obsIndex}",
                            StartTime = obsRecord.StartTime.ToString("o")
                        };

                        int chIndex = 0;
                        foreach (var channel in obsRecord.ChannelInstances)
                        {
                            var chDef = channel.Definition;
                            obsSum.Channels.Add(new ChannelSummary
                            {
                                ChannelIndex = chIndex,
                                ChannelName = chDef.ChannelName ?? $"Channel {chIndex}",
                                Phase = chDef.Phase.ToString(),
                                QuantityType = chDef.QuantityMeasured.ToString()
                            });
                            chIndex++;
                        }
                        
                        response.Observations.Add(obsSum);
                        obsIndex++;
                    }

                    var dataSources = parser.DataSourceRecords;
                    if (dataSources != null && dataSources.Count > 0)
                    {
                        var dsRecord = dataSources.FirstOrDefault();
                        if (dsRecord != null)
                        {
                            try { response.Manufacturer = string.IsNullOrWhiteSpace(dsRecord.DataSourceOwner) ? dsRecord.VendorID.ToString() : dsRecord.DataSourceOwner; }
                            catch { response.Manufacturer = "UNKNOWN_VENDOR_ID"; }
                            
                            try { response.EquipmentModel = string.IsNullOrWhiteSpace(dsRecord.DataSourceName) ? dsRecord.EquipmentID.ToString() : dsRecord.DataSourceName; }
                            catch { response.EquipmentModel = "UNKNOWN_EQUIPMENT_ID"; }
                        }
                    }
                    else
                    {
                        response.Manufacturer = "NO-DATASOURCE-RECORD";
                        response.EquipmentModel = "NO-DATASOURCE-RECORD";
                    }

                    if (!string.IsNullOrEmpty(filePath)) {
                        response.FileName = Path.GetFileName(filePath);
                    } else {
                        response.FileName = "WASM_Upload";
                    }
                    
                    response.IsSuccess = true;
                }
            }
        }
        catch (Exception ex)
        {
            response.IsSuccess = false;
            response.ErrorMessage = ex.Message;
        }

        return response;
    }

    [JSExport]
    public static byte[] GetFileMetadataWasm(byte[]? fileBytes, string? filePath)
    {
        var response = GetFileMetadataInternal(fileBytes, filePath).GetAwaiter().GetResult();
        return response.ToByteArray();
    }

    [UnmanagedCallersOnly(EntryPoint = "get_file_metadata_native")]
    public static unsafe int GetFileMetadataNative(IntPtr filePathPtr, IntPtr* outBufferPtr, int* outBufferLen)
    {
        if (outBufferPtr != null) *outBufferPtr = IntPtr.Zero;
        if (outBufferLen != null) *outBufferLen = 0;
        try
        {
            string filePath = Marshal.PtrToStringUTF8(filePathPtr) ?? "";
            var response = GetFileMetadataInternal(null, filePath).GetAwaiter().GetResult();
            
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
            var errResp = new FileMetadataResponse { IsSuccess = false, ErrorMessage = ex.Message };
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

    [JSExport]
    public static string GetRuntimeInfo()
    {
        return "1.0.0-pqdif";
    }

    [JSExport]
    public static byte[] GetSeriesWindowWasm(byte[]? fileBytes, string? filePath, byte[] requestBytes)
    {
        var request = SeriesWindowRequest.Parser.ParseFrom(requestBytes);

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
            var errResp = new SeriesWindowResponse { IsSuccess = false, ErrorMessage = "Must provide either fileBytes or filePath" };
            return errResp.ToByteArray();
        }

        using (stream)
        {
            var response = TimeSeriesExtractor.GetSeriesWindowAsync(
                stream, 
                request.ObservationIndex, 
                request.ChannelIndices, 
                request.StartIndex, 
                request.EndIndex, 
                request.TargetPoints).GetAwaiter().GetResult();
            return response.ToByteArray();
        }
    }

    [UnmanagedCallersOnly(EntryPoint = "get_series_window_native")]
    public static unsafe int GetSeriesWindowNative(IntPtr filePathPtr, IntPtr requestBytesPtr, int requestBytesLen, IntPtr* outBufferPtr, int* outBufferLen)
    {
        if (outBufferPtr != null) *outBufferPtr = IntPtr.Zero;
        if (outBufferLen != null) *outBufferLen = 0;
        try
        {
            string filePath = Marshal.PtrToStringUTF8(filePathPtr) ?? "";
            
            byte[] requestBytes = new byte[requestBytesLen];
            Marshal.Copy(requestBytesPtr, requestBytes, 0, requestBytesLen);
            var request = SeriesWindowRequest.Parser.ParseFrom(requestBytes);

            using var stream = new FileStream(filePath, FileMode.Open, FileAccess.Read);
            var response = TimeSeriesExtractor.GetSeriesWindowAsync(
                stream, 
                request.ObservationIndex, 
                request.ChannelIndices, 
                request.StartIndex, 
                request.EndIndex, 
                request.TargetPoints).GetAwaiter().GetResult();
            
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
            var errResp = new SeriesWindowResponse { IsSuccess = false, ErrorMessage = ex.Message };
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