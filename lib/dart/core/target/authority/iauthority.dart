import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';

abstract class IAuthority {
  // 职权Id
  late String id;
  // 职权名称
  late String name;
  // 职权编号
  late String code;
  // 职权归属ID
  late String belongId;
  // 备注
  late String remark;
  // 子职权
  late List<IAuthority> children;

  /// 职权下的身份
  late List<IIdentity> identitys;

  /// 创建子职权
  /// @param name 名称
  /// @param code 编号
  /// @param ispublic 是否公开
  /// @param remark 备注
  /// @returns
  Future<ResultType<XAuthority>> createSubAuthority(
    String name,
    String code,
    bool ispublic,
    String remark,
  );

  /// 删除职权
  Future<ResultType> delete();

  /// 删除子职权
  /// @param id 子职权Id
  Future<ResultType> deleteSubAuthority(String id);

  /// 更新职权
  /// @param name 名称
  /// @param code 编号
  /// @param ispublic 公开的
  /// @param remark 备注
  /// @returns
  Future<ResultType<XAuthority>> updateAuthority(
    String name,
    String code,
    bool ispublic,
    String remark,
  );

  /// 查询指定职权下的身份列表
  ///  @param reload 是否强制刷新
  /// @returns
  Future<List<IIdentity>> queryAuthorityIdentity(bool reload);
}
