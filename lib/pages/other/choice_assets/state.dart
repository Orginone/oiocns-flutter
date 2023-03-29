import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';
import 'package:orginone/util/common_tree_management.dart';

class ChoiceAssetsState extends BaseGetState {
  TextEditingController searchController = TextEditingController();

  var assetsCategory = <AssetsCategoryGroup>[].obs;
  //显示搜索页面
  var showSearchPage = false.obs;

  //选择的资产
  var selectedAsset = Rxn<AssetsCategoryGroup>();

  var searchList = <AssetsCategoryGroup>[].obs;


  var items = <AssetsCategoryGroup>[].obs;

  ChoiceAssetState() {

  }
}

