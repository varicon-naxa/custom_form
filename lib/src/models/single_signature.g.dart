// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_signature.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SingleSignatureImpl _$$SingleSignatureImplFromJson(
        Map<String, dynamic> json) =>
    _$SingleSignatureImpl(
      id: json['id'] as String?,
      attachmentId: json['attachmentId'] as String?,
      file: json['file'] as String?,
      name: json['name'] as String?,
      isLoading: json['isLoading'] as bool?,
    );

Map<String, dynamic> _$$SingleSignatureImplToJson(
        _$SingleSignatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attachmentId': instance.attachmentId,
      'file': instance.file,
      'name': instance.name,
      'isLoading': instance.isLoading,
    };
