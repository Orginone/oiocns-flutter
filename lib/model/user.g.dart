// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 4;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      fields[0] as String,
      fields[1] as String,
      fields[2] as int,
      fields[3] as String,
      fields[4] as String,
      fields[5] as String,
      fields[6] as String,
      fields[7] as String,
      fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.account)
      ..writeByte(1)
      ..write(obj.authority)
      ..writeByte(2)
      ..write(obj.expiresIn)
      ..writeByte(3)
      ..write(obj.license)
      ..writeByte(4)
      ..write(obj.motto)
      ..writeByte(5)
      ..write(obj.tokenType)
      ..writeByte(6)
      ..write(obj.userName)
      ..writeByte(7)
      ..write(obj.workspaceId)
      ..writeByte(8)
      ..write(obj.workspaceName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
