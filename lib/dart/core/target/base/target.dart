import 'dart:async';

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/consts.dart';
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

abstract class ITarget extends IFileInfo<XTarget> with ITeam {
  //会话
  late ISession session;
  //用户资源
  late DataResource resource;
  //用户设立的身份（角色）
  List<IIdentity> identitys = [];

  //子用户
  List<ITarget> subTarget = [];
  //所有相关用户
  List<ITarget> targets = [];
  //用户相关的所有会话
  List<ISession> chats = [];
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
  Target(List<String> keys, metadata, List<String> relations,
      {space, user, memberTypes = mTypes})
      : super(keys, metadata, relations, memberTypes: memberTypes) {
    if (space != null) {
      this.space = space;
    } else {
      this.space = this as IBelong;
    }
    if (user != null) {
      this.user = user;
    } else {
      this.user = this as IPerson?;
    }
    cache = XCache(fullId: '${metadata.belongId}_${metadata.id}');
    resource = DataResource(metadata, relations, [key]);
    directory = Directory(
      XDirectory.fromJson({
        ...metadata.toJson(),
        'shareId': metadata.id,
        'id': '${metadata.id}_',
        'typeName': '目录',
      }),
      this,
    );
    memberDirectory = Directory(
      XDirectory.fromJson({
        ...directory.metadata.toJson(),
        'typeName': '成员目录',
        'id': '${metadata.id}__',
        'name': metadata.typeName == TargetType.person.label
            ? '我的好友'
            : '${metadata.typeName}成员',
      }),
      this,
      parent: directory,
    );
    isContainer = true;
    session = Session(id, this, metadata);
    Future.delayed(
      Duration(milliseconds: id == userId ? 100 : 0),
      () async {
        await loadUserData(keys, metadata);
      },
    );
  }

  ///构造函数使用的参数
  // @override
  // List<String> keys = [];
  // @override
  // final XTarget metadata;
  // @override
  // List<String> relations = [];
  // @override
  // List<TargetType>? memberTypes = [];
  @override
  late IPerson? user;
  @override
  late IBelong? space;

  ///其他参数
  @override
  late ISession session;
  @override
  late bool isContainer;
  // @override
  // late IDirectory directory;
  @override
  late DataResource resource;

  @override
  late XCache cache;

  @override
  List<IIdentity> identitys = [];
  @override
  late IDirectory memberDirectory;
  //暂存
  final bool _identityLoaded = false;
  @override
  String get spaceId => space?.id ?? '';

  @override
  String get locationKey => id;

  String get cachePath => 'targets.${cache.fullId}';

  Future<void> loadUserData(List<String> keys, XTarget metadata) async {
    kernel.subscribe(
      '${metadata.belongId}-${metadata.id}-identity',
      keys,
      (dynamic data) => _receiveIdentity(data),
    );
    final data = await user?.cacheObj.get<XCache>(cachePath, XCache.fromJson);
    if (data != null && data.fullId == cache.fullId) {
      cache = data;
    }
    user?.cacheObj.subscribe(cachePath, (XCache data) {
      if (data.fullId == cache.fullId) {
        cache = data;
        user?.cacheObj.setValue(cachePath, data);
        directory.changCallback();
      }
    });
  }

  @override
  Future<bool> cacheUserData({bool? notify = true}) async {
    var success = await user?.cacheObj.set(cachePath, cache) ?? false;
    if (success && notify!) {
      await user?.cacheObj
          .notity(cachePath, cache, onlyTarget: true, ignoreSelf: true);
    }
    return success;
  }

  @override
  Future<List<IIdentity>> loadIdentitys({bool reload = false}) async {
    if (identitys.isEmpty || reload) {
      var res = await kernel
          .queryTargetIdentitys(IdPageModel(id: metadata.id, page: pageAll));
      identitys.clear();
      if (res.success && res.data?.result != null) {
        identitys = (res.data?.result ?? [])
            .map((item) => Identity(item, this))
            .toList();
      }
    }
    return identitys;
  }

  @override
  Future<IIdentity?> createIdentity(IdentityModel data) async {
    data.shareId = metadata.id;
    var res = await kernel.createIdentity(data);
    if (res.success && res.data?.id != null) {
      final identity = Identity(res.data!, this);
      identitys.add(identity);
      identity.sendIdentityChangeMsg(OperateType.create, subTarget: metadata);
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

  // @override
  // Future<ITeam?> createTarget(TargetModel data) async {
  //   return null;
  // }

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> notifySession(bool pull, List<XTarget> members) async {
    if (id != userId && typeName != '存储资源') {
      for (var member in members) {
        if (member.typeName == TargetType.person.label) {
          if (pull == true) {
            await session.sendMessage(
              MessageType.notify,
              '${user?.name} 邀请 ${member.name} 加入群聊',
              [],
            );
          } else {
            await session.sendMessage(
              MessageType.notify,
              '${user?.name} 将 ${member.name} 移出群聊',
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
          identitys.add(Identity(data.identity!, this));
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
    if (message.isNotEmpty) {
      if (data.operater?.id != user?.id) {
        // logger.info(message);
      }
      directory.structCallback();
    }
  }
}
