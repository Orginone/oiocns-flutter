import 'package:orginone/dart/base/model.dart';

import '../../../base/api/kernelapi.dart';
import '../../../base/schema.dart';
import '../../enum.dart';
import 'iidentity.dart';

class Identity extends IIdentity {
  KernelApi kernel = KernelApi.getInstance();

  @override
  String get id {
    return target.id;
  }

  @override
  String get name {
    return target.name;
  }

  Identity(XIdentity identity) {
    target = identity;
  }
  @override
  Future<XTargetArray?> loadMembers(PageRequest page) async {
    final res = await kernel.queryIdentityTargets(IDBelongTargetReq(
      id: id,
      targetType: TargetType.person.name,
      page: page,
    ));
    return res.data;
  }

  @override
  Future<bool> pullMembers(List<String> ids) async {
    final res =
        await kernel.giveIdentity(GiveIdentityModel(id: id, targetIds: ids));
    return res.success;
  }

  @override
  Future<bool> removeMembers(List<String> ids) async {
    final res =
        await kernel.removeIdentity(GiveIdentityModel(id: id, targetIds: ids));
    return res.success;
  }

  @override
  Future<ResultType<XIdentity>> updateIdentity(
      String name, String code, String remark) async {
    final res = await kernel.updateIdentity(IdentityModel(
        id: id,
        name: name,
        code: code,
        authId: target.authId,
        belongId: target.belongId,
        remark: remark));
    if (res.success) {
      target.name = name;
      target.code = code;
      target.remark = remark;
      target.updateTime = res.data!.updateTime;
    }
    return res;
  }
}
