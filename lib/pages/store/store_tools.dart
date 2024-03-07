import 'package:get/get.dart';
import 'package:orginone/common/routers/names.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/form/form_widget/form_tool.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/utils/log/log_util.dart';

class StoreTool {
  static void jumpNextPage({dynamic parentData, List? listDatas}) async {
    LogUtil.d(parentData);
    LogUtil.d(parentData.typeName);
    LogUtil.d(parentData.metadata.toString());

    SpaceEnum? type = SpaceEnum.getType(parentData.typeName);
    switch (type) {
      case SpaceEnum.form:
        Form form = await FormTool.loadForm(parentData);
        _jumpDetailPage(Routers.formPage, form);
        break;
      case SpaceEnum.property:
      case SpaceEnum.dict:
        _jumpDetailPage(Routers.standardEntityPreView, parentData);
        break;
      default:
        RoutePages.jumpHomeSub(
            home: HomeEnum.store, parentData: parentData, listDatas: listDatas);
    }
  }

  static _jumpDetailPage(String router, dynamic params) {
    Get.toNamed(router,
        arguments: RouterParam(
            parents: [if (null != params) RouterParam(datas: params)],
            datas: params));
  }
}
