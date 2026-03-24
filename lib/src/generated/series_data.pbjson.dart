// This is a generated file - do not edit.
//
// Generated from series_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use extractionModeDescriptor instead')
const ExtractionMode$json = {
  '1': 'ExtractionMode',
  '2': [
    {'1': 'RAW', '2': 0},
    {'1': 'MIN_MAX', '2': 1},
  ],
};

/// Descriptor for `ExtractionMode`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List extractionModeDescriptor = $convert
    .base64Decode('Cg5FeHRyYWN0aW9uTW9kZRIHCgNSQVcQABILCgdNSU5fTUFYEAE=');

@$core.Deprecated('Use channelSummaryDescriptor instead')
const ChannelSummary$json = {
  '1': 'ChannelSummary',
  '2': [
    {'1': 'channel_index', '3': 1, '4': 1, '5': 5, '10': 'channelIndex'},
    {'1': 'channel_name', '3': 2, '4': 1, '5': 9, '10': 'channelName'},
    {'1': 'phase', '3': 3, '4': 1, '5': 9, '10': 'phase'},
    {'1': 'quantity_type', '3': 4, '4': 1, '5': 9, '10': 'quantityType'},
  ],
};

/// Descriptor for `ChannelSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelSummaryDescriptor = $convert.base64Decode(
    'Cg5DaGFubmVsU3VtbWFyeRIjCg1jaGFubmVsX2luZGV4GAEgASgFUgxjaGFubmVsSW5kZXgSIQ'
    'oMY2hhbm5lbF9uYW1lGAIgASgJUgtjaGFubmVsTmFtZRIUCgVwaGFzZRgDIAEoCVIFcGhhc2US'
    'IwoNcXVhbnRpdHlfdHlwZRgEIAEoCVIMcXVhbnRpdHlUeXBl');

@$core.Deprecated('Use observationSummaryDescriptor instead')
const ObservationSummary$json = {
  '1': 'ObservationSummary',
  '2': [
    {
      '1': 'observation_index',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'observationIndex'
    },
    {'1': 'observation_name', '3': 2, '4': 1, '5': 9, '10': 'observationName'},
    {'1': 'start_time', '3': 3, '4': 1, '5': 9, '10': 'startTime'},
    {
      '1': 'channels',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.ChannelSummary',
      '10': 'channels'
    },
    {
      '1': 'disturbance_category',
      '3': 5,
      '4': 1,
      '5': 9,
      '10': 'disturbanceCategory'
    },
    {
      '1': 'disturbance_description',
      '3': 6,
      '4': 1,
      '5': 9,
      '10': 'disturbanceDescription'
    },
    {'1': 'time_triggered', '3': 7, '4': 1, '5': 9, '10': 'timeTriggered'},
  ],
};

/// Descriptor for `ObservationSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List observationSummaryDescriptor = $convert.base64Decode(
    'ChJPYnNlcnZhdGlvblN1bW1hcnkSKwoRb2JzZXJ2YXRpb25faW5kZXgYASABKAVSEG9ic2Vydm'
    'F0aW9uSW5kZXgSKQoQb2JzZXJ2YXRpb25fbmFtZRgCIAEoCVIPb2JzZXJ2YXRpb25OYW1lEh0K'
    'CnN0YXJ0X3RpbWUYAyABKAlSCXN0YXJ0VGltZRI6CghjaGFubmVscxgEIAMoCzIeLmdlbXN0b2'
    '5lX3BxZGlmLkNoYW5uZWxTdW1tYXJ5UghjaGFubmVscxIxChRkaXN0dXJiYW5jZV9jYXRlZ29y'
    'eRgFIAEoCVITZGlzdHVyYmFuY2VDYXRlZ29yeRI3ChdkaXN0dXJiYW5jZV9kZXNjcmlwdGlvbh'
    'gGIAEoCVIWZGlzdHVyYmFuY2VEZXNjcmlwdGlvbhIlCg50aW1lX3RyaWdnZXJlZBgHIAEoCVIN'
    'dGltZVRyaWdnZXJlZA==');

