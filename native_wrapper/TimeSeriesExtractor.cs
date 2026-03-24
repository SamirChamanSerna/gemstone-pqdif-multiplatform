#nullable enable
using System;
using System.IO;
using System.Linq;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Runtime.InteropServices;
using Gemstone.PQDIF.Logical;
using GemstonePqdif;
using Google.Protobuf;

namespace Gemstone.PQDIF.Wasm;

public static class TimeSeriesExtractor
{
    public static async Task<SeriesWindowResponse> GetSeriesWindowAsync(
        Stream stream,
        int obsIdx, IEnumerable<int> chIndices, int start, int end, int targetPoints)
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
            
            response.IsSuccess = true;
            
            int bucketSize = 1;
            ExtractionMode mode = ExtractionMode.Raw;

            // Simple fault scanner dummy
            // (Real implementation would scan thresholds)
            
            foreach (var chIdx in chIndices)
            {
                if (chIdx < 0 || chIdx >= obsRecord.ChannelInstances.Count)
                    continue;
                    
                var channel = obsRecord.ChannelInstances[chIdx];
                // Try to find the values series, avoiding the Time series and Status series
                var seriesRecord = channel.SeriesInstances.FirstOrDefault(s => s.Definition.ValueTypeID == SeriesValueType.Val)
                                ?? channel.SeriesInstances.FirstOrDefault(s => s.Definition.ValueTypeID == SeriesValueType.Min || s.Definition.ValueTypeID == SeriesValueType.Max || s.Definition.ValueTypeID == SeriesValueType.Avg || s.Definition.ValueTypeID == SeriesValueType.Inst)
                                ?? channel.SeriesInstances.FirstOrDefault(s => s.Definition.ValueTypeID != SeriesValueType.Time && s.Definition.ValueTypeID != SeriesValueType.Status && s.OriginalValues != null)
                                ?? channel.SeriesInstances.LastOrDefault(s => s.OriginalValues != null && !(s.OriginalValues is DateTime[])) 
                                ?? channel.SeriesInstances.Last();
                
                var valuesList = seriesRecord.OriginalValues as System.Collections.IList;
                if (valuesList == null) continue;

                double scale = 1.0;
                double offset = 0.0;

                try {
                    if (seriesRecord.SeriesScale != null) {
                        scale = Convert.ToDouble(seriesRecord.SeriesScale.Get());
                    }
                } catch { }

                try {
                    if (seriesRecord.SeriesOffset != null) {
                        offset = Convert.ToDouble(seriesRecord.SeriesOffset.Get());
                    }
                } catch { }

                int totalPoints = valuesList.Count;
                
                int startIndex = Math.Max(0, start);
                int endIndex = Math.Min(totalPoints, end);
                
                if (startIndex >= endIndex) continue;
                    
                int requestedRange = endIndex - startIndex;
                bucketSize = targetPoints > 0 ? requestedRange / targetPoints : 1;
                if (bucketSize < 1) bucketSize = 1;
                
                mode = bucketSize > 1 ? ExtractionMode.MinMax : ExtractionMode.Raw;
                
                int numBuckets = (requestedRange + bucketSize - 1) / bucketSize;
                int outputCount = mode == ExtractionMode.MinMax ? numBuckets * 2 : requestedRange;
                
                double[] output = new double[outputCount];
                int outIdx = 0;
                
                if (valuesList is double[] doubleArray)
                {
                    ProcessArray(doubleArray.AsSpan(startIndex, requestedRange), bucketSize, mode, output, scale, offset);
                }
                else if (valuesList is float[] floatArray)
                {
                    ProcessArray(floatArray.AsSpan(startIndex, requestedRange), bucketSize, mode, output, scale, offset);
                }
                else if (valuesList is int[] intArray)
                {
                    ProcessArray(intArray.AsSpan(startIndex, requestedRange), bucketSize, mode, output, scale, offset);
                }
                else if (valuesList is short[] shortArray)
                {
                    ProcessArray(shortArray.AsSpan(startIndex, requestedRange), bucketSize, mode, output, scale, offset);
                }
                else if (valuesList is ushort[] ushortArray)
                {
                    ProcessArray(ushortArray.AsSpan(startIndex, requestedRange), bucketSize, mode, output, scale, offset);
                }
                else
                {
                    // Fallback for IList<object> or other lists
                    if (mode == ExtractionMode.MinMax)
                    {
                        for (int i = startIndex; i < endIndex; i += bucketSize)
                        {
                            double min = double.MaxValue;
                            double max = double.MinValue;
                            int endBucket = Math.Min(i + bucketSize, endIndex);
                            
                            for (int j = i; j < endBucket; j++)
                            {
                                double val = Convert.ToDouble(valuesList[j]) * scale + offset;
                                if (val < min) min = val;
                                if (val > max) max = val;
                            }
                            
                            output[outIdx++] = min;
                            if (outIdx < output.Length) output[outIdx++] = max;
                        }
                    }
                    else
                    {
                        for (int i = startIndex; i < endIndex; i++)
                        {
                            output[outIdx++] = Convert.ToDouble(valuesList[i]) * scale + offset;
                        }
                    }
                }
                
                // Extract declared disturbance from the PQDIF file
                try {
                    if (obsRecord.DisturbanceCategoryID != Guid.Empty && obsRecord.DisturbanceCategoryID != DisturbanceCategory.None) {
                        var distInfo = DisturbanceCategory.GetInfo(obsRecord.DisturbanceCategoryID);
                        if (distInfo != null) {
                            // Check if we already added this observation's fault to avoid duplicates if multiple channels are processed
                            bool alreadyAdded = response.Faults.Any(f => f.EventType == distInfo.Name && f.ChannelIndex == chIdx);
                            if (!alreadyAdded) {
                                response.Faults.Add(new FaultEvent {
                                    EventType = distInfo.Name ?? "Perturbación",
                                    Magnitude = 0,
                                    DurationMs = 0,
                                    ChannelIndex = chIdx,
                                    StartIndex = startIndex,
                                    EndIndex = endIndex,
                                    Description = distInfo.Description ?? "Falla declarada en el registro PQDIF"
                                });
                            }
                        }
                    }
                } catch { }

                var binaryBytes = MemoryMarshal.AsBytes<double>(output).ToArray();
                
                response.ChannelData.Add(new ChannelData
                {
                    ChannelIndex = chIdx,
                    SamplesBinary = ByteString.CopyFrom(binaryBytes)
                });
            }
            
