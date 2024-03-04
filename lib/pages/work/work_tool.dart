import 'package:orginone/dart/base/model.dart';

class WorkTool {
  static WorkNodeModel? getNodeByNodeId(String nodeId, {WorkNodeModel? node}) {
    if (node != null) {
      if (nodeId == node.id) return node;
      final find = getNodeByNodeId(nodeId, node: node.children);
      if (find != null) return find;
      for (final subNode in node.branches ?? []) {
        final find = getNodeByNodeId(nodeId, node: subNode.children);
        if (find != null) return find;
      }
    }
    return null;
  }
}
