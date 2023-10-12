import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/model/user_model.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:path_provider/path_provider.dart';

import '../model/acc.dart';

///flutter packages pub run build_runner build --delete-conflicting-outputs
class HiveUtils {
  static late Box _userBox;
  static late Box _assetConfigBox;
  static late Box _subGroupConfigBox;
  static late Box _walletBox;

  static Future<void> init() async {
    if (!kIsWeb) {
      var document = await getApplicationDocumentsDirectory();
      Hive.init(document.path);
    }
    //检测并确保Hive数据库适配器注册
    if (!Hive.isAdapterRegistered(0)) {
      Hive
        ..registerAdapter(UserModelAdapter())
        ..registerAdapter(AttrsAdapter())
        ..registerAdapter(PersonAdapter())
        ..registerAdapter(TeamAdapter())
        ..registerAdapter(AssetCreationConfigAdapter())
        ..registerAdapter(ConfigAdapter())
        ..registerAdapter(FieldsAdapter())
        ..registerAdapter(SubGroupAdapter())
        ..registerAdapter(GroupAdapter())
        ..registerAdapter(WalletAdapter())
        ..registerAdapter(CoinAdapter());
    }

    _userBox = await Hive.openBox('userBox');
    _assetConfigBox = await Hive.openBox('assetConfigBox');
    _subGroupConfigBox = await Hive.openBox('subGroupConfigBox');
    _walletBox = await Hive.openBox("walletBox");
  }

  static void putUser(UserModel user) async {
    await _userBox.put("user", user);
  }

  static UserModel? getUser() {
    return _userBox.get("user");
  }

  static SubGroup? getSubGroup(String key) {
    return _subGroupConfigBox.get(key);
  }

  static void putSubGroup(String key, SubGroup group) {
    _subGroupConfigBox.put(key, group);
  }

  static void putWallet(Wallet wallet) {
    _walletBox.put(wallet.account, wallet);
  }

  static List<Wallet> getAllWallet() {
    List<Wallet> wallets = [];
    var data = _walletBox.values.toList();
    if (data.isNotEmpty) {
      for (var element in data) {
        wallets.add(element);
      }
    }
    return wallets;
  }

  static Future<void> clean() async {
    await _userBox.clear();
    await _assetConfigBox.clear();
    await _subGroupConfigBox.clear();
    await _walletBox.clear();
  }

  static void putConfig(List<AssetCreationConfig> configs) async {
    if (configs.isEmpty) {
      return;
    }
    Map<String, AssetCreationConfig> map = {};
    for (var element in configs) {
      map[element.businessCode!] = element;
    }
    if (map.isEmpty) {
      return;
    }
    await _assetConfigBox.putAll(map);
  }

  static AssetCreationConfig getConfig(String key) {
    var assetConfig = _assetConfigBox.get(key);
    if (assetConfig == null) {
      switch (key) {
        case "claim":
          assetConfig = AssetCreationConfig.fromJson(claimConfig);
          break;
        case "dispose":
          assetConfig = AssetCreationConfig.fromJson(disposeConfig);
          break;
        case "transfer":
          assetConfig = AssetCreationConfig.fromJson(transferConfig);
          break;
        case "handOver":
          assetConfig = AssetCreationConfig.fromJson(handOverConfig);
          break;
      }
    }

    return assetConfig;
  }
}
