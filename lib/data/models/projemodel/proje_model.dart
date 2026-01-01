import 'package:flutter_arch/data/models/projedetaymodel/projedetay_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'proje_model.freezed.dart';
part 'proje_model.g.dart';

@freezed
@HiveType(typeId: 2)
class Proje with _$Proje {
  const factory Proje({
    // ignore: invalid_annotation_target
    @HiveField(0) @JsonKey(name: '_id', includeIfNull: false) @Default('') String id,

    @HiveField(1) required String projeAdi,

    @HiveField(2) required ProjeDetay projeDetay,
  }) = _Proje;

  factory Proje.fromJson(Map<String, dynamic> json) => _$ProjeFromJson(json);
}
