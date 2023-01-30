import 'package:get/get.dart';
import 'package:orginone/components/bread_crumb.dart';
import 'package:orginone/dart/base/api/company_api.dart';
import 'package:orginone/dart/base/enumeration/enum_map.dart';
import 'package:orginone/dart/base/enumeration/target_type.dart';
import 'package:orginone/dart/base/model/target.dart';
import 'package:orginone/dart/base/model/tree_node.dart';
import 'package:orginone/pages/other/home/home_controller.dart';

class DeptController extends GetxController {
  final BreadCrumbController breadCrumbController = BreadCrumbController();
  final HomeController homeController = Get.find<HomeController>();

  NodeCombine? nodeCombine;
  TreeNode? currentNode;

  // 人员获取控制器
  List<Target> persons = [];
  int limit = 20;
  int offset = 0;

  @override
  onInit() {
    super.onInit();
    init();
  }

  // 初始化
  init() async {
    // 节点树
    nodeCombine = await CompanyApi.tree();
    if (nodeCombine == null) {
      return;
    }
    var topNode = nodeCombine!.topNode;
    var nodeId = Get.arguments;
    if (nodeId != null) {
      List<TreeNode> queue = [topNode];
      while (queue.isNotEmpty) {
        var first = queue.removeAt(0);
        if (first.id == nodeId) {
          await entryNode(first);
          return;
        }
        queue.addAll(first.children);
      }
    } else {
      await entryNode(topNode);
    }
  }

  /// 刷新人员
  refreshPersons(TreeNode node) async {
    limit = 20;
    offset = 0;

    var nameMap = EnumMap.targetTypeMap;
    var targetType = nameMap[node.data.typeName];

    switch (targetType) {
      case TargetType.company:
        var pageResp =
            await CompanyApi.getCompanyPersons(node.id, limit, offset);
        persons = pageResp.result;
        break;
      case TargetType.department:
        var pageResp = await CompanyApi.getDeptPersons(node.id, limit, offset);
        persons = pageResp.result;
        break;
      default:
        persons = [];
    }
  }

  entryNode(TreeNode node) async {
    // 加入到面包屑里
    var item = Item(id: node.id, label: node.label);
    breadCrumbController.push(item);

    // 当前节点为点击的节点，刷新人员
    currentNode = node;
    await refreshPersons(currentNode!);
    update();
  }

  popsNode(Item<String> item) async {
    // 从面包屑中弹出
    var index = nodeCombine!.index;
    var itemId = item.id;
    breadCrumbController.popsUntil(item.id);

    if (index.containsKey(itemId)) {
      currentNode = index[itemId];
      await refreshPersons(currentNode!);
      update();
    }
  }

  searchingCallback() {}
}
