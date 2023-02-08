import '../../base/model.dart';
import '../enum.dart';

class IApprovalItemResult {
  List<IApprovalItem>? result;
  late int total;
  late int offset;
  late int limit;

  IApprovalItemResult(this.result, this.total, this.offset, this.limit);
}

class IApplyItemResult {
  List<IApplyItem>? result;
  late int total;
  late int offset;
  late int limit;

  IApplyItemResult(this.result, this.total, this.offset, this.limit);
}

/// 待办组
abstract class ITodoGroup {
  /// @type 待办类型
  TodoType? type;

  /// @id 唯一值
  String? id;

  /// @icon 图标
  String? icon;

  /// @displayName 待办名称
  String? name;

  /// @count  待办数量
  Future<int> getCount();

  /// @desc 获取待办列表
  Future<List<IApprovalItem>> getTodoList({bool refresh = false});

  /// @desc 获取待抄送待阅列表
  Future<List<IApprovalItem>> getNoticeList(bool refresh);

  /// @desc 获取已办列表
  Future<IApprovalItemResult> getDoList(PageRequest page);

  /// @desc 获取申请列表
  Future<IApplyItemResult> getApplyList(PageRequest page);
}

/// 待办/已办项
abstract class IApprovalItem {
  /// 获得审批内容
  dynamic Data;

  /// @pass 通过
  Future<bool> pass(int status, {String remark = ''});

  /// @reject 拒绝
  Future<bool> reject(int status, String remark);
}

/// 申请项
abstract class IApplyItem {
  /// 获得审批内容
  dynamic data;

  /// @cancel 取消
  Future<bool> cancel(int status, String remark);
}

abstract class IOrderApplyItem extends IApplyItem {
  /// 取消订单详情项
  /// @param stidatus 详情项Id
  /// @param status 状态
  /// @param remark 备注
  Future<bool> cancelItem(String id, int status, String remark);

  /// 退货退款订单详情项
  /// @param status 状态
  /// @param remark 备注
  Future<bool> reject(String id, int status, String remark);
}
