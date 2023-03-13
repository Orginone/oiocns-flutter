import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/user_model.dart';
import 'package:path_provider/path_provider.dart';

import '../model/acc.dart';

class HiveUtils {
  static late Box _userBox;
  static late Box _assetConfigBox;

  static Future<void> init() async {
    if (!kIsWeb) {
      var document = await getApplicationDocumentsDirectory();
      Hive.init(document.path);
    }
    if (!Hive.isAdapterRegistered(0)) {
      Hive
        ..registerAdapter(UserModelAdapter())
        ..registerAdapter(AttrsAdapter())
        ..registerAdapter(PersonAdapter())
        ..registerAdapter(TeamAdapter())
        ..registerAdapter(AssetCreationConfigAdapter())
        ..registerAdapter(ConfigAdapter())
        ..registerAdapter(FieldsAdapter());
    }

    _userBox = await Hive.openBox('userBox');
    _assetConfigBox = await Hive.openBox('assetConfigBox');
  }

  static void putUser(UserModel user) async {
    await _userBox.put("user", user);
  }

  static UserModel? getUser() {
    return _userBox.get("user");
  }

  static Future<void> clean() async{
    await _userBox.clear();
    await _assetConfigBox.clear();
  }

  static void putConfig(List<AssetCreationConfig> configs) async{
    if(configs.isEmpty){
     return;
    }
    Map<String,AssetCreationConfig> map = {};
    for (var element in configs) {
      map[element.businessCode!] = element;
    }
    if(map.isEmpty){
      return;
    }
    await _assetConfigBox.putAll(map);
  }

  static AssetCreationConfig getConfig(String key){
   var assetConfig =  _assetConfigBox.get(key);
   if(assetConfig == null){
     switch(key){
       case "claim":
         assetConfig = AssetCreationConfig.fromJson(claimConfig);
         break;
       case "dispose":
         assetConfig = AssetCreationConfig.fromJson(disposeConfig);
         break;
     }
   }

   return assetConfig;
  }


}
