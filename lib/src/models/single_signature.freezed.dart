// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'single_signature.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SingleSignature _$SingleSignatureFromJson(Map<String, dynamic> json) {
  return _SingleSignature.fromJson(json);
}

/// @nodoc
mixin _$SingleSignature {
  /// Option Action to have color
  String? get id => throw _privateConstructorUsedError;
  String? get attachmentId => throw _privateConstructorUsedError;
  String? get file => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'signatory_name')
  String? get signatoryName => throw _privateConstructorUsedError;
  bool? get isLoading => throw _privateConstructorUsedError;

  /// Serializes this SingleSignature to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SingleSignature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SingleSignatureCopyWith<SingleSignature> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SingleSignatureCopyWith<$Res> {
  factory $SingleSignatureCopyWith(
          SingleSignature value, $Res Function(SingleSignature) then) =
      _$SingleSignatureCopyWithImpl<$Res, SingleSignature>;
  @useResult
  $Res call(
      {String? id,
      String? attachmentId,
      String? file,
      String? name,
      @JsonKey(name: 'signatory_name') String? signatoryName,
      bool? isLoading});
}

/// @nodoc
class _$SingleSignatureCopyWithImpl<$Res, $Val extends SingleSignature>
    implements $SingleSignatureCopyWith<$Res> {
  _$SingleSignatureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SingleSignature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? attachmentId = freezed,
    Object? file = freezed,
    Object? name = freezed,
    Object? signatoryName = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentId: freezed == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      signatoryName: freezed == signatoryName
          ? _value.signatoryName
          : signatoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SingleSignatureImplCopyWith<$Res>
    implements $SingleSignatureCopyWith<$Res> {
  factory _$$SingleSignatureImplCopyWith(_$SingleSignatureImpl value,
          $Res Function(_$SingleSignatureImpl) then) =
      __$$SingleSignatureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? attachmentId,
      String? file,
      String? name,
      @JsonKey(name: 'signatory_name') String? signatoryName,
      bool? isLoading});
}

/// @nodoc
class __$$SingleSignatureImplCopyWithImpl<$Res>
    extends _$SingleSignatureCopyWithImpl<$Res, _$SingleSignatureImpl>
    implements _$$SingleSignatureImplCopyWith<$Res> {
  __$$SingleSignatureImplCopyWithImpl(
      _$SingleSignatureImpl _value, $Res Function(_$SingleSignatureImpl) _then)
      : super(_value, _then);

  /// Create a copy of SingleSignature
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? attachmentId = freezed,
    Object? file = freezed,
    Object? name = freezed,
    Object? signatoryName = freezed,
    Object? isLoading = freezed,
  }) {
    return _then(_$SingleSignatureImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      attachmentId: freezed == attachmentId
          ? _value.attachmentId
          : attachmentId // ignore: cast_nullable_to_non_nullable
              as String?,
      file: freezed == file
          ? _value.file
          : file // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      signatoryName: freezed == signatoryName
          ? _value.signatoryName
          : signatoryName // ignore: cast_nullable_to_non_nullable
              as String?,
      isLoading: freezed == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SingleSignatureImpl implements _SingleSignature {
  const _$SingleSignatureImpl(
      {this.id,
      this.attachmentId,
      this.file,
      this.name,
      @JsonKey(name: 'signatory_name') this.signatoryName,
      this.isLoading});

  factory _$SingleSignatureImpl.fromJson(Map<String, dynamic> json) =>
      _$$SingleSignatureImplFromJson(json);

  /// Option Action to have color
  @override
  final String? id;
  @override
  final String? attachmentId;
  @override
  final String? file;
  @override
  final String? name;
  @override
  @JsonKey(name: 'signatory_name')
  final String? signatoryName;
  @override
  final bool? isLoading;

  @override
  String toString() {
    return 'SingleSignature(id: $id, attachmentId: $attachmentId, file: $file, name: $name, signatoryName: $signatoryName, isLoading: $isLoading)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SingleSignatureImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.attachmentId, attachmentId) ||
                other.attachmentId == attachmentId) &&
            (identical(other.file, file) || other.file == file) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.signatoryName, signatoryName) ||
                other.signatoryName == signatoryName) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, attachmentId, file, name, signatoryName, isLoading);

  /// Create a copy of SingleSignature
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SingleSignatureImplCopyWith<_$SingleSignatureImpl> get copyWith =>
      __$$SingleSignatureImplCopyWithImpl<_$SingleSignatureImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SingleSignatureImplToJson(
      this,
    );
  }
}

abstract class _SingleSignature implements SingleSignature {
  const factory _SingleSignature(
      {final String? id,
      final String? attachmentId,
      final String? file,
      final String? name,
      @JsonKey(name: 'signatory_name') final String? signatoryName,
      final bool? isLoading}) = _$SingleSignatureImpl;

  factory _SingleSignature.fromJson(Map<String, dynamic> json) =
      _$SingleSignatureImpl.fromJson;

  /// Option Action to have color
  @override
  String? get id;
  @override
  String? get attachmentId;
  @override
  String? get file;
  @override
  String? get name;
  @override
  @JsonKey(name: 'signatory_name')
  String? get signatoryName;
  @override
  bool? get isLoading;

  /// Create a copy of SingleSignature
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SingleSignatureImplCopyWith<_$SingleSignatureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
