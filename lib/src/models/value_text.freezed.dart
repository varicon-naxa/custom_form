// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'value_text.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ValueText _$ValueTextFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'default':
      return _ValueText.fromJson(json);
    case 'none':
      return NoneValueText.fromJson(json);
    case 'other':
      return OtherValueText.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'ValueText',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$ValueText {
  /// Option Action to have color
  @JsonKey(name: 'isOtherField')
  bool? get isOtherField => throw _privateConstructorUsedError;
  @JsonKey(name: 'action')
  bool? get action => throw _privateConstructorUsedError;

  /// Value that is used for remote API consumption.
  @JsonKey(readValue: readValue)
  String get value => throw _privateConstructorUsedError;

  /// Text that is displayed to the frontend.
  @JsonKey(readValue: readText)
  String get text => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)
        $default, {
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        none,
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ValueText value) $default, {
    required TResult Function(NoneValueText value) none,
    required TResult Function(OtherValueText value) other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ValueText value)? $default, {
    TResult? Function(NoneValueText value)? none,
    TResult? Function(OtherValueText value)? other,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ValueText value)? $default, {
    TResult Function(NoneValueText value)? none,
    TResult Function(OtherValueText value)? other,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ValueTextCopyWith<ValueText> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ValueTextCopyWith<$Res> {
  factory $ValueTextCopyWith(ValueText value, $Res Function(ValueText) then) =
      _$ValueTextCopyWithImpl<$Res, ValueText>;
  @useResult
  $Res call(
      {@JsonKey(name: 'isOtherField') bool? isOtherField,
      @JsonKey(name: 'action') bool? action,
      @JsonKey(readValue: readValue) String value,
      @JsonKey(readValue: readText) String text});
}

/// @nodoc
class _$ValueTextCopyWithImpl<$Res, $Val extends ValueText>
    implements $ValueTextCopyWith<$Res> {
  _$ValueTextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOtherField = freezed,
    Object? action = freezed,
    Object? value = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      isOtherField: freezed == isOtherField
          ? _value.isOtherField
          : isOtherField // ignore: cast_nullable_to_non_nullable
              as bool?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as bool?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ValueTextImplCopyWith<$Res>
    implements $ValueTextCopyWith<$Res> {
  factory _$$ValueTextImplCopyWith(
          _$ValueTextImpl value, $Res Function(_$ValueTextImpl) then) =
      __$$ValueTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'isOtherField') bool? isOtherField,
      @JsonKey(name: 'action') bool? action,
      @JsonKey(readValue: readValue) String value,
      @JsonKey(readValue: readText) String text});
}

