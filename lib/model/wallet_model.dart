import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 9)
class Wallet {
  @HiveField(0)
  String? account;
  @HiveField(1)
  String? address;
  @HiveField(2)
  List<int>? encPasswd;
  @HiveField(3)
  List<int>? mnemonicsEncKey;
  @HiveField(4)
  String? passWord;
  @HiveField(5)
  String? passwdHash;
  @HiveField(6)
  String? privateKey;
  @HiveField(7)
  String? publicKey;

  Wallet({
    this.account,
    this.address,
    this.encPasswd,
    this.mnemonicsEncKey,
    this.passWord,
    this.passwdHash,
    this.privateKey,
    this.publicKey,
  });

  // Factory method to create a WalletBean instance from a JSON object
  Wallet.fromJson(Map<String, dynamic> json) {
    account = json['account'];
    address = json['address'];
    encPasswd = List<int>.from(json['encPasswd']);
    mnemonicsEncKey = List<int>.from(json['mnemonicsEncKey']);
    passWord = json['passWord'];
    passwdHash = json['passwdHash'];
    privateKey = json['privateKey'];
    publicKey = json['publicKey'];
  }

  // Convert the WalletBean instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'address': address,
      'encPasswd': encPasswd,
      'mnemonicsEncKey': mnemonicsEncKey,
      'passWord': passWord,
      'passwdHash': passwdHash,
      'privateKey': privateKey,
      'publicKey': publicKey,
    };
  }
}
