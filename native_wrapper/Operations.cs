#nullable enable
using System;
using System.IO;
using System.Threading.Tasks;
using System.Runtime.InteropServices.JavaScript;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Linq;
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
}