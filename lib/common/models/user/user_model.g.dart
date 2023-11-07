// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      account: fields[0] as String?,
      userName: fields[1] as String?,
      workspaceId: fields[2] as String?,
      workspaceName: fields[3] as String?,
      attrs: fields[4] as Attrs?,
      person: fields[5] as Person?,
      accessToken: fields[6] as String?,
      expiresIn: fields[7] as int?,
      authority: fields[8] as String?,
      license: fields[9] as String?,
      tokenType: fields[10] as String?,
      motto: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.account)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.workspaceId)
      ..writeByte(3)
      ..write(obj.workspaceName)
      ..writeByte(4)
      ..write(obj.attrs)
      ..writeByte(5)
      ..write(obj.person)
      ..writeByte(6)
      ..write(obj.accessToken)
      ..writeByte(7)
      ..write(obj.expiresIn)
      ..writeByte(8)
      ..write(obj.authority)
      ..writeByte(9)
      ..write(obj.license)
      ..writeByte(10)
      ..write(obj.tokenType)
      ..writeByte(11)
      ..write(obj.motto);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttrsAdapter extends TypeAdapter<Attrs> {
  @override
  final int typeId = 1;

  @override
  Attrs read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Attrs(
      limit: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Attrs obj) {
    writer
      ..writeByte(1)
      ..writeByte(1)
      ..write(obj.limit);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttrsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 2;

  @override
  Person read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Person(
      id: fields[0] as String?,
      name: fields[1] as String?,
      code: fields[2] as String?,
      typeName: fields[3] as String?,
      thingId: fields[4] as String?,
      status: fields[5] as int?,
      createUser: fields[6] as String?,
      updateUser: fields[7] as String?,
      version: fields[8] as String?,
      createTime: fields[9] as String?,
      updateTime: fields[10] as String?,
      team: fields[11] as Team?,
    );
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.typeName)
      ..writeByte(4)
      ..write(obj.thingId)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createUser)
      ..writeByte(7)
      ..write(obj.updateUser)
      ..writeByte(8)
      ..write(obj.version)
      ..writeByte(9)
      ..write(obj.createTime)
      ..writeByte(10)
      ..write(obj.updateTime)
      ..writeByte(11)
      ..write(obj.team);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TeamAdapter extends TypeAdapter<Team> {
  @override
  final int typeId = 3;

  @override
  Team read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Team(
      id: fields[0] as String?,
      name: fields[1] as String?,
      code: fields[2] as String?,
      targetId: fields[3] as String?,
      remark: fields[4] as String?,
      status: fields[5] as int?,
      createUser: fields[6] as String?,
      updateUser: fields[7] as String?,
      version: fields[8] as String?,
      createTime: fields[9] as String?,
      updateTime: fields[10] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Team obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.targetId)
      ..writeByte(4)
      ..write(obj.remark)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.createUser)
      ..writeByte(7)
      ..write(obj.updateUser)
      ..writeByte(8)
      ..write(obj.version)
      ..writeByte(9)
      ..write(obj.createTime)
      ..writeByte(10)
      ..write(obj.updateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
