import 'package:get/get.dart';
import 'package:orginone/common/routers/names.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/form/form_widget/form_tool.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/dart/core/thing/standard/property.dart';
import 'package:orginone/utils/log/log_util.dart';

class StoreTool {
  static void jumpNextPage({dynamic parentData, List? listDatas}) async {
    LogUtil.d(parentData);
    LogUtil.d(parentData.typeName);
    LogUtil.d(parentData.metadata.toString());
    if (parentData.typeName == SpaceEnum.form.label) {
      // Get.toNamed(Routers.thing,
      //     arguments: {'form': parentData, "belongId": parentData.belongId});
      Form form = await FormTool.loadForm(parentData);
      Get.toNamed(Routers.formPage,
          arguments: RouterParam(
              parents: [
                // ..._getParentRouteParams(),
                if (null != form) RouterParam(datas: form)
              ],
              // parents: [..._getParentRouteParams(), RouterParam(datas: parentData.metadata)],
              // defaultActiveTabs: defaultActiveTabs ?? [TargetType.person.label],
              datas: form));
      // Get.toNamed(Routers.formPage, arguments: {
      //   'title': parentData.name,
      //   'mainForm': [xForm].cast<XForm>(),
      //   "subForm": [],
      // });
      //跳转办事详情
      // Get.toNamed(Routers.processDetails, arguments: {"todo": parentData});
    } else if (parentData.typeName == SpaceEnum.property.label) {
      // XProperty;
      // XStandard;
      Property;
      Get.toNamed(Routers.standardEntityPreView,
          arguments: RouterParam(
              parents: [
                // ..._getParentRouteParams(),
                if (null != parentData) RouterParam(datas: parentData)
              ],
              // parents: [..._getParentRouteParams(), RouterParam(datas: parentData.metadata)],
              // defaultActiveTabs: defaultActiveTabs ?? [TargetType.person.label],
              datas: parentData));
      // Get.toNamed(Routers.standardEntityPreView, arguments: {
      //   'xStandard': parentData.metadata,
      //   'title': '查看属性',
      // });
    } else {
      RoutePages.jumpHome(
          home: HomeEnum.store, parentData: parentData, listDatas: listDatas);
    }
  }
}
