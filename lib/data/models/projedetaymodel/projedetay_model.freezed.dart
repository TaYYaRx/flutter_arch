// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'projedetay_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProjeDetay _$ProjeDetayFromJson(Map<String, dynamic> json) {
  return _ProjeDetay.fromJson(json);
}

/// @nodoc
mixin _$ProjeDetay {
  @HiveField(0)
  bool get todoStatus => throw _privateConstructorUsedError;
  @HiveField(1)
  double get kuyuBoy => throw _privateConstructorUsedError;
  @HiveField(2)
  double get kuyuDerinlik => throw _privateConstructorUsedError;
  @HiveField(3)
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ProjeDetay to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProjeDetay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjeDetayCopyWith<ProjeDetay> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjeDetayCopyWith<$Res> {
  factory $ProjeDetayCopyWith(
          ProjeDetay value, $Res Function(ProjeDetay) then) =
      _$ProjeDetayCopyWithImpl<$Res, ProjeDetay>;
  @useResult
  $Res call(
      {@HiveField(0) bool todoStatus,
      @HiveField(1) double kuyuBoy,
      @HiveField(2) double kuyuDerinlik,
      @HiveField(3) DateTime createdAt});
}

/// @nodoc
class _$ProjeDetayCopyWithImpl<$Res, $Val extends ProjeDetay>
    implements $ProjeDetayCopyWith<$Res> {
  _$ProjeDetayCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProjeDetay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todoStatus = null,
    Object? kuyuBoy = null,
    Object? kuyuDerinlik = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      todoStatus: null == todoStatus
          ? _value.todoStatus
          : todoStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      kuyuBoy: null == kuyuBoy
          ? _value.kuyuBoy
          : kuyuBoy // ignore: cast_nullable_to_non_nullable
              as double,
      kuyuDerinlik: null == kuyuDerinlik
          ? _value.kuyuDerinlik
          : kuyuDerinlik // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProjeDetayImplCopyWith<$Res>
    implements $ProjeDetayCopyWith<$Res> {
  factory _$$ProjeDetayImplCopyWith(
          _$ProjeDetayImpl value, $Res Function(_$ProjeDetayImpl) then) =
      __$$ProjeDetayImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) bool todoStatus,
      @HiveField(1) double kuyuBoy,
      @HiveField(2) double kuyuDerinlik,
      @HiveField(3) DateTime createdAt});
}

/// @nodoc
class __$$ProjeDetayImplCopyWithImpl<$Res>
    extends _$ProjeDetayCopyWithImpl<$Res, _$ProjeDetayImpl>
    implements _$$ProjeDetayImplCopyWith<$Res> {
  __$$ProjeDetayImplCopyWithImpl(
      _$ProjeDetayImpl _value, $Res Function(_$ProjeDetayImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProjeDetay
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? todoStatus = null,
    Object? kuyuBoy = null,
    Object? kuyuDerinlik = null,
    Object? createdAt = null,
  }) {
    return _then(_$ProjeDetayImpl(
      todoStatus: null == todoStatus
          ? _value.todoStatus
          : todoStatus // ignore: cast_nullable_to_non_nullable
              as bool,
      kuyuBoy: null == kuyuBoy
          ? _value.kuyuBoy
          : kuyuBoy // ignore: cast_nullable_to_non_nullable
              as double,
      kuyuDerinlik: null == kuyuDerinlik
          ? _value.kuyuDerinlik
          : kuyuDerinlik // ignore: cast_nullable_to_non_nullable
              as double,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjeDetayImpl implements _ProjeDetay {
  const _$ProjeDetayImpl(
      {@HiveField(0) required this.todoStatus,
      @HiveField(1) this.kuyuBoy = 0,
      @HiveField(2) this.kuyuDerinlik = 0,
      @HiveField(3) required this.createdAt});

  factory _$ProjeDetayImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjeDetayImplFromJson(json);

  @override
  @HiveField(0)
  final bool todoStatus;
  @override
  @JsonKey()
  @HiveField(1)
  final double kuyuBoy;
  @override
  @JsonKey()
  @HiveField(2)
  final double kuyuDerinlik;
  @override
  @HiveField(3)
  final DateTime createdAt;

  @override
  String toString() {
    return 'ProjeDetay(todoStatus: $todoStatus, kuyuBoy: $kuyuBoy, kuyuDerinlik: $kuyuDerinlik, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjeDetayImpl &&
            (identical(other.todoStatus, todoStatus) ||
                other.todoStatus == todoStatus) &&
            (identical(other.kuyuBoy, kuyuBoy) || other.kuyuBoy == kuyuBoy) &&
            (identical(other.kuyuDerinlik, kuyuDerinlik) ||
                other.kuyuDerinlik == kuyuDerinlik) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, todoStatus, kuyuBoy, kuyuDerinlik, createdAt);

  /// Create a copy of ProjeDetay
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjeDetayImplCopyWith<_$ProjeDetayImpl> get copyWith =>
      __$$ProjeDetayImplCopyWithImpl<_$ProjeDetayImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjeDetayImplToJson(
      this,
    );
  }
}

abstract class _ProjeDetay implements ProjeDetay {
  const factory _ProjeDetay(
      {@HiveField(0) required final bool todoStatus,
      @HiveField(1) final double kuyuBoy,
      @HiveField(2) final double kuyuDerinlik,
      @HiveField(3) required final DateTime createdAt}) = _$ProjeDetayImpl;

  factory _ProjeDetay.fromJson(Map<String, dynamic> json) =
      _$ProjeDetayImpl.fromJson;

  @override
  @HiveField(0)
  bool get todoStatus;
  @override
  @HiveField(1)
  double get kuyuBoy;
  @override
  @HiveField(2)
  double get kuyuDerinlik;
  @override
  @HiveField(3)
  DateTime get createdAt;

  /// Create a copy of ProjeDetay
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjeDetayImplCopyWith<_$ProjeDetayImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
