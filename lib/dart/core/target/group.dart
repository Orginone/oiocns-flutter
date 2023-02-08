import 'package:./base';
import 'package:@/ts/base/schma.dart';
import 'package:./itarget';
import 'package:../enum';
import 'package:@/ts/base/common';
import 'package:@/ts/base/model.dart';


class Group extends BaseTarget implements IGroup{
  IGroup[] subGroup;
  Function _onDeleted;
  Group(XTarget target, Function onDeleted){
    super(target);
    subGroup = null;
    _onDeleted = onDeleted;
    this.memberTypes = companyTypes;
    this.subTeamTypes = [TargetType.Group];
    this.joinTargetType = [TargetType.Group];
    this.createTargetType = [TargetType.Group];
    this.searchTargetType = [...companyTypes, TargetType.Group];
  }
  ITarget[] get getSubTeam{
    return subGroup;
  }
  Future<ITarget[]> loadSubTeam(bool? reload) async{
    await getSubGroups(reload);
    return subGroup;
  }
  //可能有问题
  Future<ITarget?> create(TargetModel data) async{
    switch(data.typeName as TargetType){
      case TargetType.Group:
        return createSubGroup(data);
    }
  }
  Future<bool> delete() async{
    var res = await this.deleteTarget();
    if(res.success){
      _onDeleted?.apply(this, []);
    }
    return res.success;
  }
  Future<bool> applyJoinGroup(String id) async{
    return super.applyJoin(id, TargetType.Group);
  }
  Future<IGroup> createSubGroup(TargetParam data) async{
    var tres = await this.searchTargetByName(data.code, [TargetType.Group]);
    if (!tres.result) {
      var res = await this.createTarget({
        ...data,
        belongId: this.target.belongId,
      });
      if (res.success) {
        var group = Group(res.data, () => {
          subGroup = subGroup.filter((item) => {
              item.id != group.id
          })
        });
        subGroup.push(group);
        await this.pullSubTeam(group.target);
        return group;
      }
    } else {
      //此处如何打印
      //logger.warn('该集团已存在');
      print('该集团已存在');
    }
  }
  Future<bool> deleteSubGroup(String id) async{
    var group = subGroup.find((group) => {
        group.target.id == id
    });
    if (group != null) {
      Future<model.ResultType<boolean>> res = await kernel.recursiveDeleteTarget({
        id: id,
        typeName: TargetType.Group,
        subNodeTypeNames: [TargetType.Group],
      });
      if (res.success) {
        subGroup = subGroup.filter((group) => {
            group.target.id != id
        });
        return true;
      }
    }
    return false;
  }
  Future<IGroup[]> getSubGroups(bool reload) async{
    if (!reload && subGroup.length > 0) {
      return subGroup;
    }
    var res = await this.getSubTargets([TargetType.Group]);
    if (res.success && res.data.result) {
      subGroup = res.data.result.map((a) => {
          Group(a, () => {
            subGroup = subGroup.filter((item) => {
              item.id != a.id
            })
        })
      });
    }
    return subGroup;
  }
}