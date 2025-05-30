// ignore_for_file: invalid_annotation_target

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'single_signature.freezed.dart';
part 'single_signature.g.dart';

@freezed
class SingleSignature with _$SingleSignature {
  const factory SingleSignature({
    /// Option Action to have color
    String? id,
    String? attachmentId,
    String? file,
    @JsonKey(name: 'created_at') String? createdAt,
    dynamic uniImage,
    @JsonKey(name: 'signatory_name') String? signatoryName,
    bool? changeToImage,
  }) = _SingleSignature;

  factory SingleSignature.fromJson(Map<String, dynamic> json) =>
      _$SingleSignatureFromJson(json);
}


