// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'value_text.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ValueTextImpl _$$ValueTextImplFromJson(Map<String, dynamic> json) =>
    _$ValueTextImpl(
      isOtherField: json['isOtherField'] as bool?,
      action: json['action'] as bool?,
      value: readValue(json, 'value') as String,
      text: readText(json, 'text') as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ValueTextImplToJson(_$ValueTextImpl instance) =>
    <String, dynamic>{
      'isOtherField': instance.isOtherField,
      'action': instance.action,
      'value': instance.value,
      'text': instance.text,
      'runtimeType': instance.$type,
    };

_$NoneValueTextImpl _$$NoneValueTextImplFromJson(Map<String, dynamic> json) =>
    _$NoneValueTextImpl(
      value: json['value'] as String? ?? 'none',
      text: json['text'] as String,
      action: json['action'] as bool?,
      isOtherField: json['isOtherField'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NoneValueTextImplToJson(_$NoneValueTextImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'action': instance.action,
      'isOtherField': instance.isOtherField,
      'runtimeType': instance.$type,
    };

_$OtherValueTextImpl _$$OtherValueTextImplFromJson(Map<String, dynamic> json) =>
    _$OtherValueTextImpl(
      value: json['value'] as String? ?? 'other',
      text: json['text'] as String,
      action: json['action'] as bool?,
      isOtherField: json['isOtherField'] as bool?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$OtherValueTextImplToJson(
        _$OtherValueTextImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'action': instance.action,
      'isOtherField': instance.isOtherField,
      'runtimeType': instance.$type,
    };
