import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/base/model.dart';
import '../../../base/api/kernelapi.dart';
import '../../../base/schema.dart';
import '../../enum.dart';
import 'iauthority.dart';
import 'identity.dart';
import 'package:orginone/dart/base/common/uint.dart';
import 'package:orginone/dart/core/consts.dart';

class Authority extends IAuthority {
  late String _belongId;
  late XAuthority _authority;
  KernelApi kernel = KernelApi.getInstance();
  Authority(XAuthority auth, String belongId) {
    _authority = auth;
    _belongId = belongId;
    children = [];
    identitys = [];
    if (auth.nodes != null && auth.nodes!.isNotEmpty) {
      for (var item in auth.nodes!) {
        children.add(Authority(item, belongId));
      }
    }
  }

  List<String> get existAuthority {
    return [
      AuthorityType.applicationAdmin.name,
      AuthorityType.superAdmin.name,
      AuthorityType.marketAdmin.name,
      AuthorityType.relationAdmin.name,
      AuthorityType.thingAdmin.name,
    ];
  }

  @override
  String get id {
    return _authority.id;
  }

  @override
  String get name {
    return _authority.name;
  }

  @override
  String get code {
    return _authority.code;
  }

  @override
  String get belongId {
    return _authority.belongId;
  }

  @override
  String get remark {
    return _authority.remark;
  }

  @override
  Future<ResultType<XAuthority>> createSubAuthority(
      String name, String code, bool ispublic, String remark) async {
    if (existAuthority.indexOf(code) > 0) {
      throw unAuthorizedError;
    }
    final res = await kernel.createAuthority(AuthorityModel(
      id: '',
      name: name,
      code: code,
      remark: remark,
      public: ispublic,
      parentId: id,
      belongId: _belongId,
    ));
    if (res.success && res.data != null) {
      children.add(Authority(res.data!, _belongId));
    }
    return res;
  }

  @override
  Future<ResultType> delete() async {
    final res = await kernel.deleteAuthority(IdReqModel(
      id: id,
      belongId: _belongId,
      typeName: '',
    ));
    return res;
  }

  @override
  Future<ResultType> deleteSubAuthority(String id) async {
    final index = children.where((IAuthority auth) => auth.id == id).toList();
    if (index.isNotEmpty) {
      final res = await kernel.deleteAuthority(IdReqModel(
        id: id,
        typeName: '',
      ));
      if (res.success) {
        children = children.where((IAuthority auth) => auth.id != id).toList();
      }
      return res;
    }
    return ResultType(code: 400, msg: unAuthorizedError, success: false);
  }

  @override
  Future<List<IIdentity>> queryAuthorityIdentity(bool reload) async {
    if (!reload && identitys.isNotEmpty) {
      return identitys;
    }
    final res = await kernel.queryAuthorityIdentitys(IdSpaceReq(
        id: _authority.id,
        page: PageRequest(offset: 0, filter: '', limit: Constants.maxUint16),
        spaceId: id));
    if (res.success && res.data != null) {
      res.data!.result?.forEach((element) {
        identitys.add(Identity(element));
      });
    }
    return identitys;
  }

  @override
  Future<ResultType<XAuthority>> updateAuthority(
      String name, String code, bool ispublic, String remark) async {
    final res = await kernel.updateAuthority(AuthorityModel(
        id: _authority.id,
        name: name,
        code: code,
        public: ispublic,
        parentId: _authority.parentId,
        belongId: _authority.belongId,
        remark: remark));
    if (res.success) {
      _authority.name = name;
      _authority.code = code;
      _authority.public = ispublic;
      _authority.remark = remark;
      _authority.updateTime = res.data!.updateTime;
    }
    return res;
  }
}
