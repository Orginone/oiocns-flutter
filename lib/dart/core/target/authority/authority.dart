import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/main.dart';

abstract class IAuthority implements IMsgChat {
  /// 数据实体
  late XAuthority metadata;

  /// 拥有该权限的成员
  late List<XTarget> targets;

  /// 加载权限的自归属用户
  late IBelong space;

  /// 父级权限
  IAuthority? parent;

  /// 子级权限
  late List<IAuthority> children;

  /// 用户相关的所有会话
  List<IMsgChat> get chats;

  /// 深加载
  Future<void> deepLoad({bool reload = false});

  /// 创建权限
  Future<IAuthority?> create(AuthorityModel data);

  /// 更新权限
  Future<bool> update(AuthorityModel data);

  /// 删除权限
  Future<bool> delete();

  /// 根据权限id查找权限实例
  IAuthority? findAuthById(String authId, {IAuthority? auth});

  /// 根据权限获取所有父级权限Id
  List<String> loadParentAuthIds(List<String> authIds);

  /// 判断是否拥有某些权限
  bool hasAuthoritys(List<String> authIds);
}

class Authority extends MsgChat implements IAuthority {
  @override
  late List<IAuthority> children;

  @override
  late XAuthority metadata;

  @override
  IAuthority? parent;

  @override
  late IBelong space;

  @override
  late List<XTarget> targets;

  Authority(this.metadata, this.space, [this.parent])
      : super(
          space.belong,
          metadata.id ?? "",
          ShareIcon(
            name: metadata.name ?? "",
            typeName: '权限',
            avatar: FileItemShare.parseAvatar(metadata.icon),
          ),
          [space.metadata.name, '角色群'],
          metadata.remark ?? "",
          space,
        ) {
    targets = [];
    children = [];
    for (var node in metadata.nodes ?? []) {
      children.add(Authority(node, space, this));
    }
  }

  @override
  Future<IAuthority?> create(AuthorityModel data) async {
    data.parentId = metadata.id;
    final res = await kernel.createAuthority(data);
    if (res.success && res.data?.id != null) {
      final authority = Authority(res.data!, space, this);
      children.add(authority);
      return authority;
    }
    return null;
  }

  @override
  Future<void> deepLoad({bool reload = false}) async {
    await loadMembers(reload: reload);
    for (final item in children) {
      await item.deepLoad(reload: reload);
    }
  }

  @override
  IAuthority? findAuthById(String authId, {IAuthority? auth}) {
    auth = auth ?? space.superAuth;
    if (auth?.metadata.id == authId) {
      return auth;
    } else {
      for (final item in auth?.children ?? []) {
        final find = findAuthById(authId, auth: item);
        if (find != null) {
          return find;
        }
      }
    }
    return null;
  }

  @override
  bool hasAuthoritys(List<String> authIds) {
    var ids = loadParentAuthIds(authIds);
    final orgIds = [metadata.belongId ?? ""];
    if (metadata.shareId != null && metadata.shareId != null) {
      orgIds.add(metadata.shareId!);
    }
    return space.user.authenticate(orgIds, ids);
  }

  @override
  Future<List<XTarget>> loadMembers({bool reload = false}) async {
    if (targets.isEmpty || reload) {
      final res = await kernel.queryAuthorityTargets(GainModel(
        id: metadata.id!,
        subId: space.metadata.belongId,
      ));
      if (res.success) {
        targets = res.data?.result ?? [];
      }
    }
    return targets;
  }

  @override
  List<String> loadParentAuthIds(List<String> authIds) {
    final result = <String>[];
    for (final authId in authIds) {
      final auth = findAuthById(authId);
      if (auth != null) {
        _appendParentId(auth, result);
      }
    }
    return result;
  }

  void _appendParentId(IAuthority auth, List<String> authIds) {
    if (!authIds.contains(auth.metadata.id)) {
      authIds.add(auth.metadata.id!);
    }
    if (auth.parent != null) {
      _appendParentId(auth.parent!, authIds);
    }
  }

  @override
  Future<bool> update(AuthorityModel data) async {
    data.id = metadata.id;
    data.shareId = metadata.shareId;
    data.parentId = metadata.parentId;
    data.name = data.name ?? metadata.name;
    data.code = data.code ?? metadata.code;
    data.icon = data.icon ?? metadata.icon;
    data.remark = data.remark ?? metadata.remark;
    final res = await kernel.updateAuthority(data);
    if (res.success && res.data?.id != null) {
      metadata = res.data!;
      share = ShareIcon(
        name: metadata.name ?? "",
        typeName: '权限',
        avatar: FileItemShare.parseAvatar(metadata.icon),
      );
    }
    return res.success;
  }

  @override
  Future<bool> delete() async {
    final res = await kernel.deleteAuthority(IdReq(id: metadata.id!));
    if (res.success && parent != null) {
      parent!.children.removeWhere((i) => i != this);
    }
    return res.success;
  }

  @override
  List<IMsgChat> get chats {
    final chats = <IMsgChat>[this];
    for (final item in children) {
      chats.addAll(item.chats);
    }
    return chats;
  }
}
