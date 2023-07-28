// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 9;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      account: fields[0] as String?,
      address: fields[1] as String?,
      encPasswd: (fields[2] as List?)?.cast<int>(),
      mnemonicsEncKey: (fields[3] as List?)?.cast<int>(),
      passWord: fields[4] as String?,
      passwdHash: fields[5] as String?,
      privateKey: fields[6] as String?,
      publicKey: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.account)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.encPasswd)
      ..writeByte(3)
      ..write(obj.mnemonicsEncKey)
      ..writeByte(4)
      ..write(obj.passWord)
      ..writeByte(5)
      ..write(obj.passwdHash)
      ..writeByte(6)
      ..write(obj.privateKey)
      ..writeByte(7)
      ..write(obj.publicKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
