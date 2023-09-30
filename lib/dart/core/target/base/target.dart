import 'dart:async';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/resource.dart';
import 'package:orginone/main.dart';
import '../../public/operates.dart';
import 'team.dart';

/// 空间类型数据
class SpaceType {
  // 唯一标识
  late String id;

  // 名称
  late String name;

  // 类型
  late TargetType typeName;

  // 头像
  late ShareIcon share;
}

abstract class ITarget extends IFileInfo<XTarget> with ITeam {
  //会话
  late ISession session;
  //用户资源
  late DataResource resource;
  //用户设立的身份（角色）
  late List<IIdentity> identitys;
  //子用户
  List<ITarget> get subTarget;
  //所有相关用户
  List<ITarget> get targets;
  //用户相关的所有会话
  @override
  List<ISession> get chats;
  //成员目录
  late IDirectory memberDirectory;
  //退出用户群
  Future<bool> exit();
  //加载用户设立的身份（角色）对象
  Future<List<IIdentity>> loadIdentitys({bool reload = false});
  //为用户设立身份
  Future<IIdentity?> createIdentity(IdentityModel data);
  //发送身份变更通知
  Future<bool> sendIdentityChangeMsg(dynamic data);
}

///用户基类实现
abstract class Target extends Team implements ITarget {
  @override
  late IPerson user;
  @override
  late IBelong space;
  @override
  late ISession session;
  @override
  late IDirectory directory;
  @override
  late DataResource resource;
  //继承了IFileInfo
  // late List<XCache> cache;
  @override
  late bool isContainer;
  @override
  late List<IIdentity> identitys = [];
  @override
  late IDirectory memberDirectory;
  //暂存
  final bool _identityLoaded = false;

  Target(List<String> _keys, XTarget _metadata, List<String> _relations,
      {IBelong? space, IPerson? user, List<TargetType>? memberTypes})
      : super(_keys, _metadata, _relations) {
    if (space != null) {
      this.space = space;
    } else {
      this.space = this as IBelong;
    }
    if (user != null) {
      this.user = user;
    } else {
      this.user = this as IPerson;
    }
    cache = XCache(fullId: '${_metadata.belongId}_${_metadata.id}');
    resource = DataResource(_metadata, _relations, [key]);
    directory = Directory(
      {
        ..._metadata.toJson(),
        'shareId': _metadata.id,
        'id': '${_metadata.id}_',
        'typeName': '目录',
      } as XDirectory,
      this,
      this as IDirectory,
    );
    memberDirectory = Directory(
      {
        ...directory.metadata.toJson(),
        'typeName': '成员目录',
        'id': '${_metadata.id}__',
        'name': _metadata.typeName == TargetType.person.label
            ? '我的好友'
            : '${_metadata.typeName}成员',
      } as XDirectory,
      this,
      this as IDirectory,
      parent: directory,
    );
    isContainer = true;
    session = Session(id, this, _metadata);
    Future.delayed(
      Duration(milliseconds: id == userId ? 100 : 0),
      () async {
        await loadUserData(_keys, _metadata);
      },
    );
  }

  @override
  String get spaceId {
    return space.id;
  }

  @override
  String get locationKey {
    return id;
  }

  String get cachePath {
    return 'targets.${cache.fullId}';
  }

  Future<void> loadUserData(List<String> keys, XTarget metadata) async {
    kernel.subscribe(
      '${metadata.belongId}-${metadata.id}-identity',
      keys,
      (dynamic data) => _receiveIdentity(data),
    );
    final data = await user.cacheObj.get<XCache>(cachePath);
    if (data != null && data.fullId == cache.fullId) {
      cache = data;
    }
    user.cacheObj.subscribe(cachePath, (XCache data) {
      if (data.fullId == cache.fullId) {
        cache = data;
        user.cacheObj.setValue(cachePath, data);
        directory.changCallback();
      }
    });
  }

  @override
  Future<bool> cacheUserData({bool? notify = true}) async {
    var success = await user.cacheObj.set(cachePath, cache);
    if (success && notify!) {
      await user.cacheObj
          .notity(cachePath, cache, onlyTarget: true, ignoreSelf: true);
    }
    return success;
  }

  @override
  Future<List<IIdentity>> loadIdentitys({bool reload = false}) async {
    if (identitys.isEmpty || reload) {
      var res = await kernel.queryTargetIdentitys(IDBelongReq(
          id: metadata.id,
          page: PageRequest(offset: 0, limit: 9999, filter: '')));
      identitys.clear();
      if (res.success && res.data?.result != null) {
        for (var element in res.data!.result!) {
          identitys.add(Identity(space, element));
        }
      }
    }
    return identitys;
  }

