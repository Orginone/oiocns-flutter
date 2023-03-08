

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/assets_detail_config.dart';
import 'package:orginone/model/assets_info.dart';

class AssetsDetailsState extends BaseGetState{
  late AssetsInfo assets;

  var config = Rxn<AssetsDetailConfig>();

  AssetsDetailsState(){
    assets = Get.arguments['assets'];
  }
}