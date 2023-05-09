import '../../base/model.dart';
import '../../base/schema.dart';
import '../enum.dart';
import 'base.dart';
import 'itarget.dart';

class Group extends BaseTarget implements IGroup {
  @override
  late List<IGroup> subGroup;
  final Function _onDeleted;
  Group(XTarget target, ISpace? space, String userId, this._onDeleted)
      : super(target, space, userId) {
    subGroup = [];
    memberTypes = companyTypes;
    subTeamTypes = [TargetType.group];
    joinTargetType = [TargetType.group];
    createTargetType = [TargetType.group];
    searchTargetType = [...companyTypes, TargetType.group];
  }

  @override
  List<ITarget> get subTeam {
    return subGroup;
  }

  @override
  Future<List<ITarget>> loadSubTeam({bool reload = false}) async {
    await getSubGroups(reload: reload);
    return subGroup;
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    switch (data.typeName as TargetType) {
      case TargetType.group:
        return createSubGroup(data);
      default:
        return null;
    }
  }

  @override
  Future<bool> delete() async {
    final res = await deleteTarget();
    if (res.success) {
      _onDeleted(this, []);
    }
    return res.success;
  }

  @override
  Future<bool> applyJoinGroup(String id) async {
    return await super.applyJoin(id, TargetType.group);
  }

  @override
  Future<IGroup?> createSubGroup(TargetModel data) async {
    final tres = await searchTargetByName(data.code, [TargetType.group]);
    if (tres.result == null) {
      data.belongId = target.id;
      final res = await createTarget(data);
      if (res.success) {
        final group = Group(
            res.data!,
            space,
            userId,
            () => {
                  subGroup =
                      subGroup.where((item) => item.id != res.data!.id).toList()
                });
        subGroup.add(group);
        await pullSubTeam(group.target);
        return group;
      }
    } else {
      // logger.warn("该集团已存在");
    }
    return null;
  }

  @override
  Future<bool> deleteSubGroup(String id) async {
    final group = subGroup.firstWhere((group) => group.target.id == id);
    if (group.id != '') {
      final res = await kernel.recursiveDeleteTarget(RecursiveReqModel(
        id: id,
        typeName: TargetType.group.name,
        subNodeTypeNames: [TargetType.group.name],
      ));
      if (res.success) {
        subGroup = subGroup.where((group) => group.target.id != id).toList();
        return true;
      }
    }
    return false;
  }

  @override
  Future<List<IGroup>> getSubGroups({bool reload = false}) async {
    if (!reload && subGroup.isNotEmpty) {
      return subGroup;
    }
    final res = await getSubTargets([TargetType.group]);
    if (res.success && res.data?.result != null) {
      subGroup = res.data!.result
              ?.map((a) => Group(
                  a,
                  space,
                  userId,
                  () => {
                        subGroup =
                            subGroup.where((item) => item.id != a.id).toList()
                      }))
              .toList() ??
          [];
    }
    return subGroup;
  }

  @override
  Future<void> deepLoad({bool reload = false}) async {
    await loadSubTeam(reload: reload);
    for (var item in subGroup) {
      await item.deepLoad(reload: reload);
    }
  }
}
