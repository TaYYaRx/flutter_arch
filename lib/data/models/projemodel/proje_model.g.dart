// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proje_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjeAdapter extends TypeAdapter<Proje> {
  @override
  final int typeId = 2;

  @override
  Proje read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Proje(
      id: fields[0] as String,
      projeAdi: fields[1] as String,
      projeDetay: fields[2] as ProjeDetay,
    );
  }

  @override
  void write(BinaryWriter writer, Proje obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.projeAdi)
      ..writeByte(2)
      ..write(obj.projeDetay);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProjeImpl _$$ProjeImplFromJson(Map<String, dynamic> json) => _$ProjeImpl(
      id: json['_id'] as String? ?? '',
      projeAdi: json['projeAdi'] as String,
      projeDetay:
          ProjeDetay.fromJson(json['projeDetay'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ProjeImplToJson(_$ProjeImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'projeAdi': instance.projeAdi,
      'projeDetay': instance.projeDetay,
    };
