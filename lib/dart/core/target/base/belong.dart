import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/msgchat.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/dict/dict.dart';
import 'package:orginone/main.dart';

import 'target.dart';

abstract class IBelong extends ITarget {
  //当前用户
  late IPerson user;

  //归属的消息
  late IChatMessage message;

  //超管权限，权限为树结构
  IAuthority? superAuth;

  //元数据字典
  late List<IDict> dicts;

  //加入/管理的群
  late List<ICohort> cohorts;

  //上级用户
  List<ITarget> get parentTarget;

  //群会话
  List<IChat> get cohortChats;

  //加载群
  Future<List<ICohort>> loadCohorts({bool reload = false});

  //加载超管权限
  Future<IAuthority?> loadSuperAuth({bool reload = false});

  //加载元数据字典
  Future<List<IDict>> loadDicts({bool reload = false});

  //申请加用户
  Future<bool> applyJoin(List<XTarget> members);

  //添加字典
  Future<IDict?> createDict(DictModel data);

  //设立人员群
  Future<ICohort?> createCohort(TargetModel data);
}

abstract class Belong extends Target implements IBelong {
  Belong(super.metadata, super.labels, [IPerson? user]) {
    memberTypes = [TargetType.person];
    this.user = user ?? this as IPerson;
    dicts = [];
    cohorts = [];
    speciesTypes = [SpeciesType.store];
    message = ChatMessage(this);
  }

  @override
  late List<ICohort> cohorts;

  @override
  late List<IDict> dicts;

  @override
  late IChatMessage message;

  @override
  IAuthority? superAuth;

  @override
  late IPerson user;

  @override
  Future<ICohort?> createCohort(TargetModel data) async {
    data.typeName = TargetType.cohort.label;
    var metadata = await create(data);
    if (metadata != null) {
      var cohort = Cohort(this,metadata);
      if (this.metadata.typeName != TargetType.person.label) {
        if (!(await pullSubTarget(cohort))) {
          return null;
        }
      }
      cohorts.add(cohort);
      await cohort.pullMembers([user.metadata]);
      return cohort;
    }
  }

  @override
  Future<IDict?> createDict(DictModel data) async {
    data.belongId = metadata.id;
    var res = await kernel.createDict(data);
    if (res.success && res.data != null) {
      var dict = Dict(res.data!, this);
      dicts.add(dict);
      return dict;
    }
  }


  @override
  Future<List<IDict>> loadDicts({bool reload = false}) async {
    if (dicts.isEmpty || reload) {
      var res = await kernel.queryDicts(IdReq(
        id: metadata.id,
      ));
      if (res.success && res.data?.result != null) {
        for (var element in res.data!.result!) {
          dicts.add(Dict(element, this));
        }
      }
    }
    return dicts;
  }

  @override
  Future<IAuthority?> loadSuperAuth({bool reload = false}) async {
    if (superAuth == null || reload) {
      var res = await kernel.queryAuthorityTree(IdReq(id: metadata.id));
      if (res.success && res.data?.id != null) {
        superAuth = Authority(res.data!, this);
      }
    }
    return superAuth;
  }

}