import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/identity/identity.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main.dart';

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

abstract class ITarget extends ITeam {
  //用户设立的身份
  late List<IIdentity> identitys;

  //支持的类别类型
  late List<SpeciesType> speciesTypes;

  List<ITarget> get subTarget;

  /** 所有相关用户 */
  List<ITarget> get targets;

  //退出用户群
  Future<bool> exit();

  //加载用户设立的身份(角色)对象
  Future<List<IIdentity>> loadIdentitys({bool reload = false});

  //为用户设立身份
  Future<IIdentity?> createIdentity(IdentityModel data);

}

abstract class Target extends Team implements ITarget {

  @override
  late List<IIdentity> identitys;

  @override
  late List<SpeciesType> speciesTypes;

  @override
  List<ITarget> get subTarget;

  Target(super.metadata, super.labels,{super.space}) {
    speciesTypes = [SpeciesType.application, SpeciesType.resource];
    memberTypes = [TargetType.person];
    identitys = [];
    var xDirectory = XDirectory.fromJson(metadata.toJson());
    xDirectory.shareId = metadata.id!;
    xDirectory.id = "${metadata.id!}_";
    directory =  Directory(xDirectory,
      this,
    );
  }

  @override
  Future<ITeam?> createTarget(TargetModel data) async{
   return null;
  }

  @override
  Future<IIdentity?> createIdentity(IdentityModel data) async {
    data.shareId = metadata.id;
    var res = await kernel.createIdentity(data);
    if (res.success && res.data?.id != null) {
      var identity = Identity(space,res.data!);
      identitys.add(identity);
      return identity;
    }
    return null;
  }

  Future<bool> pullSubTarget(ITeam team) async {
    var res = await kernel
        .pullAnyToTeam(GiveModel(id: metadata.id!, subIds: [team.metadata.id!]));
    return res.success;
  }



  @override
  Future<List<IIdentity>> loadIdentitys({bool reload = false}) async {
    if (identitys.isEmpty || reload) {
      var res = await kernel.queryTargetIdentitys(IDBelongReq(
          id: metadata.id!,
          page: PageRequest(offset: 0, limit: 9999, filter: '')));
      if (res.success && res.data?.result != null) {
        for (var element in res.data!.result!) {
          identitys.add(Identity(space,element));
        }
      }
    }
    return identitys;
  }

  @override
  Future<bool> loadContent({bool reload = false}) async{
    await super.loadContent(reload: reload);
    await loadIdentitys(reload: reload);
    return true;
  }

  @override
  // TODO: implement directory
  late IDirectory directory;

}
