import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/main.dart';

/// 单位群接口
abstract class IGroup implements ITarget {
  /// 父级单位群
  IGroup? parent;

  /// 子单位群
  List<IGroup> children = [];

  /// 加载子单位群
  Future<List<IGroup>> loadChildren({bool reload = false});

  /// 设立子单位群
  Future<IGroup?> createChildren(TargetModel data);
}

class Group extends Target implements IGroup {
  ///构造函数
  Group(
    this.keys,
    this.metadata,
    this.relations,
    this.company, {
    this.parent,
  }) : super(
          keys,
          metadata,
          [...relations, metadata.id],
          space: company,
          user: company.user,
          memberTypes: [
            TargetType.company,
            TargetType.hospital,
            TargetType.university,
          ],
        ) {
    keys = [...keys, key];
    relations = [...relations, metadata.id];
  }

  @override
  List<String> keys = [];
  @override
  XTarget metadata;
  @override
  List<String> relations = [];
  ICompany company;

  @override
  late IBelong? space;

  @override
  List<IGroup> children = [];
  @override
  IGroup? parent;

  bool _childrenLoaded = false;

  @override
  Future<List<IGroup>> loadChildren({bool reload = false}) async {
    if (!_childrenLoaded || reload == true) {
      final res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: [TargetType.group.label],
        page: pageAll,
      ));
      if (res.success) {
        _childrenLoaded = true;
        children = (res.data?.result ?? [])
            .map((i) => Group(keys, i, relations, company, parent: this))
            .toList();
      }
    }
    return children;
  }

  @override
  Future<IGroup?> createChildren(TargetModel data) async {
    data.typeName = TargetType.group.label;
    final metadata = await create(data);
    if (metadata != null) {
      final group = Group(keys, metadata, relations, company, parent: this);
      children.add(group);
      return group;
    }
    return null;
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) async {
    return await createChildren(data);
  }

  @override
  Future<bool> exit() async {
    if (metadata.belongId != company.metadata.id) {
      if (await removeMembers([company.metadata])) {
        if (parent != null) {
          parent!.children.removeWhere((i) => i != this);
        } else {
          company.groups.removeWhere((i) => i != this);
        }
        return true;
      }
    }
    return false;
  }

  @override
  Future<bool> delete({bool? notity}) async {
    final success = await super.delete(notity: notity);

    if (success) {
      if (parent != null) {
        parent?.children =
            parent?.children.where((i) => i.key != key).toList() ?? [];
      } else {
        company.groups = company.groups.where((i) => i.key != key).toList();
      }
    }
    return success;
  }

  @override
  List<ITarget> get subTarget => children;
  @override
  List<ISession> get chats {
    List<ISession> chats = [];
    for (final item in children) {
      chats.addAll(item.chats);
    }
    return chats;
  }

  @override
  List<ITarget> get targets {
    List<ITarget> targets = [this];
    for (var item in children) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  List<ITarget> content({int? mode}) {
    return [...children];
  }

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await Future.wait([
      loadChildren(reload: reload!),
      loadMembers(reload: reload),
      directory.loadDirectoryResource(reload: reload),
    ]);
    for (var group in children) {
      await group.deepLoad(
        reload: reload,
      );
    }
  }

  @override
  List<OperateModel> operates({int? mode}) {
    final operates = super.operates();
    if (hasRelationAuth()) {
      operates.insert(
          0, OperateModel.fromJson(TargetOperates.newGroup.toJson()));
    }
    return operates;
  }

  Future _addSubTarget(XTarget target) async {
    switch (TargetType.getType(target.typeName!)) {
      case TargetType.group:
        if (children.every((i) => i.id != target.id)) {
          final group = Group(keys, target, relations, company, parent: this);
          await group.deepLoad();
          children.add(group);
          return '$name创建了${target.name}.';
        }
        break;

      default:
    }
    return '';
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