/// @nodoc
class __$$ValueTextImplCopyWithImpl<$Res>
    extends _$ValueTextCopyWithImpl<$Res, _$ValueTextImpl>
    implements _$$ValueTextImplCopyWith<$Res> {
  __$$ValueTextImplCopyWithImpl(
      _$ValueTextImpl _value, $Res Function(_$ValueTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isOtherField = freezed,
    Object? action = freezed,
    Object? value = null,
    Object? text = null,
  }) {
    return _then(_$ValueTextImpl(
      isOtherField: freezed == isOtherField
          ? _value.isOtherField
          : isOtherField // ignore: cast_nullable_to_non_nullable
              as bool?,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as bool?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ValueTextImpl implements _ValueText {
  const _$ValueTextImpl(
      {@JsonKey(name: 'isOtherField') this.isOtherField,
      @JsonKey(name: 'action') this.action,
      @JsonKey(readValue: readValue) required this.value,
      @JsonKey(readValue: readText) required this.text,
      final String? $type})
      : $type = $type ?? 'default';

  factory _$ValueTextImpl.fromJson(Map<String, dynamic> json) =>
      _$$ValueTextImplFromJson(json);

  /// Option Action to have color
  @override
  @JsonKey(name: 'isOtherField')
  final bool? isOtherField;
  @override
  @JsonKey(name: 'action')
  final bool? action;

  /// Value that is used for remote API consumption.
  @override
  @JsonKey(readValue: readValue)
  final String value;

  /// Text that is displayed to the frontend.
  @override
  @JsonKey(readValue: readText)
  final String text;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ValueText(isOtherField: $isOtherField, action: $action, value: $value, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValueTextImpl &&
            (identical(other.isOtherField, isOtherField) ||
                other.isOtherField == isOtherField) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, isOtherField, action, value, text);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ValueTextImplCopyWith<_$ValueTextImpl> get copyWith =>
      __$$ValueTextImplCopyWithImpl<_$ValueTextImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)
        $default, {
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        none,
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        other,
  }) {
    return $default(isOtherField, action, value, text);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
  }) {
    return $default?.call(isOtherField, action, value, text);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(isOtherField, action, value, text);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ValueText value) $default, {
    required TResult Function(NoneValueText value) none,
    required TResult Function(OtherValueText value) other,
  }) {
    return $default(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ValueText value)? $default, {
    TResult? Function(NoneValueText value)? none,
    TResult? Function(OtherValueText value)? other,
  }) {
    return $default?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ValueText value)? $default, {
    TResult Function(NoneValueText value)? none,
    TResult Function(OtherValueText value)? other,
    required TResult orElse(),
  }) {
    if ($default != null) {
      return $default(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ValueTextImplToJson(
      this,
    );
  }
}

abstract class _ValueText implements ValueText {
  const factory _ValueText(
          {@JsonKey(name: 'isOtherField') final bool? isOtherField,
          @JsonKey(name: 'action') final bool? action,
          @JsonKey(readValue: readValue) required final String value,
          @JsonKey(readValue: readText) required final String text}) =
      _$ValueTextImpl;

  factory _ValueText.fromJson(Map<String, dynamic> json) =
      _$ValueTextImpl.fromJson;

  @override

  /// Option Action to have color
  @JsonKey(name: 'isOtherField')
  bool? get isOtherField;
  @override
  @JsonKey(name: 'action')
  bool? get action;
  @override

  /// Value that is used for remote API consumption.
  @JsonKey(readValue: readValue)
  String get value;
  @override

  /// Text that is displayed to the frontend.
  @JsonKey(readValue: readText)
  String get text;
  @override
  @JsonKey(ignore: true)
  _$$ValueTextImplCopyWith<_$ValueTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NoneValueTextImplCopyWith<$Res>
    implements $ValueTextCopyWith<$Res> {
  factory _$$NoneValueTextImplCopyWith(
          _$NoneValueTextImpl value, $Res Function(_$NoneValueTextImpl) then) =
      __$$NoneValueTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String text, bool? action, bool? isOtherField});
}

/// @nodoc
class __$$NoneValueTextImplCopyWithImpl<$Res>
    extends _$ValueTextCopyWithImpl<$Res, _$NoneValueTextImpl>
    implements _$$NoneValueTextImplCopyWith<$Res> {
  __$$NoneValueTextImplCopyWithImpl(
      _$NoneValueTextImpl _value, $Res Function(_$NoneValueTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? text = null,
    Object? action = freezed,
    Object? isOtherField = freezed,
  }) {
    return _then(_$NoneValueTextImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOtherField: freezed == isOtherField
          ? _value.isOtherField
          : isOtherField // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NoneValueTextImpl implements NoneValueText {
  const _$NoneValueTextImpl(
      {this.value = 'none',
      required this.text,
      this.action,
      this.isOtherField,
      final String? $type})
      : $type = $type ?? 'none';

  factory _$NoneValueTextImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoneValueTextImplFromJson(json);

  @override
  @JsonKey()
  final String value;
  @override
  final String text;
  @override
  final bool? action;
  @override
  final bool? isOtherField;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ValueText.none(value: $value, text: $text, action: $action, isOtherField: $isOtherField)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoneValueTextImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.isOtherField, isOtherField) ||
                other.isOtherField == isOtherField));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, value, text, action, isOtherField);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoneValueTextImplCopyWith<_$NoneValueTextImpl> get copyWith =>
      __$$NoneValueTextImplCopyWithImpl<_$NoneValueTextImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)
        $default, {
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        none,
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        other,
  }) {
    return none(value, text, action, isOtherField);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
  }) {
    return none?.call(value, text, action, isOtherField);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(value, text, action, isOtherField);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ValueText value) $default, {
    required TResult Function(NoneValueText value) none,
    required TResult Function(OtherValueText value) other,
  }) {
    return none(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ValueText value)? $default, {
    TResult? Function(NoneValueText value)? none,
    TResult? Function(OtherValueText value)? other,
  }) {
    return none?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ValueText value)? $default, {
    TResult Function(NoneValueText value)? none,
    TResult Function(OtherValueText value)? other,
    required TResult orElse(),
  }) {
    if (none != null) {
      return none(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$NoneValueTextImplToJson(
      this,
    );
  }
}

abstract class NoneValueText implements ValueText {
  const factory NoneValueText(
      {final String value,
      required final String text,
      final bool? action,
      final bool? isOtherField}) = _$NoneValueTextImpl;

  factory NoneValueText.fromJson(Map<String, dynamic> json) =
      _$NoneValueTextImpl.fromJson;

  @override
  String get value;
  @override
  String get text;
  @override
  bool? get action;
  @override
  bool? get isOtherField;
  @override
  @JsonKey(ignore: true)
  _$$NoneValueTextImplCopyWith<_$NoneValueTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OtherValueTextImplCopyWith<$Res>
    implements $ValueTextCopyWith<$Res> {
  factory _$$OtherValueTextImplCopyWith(_$OtherValueTextImpl value,
          $Res Function(_$OtherValueTextImpl) then) =
      __$$OtherValueTextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String value, String text, bool? action, bool? isOtherField});
}

