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
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      uniImage: json['uniImage'],
      signatoryName: json['signatory_name'] as String?,
      changeToImage: json['changeToImage'] as bool?,
    );

Map<String, dynamic> _$$SingleSignatureImplToJson(
        _$SingleSignatureImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attachmentId': instance.attachmentId,
      'file': instance.file,
      'created_at': instance.createdAt?.toIso8601String(),
      'uniImage': instance.uniImage,
      'signatory_name': instance.signatoryName,
      'changeToImage': instance.changeToImage,
    };
