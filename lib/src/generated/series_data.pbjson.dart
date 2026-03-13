// This is a generated file - do not edit.
//
// Generated from proto/series_data.proto.

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
    {'1': 'channel_index', '3': 2, '4': 1, '5': 5, '10': 'channelIndex'},
    {'1': 'start_index', '3': 3, '4': 1, '5': 5, '10': 'startIndex'},
    {'1': 'end_index', '3': 4, '4': 1, '5': 5, '10': 'endIndex'},
    {'1': 'target_points', '3': 5, '4': 1, '5': 5, '10': 'targetPoints'},
  ],
};

/// Descriptor for `SeriesWindowRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seriesWindowRequestDescriptor = $convert.base64Decode(
    'ChNTZXJpZXNXaW5kb3dSZXF1ZXN0EisKEW9ic2VydmF0aW9uX2luZGV4GAEgASgFUhBvYnNlcn'
    'ZhdGlvbkluZGV4EiMKDWNoYW5uZWxfaW5kZXgYAiABKAVSDGNoYW5uZWxJbmRleBIfCgtzdGFy'
    'dF9pbmRleBgDIAEoBVIKc3RhcnRJbmRleBIbCgllbmRfaW5kZXgYBCABKAVSCGVuZEluZGV4Ei'
    'MKDXRhcmdldF9wb2ludHMYBSABKAVSDHRhcmdldFBvaW50cw==');

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
    {'1': 'samples_binary', '3': 5, '4': 1, '5': 12, '10': 'samplesBinary'},
  ],
};

/// Descriptor for `SeriesWindowResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List seriesWindowResponseDescriptor = $convert.base64Decode(
    'ChRTZXJpZXNXaW5kb3dSZXNwb25zZRIdCgppc19zdWNjZXNzGAEgASgIUglpc1N1Y2Nlc3MSIw'
    'oNZXJyb3JfbWVzc2FnZRgCIAEoCVIMZXJyb3JNZXNzYWdlEjIKBG1vZGUYAyABKA4yHi5nZW1z'
    'dG9uZV9wcWRpZi5FeHRyYWN0aW9uTW9kZVIEbW9kZRIfCgtidWNrZXRfc2l6ZRgEIAEoBVIKYn'
    'Vja2V0U2l6ZRIlCg5zYW1wbGVzX2JpbmFyeRgFIAEoDFINc2FtcGxlc0JpbmFyeQ==');
