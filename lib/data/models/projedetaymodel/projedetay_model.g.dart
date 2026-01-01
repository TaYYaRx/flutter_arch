// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projedetay_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjeDetayAdapter extends TypeAdapter<ProjeDetay> {
  @override
  final int typeId = 1;

  @override
  ProjeDetay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjeDetay(
      todoStatus: fields[0] as bool,
      kuyuBoy: fields[1] as double,
      kuyuDerinlik: fields[2] as double,
      createdAt: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjeDetay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.todoStatus)
      ..writeByte(1)
      ..write(obj.kuyuBoy)
      ..writeByte(2)
      ..write(obj.kuyuDerinlik)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjeDetayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjeDetayImpl _$$ProjeDetayImplFromJson(Map<String, dynamic> json) =>
    _$ProjeDetayImpl(
      todoStatus: json['todoStatus'] as bool,
      kuyuBoy: (json['kuyuBoy'] as num?)?.toDouble() ?? 0,
      kuyuDerinlik: (json['kuyuDerinlik'] as num?)?.toDouble() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProjeDetayImplToJson(_$ProjeDetayImpl instance) =>
    <String, dynamic>{
      'todoStatus': instance.todoStatus,
      'kuyuBoy': instance.kuyuBoy,
      'kuyuDerinlik': instance.kuyuDerinlik,
      'createdAt': instance.createdAt.toIso8601String(),
    };