/// @nodoc
class __$$OtherValueTextImplCopyWithImpl<$Res>
    extends _$ValueTextCopyWithImpl<$Res, _$OtherValueTextImpl>
    implements _$$OtherValueTextImplCopyWith<$Res> {
  __$$OtherValueTextImplCopyWithImpl(
      _$OtherValueTextImpl _value, $Res Function(_$OtherValueTextImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
    Object? text = null,
    Object? action = freezed,
    Object? isOtherField = freezed,
  }) {
    return _then(_$OtherValueTextImpl(
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      action: freezed == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as bool?,
      isOtherField: freezed == isOtherField
          ? _value.isOtherField
          : isOtherField // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OtherValueTextImpl implements OtherValueText {
  const _$OtherValueTextImpl(
      {this.value = 'other',
      required this.text,
      this.action,
      this.isOtherField,
      final String? $type})
      : $type = $type ?? 'other';

  factory _$OtherValueTextImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtherValueTextImplFromJson(json);

  @override
  @JsonKey()
  final String value;
  @override
  final String text;
  @override
  final bool? action;
  @override
  final bool? isOtherField;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'ValueText.other(value: $value, text: $text, action: $action, isOtherField: $isOtherField)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtherValueTextImpl &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.isOtherField, isOtherField) ||
                other.isOtherField == isOtherField));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, value, text, action, isOtherField);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OtherValueTextImplCopyWith<_$OtherValueTextImpl> get copyWith =>
      __$$OtherValueTextImplCopyWithImpl<_$OtherValueTextImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)
        $default, {
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        none,
    required TResult Function(
            String value, String text, bool? action, bool? isOtherField)
        other,
  }) {
    return other(value, text, action, isOtherField);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult? Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
  }) {
    return other?.call(value, text, action, isOtherField);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            @JsonKey(name: 'isOtherField') bool? isOtherField,
            @JsonKey(name: 'action') bool? action,
            @JsonKey(readValue: readValue) String value,
            @JsonKey(readValue: readText) String text)?
        $default, {
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        none,
    TResult Function(
            String value, String text, bool? action, bool? isOtherField)?
        other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(value, text, action, isOtherField);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_ValueText value) $default, {
    required TResult Function(NoneValueText value) none,
    required TResult Function(OtherValueText value) other,
  }) {
    return other(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_ValueText value)? $default, {
    TResult? Function(NoneValueText value)? none,
    TResult? Function(OtherValueText value)? other,
  }) {
    return other?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_ValueText value)? $default, {
    TResult Function(NoneValueText value)? none,
    TResult Function(OtherValueText value)? other,
    required TResult orElse(),
  }) {
    if (other != null) {
      return other(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$OtherValueTextImplToJson(
      this,
    );
  }
}

abstract class OtherValueText implements ValueText {
  const factory OtherValueText(
      {final String value,
      required final String text,
      final bool? action,
      final bool? isOtherField}) = _$OtherValueTextImpl;

  factory OtherValueText.fromJson(Map<String, dynamic> json) =
      _$OtherValueTextImpl.fromJson;

  @override
  String get value;
  @override
  String get text;
  @override
  bool? get action;
  @override
  bool? get isOtherField;
  @override
  @JsonKey(ignore: true)
  _$$OtherValueTextImplCopyWith<_$OtherValueTextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
