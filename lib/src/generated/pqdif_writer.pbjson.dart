// This is a generated file - do not edit.
//
// Generated from pqdif_writer.proto.

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

@$core.Deprecated('Use channelDefinitionDescriptor instead')
const ChannelDefinition$json = {
  '1': 'ChannelDefinition',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 5, '10': 'channelId'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'quantity_type', '3': 3, '4': 1, '5': 5, '10': 'quantityType'},
    {'1': 'quantity_units', '3': 4, '4': 1, '5': 5, '10': 'quantityUnits'},
    {'1': 'nominal_value', '3': 5, '4': 1, '5': 1, '10': 'nominalValue'},
  ],
};

/// Descriptor for `ChannelDefinition`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List channelDefinitionDescriptor = $convert.base64Decode(
    'ChFDaGFubmVsRGVmaW5pdGlvbhIdCgpjaGFubmVsX2lkGAEgASgFUgljaGFubmVsSWQSEgoEbm'
    'FtZRgCIAEoCVIEbmFtZRIjCg1xdWFudGl0eV90eXBlGAMgASgFUgxxdWFudGl0eVR5cGUSJQoO'
    'cXVhbnRpdHlfdW5pdHMYBCABKAVSDXF1YW50aXR5VW5pdHMSIwoNbm9taW5hbF92YWx1ZRgFIA'
    'EoAVIMbm9taW5hbFZhbHVl');

@$core.Deprecated('Use writeInitRequestDescriptor instead')
const WriteInitRequest$json = {
  '1': 'WriteInitRequest',
  '2': [
    {'1': 'file_path', '3': 1, '4': 1, '5': 9, '10': 'filePath'},
    {'1': 'equipment_name', '3': 2, '4': 1, '5': 9, '10': 'equipmentName'},
    {'1': 'vendor_name', '3': 3, '4': 1, '5': 9, '10': 'vendorName'},
    {
      '1': 'channels',
      '3': 4,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.ChannelDefinition',
      '10': 'channels'
    },
  ],
};

/// Descriptor for `WriteInitRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeInitRequestDescriptor = $convert.base64Decode(
    'ChBXcml0ZUluaXRSZXF1ZXN0EhsKCWZpbGVfcGF0aBgBIAEoCVIIZmlsZVBhdGgSJQoOZXF1aX'
    'BtZW50X25hbWUYAiABKAlSDWVxdWlwbWVudE5hbWUSHwoLdmVuZG9yX25hbWUYAyABKAlSCnZl'
    'bmRvck5hbWUSPQoIY2hhbm5lbHMYBCADKAsyIS5nZW1zdG9uZV9wcWRpZi5DaGFubmVsRGVmaW'
    '5pdGlvblIIY2hhbm5lbHM=');

@$core.Deprecated('Use writeChannelDataDescriptor instead')
const WriteChannelData$json = {
  '1': 'WriteChannelData',
  '2': [
    {'1': 'channel_id', '3': 1, '4': 1, '5': 5, '10': 'channelId'},
    {'1': 'data_raw', '3': 2, '4': 1, '5': 12, '10': 'dataRaw'},
  ],
};

/// Descriptor for `WriteChannelData`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeChannelDataDescriptor = $convert.base64Decode(
    'ChBXcml0ZUNoYW5uZWxEYXRhEh0KCmNoYW5uZWxfaWQYASABKAVSCWNoYW5uZWxJZBIZCghkYX'
    'RhX3JhdxgCIAEoDFIHZGF0YVJhdw==');

@$core.Deprecated('Use writeObservationRequestDescriptor instead')
const WriteObservationRequest$json = {
  '1': 'WriteObservationRequest',
  '2': [
    {'1': 'timestamp_ms', '3': 1, '4': 1, '5': 3, '10': 'timestampMs'},
    {
      '1': 'samples',
      '3': 2,
      '4': 3,
      '5': 11,
      '6': '.gemstone_pqdif.WriteChannelData',
      '10': 'samples'
    },
  ],
};

/// Descriptor for `WriteObservationRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeObservationRequestDescriptor = $convert.base64Decode(
    'ChdXcml0ZU9ic2VydmF0aW9uUmVxdWVzdBIhCgx0aW1lc3RhbXBfbXMYASABKANSC3RpbWVzdG'
    'FtcE1zEjoKB3NhbXBsZXMYAiADKAsyIC5nZW1zdG9uZV9wcWRpZi5Xcml0ZUNoYW5uZWxEYXRh'
    'UgdzYW1wbGVz');

@$core.Deprecated('Use writeResponseDescriptor instead')
const WriteResponse$json = {
  '1': 'WriteResponse',
  '2': [
    {'1': 'is_success', '3': 1, '4': 1, '5': 8, '10': 'isSuccess'},
    {'1': 'error_message', '3': 2, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'file_result', '3': 3, '4': 1, '5': 12, '10': 'fileResult'},
  ],
};

/// Descriptor for `WriteResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List writeResponseDescriptor = $convert.base64Decode(
    'Cg1Xcml0ZVJlc3BvbnNlEh0KCmlzX3N1Y2Nlc3MYASABKAhSCWlzU3VjY2VzcxIjCg1lcnJvcl'
    '9tZXNzYWdlGAIgASgJUgxlcnJvck1lc3NhZ2USHwoLZmlsZV9yZXN1bHQYAyABKAxSCmZpbGVS'
    'ZXN1bHQ=');
