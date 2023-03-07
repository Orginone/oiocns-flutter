import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';
import 'package:orginone/util/toast_utils.dart';

class CommonTreeManagement {
  static final CommonTreeManagement _instance = CommonTreeManagement._();

  factory CommonTreeManagement() => _instance;

  CommonTreeManagement._();

  SettingController get setting => Get.find<SettingController>();

  final List<XDictItem> _assetsCategory = [];

  List<XDictItem> get assetsCategory => _assetsCategory;

  final List<ISpeciesItem> _species = [];

  List<ISpeciesItem> get species => _species;

  Future<void> initTree() async {
    var item  = await setting.space.loadSpeciesTree(reload: true);
    if(item!=null){
      _species.clear();
      _species.add(item);
    }
    ResultType<XDictItemArray> res = await kernel.queryDictItems(
      IdSpaceReq(
        id: "27466608056615936",
        spaceId: setting.space.id ?? "",
        page: PageRequest(
          offset: 0,
          limit: 99999,
          filter: '',
        ),
      ),
    );
    _assetsCategory.clear();
    if(res.success && (res.data?.result?.isNotEmpty??false)){
      _assetsCategory.addAll(res.data!.result!);
    }else{
      ToastUtils.showMsg(msg: "获取资产分类数据失败");
    }
  }

  ISpeciesItem? findSpeciesTree(String name) {
    List<ISpeciesItem> list = [];
    for (var value in  _species) {
      var items = value.getAllLastList();
      list.addAll(items);
    }
    var item = list.where((element) => element.name == name);
    if(item.isNotEmpty){
      return item.first;
    }
    return null;
  }

  XDictItem? findTree(String name) {
   var item =  _assetsCategory.where((element) => element.name == name);
   if(item.isNotEmpty){
     return item.first;
   }
   return null;
  }
}
