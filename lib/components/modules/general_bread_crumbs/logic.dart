import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';
import 'package:orginone/utils/toast_utils.dart';

import 'state.dart';

class GeneralBreadCrumbsController
    extends BaseBreadcrumbNavController<GeneralBreadCrumbsState> {
  @override
  final GeneralBreadCrumbsState state = GeneralBreadCrumbsState();

  void onNext(GeneralBreadcrumbNav item) {
    if (item.spaceEnum == SpaceEnum.work || item.spaceEnum == SpaceEnum.file) {
      jumpDetails(item);
    } else {
      Get.toNamed(Routers.generalBreadCrumbs,
          arguments: {"data": item}, preventDuplicates: false);
    }
  }

  void jumpDetails(GeneralBreadcrumbNav item) async {
    switch (item.spaceEnum) {
      case SpaceEnum.work:
        WorkNodeModel? node = await item.source.loadWorkNode();
        if (node != null && node.forms != null && node.forms!.isNotEmpty) {
          Get.toNamed(Routers.createWork, arguments: {
            "work": item.source,
            "node": node,
            'target': item.space
          });
        } else {
          ToastUtils.showMsg(msg: "流程未绑定表单");
        }
        {}
        break;
      case SpaceEnum.file:
        RoutePages.jumpFile(file: (item.source as ISysFileInfo).shareInfo());
        break;
      default:
    }
  }

  void operation(PopupMenuKey key, GeneralBreadcrumbNav item) {
    switch (key) {
      case PopupMenuKey.setCommon:
        //TODO:isMostUsed  removeMostUsed字段不存在 用到看逻辑改
        // settingCtrl.work.setMostUsed(item.source);
        break;
      case PopupMenuKey.removeCommon:
        // settingCtrl.work.removeMostUsed(item.source);
        break;
      default:
    }
  }
}
