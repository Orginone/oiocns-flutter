import 'package:orginone/dart/base/model/target.dart';

class TreeNode {
  String id;
  String label;
  bool hasNodes;
  Target data;
  List<TreeNode> children;

  TreeNode.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        label = map["label"],
        hasNodes = map["hasNodes"],
        data = Target.fromMap(map["data"]),
        children = <TreeNode>[];

  static TreeNode fromNode(
      Map<String, dynamic> node, Map<String, TreeNode> index) {
    TreeNode treeNode = TreeNode.fromMap(node);
    index.putIfAbsent(treeNode.id, () => treeNode);
    List<dynamic> mapChildren = node["children"] ?? [];
    if (mapChildren.isNotEmpty) {
      var nodes = mapChildren.map((item) => fromNode(item, index)).toList();
      treeNode.children.addAll(nodes);
    }
    return treeNode;
  }
}

class NodeCombine {
  final TreeNode topNode;
  final Map<String, TreeNode> index;

  const NodeCombine(this.topNode, this.index);
}
