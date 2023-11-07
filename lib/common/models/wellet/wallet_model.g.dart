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
      coins: (fields[8] as List?)?.cast<Coin>(),
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.publicKey)
      ..writeByte(8)
      ..write(obj.coins);
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

class CoinAdapter extends TypeAdapter<Coin> {
  @override
  final int typeId = 10;

  @override
  Coin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Coin(
      address: fields[0] as String?,
      type: fields[1] as String?,
      node: fields[3] as String?,
      balance: fields[4] as String?,
      tokenSymbol: fields[2] as String?,
      privateKey: fields[5] as String?,
      publicKey: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Coin obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.address)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.tokenSymbol)
      ..writeByte(3)
      ..write(obj.node)
      ..writeByte(4)
      ..write(obj.balance)
      ..writeByte(5)
      ..write(obj.privateKey)
      ..writeByte(6)
      ..write(obj.publicKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