@$core.Deprecated('Use fileMetadataResponseDescriptor instead')
const FileMetadataResponse$json = {
  '1': 'FileMetadataResponse',
  '2': [
    {'1': 'is_success', '3': 1, '4': 1, '5': 8, '10': 'isSuccess'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'file_name', '3': 3, '4': 1, '5': 9, '10': 'fileName'},
    {'1': 'equipment_model', '3': 4, '4': 1, '5': 9, '10': 'equipmentModel'},
    {'1': 'manufacturer', '3': 5, '4': 1, '5': 9, '10': 'manufacturer'},
    {
      '1': 'observations',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.ObservationSummary',
      '10': 'observations'
    },
  ],
};

/// Descriptor for `FileMetadataResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fileMetadataResponseDescriptor = $convert.base64Decode(
    'ChRGaWxlTWV0YWRhdGFSZXNwb25zZRIdCgppc19zdWNjZXNzGAEgASgIUglpc1N1Y2Nlc3MSIw'
    'oNZXJyb3JfbWVzc2FnZRgCIAEoCVIMZXJyb3JNZXNzYWdlEhsKCWZpbGVfbmFtZRgDIAEoCVII'
    'ZmlsZU5hbWUSJwoPZXF1aXBtZW50X21vZGVsGAQgASgJUg5lcXVpcG1lbnRNb2RlbBIiCgxtYW'
    '51ZmFjdHVyZXIYBSABKAlSDG1hbnVmYWN0dXJlchJGCgxvYnNlcnZhdGlvbnMYBiADKAsyIi5n'
    'ZW1zdG9uZV9wcWRpZi5PYnNlcnZhdGlvblN1bW1hcnlSDG9ic2VydmF0aW9ucw==');

@$core.Deprecated('Use faultEventDescriptor instead')
const FaultEvent$json = {
  '1': 'FaultEvent',
  '2': [
    {'1': 'event_type', '3': 1, '4': 1, '5': 9, '10': 'eventType'},
    {'1': 'magnitude', '3': 2, '4': 1, '5': 1, '10': 'magnitude'},
    {'1': 'duration_ms', '3': 3, '4': 1, '5': 1, '10': 'durationMs'},
    {'1': 'channel_index', '3': 4, '4': 1, '5': 5, '10': 'channelIndex'},
    {'1': 'start_index', '3': 5, '4': 1, '5': 5, '10': 'startIndex'},
    {'1': 'end_index', '3': 6, '4': 1, '5': 5, '10': 'endIndex'},
    {'1': 'description', '3': 7, '4': 1, '5': 9, '10': 'description'},
  ],
};

/// Descriptor for `FaultEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List faultEventDescriptor = $convert.base64Decode(
    'CgpGYXVsdEV2ZW50Eh0KCmV2ZW50X3R5cGUYASABKAlSCWV2ZW50VHlwZRIcCgltYWduaXR1ZG'
    'UYAiABKAFSCW1hZ25pdHVkZRIfCgtkdXJhdGlvbl9tcxgDIAEoAVIKZHVyYXRpb25NcxIjCg1j'
    'aGFubmVsX2luZGV4GAQgASgFUgxjaGFubmVsSW5kZXgSHwoLc3RhcnRfaW5kZXgYBSABKAVSCn'
    'N0YXJ0SW5kZXgSGwoJZW5kX2luZGV4GAYgASgFUghlbmRJbmRleBIgCgtkZXNjcmlwdGlvbhgH'
    'IAEoCVILZGVzY3JpcHRpb24=');