  @override
  Future<IIdentity?> createIdentity(IdentityModel data) async {
    data.shareId = metadata.id;
    var res = await kernel.createIdentity(data);
    if (res.success && res.data?.id != null) {
      var identity = Identity(space, res.data!);
      identitys.add(identity);
      return identity;
    }
    return null;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    var operates = super.operates(); ////
    if (session.isMyChat) {
      operates.insert(0, TargetOperates.chat as OperateModel);
    }
    if (members.any((i) => i.id == userId)) {
      //operates.insert(0,MemberOperates.exit as OperateModel);
    }
    return operates;
  }

  Future<bool> pullSubTarget(ITeam team) async {
    var res = await kernel
        .pullAnyToTeam(GiveModel(id: metadata.id, subIds: [team.metadata.id]));
    if (res.success) {
      await sendTargetNotity(OperateType.add, sub: team.metadata);
    }
    return res.success;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await Future.wait([
      super.loadContent(reload: reload),
      loadIdentitys(reload: reload),
    ]);
    return true;
  }

  @override
  Future<bool> rename(String name) async {
    return update(TargetModel(
      id: metadata.id,
      name: name,
      code: metadata.code,
      typeName: metadata.typeName!,
      icon: metadata.icon,
      belongId: metadata.belongId,
      remark: metadata.remark,
      teamCode: metadata.team?.code ?? code,
      teamName: metadata.team?.name ?? this.name,
      public: metadata.public,
    ));
  }
  //暂不支持
  // @override
  // bool copy(IDirectory _destination){
  //   throw Error();
  // }

  //暂不支持
  // @override
  // bool move(IDirectory _destination){
  //   throw Error();
  // }

  @override
  Future<ITeam?> createTarget(TargetModel data) async {
    return null;
  }

  @override
  Future<void> notifySession(bool pull, List<XTarget> member) async {
    if (id != userId) {
      for (var member in members) {
        if (member.typeName == TargetType.person) {
          if (pull) {
            await session.sendMessage(
              MessageType.notify,
              '${user.name} 邀请 ${member.name} 加入群聊',
              [],
            );
          } else {
            await session.sendMessage(
              MessageType.notify,
              '${user.name} 将 ${member.name} 移出群聊',
              [],
            );
          }
        }
      }
    }
  }

  @override
  Future<bool> sendIdentityChangeMsg(dynamic data) async {
    var res = await kernel.dataNotify(DataNotityType(
      data: data,
      targetId: metadata.id,
      ignoreSelf: true,
      flag: 'identity',
      relations: relations,
      belongId: belongId,
      onlyTarget: false,
      onlineOnly: false,
      subTargetId: null,
    ));
    return res.success;
  }

  Future _receiveIdentity(IdentityOperateModel data) async {
    var message = '';
    switch (data.operate) {
      case '创建':
        message = '${data.operater?.name}新增身份【${data.identity?.name}】.';
        if (identitys.every((q) => q.id != data.identity?.id)) {
          identitys.add(Identity(data.identity as ITarget, this as XIdentity));
        }
        break;
      case '删除':
        message = '${data.operater?.name}将身份【${data.identity?.name}】删除.';
        for (var i in identitys) {
          if (i.id == data.identity?.id) {
            await i.delete(notity: true);
          }
        }
        break;
      case '更新':
        message = '${data.operater?.name}将身份【${data.identity?.name}】信息更新.';
        updateMetadata<XIdentity>(data.identity!);
        break;
      case '移除':
        if (data.subTarget != null) {
          message =
              '${data.operater?.name}移除赋予【${data.subTarget!.name}】的身份【${data.identity?.name}】.';
          for (var i in identitys) {
            if (i.id == data.identity?.id) {
              await i.removeMembers([data.subTarget!], notity: true);
            }
          }
        }
        break;
      case '新增':
        if (data.subTarget != null) {
          message =
              '${data.operater?.name}赋予{${data.subTarget!.name}身份【${data.identity?.name}】.';
          for (var i in identitys) {
            if (i.id == data.identity?.id) {
              await i.pullMembers([data.subTarget!], notity: true);
            }
          }
        }
        break;
    }
    //日志
    // if (message.isNotEmpty) {
    //   if (data.operater?.id != user.id) {
    //     logger.info(message);
    //   }
    //   directory.structCallback();
    // }
  }
}
