import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';

class ChoiceAssetsState extends BaseGetState {
  TextEditingController searchController = TextEditingController();

  var assetsCategory = <XDictItem>[].obs;

  //显示搜索页面
  var showSearchPage = false.obs;

  //选择的资产
  var selectedAsset = Rxn<ISpeciesItem>();

  var searchList = <ISpeciesItem>[].obs;


  var items = <ISpeciesItem>[].obs;

  ChoiceAssetState() {

  }
}

