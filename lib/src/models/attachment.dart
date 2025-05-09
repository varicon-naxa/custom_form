import 'package:freezed_annotation/freezed_annotation.dart';
part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
class Attachment with _$Attachment {
  factory Attachment({
    String? id,
    String? file,
    String? thumbnail,
    String? name,
    String? localId,
    @JsonKey(name: 'mime_type') String? mime,
    @Default(true) @JsonKey(name: 'is_uploaded') bool? isUploaded,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}