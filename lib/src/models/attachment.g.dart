// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttachmentImpl _$$AttachmentImplFromJson(Map<String, dynamic> json) =>
    _$AttachmentImpl(
      id: json['id'] as String?,
      file: json['file'] as String?,
      thumbnail: json['thumbnail'] as String?,
      name: json['name'] as String?,
      localId: json['localId'] as String?,
      mime: json['mime_type'] as String?,
      isUploaded: json['is_uploaded'] as bool? ?? true,
    );

Map<String, dynamic> _$$AttachmentImplToJson(_$AttachmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'file': instance.file,
      'thumbnail': instance.thumbnail,
      'name': instance.name,
      'localId': instance.localId,
      'mime_type': instance.mime,
      'is_uploaded': instance.isUploaded,
    };
