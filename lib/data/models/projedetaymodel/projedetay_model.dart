import 'package:hive/hive.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'projedetay_model.freezed.dart';
part 'projedetay_model.g.dart';

@freezed
@HiveType(typeId: 1)
class ProjeDetay with _$ProjeDetay {
  const factory ProjeDetay({
    @HiveField(0) required bool todoStatus,
    @HiveField(1) required int kuyuBoy,
    @HiveField(2) required int kuyuDerinlik,
    @HiveField(3) required DateTime createdAt,
  }) = _ProjeDetay;

  factory ProjeDetay.fromJson(Map<String, dynamic> json)
      => _$ProjeDetayFromJson(json);
}
