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
  @HiveField(8)
  List<Coin>? coins;

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
    if (json['coins'] != null) {
      coins = [];
      json['coins'].forEach((json) {
        coins!.add(Coin.fromJson(json));
      });
    }
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
      'coins': coins?.map((e) => e.toJson()).toList(),
    };
  }
}

@HiveType(typeId: 10)
class Coin {
  @HiveField(0)
  String? address;
  @HiveField(1)
  String? type;
  @HiveField(2)
  String? tokenSymbol;
  @HiveField(3)
  String? node;
  @HiveField(4)
  String? balance;

  Coin({this.address, this.type, this.node, this.balance, this.tokenSymbol});

  Coin.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    type = json['type'];
    tokenSymbol = json['tokenSymbol'];
    node = json['node'];
    balance = json['balance'];
  }

  // Convert the WalletBean instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'util': node,
      'tokenSymbol': tokenSymbol,
      'cointype': type,
      'balance': balance,
    };
  }
}

const DEFAULT_COINS = [
  {
    "address": "",
    "type": "AS",
    "tokenSymbol": "AS",
    'node': '',
    'balance': '0',
  },
  {
    "address": "",
    "type": "BTC",
    "tokenSymbol": "BTC",
    'node': '',
    'balance': '0',
  },
  {
    "address": "",
    "type": "ETH",
    "tokenSymbol": "ETH",
    'node': '',
    'balance': '0',
  },
];