@$core.Deprecated('Use seriesWindowRequestDescriptor instead')
const SeriesWindowRequest$json = {
  '1': 'SeriesWindowRequest',
  '2': [
    {
      '1': 'observation_index',
      '3': 1,
      '4': 1,
      '5': 5,
      '10': 'observationIndex'
    },
    {'1': 'channel_indices', '3': 2, '4': 3, '5': 5, '10': 'channelIndices'},
    {'1': 'start_index', '3': 3, '4': 1, '5': 5, '10': 'startIndex'},
    {'1': 'end_index', '3': 4, '4': 1, '5': 5, '10': 'endIndex'},
    {'1': 'target_points', '3': 5, '4': 1, '5': 5, '10': 'targetPoints'},
  ],
};

/// Descriptor for `SeriesWindowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seriesWindowRequestDescriptor = $convert.base64Decode(
    'ChNTZXJpZXNXaW5kb3dSZXF1ZXN0EisKEW9ic2VydmF0aW9uX2luZGV4GAEgASgFUhBvYnNlcn'
    'ZhdGlvbkluZGV4EicKD2NoYW5uZWxfaW5kaWNlcxgCIAMoBVIOY2hhbm5lbEluZGljZXMSHwoL'
    'c3RhcnRfaW5kZXgYAyABKAVSCnN0YXJ0SW5kZXgSGwoJZW5kX2luZGV4GAQgASgFUghlbmRJbm'
    'RleBIjCg10YXJnZXRfcG9pbnRzGAUgASgFUgx0YXJnZXRQb2ludHM=');

@$core.Deprecated('Use channelDataDescriptor instead')
const ChannelData$json = {
  '1': 'ChannelData',
  '2': [
    {'1': 'channel_index', '3': 1, '4': 1, '5': 5, '10': 'channelIndex'},
    {'1': 'samples_binary', '3': 2, '4': 1, '5': 12, '10': 'samplesBinary'},
  ],
};

/// Descriptor for `ChannelData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDataDescriptor = $convert.base64Decode(
    'CgtDaGFubmVsRGF0YRIjCg1jaGFubmVsX2luZGV4GAEgASgFUgxjaGFubmVsSW5kZXgSJQoOc2'
    'FtcGxlc19iaW5hcnkYAiABKAxSDXNhbXBsZXNCaW5hcnk=');

@$core.Deprecated('Use seriesWindowResponseDescriptor instead')
const SeriesWindowResponse$json = {
  '1': 'SeriesWindowResponse',
  '2': [
    {'1': 'is_success', '3': 1, '4': 1, '5': 8, '10': 'isSuccess'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {
      '1': 'mode',
      '3': 3,
      '4': 1,
      '5': 14,
      '6': '.gemstone_pqdif.ExtractionMode',
      '10': 'mode'
    },
    {'1': 'bucket_size', '3': 4, '4': 1, '5': 5, '10': 'bucketSize'},
    {
      '1': 'channel_data',
      '3': 5,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.ChannelData',
      '10': 'channelData'
    },
    {
      '1': 'faults',
      '3': 6,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.FaultEvent',
      '10': 'faults'
    },
  ],
};

/// Descriptor for `SeriesWindowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seriesWindowResponseDescriptor = $convert.base64Decode(
    'ChRTZXJpZXNXaW5kb3dSZXNwb25zZRIdCgppc19zdWNjZXNzGAEgASgIUglpc1N1Y2Nlc3MSIw'
    'oNZXJyb3JfbWVzc2FnZRgCIAEoCVIMZXJyb3JNZXNzYWdlEjIKBG1vZGUYAyABKA4yHi5nZW1z'
    'dG9uZV9wcWRpZi5FeHRyYWN0aW9uTW9kZVIEbW9kZRIfCgtidWNrZXRfc2l6ZRgEIAEoBVIKYn'
    'Vja2V0U2l6ZRI+CgxjaGFubmVsX2RhdGEYBSADKAsyGy5nZW1zdG9uZV9wcWRpZi5DaGFubmVs'
    'RGF0YVILY2hhbm5lbERhdGESMgoGZmF1bHRzGAYgAygLMhouZ2Vtc3RvbmVfcHFkaWYuRmF1bH'
    'RFdmVudFIGZmF1bHRz');
