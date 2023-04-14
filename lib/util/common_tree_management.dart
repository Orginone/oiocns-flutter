import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/thing/index.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';
import 'package:orginone/util/toast_utils.dart';

import '../dart/core/thing/species.dart';

class CommonTreeManagement {
  static final CommonTreeManagement _instance = CommonTreeManagement._();

  factory CommonTreeManagement() => _instance;

  CommonTreeManagement._();

  SettingController get _setting => Get.find<SettingController>();

  final List<AssetsCategoryGroup> _category = [];

  List<AssetsCategoryGroup> get category => _category;

  var _species = Rxn<SpeciesItem>();

  SpeciesItem? get species => _species.value;

  Future<void> initTree() async {
    _species.value = await loadSpeciesTree(_setting.space.id);
    _category.clear();
    ResultType<XDictItemArray> res = await kernel.queryDictItems(
      IdSpaceReq(
        id: "27466608056615936",
        spaceId: _setting.space.id ?? "",
        page: PageRequest(
          offset: 0,
          limit: 99999,
          filter: '',
        ),
      ),
    );
    if(res.success && (res.data?.result?.isNotEmpty??false)){
      _category.addAll(_handleGroupCategory(res.data!.result!));
    }else{
      // ToastUtils.showMsg(msg: "获取资产分类数据失败");
      print('获取资产分类数据失败');
    }
  }

  List<ISpeciesItem> getAllSpecies(List<ISpeciesItem> species) {
    List<ISpeciesItem> list = [];
    for (var element in species) {
      list.add(element);
      if (element.children.isNotEmpty) {
        list.addAll(getAllSpecies(element.children));
      }
    }

    return list;
  }

  List<AssetsCategoryGroup> get nonLevelCategory{
    List<AssetsCategoryGroup> category = [];

    for (var value in _category) {
      if(!value.hasNextLevel){
        category.add(value);
      }else{
        category.addAll(value.nonLevel);
      }
    }

    return category;

  }

  AssetsCategoryGroup? findCategoryTree(String name){
    try{
      return nonLevelCategory.firstWhere((element) => element.name == name);
    }catch(e){
      return null;
    }
  }

  List<AssetsCategoryGroup> _handleGroupCategory(List<XDictItem> items) {
    List<AssetsCategoryGroup> category = [];

    //获取一级分类
    for (var item in items) {
      if (item.value.isEmpty) {
        continue;
      }
      int code = int.parse(item.value);
      AssetsCategoryGroup group = AssetsCategoryGroup(
        name: item.name,
        code: code,
        id: item.id,
        nextLevel: [],
      );
      int divisibleCode = code ~/ 10000000;
      double exceptCode = code / 10000000;

      //只有可以整除的才能作为一级分类
      if (exceptCode == divisibleCode) {
        category.add(group);
      } else if (code < (divisibleCode + 1) * 10000000) {
        //获取可作为范围内的数据
        int index = divisibleCode - 1;
        if (index >= 0) {
          category[index].nextLevel.add(group);
        }
      }
    }

    //获取后续的分类
    List<AssetsCategoryGroup> getNextLevel(
        AssetsCategoryGroup parent, List<AssetsCategoryGroup> list, int lv) {
      List<AssetsCategoryGroup> category = [];

      int i = 0;
      int j = 10000000;
      while (i <= lv) {
        j = j ~/ 10;
        i++;
      }
      for (var value in list) {
        int code = value.code - parent.code;
        if (code == (j * (category.length + 1)) && (code ~/ j == category.length + 1)) {
          category.add(value);
        } else if (code ~/ j == category.length && category.isNotEmpty) {
          category[category.length - 1].nextLevel.add(value);
        }
      }
      for (var value1 in category) {
        int nextLv = lv+1;
        if (value1.nextLevel.isNotEmpty) {
          var data = getNextLevel(value1, value1.nextLevel, nextLv);
          if(data.isEmpty){
            nextLv++;
            value1.nextLevel = getNextLevel(value1, value1.nextLevel, nextLv);
          }
        }
      }
      return category;
    }

    for (var element in category) {
      if (element.nextLevel.isNotEmpty) {
        element.nextLevel = getNextLevel(element, element.nextLevel, 2);
      }
    }

    return category;
  }

  Future<XAttribute?> findXAttribute(
      {required String specieId, required String attributeId}) async {

    if (_species == null) {
      return null;
    }
    try{
      var data = _species.value!
          .getAllList()
          .firstWhere((element) => element.id == specieId);
      if (data.attrs.isEmpty) {
        await data.loadAttrs(_setting.space.id, true, true,
            PageRequest(offset: 0, limit: 9999, filter: ''));
      }
      return data.attrs.firstWhere((element) => element.id == attributeId);
    }catch(e){
      return null;
    }
  }
}

class AssetsCategoryGroup {
  late String name;
  late  int code;
  late String id;
  late List<AssetsCategoryGroup> nextLevel;

  AssetsCategoryGroup(
      {this.name = '',
      this.code = 0,
      this.id = '',
      this.nextLevel = const []});

  AssetsCategoryGroup.formJson( Map<String,dynamic> json){
    name = json['name'];
    code = json['code'];
    id = json['id'];
    if(json['nextLevel']!=null){
      nextLevel = [];
      json['nextLevel'].forEach((json){
        nextLevel.add(AssetsCategoryGroup.formJson(json));
      });
    }
  }

  Map<String,dynamic> toJson(){
    return {
      "name":name,
      "code":code,
      "id":id,
      "nextLevel":nextLevel.map((e) => e.toJson()).toList()
    };
  }

  bool get hasNextLevel => nextLevel.isNotEmpty;

  List<AssetsCategoryGroup> get nonLevel{
    List<AssetsCategoryGroup> data = [];

    for (var value in nextLevel) {
      if(!value.hasNextLevel){
        data.add(value);
      }else{
        data.addAll(value.nonLevel);
      }
    }
    return data;
  }
}