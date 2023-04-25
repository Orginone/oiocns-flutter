import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/chat/chat.dart';
import 'package:orginone/dart/core/target/chat/ichat.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import '../../../base/api/kernelapi.dart';
import '../../../base/schema.dart';
import '../../enum.dart';
import 'iauthority.dart';
import 'identity.dart';
import 'package:orginone/dart/base/common/uint.dart';
import 'package:orginone/dart/core/consts.dart';

class Authority implements IAuthority {
  @override
  IChat chat;

  @override
  List<IAuthority> children;

  @override
  String userId;

  @override
  List<IIdentity> identitys;

  @override
  ISpace space;

  @override
  XAuthority target;

  @override
  get belongId {
    return target.belongId!;
  }

  @override
  get id {
    return target.id!;
  }

  @override
  get code {
    return target.code!;
  }

  @override
  get name {
    return target.name!;
  }

  @override
  get remark {
    return target.remark!;
  }

  KernelApi kernel = KernelApi.getInstance();

  Authority(this.target, this.space, this.userId)
      : children = [],
        identitys = [],
        chat = createAuthChat(userId, space.id, space.teamName, target) {
    if (target.nodes != null && target.nodes!.isNotEmpty) {
      for (var item in target.nodes!) {
        children.add(Authority(item, space, userId));
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
      belongId: belongId,
    ));
    if (res.success && res.data != null) {
      children.add(Authority(res.data!, space, userId));
    }
    return res;
  }

  @override
  Future<ResultType> delete() async {
    final res = await kernel.deleteAuthority(IdReqModel(
      id: id,
      belongId: belongId,
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
        id: id ?? "",
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
        id: id,
        name: name,
        code: code,
        public: ispublic,
        parentId: target.parentId,
        belongId: belongId,
        remark: remark));
    if (res.success) {
      target.name = name;
      target.code = code;
      target.public = ispublic;
      target.remark = remark;
      target.updateTime = res.data!.updateTime;
    }
    return res;
  }

  @override
  List<IChat> allChats() {
    var chats = [chat];
    for (var item in children) {
      chats.addAll(item.allChats());
    }
    return chats;
  }
}
