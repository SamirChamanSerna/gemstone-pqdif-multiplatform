// This is a generated file - do not edit.
//
// Generated from pqdif_writer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class ChannelDefinition extends $pb.GeneratedMessage {
  factory ChannelDefinition({
    $core.int? channelId,
    $core.String? name,
    $core.int? quantityType,
    $core.int? quantityUnits,
    $core.double? nominalValue,
  }) {
    final result = create();
    if (channelId != null) result.channelId = channelId;
    if (name != null) result.name = name;
    if (quantityType != null) result.quantityType = quantityType;
    if (quantityUnits != null) result.quantityUnits = quantityUnits;
    if (nominalValue != null) result.nominalValue = nominalValue;
    return result;
  }

  ChannelDefinition._();

  factory ChannelDefinition.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ChannelDefinition.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ChannelDefinition',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'channelId')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aI(3, _omitFieldNames ? '' : 'quantityType')
    ..aI(4, _omitFieldNames ? '' : 'quantityUnits')
    ..aD(5, _omitFieldNames ? '' : 'nominalValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelDefinition clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ChannelDefinition copyWith(void Function(ChannelDefinition) updates) =>
      super.copyWith((message) => updates(message as ChannelDefinition))
          as ChannelDefinition;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChannelDefinition create() => ChannelDefinition._();
  @$core.override
  ChannelDefinition createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ChannelDefinition getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ChannelDefinition>(create);
  static ChannelDefinition? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelId => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get quantityType => $_getIZ(2);
  @$pb.TagNumber(3)
  set quantityType($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasQuantityType() => $_has(2);
  @$pb.TagNumber(3)
  void clearQuantityType() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.int get quantityUnits => $_getIZ(3);
  @$pb.TagNumber(4)
  set quantityUnits($core.int value) => $_setSignedInt32(3, value);
  @$pb.TagNumber(4)
  $core.bool hasQuantityUnits() => $_has(3);
  @$pb.TagNumber(4)
  void clearQuantityUnits() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get nominalValue => $_getN(4);
  @$pb.TagNumber(5)
  set nominalValue($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasNominalValue() => $_has(4);
  @$pb.TagNumber(5)
  void clearNominalValue() => $_clearField(5);
}

class WriteInitRequest extends $pb.GeneratedMessage {
  factory WriteInitRequest({
    $core.String? filePath,
    $core.String? equipmentName,
    $core.String? vendorName,
    $core.Iterable<ChannelDefinition>? channels,
  }) {
    final result = create();
    if (filePath != null) result.filePath = filePath;
    if (equipmentName != null) result.equipmentName = equipmentName;
    if (vendorName != null) result.vendorName = vendorName;
    if (channels != null) result.channels.addAll(channels);
    return result;
  }

  WriteInitRequest._();

  factory WriteInitRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteInitRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteInitRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'filePath')
    ..aOS(2, _omitFieldNames ? '' : 'equipmentName')
    ..aOS(3, _omitFieldNames ? '' : 'vendorName')
    ..pPM<ChannelDefinition>(4, _omitFieldNames ? '' : 'channels',
        subBuilder: ChannelDefinition.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteInitRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteInitRequest copyWith(void Function(WriteInitRequest) updates) =>
      super.copyWith((message) => updates(message as WriteInitRequest))
          as WriteInitRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteInitRequest create() => WriteInitRequest._();
  @$core.override
  WriteInitRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteInitRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteInitRequest>(create);
  static WriteInitRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get filePath => $_getSZ(0);
  @$pb.TagNumber(1)
  set filePath($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFilePath() => $_has(0);
  @$pb.TagNumber(1)
  void clearFilePath() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get equipmentName => $_getSZ(1);
  @$pb.TagNumber(2)
  set equipmentName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasEquipmentName() => $_has(1);
  @$pb.TagNumber(2)
  void clearEquipmentName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get vendorName => $_getSZ(2);
  @$pb.TagNumber(3)
  set vendorName($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasVendorName() => $_has(2);
  @$pb.TagNumber(3)
  void clearVendorName() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<ChannelDefinition> get channels => $_getList(3);
}

class WriteChannelData extends $pb.GeneratedMessage {
  factory WriteChannelData({
    $core.int? channelId,
    $core.List<$core.int>? dataRaw,
  }) {
    final result = create();
    if (channelId != null) result.channelId = channelId;
    if (dataRaw != null) result.dataRaw = dataRaw;
    return result;
  }

  WriteChannelData._();

  factory WriteChannelData.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteChannelData.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteChannelData',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'channelId')
    ..a<$core.List<$core.int>>(
        2, _omitFieldNames ? '' : 'dataRaw', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteChannelData clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteChannelData copyWith(void Function(WriteChannelData) updates) =>
      super.copyWith((message) => updates(message as WriteChannelData))
          as WriteChannelData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteChannelData create() => WriteChannelData._();
  @$core.override
  WriteChannelData createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteChannelData getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteChannelData>(create);
  static WriteChannelData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get channelId => $_getIZ(0);
  @$pb.TagNumber(1)
  set channelId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasChannelId() => $_has(0);
  @$pb.TagNumber(1)
  void clearChannelId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.List<$core.int> get dataRaw => $_getN(1);
  @$pb.TagNumber(2)
  set dataRaw($core.List<$core.int> value) => $_setBytes(1, value);
  @$pb.TagNumber(2)
  $core.bool hasDataRaw() => $_has(1);
  @$pb.TagNumber(2)
  void clearDataRaw() => $_clearField(2);
}

class WriteObservationRequest extends $pb.GeneratedMessage {
  factory WriteObservationRequest({
    $fixnum.Int64? timestampMs,
    $core.Iterable<WriteChannelData>? samples,
  }) {
    final result = create();
    if (timestampMs != null) result.timestampMs = timestampMs;
    if (samples != null) result.samples.addAll(samples);
    return result;
  }

  WriteObservationRequest._();

  factory WriteObservationRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteObservationRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteObservationRequest',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'timestampMs')
    ..pPM<WriteChannelData>(2, _omitFieldNames ? '' : 'samples',
        subBuilder: WriteChannelData.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteObservationRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteObservationRequest copyWith(
          void Function(WriteObservationRequest) updates) =>
      super.copyWith((message) => updates(message as WriteObservationRequest))
          as WriteObservationRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteObservationRequest create() => WriteObservationRequest._();
  @$core.override
  WriteObservationRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteObservationRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteObservationRequest>(create);
  static WriteObservationRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get timestampMs => $_getI64(0);
  @$pb.TagNumber(1)
  set timestampMs($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTimestampMs() => $_has(0);
  @$pb.TagNumber(1)
  void clearTimestampMs() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<WriteChannelData> get samples => $_getList(1);
}

class WriteResponse extends $pb.GeneratedMessage {
  factory WriteResponse({
    $core.bool? isSuccess,
    $core.String? errorMessage,
    $core.List<$core.int>? fileResult,
  }) {
    final result = create();
    if (isSuccess != null) result.isSuccess = isSuccess;
    if (errorMessage != null) result.errorMessage = errorMessage;
    if (fileResult != null) result.fileResult = fileResult;
    return result;
  }

  WriteResponse._();

  factory WriteResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory WriteResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'WriteResponse',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'gemstone_pqdif'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'isSuccess')
    ..aOS(2, _omitFieldNames ? '' : 'errorMessage')
    ..a<$core.List<$core.int>>(
        3, _omitFieldNames ? '' : 'fileResult', $pb.PbFieldType.OY)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  WriteResponse copyWith(void Function(WriteResponse) updates) =>
      super.copyWith((message) => updates(message as WriteResponse))
          as WriteResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static WriteResponse create() => WriteResponse._();
  @$core.override
  WriteResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static WriteResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<WriteResponse>(create);
  static WriteResponse? _defaultInstance;

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
  $core.List<$core.int> get fileResult => $_getN(2);
  @$pb.TagNumber(3)
  set fileResult($core.List<$core.int> value) => $_setBytes(2, value);
  @$pb.TagNumber(3)
  $core.bool hasFileResult() => $_has(2);
  @$pb.TagNumber(3)
  void clearFileResult() => $_clearField(3);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
