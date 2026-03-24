using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using Gemstone.PQDIF.Logical;
using Gemstone.PQDIF.Physical;
using GemstonePqdif;
using Google.Protobuf;

namespace Gemstone.PQDIF.Wasm;

public class PqdifWriterSession : IDisposable
{
    private LogicalWriter _writer;
    private Stream _outputStream;
    private bool _isWeb;
    private DataSourceRecord _dataSource;
    private MonitorSettingsRecord _settings;
    private Dictionary<int, Gemstone.PQDIF.Logical.ChannelDefinition> _channelDefs = new Dictionary<int, Gemstone.PQDIF.Logical.ChannelDefinition>();

    public PqdifWriterSession(WriteInitRequest request)
    {
        _isWeb = string.IsNullOrEmpty(request.FilePath);
        if (_isWeb)
        {
            _outputStream = new MemoryStream();
        }
        else
        {
            _outputStream = new FileStream(request.FilePath, FileMode.Create, FileAccess.Write);
        }

        _writer = new LogicalWriter(_outputStream);

        var containerRecord = ContainerRecord.CreateContainerRecord();
        containerRecord.FileName = _isWeb ? "export.pqd" : Path.GetFileName(request.FilePath) ?? "export.pqd";
        _writer.WriteAsync(containerRecord).GetAwaiter().GetResult();

        _dataSource = DataSourceRecord.CreateDataSourceRecord(request.EquipmentName);
        _dataSource.DataSourceOwner = request.VendorName;

        _settings = MonitorSettingsRecord.CreateMonitorSettingsRecord();
        _settings.NominalFrequency = 60.0;
        
        foreach (var ch in request.Channels)
        {
            var def = _dataSource.AddNewChannelDefinition();
            def.ChannelName = ch.Name;
            
            SeriesDefinition seriesDef;
            if (def.SeriesDefinitions.Count == 0)
            {
                seriesDef = def.AddNewSeriesDefinition();
            }
            else
            {
                seriesDef = def.SeriesDefinitions.First();
            }

            seriesDef.ValueTypeID = SeriesValueType.Val;
            seriesDef.QuantityCharacteristicID = QuantityCharacteristic.Instantaneous; // dummy or real

            _channelDefs[ch.ChannelId] = def;
        }
    }

    public void AddObservation(WriteObservationRequest request)
    {
        var obs = ObservationRecord.CreateObservationRecord(_dataSource, _settings);
        obs.StartTime = DateTimeOffset.FromUnixTimeMilliseconds(request.TimestampMs).UtcDateTime;

        foreach (var ch in request.Samples)
        {
            if (_channelDefs.TryGetValue(ch.ChannelId, out var def))
            {
                var channelInstance = obs.AddNewChannelInstance(def);
                var seriesInstance = channelInstance.AddNewSeriesInstance();
                
                var span = ch.DataRaw.Span;
                var doubleSpan = MemoryMarshal.Cast<byte, double>(span);
                
                // Set the double array
                var objList = new List<object>();
                foreach(var val in doubleSpan) objList.Add(val);
                seriesInstance.SetValues(objList);
            }
        }
        
        _writer.WriteAsync(obs, false).GetAwaiter().GetResult();
    }

    public WriteResponse FinalizeSession()
    {
        _writer.Dispose();
        
        var response = new WriteResponse { IsSuccess = true };
        if (_isWeb)
        {
            var ms = (MemoryStream)_outputStream;
            response.FileResult = ByteString.CopyFrom(ms.ToArray());
        }
        
        _outputStream.Dispose();
        return response;
    }

    public void Dispose()
    {
        _writer?.Dispose();
        _outputStream?.Dispose();
    }
}
