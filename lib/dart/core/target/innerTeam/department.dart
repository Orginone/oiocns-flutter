import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/main_base.dart';
import '../../../base/common/uint.dart';

/// 单位内部机构（部门）接口
abstract class IDepartment implements ITarget {
  /// 父级部门
  IDepartment? parent;

  /// 子级部门
  late List<IDepartment> children;

  /// 支持的子机构类型
  late List<String> childrenTypes;

  /// 加载子部门
  Future<List<IDepartment>> loadChildren({bool? reload});

  /// 设立内部机构
  Future<IDepartment?> createDepartment(TargetModel data);
}

///
class Department extends Target implements IDepartment {
  ///构造函数
  Department(
    this.keys,
    this.metadata,
    this.company, {
    this.parent,
  }) : super(keys, metadata, [company.id], space: company, user: company.user) {
    keys = [...keys, key];
    switch (TargetType.getType(metadata.typeName!)) {
      case TargetType.college:
        childrenTypes = [
          TargetType.major.label,
          TargetType.office.label,
          TargetType.working.label,
          TargetType.research.label,
          TargetType.laboratory.label,
        ];
        break;
      case TargetType.section:
      case TargetType.department:
        childrenTypes = [
          TargetType.office.label,
          TargetType.working.label,
          TargetType.research.label,
          TargetType.laboratory.label,
        ];
        break;
      case TargetType.major:
      case TargetType.research:
      case TargetType.laboratory:
        childrenTypes = [TargetType.working.label];
        break;
      default:
        childrenTypes = [];
        break;
    }
  }
  @override
  List<String> keys;
  @override
  final XTarget metadata;
  final ICompany company;
  @override
  final IDepartment? parent;
  @override
  List<IDepartment> children = [];

  @override
  List<String> childrenTypes = [];

  bool _childrenLoaded = false;
  @override
  Future<List<IDepartment>> loadChildren({bool? reload = false}) async {
    if (childrenTypes.isNotEmpty && (_childrenLoaded || reload!)) {
      var res = await kernel.querySubTargetById(GetSubsModel(
        id: metadata.id,
        subTypeNames: childrenTypes,
        page: PageModel(offset: 0, limit: Constants.maxUint16, filter: ''),
      ));
      if (res.success) {
        _childrenLoaded = true;
        children = (res.data?.result ?? [])
            .map(
              (i) => Department(keys, i, company, parent: this),
            )
            .toList();
      }
    }
    return children;
  }

  @override
  Future<IDepartment?> createDepartment(TargetModel data) async {
    if (!childrenTypes.contains(data.typeName)) {
      data.typeName = TargetType.working.label;
    }
    data.public = false;
    var metadata = await create(data);
    if (metadata != null) {
      var department = Department(keys, metadata, company, parent: this);
      await department.deepLoad();
      if (await pullSubTarget(department)) {
        children.add(department);
        return department;
      }
    }
    return null;
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) async {
    return createDepartment(data);
  }

  @override
  Future<bool> exit() async {
    if (await removeMembers(user?.metadata != null ? [user!.metadata] : [])) {
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
  Future<bool> delete({bool? notity = false}) async {
    var success = await super.delete(notity: notity);
    if (success) {
      if (parent != null) {
        parent!.children.removeWhere((i) => i == this);
      } else {
        company.departments.removeWhere((i) => i == this);
      }
    }
    return success;
  }

  @override
  List<ITarget> get subTarget => children;
  @override
  List<ISession> get chats {
    return targets.map((e) => e.session).toList();
  }

  @override
  List<ITarget> get targets {
    List<ITarget> targets = [this];
    for (var item in children) {
      targets.addAll(item.targets);
    }
    return targets;
  }

  List<IFile> contents() {
    return [...children.map((e) => e as IFile)];
  }

  @override
  Future<void> deepLoad({bool? reload = false}) async {
    await Future.wait([
      loadChildren(reload: reload),
      loadMembers(reload: reload),
      directory.loadDirectoryResource(reload: reload),
    ]);

    for (var department in children) {
      await department.deepLoad(reload: reload);
    }
  }

  @override
  List<OperateModel> operates({int? mode}) {
    var operates = super.operates();
    if (hasRelationAuth()) {
      operates.insert(
          0, OperateModel.fromJson(TargetOperates.newDepartment.toJson()));
    }
    return operates;
  }

  Future<String> _addSubTarget(XTarget target) async {
    if (childrenTypes.contains((target.typeName!))) {
      if (children.every((element) => element.id != target.id)) {
        var department = Department(keys, target, company, parent: this);
        await department.deepLoad();
        children.add(department);
        return '$name创建了${target.name}.';
      }
    }
    return '';
  }

  @override
  // TODO: implement locationKey
  String get locationKey => '';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
