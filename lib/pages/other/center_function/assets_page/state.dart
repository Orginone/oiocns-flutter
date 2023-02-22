

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_list_state.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/model/my_assets_list.dart';

class AssetsState extends BaseGetListState<MyAssetsList>{
  var useList = <AssetUse>[].obs;

}

