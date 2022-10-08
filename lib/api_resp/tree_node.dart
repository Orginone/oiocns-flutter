import 'package:orginone/api_resp/target_resp.dart';

class TreeNode {
  String id;
  String label;
  bool hasNodes;
  TargetResp data;
  List<TreeNode> children;

  TreeNode.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        label = map["label"],
        hasNodes = map["hasNodes"],
        data = TargetResp.fromMap(map["data"]),
        children = <TreeNode>[];

  static TreeNode fromNode(Map<String, dynamic> node) {
    TreeNode treeNode = TreeNode.fromMap(node);
    List<Map<String, dynamic>> mapChildren = node["children"] ?? [];
    if (mapChildren.isNotEmpty) {
      var nodes = mapChildren.map((item) => fromNode(item)).toList();
      treeNode.children.addAll(nodes);
    }
    return treeNode;
  }
}
