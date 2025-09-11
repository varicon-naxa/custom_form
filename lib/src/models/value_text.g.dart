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
      notifyTo: json['notify_To'] as List<dynamic>?,
      text: readText(json, 'text') as String,
      image: json['image'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$ValueTextImplToJson(_$ValueTextImpl instance) =>
    <String, dynamic>{
      'isOtherField': instance.isOtherField,
      'action': instance.action,
      'value': instance.value,
      'notify_To': instance.notifyTo,
      'text': instance.text,
      'image': instance.image,
      'runtimeType': instance.$type,
    };

_$NoneValueTextImpl _$$NoneValueTextImplFromJson(Map<String, dynamic> json) =>
    _$NoneValueTextImpl(
      value: json['value'] as String? ?? 'none',
      text: json['text'] as String,
      action: json['action'] as bool?,
      isOtherField: json['isOtherField'] as bool?,
      notifyTo: json['notify_To'] as List<dynamic>?,
      image: json['image'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$NoneValueTextImplToJson(_$NoneValueTextImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'action': instance.action,
      'isOtherField': instance.isOtherField,
      'notify_To': instance.notifyTo,
      'image': instance.image,
      'runtimeType': instance.$type,
    };

_$OtherValueTextImpl _$$OtherValueTextImplFromJson(Map<String, dynamic> json) =>
    _$OtherValueTextImpl(
      value: json['value'] as String? ?? 'other',
      text: json['text'] as String,
      action: json['action'] as bool?,
      isOtherField: json['isOtherField'] as bool?,
      notifyTo: json['notify_To'] as List<dynamic>?,
      image: json['image'] as Map<String, dynamic>?,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$OtherValueTextImplToJson(
        _$OtherValueTextImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'text': instance.text,
      'action': instance.action,
      'isOtherField': instance.isOtherField,
      'notify_To': instance.notifyTo,
      'image': instance.image,
      'runtimeType': instance.$type,
    };
