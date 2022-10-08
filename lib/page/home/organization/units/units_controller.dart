import 'package:get/get.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/component/bread_crumb.dart';
import 'package:orginone/page/home/home_controller.dart';

import '../../../../api_resp/tree_node.dart';

class UnitsController extends GetxController {
  final BreadCrumbController breadCrumbController = BreadCrumbController();
  final HomeController homeController = Get.find<HomeController>();

  @override
  onInit() {
    super.onInit();

    // 当前空间
    var space = homeController.currentSpace;
    breadCrumbController.push(Item(id: space.id, label: space.name));

    // 子节点
    CompanyApi.tree().then((topNode) {
      List<TreeNode> children = topNode.children;

    });
  }

  searchingCallback() {}
}
