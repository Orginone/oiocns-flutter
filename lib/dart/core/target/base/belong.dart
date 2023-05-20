import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/message.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/thing/dict/dict.dart';
import 'package:orginone/dart/core/thing/dict/dictclass.dart';
import 'package:orginone/dart/core/thing/filesys/filesysItem.dart';
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

  late IFileSystem fileSystem;

  //上级用户
  List<ITarget> get parentTarget;

  //群会话
  List<IMsgChat> get cohortChats;

  //加载群
  Future<List<ICohort>> loadCohorts({bool reload = false});

  //加载超管权限
  Future<IAuthority?> loadSuperAuth({bool reload = false});

  //加载字典
  Future<List<IDict>> loadDicts();

  //申请加用户
  Future<bool> applyJoin(List<XTarget> members);

  //设立人员群
  Future<ICohort?> createCohort(TargetModel data);
}

abstract class Belong extends Target implements IBelong {
  Belong(super.metadata, super.labels, [IPerson? user]) {
    memberTypes = [TargetType.person];
    this.user = user ?? this as IPerson;
    dicts = [];
    cohorts = [];
    speciesTypes = [SpeciesType.store, SpeciesType.dict];
    message = ChatMessage(this);
    fileSystem = FileSystem(this);
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
  late IFileSystem fileSystem;

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
  Future<List<IDict>> loadDicts() async {
    for (var specie in species) {
      if (specie.metadata.typeName == SpeciesType.dict.label) {
        var subDicts = await (specie as IDictClass).loadAllDicts();
        for (var item in subDicts) {
          if (dicts.indexWhere(
                  (element) => element.metadata.id == item.metadata.id) <
              0) {
            dicts.add(item);
          }
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
