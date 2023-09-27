import 'package:flutter/cupertino.dart';
import 'package:flutter/src/material/popup_menu.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main.dart';

/// 单位内部机构（部门）接口
abstract class IDepartment implements ITarget {
  /// 设立部门的单位
  late ICompany company;

  /// 父级部门
  IDepartment? parent;

  /// 子级部门
  late List<IDepartment> children;

  /// 支持的子机构类型
  late List<TargetType> childrenTypes;

  /// 加载子部门
  Future<List<IDepartment>> loadChildren({bool reload = false});

  /// 设立内部机构
  Future<IDepartment?> createDepartment(TargetModel data);
}

class Department extends Target implements IDepartment {
  @override
  late List<IDepartment> children;

  @override
  late List<TargetType> childrenTypes;

  @override
  late ICompany company;

  @override
  IDepartment? parent;

  Department(XTarget metadata, this.company, [this.parent])
      : super(metadata, [metadata.belong?.name ?? '', '${metadata.typeName}群'],
            space: company) {
    children = [];
    switch (TargetType.getType(metadata.typeName!)) {
      case TargetType.college:
        childrenTypes = [
          TargetType.major,
          TargetType.office,
          TargetType.working,
          TargetType.research,
          TargetType.laboratory,
        ];
        break;
      case TargetType.section:
      case TargetType.department:
        childrenTypes = [
          TargetType.office,
          TargetType.working,
          TargetType.research,
          TargetType.laboratory,
        ];
        break;
      case TargetType.major:
      case TargetType.research:
      case TargetType.laboratory:
        childrenTypes = [TargetType.working];
        break;
      default:
        childrenTypes = [];
        break;
    }
  }

  @override
  // TODO: implement chats
  List<IMsgChat> get chats {
    var chats = <IMsgChat>[this];
    for (var item in children) {
      chats.addAll(item.chats);
    }
    return chats;
  }

  @override
  Future<IDepartment?> createDepartment(TargetModel data) async {
    if (!childrenTypes.contains(TargetType.getType(data.typeName))) {
      data.typeName = TargetType.working.label;
    }
    data.public = false;
    var metadata = await create(data);
    if (metadata != null) {
      metadata.belong = this.metadata;
      var department = Department(metadata, company, this);
      if (await pullSubTarget(department)) {
        children.add(department);
        return department;
      }
    }
    return null;
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) async {
    // TODO: implement createTarget
    return createDepartment(data);
  }

  @override
  Future<void> deepLoad(
      {bool reload = false, bool reloadContent = false}) async {
    await Future.wait([
      loadChildren(reload: reload),
      loadMembers(reload: reload),
      directory.loadContent(reload: reloadContent),
    ]);

    for (var department in children) {
      await department.deepLoad(reload: reload);
    }
  }

  @override
  Future<bool> delete() async {
    var res = await kernel.deleteTarget(IdReq(id: metadata.id));
    if (res.success) {
      if (parent != null) {
        parent!.children.removeWhere((i) => i == this);
      } else {
        company.departments.removeWhere((i) => i == this);
      }
    }
    return res.success;
  }

  @override
  Future<bool> exit() async {
    if (await removeMembers([space.user.metadata])) {
      if (parent != null) {
        parent!.children.removeWhere((i) => i == this);
      } else {
        company.departments.removeWhere((i) => i == this);
      }
      return true;
    }
    return false;
  }

  @override
  Future<List<IDepartment>> loadChildren({bool reload = false}) async {
    if (childrenTypes.isNotEmpty && (children.isEmpty || reload)) {
      var res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: childrenTypes.map((e) => e.label).toList(),
        page: PageRequest(offset: 0, limit: 9999, filter: ''),
      ));
      if (res.success) {
        children = (res.data?.result ?? [])
            .map(
              (i) => Department(i, company, this),
            )
            .toList();
      }
    }
    return children;
  }

  @override
  // TODO: implement subTarget
  List<ITarget> get subTarget => children;

  @override
  // TODO: implement targets
  List<ITarget> get targets {
    List<ITarget> targets = [this];
    for (var item in children) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  @override
  // TODO: implement popupMenuItem
  List<PopupMenuItem> get popupMenuItem {
    List<PopupMenuKey> key = [];
    if (hasRelationAuth()) {
      key.addAll([
        ...createPopupMenuKey,
        PopupMenuKey.createDepartment,
        PopupMenuKey.updateInfo
      ]);
    }
    key.addAll(defaultPopupMenuKey);
    return key
        .map((e) => PopupMenuItem(
              value: e,
              child: Text(e.label),
            ))
        .toList();
  }

  @override
  bool isLoaded = false;

  @override
  Future<bool> teamChangedNotity(XTarget target) async {
    if (childrenTypes.contains(TargetType.getType(target.typeName!))) {
      if (!children.any((i) => i.id == target.id)) {
        final department = Department(target, company);
        await department.deepLoad();
        children.add(department);
        return true;
      }
      return false;
    }
    return await pullMembers([target]);
  }

  @override
  List<IFileInfo<XEntity>> content(int mode) {
    return [];
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';
}
