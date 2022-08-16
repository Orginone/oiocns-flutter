// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_resp.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeamRespAdapter extends TypeAdapter<TeamResp> {
  @override
  final int typeId = 6;

  @override
  TeamResp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeamResp(
      fields[0] as int,
      fields[1] as String,
      fields[2] as String,
      fields[3] as int,
      fields[4] as int,
      fields[5] as String,
      fields[6] as int,
      fields[7] as int,
      fields[8] as int,
      fields[9] as int,
      fields[10] as DateTime,
      fields[11] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TeamResp obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.targetId)
      ..writeByte(4)
      ..write(obj.authId)
      ..writeByte(5)
      ..write(obj.remark)
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
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamRespAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
