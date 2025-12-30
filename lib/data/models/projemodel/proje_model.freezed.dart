// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'proje_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Proje _$ProjeFromJson(Map<String, dynamic> json) {
  return _Proje.fromJson(json);
}

/// @nodoc
mixin _$Proje {

  @HiveField(0)
  @JsonKey(name: '_id')
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get projeAdi => throw _privateConstructorUsedError;
  @HiveField(2)
  ProjeDetay get projeDetay => throw _privateConstructorUsedError;

  /// Serializes this Proje to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProjeCopyWith<Proje> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProjeCopyWith<$Res> {
  factory $ProjeCopyWith(Proje value, $Res Function(Proje) then) =
      _$ProjeCopyWithImpl<$Res, Proje>;
  @useResult
  $Res call(
      {@HiveField(0) @JsonKey(name: '_id') String id,
      @HiveField(1) String projeAdi,
      @HiveField(2) ProjeDetay projeDetay});

  $ProjeDetayCopyWith<$Res> get projeDetay;
}

/// @nodoc
class _$ProjeCopyWithImpl<$Res, $Val extends Proje>
    implements $ProjeCopyWith<$Res> {
  _$ProjeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projeAdi = null,
    Object? projeDetay = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projeAdi: null == projeAdi
          ? _value.projeAdi
          : projeAdi // ignore: cast_nullable_to_non_nullable
              as String,
      projeDetay: null == projeDetay
          ? _value.projeDetay
          : projeDetay // ignore: cast_nullable_to_non_nullable
              as ProjeDetay,
    ) as $Val);
  }

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProjeDetayCopyWith<$Res> get projeDetay {
    return $ProjeDetayCopyWith<$Res>(_value.projeDetay, (value) {
      return _then(_value.copyWith(projeDetay: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ProjeImplCopyWith<$Res> implements $ProjeCopyWith<$Res> {
  factory _$$ProjeImplCopyWith(
          _$ProjeImpl value, $Res Function(_$ProjeImpl) then) =
      __$$ProjeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) @JsonKey(name: '_id') String id,
      @HiveField(1) String projeAdi,
      @HiveField(2) ProjeDetay projeDetay});

  @override
  $ProjeDetayCopyWith<$Res> get projeDetay;
}

/// @nodoc
class __$$ProjeImplCopyWithImpl<$Res>
    extends _$ProjeCopyWithImpl<$Res, _$ProjeImpl>
    implements _$$ProjeImplCopyWith<$Res> {
  __$$ProjeImplCopyWithImpl(
      _$ProjeImpl _value, $Res Function(_$ProjeImpl) _then)
      : super(_value, _then);

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? projeAdi = null,
    Object? projeDetay = null,
  }) {
    return _then(_$ProjeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      projeAdi: null == projeAdi
          ? _value.projeAdi
          : projeAdi // ignore: cast_nullable_to_non_nullable
              as String,
      projeDetay: null == projeDetay
          ? _value.projeDetay
          : projeDetay // ignore: cast_nullable_to_non_nullable
              as ProjeDetay,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProjeImpl implements _Proje {
  const _$ProjeImpl(
      {@HiveField(0) @JsonKey(name: '_id') required this.id,
      @HiveField(1) required this.projeAdi,
      @HiveField(2) required this.projeDetay});

  factory _$ProjeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProjeImplFromJson(json);


  @override
  @HiveField(0)
  @JsonKey(name: '_id')
  final String id;
  @override
  @HiveField(1)
  final String projeAdi;
  @override
  @HiveField(2)
  final ProjeDetay projeDetay;

  @override
  String toString() {
    return 'Proje(id: $id, projeAdi: $projeAdi, projeDetay: $projeDetay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProjeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.projeAdi, projeAdi) ||
                other.projeAdi == projeAdi) &&
            (identical(other.projeDetay, projeDetay) ||
                other.projeDetay == projeDetay));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, projeAdi, projeDetay);

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProjeImplCopyWith<_$ProjeImpl> get copyWith =>
      __$$ProjeImplCopyWithImpl<_$ProjeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProjeImplToJson(
      this,
    );
  }
}

abstract class _Proje implements Proje {
  const factory _Proje(
      {@HiveField(0) @JsonKey(name: '_id') required final String id,
      @HiveField(1) required final String projeAdi,
      @HiveField(2) required final ProjeDetay projeDetay}) = _$ProjeImpl;

  factory _Proje.fromJson(Map<String, dynamic> json) = _$ProjeImpl.fromJson;


  @override
  @HiveField(0)
  @JsonKey(name: '_id')
  String get id;
  @override
  @HiveField(1)
  String get projeAdi;
  @override
  @HiveField(2)
  ProjeDetay get projeDetay;

  /// Create a copy of Proje
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProjeImplCopyWith<_$ProjeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
