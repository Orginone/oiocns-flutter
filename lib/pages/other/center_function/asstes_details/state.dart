

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/my_assets_list.dart';

class AssetsDetailsState extends BaseGetState{
  late MyAssetsList assets;

  AssetsDetailsState(){
    assets = Get.arguments['assets'];
  }
}