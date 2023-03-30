import 'package:orginone/dart/base/model.dart';

import '../../base/common/uint.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'itarget.dart';

/*
 * 岗位的元操作
 */
class Station extends BaseTarget implements IStation {
  final Function _onDeleted;
  late List<XIdentity> _identitys;
  Station(XTarget target, this._onDeleted) : super(target);
  @override
  Future<bool> delete() async {
    final res = await deleteTarget();
    if (res.success) {
      _onDeleted(this, []);
    }
    return res.success;
  }

  @override
  Future<XTargetArray> searchPerson(String code) async {
    return await searchTargetByName(code, [TargetType.person]);
  }

  /* 加载岗位下的身份 */
  @override
  Future<List<XIdentity>> loadIdentitys({bool reload = false}) async {
    if (!reload && _identitys.isNotEmpty) {
      return _identitys;
    }
    final res = await kernel.queryTeamIdentitys(IDBelongReq(
      id: id,
      page: PageRequest(
        offset: 0,
        limit: Constants.maxUint16,
        filter: '',
      ),
    ));
    if (res.success && res.data?.result != null) {
      _identitys = res.data!.result!;
    }
    return _identitys;
  }

  @override
  Future<bool> pullIdentitys(List<XIdentity> identitys) async {
    identitys = identitys.where((a) => !_identitys.contains(a)).toList();
    if (identitys.isNotEmpty) {
      final res = await kernel.pullIdentityToTeam(TeamPullModel(
        id: id,
        targetIds: identitys.map((a) => a.id??"").toList(),
        targetType: '',
        teamTypes: [target.typeName],
      ));
      if (res.success) {
        _identitys.addAll(identitys);
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> removeIdentitys(List<String> ids) async {
    final res = await kernel.removeTeamIdentity(GiveIdentityModel(
      id: target.team!.id,
      targetIds: ids,
    ));
    if (res.success) {
      _identitys = _identitys.where((a) => !ids.contains(a.id)).toList();
      return true;
    }
    return false;
  }
}
