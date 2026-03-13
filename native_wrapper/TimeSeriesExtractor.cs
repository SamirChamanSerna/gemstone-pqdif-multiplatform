#nullable enable
using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using Gemstone.PQDIF.Logical;
using GemstonePqdif;
using Google.Protobuf;

namespace Gemstone.PQDIF.Wasm;

public static class TimeSeriesExtractor
{
    public static async Task<SeriesWindowResponse> GetSeriesWindowAsync(
        Stream stream,
        int obsIdx, int chIdx, int start, int end, int targetPoints)
    {
        var response = new SeriesWindowResponse();
        try
        {
            using var parser = new LogicalParser();
            await parser.OpenAsync(stream, false);
            
            ObservationRecord? obsRecord = null;
            for (int i = 0; i <= obsIdx; i++)
            {
                if (await parser.HasNextObservationRecordAsync())
                {
                    obsRecord = await parser.NextObservationRecordAsync();
                }
                else
                {
                    throw new ArgumentException($"Observation index {obsIdx} out of range.");
                }
            }
            
            if (obsRecord == null) throw new Exception("Failed to get observation record.");
            
            if (chIdx < 0 || chIdx >= obsRecord.ChannelInstances.Count)
                throw new ArgumentException($"Channel index {chIdx} out of range.");
                
            var channel = obsRecord.ChannelInstances[chIdx];
            // Get the value series (usually not the time series, which is characteristic Time)
            var seriesRecord = channel.SeriesInstances.Last();
                            
            var valuesList = seriesRecord.OriginalValues.Cast<object>().ToList();
            int totalPoints = valuesList.Count;
            
            int startIndex = Math.Max(0, start);
            int endIndex = Math.Min(totalPoints, end);
            
            if (startIndex >= endIndex)
                throw new ArgumentException("Invalid start and end indices.");
                
            int requestedRange = endIndex - startIndex;
            int bucketSize = targetPoints > 0 ? requestedRange / targetPoints : 1;
            if (bucketSize < 1) bucketSize = 1;
            
            ExtractionMode mode = bucketSize > 1 ? ExtractionMode.MinMax : ExtractionMode.Raw;
            
            int numBuckets = (requestedRange + bucketSize - 1) / bucketSize;
            int outputCount = mode == ExtractionMode.MinMax ? numBuckets * 2 : requestedRange;
            
            double[] output = new double[outputCount];
            int outIdx = 0;
            
            if (mode == ExtractionMode.MinMax)
            {
                for (int i = startIndex; i < endIndex; i += bucketSize)
                {
                    double min = double.MaxValue;
                    double max = double.MinValue;
                    int endBucket = Math.Min(i + bucketSize, endIndex);
                    
                    for (int j = i; j < endBucket; j++)
                    {
                        double val = Convert.ToDouble(valuesList[j]);
                        if (val < min) min = val;
                        if (val > max) max = val;
                    }
                    
                    output[outIdx++] = min;
                    if (outIdx < output.Length)
                        output[outIdx++] = max;
                }
            }
            else
            {
                for (int i = startIndex; i < endIndex; i++)
                {
                    output[outIdx++] = Convert.ToDouble(valuesList[i]);
                }
            }
            
            byte[] binaryBytes = new byte[output.Length * sizeof(double)];
            Buffer.BlockCopy(output, 0, binaryBytes, 0, binaryBytes.Length);
            
            response.Mode = mode;
            response.BucketSize = bucketSize;
            response.SamplesBinary = ByteString.CopyFrom(binaryBytes);
            response.IsSuccess = true;
        }
        catch (Exception ex)
        {
            response.IsSuccess = false;
            response.ErrorMessage = ex.Message;
        }
        
        return response;
    }
}