            response.Mode = mode;
            response.BucketSize = bucketSize;
        }
        catch (Exception ex)
        {
            response.IsSuccess = false;
            response.ErrorMessage = ex.Message;
        }
        
        return response;
    }

    private static void ProcessArray(ReadOnlySpan<double> span, int bucketSize, ExtractionMode mode, double[] output, double scale, double offset)
    {
        ProcessArrayInternal(span, bucketSize, mode, output, val => val * scale + offset);
    }

    private static void ProcessArray(ReadOnlySpan<float> span, int bucketSize, ExtractionMode mode, double[] output, double scale, double offset)
    {
        ProcessArrayInternal(span, bucketSize, mode, output, val => (double)val * scale + offset);
    }

    private static void ProcessArray(ReadOnlySpan<int> span, int bucketSize, ExtractionMode mode, double[] output, double scale, double offset)
    {
        ProcessArrayInternal(span, bucketSize, mode, output, val => (double)val * scale + offset);
    }

    private static void ProcessArray(ReadOnlySpan<short> span, int bucketSize, ExtractionMode mode, double[] output, double scale, double offset)
    {
        ProcessArrayInternal(span, bucketSize, mode, output, val => (double)val * scale + offset);
    }

    private static void ProcessArray(ReadOnlySpan<ushort> span, int bucketSize, ExtractionMode mode, double[] output, double scale, double offset)
    {
        ProcessArrayInternal(span, bucketSize, mode, output, val => (double)val * scale + offset);
    }

    private delegate double Converter<T>(T value);

    private static void ProcessArrayInternal<T>(ReadOnlySpan<T> span, int bucketSize, ExtractionMode mode, double[] output, Converter<T> converter)
    {
        int outIdx = 0;
        int length = span.Length;

        if (mode == ExtractionMode.MinMax)
        {
            for (int i = 0; i < length; i += bucketSize)
            {
                double min = double.MaxValue;
                double max = double.MinValue;
                int endBucket = Math.Min(i + bucketSize, length);
                
                for (int j = i; j < endBucket; j++)
                {
                    double val = converter(span[j]);
                    if (val < min) min = val;
                    if (val > max) max = val;
                }
                
                output[outIdx++] = min;
                if (outIdx < output.Length) output[outIdx++] = max;
            }
        }
        else
        {
            for (int i = 0; i < length; i++)
            {
                output[outIdx++] = converter(span[i]);
            }
        }
    }
}