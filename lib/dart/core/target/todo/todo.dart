import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';

abstract class ITodo {
  /// 唯一Id
  late String id;

  /// 事项名称
  late String name;

  /// 事项类型
  late String type;

  /// 备注
  late String remark;

  /// 共享组织
  late String shareId;

  /// 所在空间ID
  late String spaceId;

  /// 分类Id
  late String speciesId;

  /// 对象
  late dynamic target;

  /// 创建时间
  late String createTime;

  /// 发起人
  late String createUser;

  /// 状态
  late int status;

  /// 审批办事
  Future<bool> approval(int status, String? comment, String? data);
}

class FlowTodo implements ITodo {
  @override
  String createTime;

  @override
  String createUser;

  @override
  String id;

  @override
  String name;

  @override
  String remark;

  @override
  String shareId;

  @override
  String spaceId;

  @override
  String speciesId;

  @override
  int status;

  @override
  dynamic target;

  @override
  String type;

  FlowTodo(XFlowTaskHistory task)
      : id = task.id??'',
        name = task.instance?.title??"",
        target = task,
        type = '事项',
        remark = '',
        status = task.status??0,
        createTime = task.createTime??"",
        shareId = task.instance?.belongId??"",
        spaceId = task.instance?.belongId??"",
        createUser = task.instance?.createUser??"",
        speciesId = task.instance?.define?.speciesId ?? '';

  @override
  Future<bool> approval(int status, String? comment, String? data) async {
    var res = await kernel.approvalTask(ApprovalTaskReq(
      id: id,
      comment: comment,
      status: status,
      data: data,
    ));
    return res.success;
  }
}

class OrgTodo implements ITodo {
  @override
  String createTime;

  @override
  String createUser;

  @override
  String id;

  @override
  String name;

  @override
  String remark;

  @override
  String shareId;

  @override
  String spaceId;

  @override
  String speciesId;

  @override
  int status;

  @override
  dynamic target;

  @override
  String type;

  OrgTodo(XRelation task)
      : id = task.id,
        target = task,
        type = '组织',
        remark = '',
        speciesId = '',
        status = task.status,
        createTime = task.createTime,
        name = '申请加入${task.team?.name}',
        shareId = task.team?.targetId ?? '0',
        spaceId = task.team?.targetId ?? '0',
        createUser = task.targetId;

  @override
  Future<bool> approval(int status, String? comment, String? data) async {
    var res = await kernel.joinTeamApproval(ApprovalModel(
      id: id,
      status: status,
    ));
    return res.success;
  }
}
