// This is a generated file - do not edit.
//
// Generated from series_data.proto.

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

class ChannelSummary extends $pb.GeneratedMessage {
  factory ChannelSummary({
    $core.int? channelIndex,
    $core.String? channelName,
    $core.String? phase,
    $core.String? quantityType,
  }) {
    final result = create();
    if (channelIndex != null) result.channelIndex = channelIndex;
    if (channelName != null) result.channelName = channelName;
    if (phase != null) result.phase = phase;
    if (quantityType != null) result.quantityType = quantityType;
    return result;
  }

  ChannelSummary._();

  factory ChannelSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChannelSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'channelIndex')
    ..aOS(2, _omitFieldNames ? '' : 'channelName')
    ..aOS(3, _omitFieldNames ? '' : 'phase')
    ..aOS(4, _omitFieldNames ? '' : 'quantityType')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelSummary copyWith(void Function(ChannelSummary) updates) =>
      super.copyWith((message) => updates(message as ChannelSummary))
          as ChannelSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChannelSummary create() => ChannelSummary._();
  @$core.override
  ChannelSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChannelSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelSummary>(create);
  static ChannelSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get channelName => $_getSZ(1);
  @$pb.TagNumber(2)
  set channelName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasChannelName() => $_has(1);
  @$pb.TagNumber(2)
  void clearChannelName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get phase => $_getSZ(2);
  @$pb.TagNumber(3)
  set phase($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPhase() => $_has(2);
  @$pb.TagNumber(3)
  void clearPhase() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get quantityType => $_getSZ(3);
  @$pb.TagNumber(4)
  set quantityType($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantityType() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantityType() => $_clearField(4);
}

class ObservationSummary extends $pb.GeneratedMessage {
  factory ObservationSummary({
    $core.int? observationIndex,
    $core.String? observationName,
    $core.String? startTime,
    $core.Iterable<ChannelSummary>? channels,
  }) {
    final result = create();
    if (observationIndex != null) result.observationIndex = observationIndex;
    if (observationName != null) result.observationName = observationName;
    if (startTime != null) result.startTime = startTime;
    if (channels != null) result.channels.addAll(channels);
    return result;
  }

  ObservationSummary._();

  factory ObservationSummary.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ObservationSummary.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ObservationSummary',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'observationIndex')
    ..aOS(2, _omitFieldNames ? '' : 'observationName')
    ..aOS(3, _omitFieldNames ? '' : 'startTime')
    ..pPM<ChannelSummary>(4, _omitFieldNames ? '' : 'channels',
        subBuilder: ChannelSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservationSummary clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ObservationSummary copyWith(void Function(ObservationSummary) updates) =>
      super.copyWith((message) => updates(message as ObservationSummary))
          as ObservationSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ObservationSummary create() => ObservationSummary._();
  @$core.override
  ObservationSummary createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ObservationSummary getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ObservationSummary>(create);
  static ObservationSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get observationIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set observationIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasObservationIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearObservationIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get observationName => $_getSZ(1);
  @$pb.TagNumber(2)
  set observationName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasObservationName() => $_has(1);
  @$pb.TagNumber(2)
  void clearObservationName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get startTime => $_getSZ(2);
  @$pb.TagNumber(3)
  set startTime($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasStartTime() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartTime() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ChannelSummary> get channels => $_getList(3);
}

class FileMetadataResponse extends $pb.GeneratedMessage {
  factory FileMetadataResponse({
    $core.bool? isSuccess,
    $core.String? errorMessage,
    $core.String? fileName,
    $core.String? equipmentModel,
    $core.String? manufacturer,
    $core.Iterable<ObservationSummary>? observations,
  }) {
    final result = create();
    if (isSuccess != null) result.isSuccess = isSuccess;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (fileName != null) result.fileName = fileName;
    if (equipmentModel != null) result.equipmentModel = equipmentModel;
    if (manufacturer != null) result.manufacturer = manufacturer;
    if (observations != null) result.observations.addAll(observations);
    return result;
  }

  FileMetadataResponse._();

  factory FileMetadataResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FileMetadataResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FileMetadataResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isSuccess')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..aOS(3, _omitFieldNames ? '' : 'fileName')
    ..aOS(4, _omitFieldNames ? '' : 'equipmentModel')
    ..aOS(5, _omitFieldNames ? '' : 'manufacturer')
    ..pPM<ObservationSummary>(6, _omitFieldNames ? '' : 'observations',
        subBuilder: ObservationSummary.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FileMetadataResponse copyWith(void Function(FileMetadataResponse) updates) =>
      super.copyWith((message) => updates(message as FileMetadataResponse))
          as FileMetadataResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse create() => FileMetadataResponse._();
  @$core.override
  FileMetadataResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FileMetadataResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FileMetadataResponse>(create);
  static FileMetadataResponse? _defaultInstance;

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
  $core.String get fileName => $_getSZ(2);
  @$pb.TagNumber(3)
  set fileName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileName() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileName() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get equipmentModel => $_getSZ(3);
  @$pb.TagNumber(4)
  set equipmentModel($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasEquipmentModel() => $_has(3);
  @$pb.TagNumber(4)
  void clearEquipmentModel() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get manufacturer => $_getSZ(4);
  @$pb.TagNumber(5)
  set manufacturer($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasManufacturer() => $_has(4);
  @$pb.TagNumber(5)
  void clearManufacturer() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<ObservationSummary> get observations => $_getList(5);
}

class FaultEvent extends $pb.GeneratedMessage {
  factory FaultEvent({
    $core.String? eventType,
    $core.double? magnitude,
    $core.double? durationMs,
    $core.int? channelIndex,
    $core.int? startIndex,
    $core.int? endIndex,
    $core.String? description,
  }) {
    final result = create();
    if (eventType != null) result.eventType = eventType;
    if (magnitude != null) result.magnitude = magnitude;
    if (durationMs != null) result.durationMs = durationMs;
    if (channelIndex != null) result.channelIndex = channelIndex;
    if (startIndex != null) result.startIndex = startIndex;
    if (endIndex != null) result.endIndex = endIndex;
    if (description != null) result.description = description;
    return result;
  }

  FaultEvent._();

  factory FaultEvent.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FaultEvent.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FaultEvent',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'eventType')
    ..aD(2, _omitFieldNames ? '' : 'magnitude')
    ..aD(3, _omitFieldNames ? '' : 'durationMs')
    ..aI(4, _omitFieldNames ? '' : 'channelIndex')
    ..aI(5, _omitFieldNames ? '' : 'startIndex')
    ..aI(6, _omitFieldNames ? '' : 'endIndex')
    ..aOS(7, _omitFieldNames ? '' : 'description')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaultEvent clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FaultEvent copyWith(void Function(FaultEvent) updates) =>
      super.copyWith((message) => updates(message as FaultEvent)) as FaultEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FaultEvent create() => FaultEvent._();
  @$core.override
  FaultEvent createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FaultEvent getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FaultEvent>(create);
  static FaultEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get eventType => $_getSZ(0);
  @$pb.TagNumber(1)
  set eventType($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasEventType() => $_has(0);
  @$pb.TagNumber(1)
  void clearEventType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get magnitude => $_getN(1);
  @$pb.TagNumber(2)
  set magnitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMagnitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearMagnitude() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get durationMs => $_getN(2);
  @$pb.TagNumber(3)
  set durationMs($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDurationMs() => $_has(2);
  @$pb.TagNumber(3)
  void clearDurationMs() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get channelIndex => $_getIZ(3);
  @$pb.TagNumber(4)
  set channelIndex($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasChannelIndex() => $_has(3);
  @$pb.TagNumber(4)
  void clearChannelIndex() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get startIndex => $_getIZ(4);
  @$pb.TagNumber(5)
  set startIndex($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasStartIndex() => $_has(4);
  @$pb.TagNumber(5)
  void clearStartIndex() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get endIndex => $_getIZ(5);
  @$pb.TagNumber(6)
  set endIndex($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEndIndex() => $_has(5);
  @$pb.TagNumber(6)
  void clearEndIndex() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get description => $_getSZ(6);
  @$pb.TagNumber(7)
  set description($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasDescription() => $_has(6);
  @$pb.TagNumber(7)
  void clearDescription() => $_clearField(7);
}

/// Petición de ventana de series
class SeriesWindowRequest extends $pb.GeneratedMessage {
  factory SeriesWindowRequest({
    $core.int? observationIndex,
    $core.Iterable<$core.int>? channelIndices,
    $core.int? startIndex,
    $core.int? endIndex,
    $core.int? targetPoints,
  }) {
    final result = create();
    if (observationIndex != null) result.observationIndex = observationIndex;
    if (channelIndices != null) result.channelIndices.addAll(channelIndices);
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
    ..p<$core.int>(
        2, _omitFieldNames ? '' : 'channelIndices', $pb.PbFieldType.K3)
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
  $pb.PbList<$core.int> get channelIndices => $_getList(1);

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

class ChannelData extends $pb.GeneratedMessage {
  factory ChannelData({
    $core.int? channelIndex,
    $core.List<$core.int>? samplesBinary,
  }) {
    final result = create();
    if (channelIndex != null) result.channelIndex = channelIndex;
    if (samplesBinary != null) result.samplesBinary = samplesBinary;
    return result;
  }

  ChannelData._();

  factory ChannelData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChannelData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'channelIndex')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'samplesBinary', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelData copyWith(void Function(ChannelData) updates) =>
      super.copyWith((message) => updates(message as ChannelData))
          as ChannelData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChannelData create() => ChannelData._();
  @$core.override
  ChannelData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChannelData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelData>(create);
  static ChannelData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get samplesBinary => $_getN(1);
  @$pb.TagNumber(2)
  set samplesBinary($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSamplesBinary() => $_has(1);
  @$pb.TagNumber(2)
  void clearSamplesBinary() => $_clearField(2);
}

/// Respuesta de ventana de series
class SeriesWindowResponse extends $pb.GeneratedMessage {
  factory SeriesWindowResponse({
    $core.bool? isSuccess,
    $core.String? errorMessage,
    ExtractionMode? mode,
    $core.int? bucketSize,
    $core.Iterable<ChannelData>? channelData,
    $core.Iterable<FaultEvent>? faults,
  }) {
    final result = create();
    if (isSuccess != null) result.isSuccess = isSuccess;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (mode != null) result.mode = mode;
    if (bucketSize != null) result.bucketSize = bucketSize;
    if (channelData != null) result.channelData.addAll(channelData);
    if (faults != null) result.faults.addAll(faults);
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
    ..pPM<ChannelData>(5, _omitFieldNames ? '' : 'channelData',
        subBuilder: ChannelData.create)
    ..pPM<FaultEvent>(6, _omitFieldNames ? '' : 'faults',
        subBuilder: FaultEvent.create)
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
  $pb.PbList<ChannelData> get channelData => $_getList(4);

  @$pb.TagNumber(6)
  $pb.PbList<FaultEvent> get faults => $_getList(5);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
