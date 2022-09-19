// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target_resp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TargetRespAdapter extends TypeAdapter<TargetResp> {
  @override
  final int typeId = 5;

  @override
  TargetResp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TargetResp(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as int,
      fields[5] as int,
      fields[6] as int,
      fields[7] as int,
      fields[8] as int,
      fields[9] as int,
      fields[10] as DateTime,
      fields[11] as DateTime,
      fields[12] as TeamResp,
      (fields[13] as List?)?.cast<IdentityResp>(),
    );
  }

  @override
  void write(BinaryWriter writer, TargetResp obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.typeName)
      ..writeByte(4)
      ..write(obj.belongId)
      ..writeByte(5)
      ..write(obj.thingId)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.createUser)
      ..writeByte(8)
      ..write(obj.updateUser)
      ..writeByte(9)
      ..write(obj.version)
      ..writeByte(10)
      ..write(obj.createTime)
      ..writeByte(11)
      ..write(obj.updateTime)
      ..writeByte(12)
      ..write(obj.team)
      ..writeByte(13)
      ..write(obj.givenIdentitys);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetRespAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
