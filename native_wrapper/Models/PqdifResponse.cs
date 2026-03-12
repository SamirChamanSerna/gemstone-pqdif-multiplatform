namespace Gemstone.PQDIF.Wasm.Models;

public partial class PqdifMetadataResponse
{
    public string VendorName { get; set; } = string.Empty;
    public string EquipmentName { get; set; } = string.Empty;
    public int ObservationCount { get; set; } = 0;
    public bool IsSuccess { get; set; } = false;
    public string ErrorMessage { get; set; } = string.Empty;
}