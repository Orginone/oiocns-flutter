// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'asset_creation_config.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AssetCreationConfigAdapter extends TypeAdapter<AssetCreationConfig> {
  @override
  final int typeId = 4;

  @override
  AssetCreationConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AssetCreationConfig(
      businessName: fields[0] as String?,
      businessCode: fields[1] as String?,
      config: (fields[2] as List?)?.cast<Config>(),
    );
  }

  @override
  void write(BinaryWriter writer, AssetCreationConfig obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.businessName)
      ..writeByte(1)
      ..write(obj.businessCode)
      ..writeByte(2)
      ..write(obj.config);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AssetCreationConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ConfigAdapter extends TypeAdapter<Config> {
  @override
  final int typeId = 5;

  @override
  Config read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Config(
      title: fields[0] as String?,
      sort: fields[1] as int?,
      fields: (fields[2] as List?)?.cast<Fields>(),
    );
  }

  @override
  void write(BinaryWriter writer, Config obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.sort)
      ..writeByte(2)
      ..write(obj.fields);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FieldsAdapter extends TypeAdapter<Fields> {
  @override
  final int typeId = 6;

  @override
  Fields read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Fields(
      title: fields[0] as String?,
      code: fields[2] as String?,
      type: fields[3] as String?,
      required: fields[4] as bool?,
      readOnly: fields[5] as bool?,
      regx: fields[6] as String?,
      hidden: fields[8] as bool?,
      router: fields[14] as String?,
      hint: fields[1] as String?,
      select: (fields[7] as Map?)?.cast<dynamic, String>(),
    )
      ..maxLine = fields[9] as int?
      ..marginTop = fields[10] as double?
      ..marginBottom = fields[11] as double?
      ..marginLeft = fields[12] as double?
      ..marginRight = fields[13] as double?;
  }

  @override
  void write(BinaryWriter writer, Fields obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.hint)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.required)
      ..writeByte(5)
      ..write(obj.readOnly)
      ..writeByte(6)
      ..write(obj.regx)
      ..writeByte(7)
      ..write(obj.select)
      ..writeByte(8)
      ..write(obj.hidden)
      ..writeByte(9)
      ..write(obj.maxLine)
      ..writeByte(10)
      ..write(obj.marginTop)
      ..writeByte(11)
      ..write(obj.marginBottom)
      ..writeByte(12)
      ..write(obj.marginLeft)
      ..writeByte(13)
      ..write(obj.marginRight)
      ..writeByte(14)
      ..write(obj.router);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FieldsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
