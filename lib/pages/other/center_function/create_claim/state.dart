import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';
import 'package:orginone/model/acc.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/util/hive_utils.dart';

class CreateClaimState extends BaseGetState {
  late bool isEdit;

  var detailedData = <Config>[].obs;

  late AssetUse assetUse;

  late AssetCreationConfig config;

  CreateClaimState() {
    config = HiveUtils.getConfig("claim");
    isEdit = Get.arguments?['isEdit'] ?? false;
    if (isEdit) {
      assetUse = Get.arguments?['assetUse'];
      Map<String, dynamic> assetUseJson = assetUse.toJson();
      for (var element in config.config![0].fields!) {
        element.initDefaultData(assetUseJson);
      }
      if (assetUse.approvalDocument?.detail?.isNotEmpty ?? false) {
        var assets = assetUse.approvalDocument!.detail!;
        for (var value in assets) {
          Map<String, dynamic> assetsJson = value.toJson();
          Config c = config.config![1].toNewConfig();
          for (var element in c.fields!) {
            element.initDefaultData(assetsJson);
          }
          detailedData.add(c);
        }
      }
    } else {
      detailedData.add(config.config![1].toNewConfig());
    }
  }
}
