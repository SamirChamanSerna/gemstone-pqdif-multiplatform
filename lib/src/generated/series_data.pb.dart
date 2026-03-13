// This is a generated file - do not edit.
//
// Generated from proto/series_data.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'series_data.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'series_data.pbenum.dart';

/// Petición de ventana de series
class SeriesWindowRequest extends $pb.GeneratedMessage {
  factory SeriesWindowRequest({
    $core.int? observationIndex,
    $core.int? channelIndex,
    $core.int? startIndex,
    $core.int? endIndex,
    $core.int? targetPoints,
  }) {
    final result = create();
    if (observationIndex != null) result.observationIndex = observationIndex;
    if (channelIndex != null) result.channelIndex = channelIndex;
    if (startIndex != null) result.startIndex = startIndex;
    if (endIndex != null) result.endIndex = endIndex;
    if (targetPoints != null) result.targetPoints = targetPoints;
    return result;
  }

  SeriesWindowRequest._();

  factory SeriesWindowRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeriesWindowRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeriesWindowRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'observationIndex')
    ..aI(2, _omitFieldNames ? '' : 'channelIndex')
    ..aI(3, _omitFieldNames ? '' : 'startIndex')
    ..aI(4, _omitFieldNames ? '' : 'endIndex')
    ..aI(5, _omitFieldNames ? '' : 'targetPoints')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeriesWindowRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeriesWindowRequest copyWith(void Function(SeriesWindowRequest) updates) =>
      super.copyWith((message) => updates(message as SeriesWindowRequest))
          as SeriesWindowRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeriesWindowRequest create() => SeriesWindowRequest._();
  @$core.override
  SeriesWindowRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeriesWindowRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeriesWindowRequest>(create);
  static SeriesWindowRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get observationIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set observationIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get channelIndex => $_getIZ(1);
  @$pb.TagNumber(2)
  set channelIndex($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannelIndex() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelIndex() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get startIndex => $_getIZ(2);
  @$pb.TagNumber(3)
  set startIndex($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartIndex() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartIndex() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get endIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set endIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEndIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get targetPoints => $_getIZ(4);
  @$pb.TagNumber(5)
  set targetPoints($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTargetPoints() => $_has(4);
  @$pb.TagNumber(5)
  void clearTargetPoints() => $_clearField(5);
}

/// Respuesta de ventana de series
class SeriesWindowResponse extends $pb.GeneratedMessage {
  factory SeriesWindowResponse({
    $core.bool? isSuccess,
    $core.String? errorMessage,
    ExtractionMode? mode,
    $core.int? bucketSize,
    $core.List<$core.int>? samplesBinary,
  }) {
    final result = create();
    if (isSuccess != null) result.isSuccess = isSuccess;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (mode != null) result.mode = mode;
    if (bucketSize != null) result.bucketSize = bucketSize;
    if (samplesBinary != null) result.samplesBinary = samplesBinary;
    return result;
  }

  SeriesWindowResponse._();

  factory SeriesWindowResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory SeriesWindowResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SeriesWindowResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isSuccess')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..aE<ExtractionMode>(3, _omitFieldNames ? '' : 'mode',
        enumValues: ExtractionMode.values)
    ..aI(4, _omitFieldNames ? '' : 'bucketSize')
    ..a<$core.List<$core.int>>(
        5, _omitFieldNames ? '' : 'samplesBinary', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeriesWindowResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SeriesWindowResponse copyWith(void Function(SeriesWindowResponse) updates) =>
      super.copyWith((message) => updates(message as SeriesWindowResponse))
          as SeriesWindowResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SeriesWindowResponse create() => SeriesWindowResponse._();
  @$core.override
  SeriesWindowResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static SeriesWindowResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SeriesWindowResponse>(create);
  static SeriesWindowResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $core.bool get isSuccess => $_getBF(0);
  @$pb.TagNumber(1)
  set isSuccess($core.bool value) => $_setBool(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIsSuccess() => $_has(0);
  @$pb.TagNumber(1)
  void clearIsSuccess() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get errorMessage => $_getSZ(1);
  @$pb.TagNumber(2)
  set errorMessage($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasErrorMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearErrorMessage() => $_clearField(2);

  @$pb.TagNumber(3)
  ExtractionMode get mode => $_getN(2);
  @$pb.TagNumber(3)
  set mode(ExtractionMode value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMode() => $_has(2);
  @$pb.TagNumber(3)
  void clearMode() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get bucketSize => $_getIZ(3);
  @$pb.TagNumber(4)
  set bucketSize($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasBucketSize() => $_has(3);
  @$pb.TagNumber(4)
  void clearBucketSize() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.List<$core.int> get samplesBinary => $_getN(4);
  @$pb.TagNumber(5)
  set samplesBinary($core.List<$core.int> value) => $_setBytes(4, value);
  @$pb.TagNumber(5)
  $core.bool hasSamplesBinary() => $_has(4);
  @$pb.TagNumber(5)
  void clearSamplesBinary() => $_clearField(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
