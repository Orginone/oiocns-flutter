import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/base/model.dart';

abstract class IIdentity {
  /// 实体对象
  late XIdentity target;

  /// 当前身份Id
  late String id;

  /// 当前身份名称
  late String name;

  /// 更新身份
  /// @param name 名称
  /// @param code 编号
  /// @param remark 备注
  /// @returns
  Future<ResultType<XIdentity>> updateIdentity(
    String name,
    String code,
    String remark,
  );

  ///
  /// 加载组织成员
  /// @param page 分页请求
  Future<XTargetArray?> loadMembers(PageRequest page);

  ///
  /// 拉取成员加入群组
  /// @param {string[]} ids 成员ID数组

  Future<bool> pullMembers(List<String> ids);

  ///
  /// 移除群成员
  /// @param {string[]} ids 成员ID数组
  /// @param {TargetType} type 成员类型

  Future<bool> removeMembers(List<String> ids);
}
