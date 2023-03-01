import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/market/model.dart';
import 'package:orginone/util/toast_utils.dart';

class CommonTreeManagement {
  static final CommonTreeManagement _instance = CommonTreeManagement._();

  factory CommonTreeManagement() => _instance;

  CommonTreeManagement._();

  SettingController get setting => Get.find();

  final List<XDictItem> _assetsCategory = [];

  List<XDictItem> get assetsCategory => _assetsCategory;

  Future<void> initTree() async {
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

  XDictItem? findTree(String name) {
   var item =  _assetsCategory.where((element) => element.name == name);
   if(item.isNotEmpty){
     return item.first;
   }
   return null;
  }
}
