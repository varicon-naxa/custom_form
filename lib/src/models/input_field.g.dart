// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'input_field.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FallbackInputFieldImpl _$$FallbackInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$FallbackInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$FallbackInputFieldImplToJson(
        _$FallbackInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'type': instance.$type,
    };

_$TextInputFieldImpl _$$TextInputFieldImplFromJson(Map<String, dynamic> json) =>
    _$TextInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      answer: json['answer'] as String?,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TextInputFieldImplToJson(
        _$TextInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'name': instance.name,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'answer': instance.answer,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$SignatureInputFieldImpl _$$SignatureInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$SignatureInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      answer: json['answer'] as Map<String, dynamic>?,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SignatureInputFieldImplToJson(
        _$SignatureInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'answer': instance.answer,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$MultiSignatureInputFieldImpl _$$MultiSignatureInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$MultiSignatureInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => SingleSignature.fromJson(e as Map<String, dynamic>))
          .toList(),
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$MultiSignatureInputFieldImplToJson(
        _$MultiSignatureInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'answer': instance.answer,
      'type': instance.$type,
    };

_$DateInputFieldImpl _$$DateInputFieldImplFromJson(Map<String, dynamic> json) =>
    _$DateInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DateInputFieldImplToJson(
        _$DateInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$InstructionInputFieldImpl _$$InstructionInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$InstructionInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      instruction: json['instruction'] as String?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$InstructionInputFieldImplToJson(
        _$InstructionInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'instruction': instance.instruction,
      'attachments': instance.attachments,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$SectionInputFieldImpl _$$SectionInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$SectionInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      instruction: json['instruction'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$SectionInputFieldImplToJson(
        _$SectionInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'instruction': instance.instruction,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$TimeInputFieldImpl _$$TimeInputFieldImplFromJson(Map<String, dynamic> json) =>
    _$TimeInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$TimeInputFieldImplToJson(
        _$TimeInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$UrlInputFieldImpl _$$UrlInputFieldImplFromJson(Map<String, dynamic> json) =>
    _$UrlInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$UrlInputFieldImplToJson(_$UrlInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$NumberInputFieldImpl _$$NumberInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$NumberInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$NumberInputFieldImplToJson(
        _$NumberInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$EmailInputFieldImpl _$$EmailInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$EmailInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EmailInputFieldImplToJson(
        _$EmailInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$DateTimeInputFieldImpl _$$DateTimeInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$DateTimeInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      min: json['min'],
      minErrorText: json['minErrorText'] as String?,
      max: json['max'],
      maxErrorText: json['maxErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DateTimeInputFieldImplToJson(
        _$DateTimeInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'min': instance.min,
      'minErrorText': instance.minErrorText,
      'max': instance.max,
      'maxErrorText': instance.maxErrorText,
      'type': instance.$type,
    };

_$CommentInputFieldImpl _$$CommentInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$CommentInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      hintText: json['placeholder'] as String?,
      maxLength: json['maxLength'] as int?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$CommentInputFieldImplToJson(
        _$CommentInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'placeholder': instance.hintText,
      'maxLength': instance.maxLength,
      'type': instance.$type,
    };

_$DropdownInputFieldImpl _$$DropdownInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$DropdownInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      fromManualList: json['fromManualList'] as bool? ?? true,
      islinked: json['islinked'] as bool?,
      answerList: json['selectedLinkListLabel'] as String?,
      linkedQuery: json['islinked_query'] as String?,
      allowClear: json['allowClear'] as bool? ?? true,
      hintText: json['placeholder'] as String?,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$DropdownInputFieldImplToJson(
        _$DropdownInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'fromManualList': instance.fromManualList,
      'islinked': instance.islinked,
      'selectedLinkListLabel': instance.answerList,
      'islinked_query': instance.linkedQuery,
      'allowClear': instance.allowClear,
      'placeholder': instance.hintText,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'type': instance.$type,
    };

_$MultipleInputFieldImpl _$$MultipleInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$MultipleInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      actionMessage: json['actionMessage'] as String?,
      fromManualList: json['fromManualList'] as bool? ?? true,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      maxSelectedChoices: json['maxSelectedChoices'] as int?,
      islinked: json['islinked'] as bool?,
      answerList: json['selectedLinkListLabel'] as String?,
      linkedQuery: json['islinked_query'] as String?,
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      showSelectAllItem: json['showSelectAllItem'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$MultipleInputFieldImplToJson(
        _$MultipleInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'actionMessage': instance.actionMessage,
      'fromManualList': instance.fromManualList,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'maxSelectedChoices': instance.maxSelectedChoices,
      'islinked': instance.islinked,
      'selectedLinkListLabel': instance.answerList,
      'islinked_query': instance.linkedQuery,
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'showSelectAllItem': instance.showSelectAllItem,
      'type': instance.$type,
    };

_$CheckboxInputFieldImpl _$$CheckboxInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$CheckboxInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      actionMessage: json['actionMessage'] as String?,
      fromManualList: json['fromManualList'] as bool? ?? true,
      islinked: json['islinked'] as bool?,
      answerList: json['selectedLinkListLabel'] as String?,
      linkedQuery: json['islinked_query'] as String?,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      maxSelectedChoices: json['maxSelectedChoices'] as int?,
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      showSelectAllItem: json['showSelectAllItem'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$CheckboxInputFieldImplToJson(
        _$CheckboxInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'actionMessage': instance.actionMessage,
      'fromManualList': instance.fromManualList,
      'islinked': instance.islinked,
      'selectedLinkListLabel': instance.answerList,
      'islinked_query': instance.linkedQuery,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'maxSelectedChoices': instance.maxSelectedChoices,
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'showSelectAllItem': instance.showSelectAllItem,
      'type': instance.$type,
    };

_$RadioInputFieldImpl _$$RadioInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$RadioInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      actionMessage: json['actionMessage'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      showClearButton: json['showClearButton'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$RadioInputFieldImplToJson(
        _$RadioInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'actionMessage': instance.actionMessage,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'showClearButton': instance.showClearButton,
      'type': instance.$type,
    };

_$YesNoInputFieldImpl _$$YesNoInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$YesNoInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      isConditional: json['isConditional'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      actionMessage: json['actionMessage'] as String?,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      showClearButton: json['showClearButton'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$YesNoInputFieldImplToJson(
        _$YesNoInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'isConditional': instance.isConditional,
      'requiredErrorText': instance.requiredErrorText,
      'actionMessage': instance.actionMessage,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'showClearButton': instance.showClearButton,
      'type': instance.$type,
    };

_$YesNoNaInputFieldImpl _$$YesNoNaInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$YesNoNaInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as String?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      actionMessage: json['actionMessage'] as String?,
      isConditional: json['isConditional'] as bool? ?? false,
      choices: (json['choice'] as List<dynamic>?)
              ?.map(const ValueTextConverter().fromJson)
              .toList() ??
          const [],
      showNoneItem: json['showNoneItem'] as bool? ?? false,
      noneText: json['noneText'] as String?,
      showOtherItem: json['showOtherItem'] as bool? ?? false,
      otherText: json['otherText'] as String?,
      otherErrorText: json['otherErrorText'] as String?,
      otherPlaceholder: json['otherPlaceholder'] as String?,
      showClearButton: json['showClearButton'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$YesNoNaInputFieldImplToJson(
        _$YesNoNaInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'actionMessage': instance.actionMessage,
      'isConditional': instance.isConditional,
      'choice':
          instance.choices.map(const ValueTextConverter().toJson).toList(),
      'showNoneItem': instance.showNoneItem,
      'noneText': instance.noneText,
      'showOtherItem': instance.showOtherItem,
      'otherText': instance.otherText,
      'otherErrorText': instance.otherErrorText,
      'otherPlaceholder': instance.otherPlaceholder,
      'showClearButton': instance.showClearButton,
      'type': instance.$type,
    };

_$FileInputFieldImpl _$$FileInputFieldImplFromJson(Map<String, dynamic> json) =>
    _$FileInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isMultiple: json['isMultiple'] as bool? ?? false,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$FileInputFieldImplToJson(
        _$FileInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isMultiple': instance.isMultiple,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'type': instance.$type,
    };

_$ImageInputFieldImpl _$$ImageInputFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$ImageInputFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: (json['answer'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isMultiple: json['isMultiple'] as bool? ?? false,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ImageInputFieldImplToJson(
        _$ImageInputFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isMultiple': instance.isMultiple,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'type': instance.$type,
    };

_$GeolocationFieldImpl _$$GeolocationFieldImplFromJson(
        Map<String, dynamic> json) =>
    _$GeolocationFieldImpl(
      id: json['id'] as String,
      label: json['label'] as String?,
      answer: json['answer'] as Map<String, dynamic>?,
      description: json['description'] as String?,
      visible: json['visible'] as bool? ?? true,
      isRequired: json['isRequired'] as bool? ?? false,
      readOnly: json['readOnly'] as bool? ?? false,
      requiredErrorText: json['requiredErrorText'] as String?,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$GeolocationFieldImplToJson(
        _$GeolocationFieldImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'answer': instance.answer,
      'description': instance.description,
      'visible': instance.visible,
      'isRequired': instance.isRequired,
      'readOnly': instance.readOnly,
      'requiredErrorText': instance.requiredErrorText,
      'type': instance.$type,
    };
