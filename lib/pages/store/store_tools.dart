import 'package:get/get.dart';
import 'package:orginone/common/routers/names.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/form/form_widget/form_tool.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/utils/log/log_util.dart';

class StoreTool {
  /// 跳转到数据二级页面
  static void jumpStore({dynamic parentData, List? listDatas}) async {
    LogUtil.d(parentData);
    LogUtil.d(parentData.typeName);
    LogUtil.d(parentData.metadata.toString());

    SpaceEnum? type = SpaceEnum.getType(parentData.typeName);
    switch (type) {
      case SpaceEnum.form:
        Form form = await FormTool.loadForm(parentData);
        _jumpDetailOrInfoPage(Routers.formPage, form);
        break;
      case SpaceEnum.property:
      case SpaceEnum.dict:
      case SpaceEnum.species:
        _jumpDetailOrInfoPage(Routers.standardEntityDetailPage, parentData);
        break;
      default:
        RoutePages.jumpStoreSub(parentData: parentData, listDatas: listDatas);
    }
  }

  /// 跳转到数据详情页面
  /// data 需要展示的目标对象
  /// defaultActiveTabs 默认激活页签
  static void jumpStoreInfoPage(
      {dynamic data, List<String> defaultActiveTabs = const []}) async {
    LogUtil.d('jumpStoreInfoPage');
    LogUtil.d(data.runtimeType);
    LogUtil.d(data);
    SpaceEnum? type = SpaceEnum.getType(data.typeName);
    switch (type) {
      // case SpaceEnum.form:
      //   Form form = await FormTool.loadForm(data);
      //   _jumpDetailPage(Routers.formPage, form);
      //   break;
      // case SpaceEnum.form:
      case SpaceEnum.property:
      case SpaceEnum.dict:
      case SpaceEnum.species:
        _jumpDetailOrInfoPage(Routers.standardEntityInfoPage, data);
        break;
      default:
      // _jumpHomeSub(home: HomeEnum.store, parentData: data, listDatas: data);
    }
  }

  static _jumpDetailOrInfoPage(String router, dynamic params) {
    Get.toNamed(router,
        arguments: RouterParam(
            parents: [if (null != params) RouterParam(datas: params)],
            datas: params));
  }
}
