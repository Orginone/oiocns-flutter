import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';

abstract class IBelong extends ITarget {
  //超管权限，权限为树结构
  late IAuthority? superAuth;
  //加入/管理的群
  late List<ICohort> cohorts;
  //存储资源群
  late List<IStorage> storages;
  //上级用户
  late List<ITarget> parentTarget;
  //群会话
  late List<ISession> cohortChats;
  //共享组织
  late List<ITarget> shareTarget;

  /// 获取存储占用情况
  Future<DiskInfoType> getDiskInfo();
  //加载超管权限
  Future<IAuthority?> loadSuperAuth({bool reload = false});
  //申请加用户
  Future<bool> applyJoin(List<XTarget> members);
  //设立人员群
  Future<ICohort?> createCohort(TargetModel data);
  //发送职权变更消息
  Future<bool> sendAuthorityChangeMsg(String operate, XAuthority authority);
}

//自归属用户基类实现
abstract class Belong extends Target implements IBelong {
  ///构造函数
  Belong(
    this.metadata,
    this.relations, {
    this.user,
    this.memberTypes = mTypes,
  }) : super([], metadata, relations,
            space: null, user: user, memberTypes: memberTypes) {
    memberTypes = [TargetType.person];

    kernel.subscribe('${metadata.belongId}-${metadata.id}-authority', [key],
        (data) => superAuth?.receiveAuthority(data)); ///////

    // speciesTypes = [SpeciesType.store, SpeciesType.dict];
    // message = ChatMessage(this);
  }

  @override
  final XTarget metadata;
  @override
  final List<String> relations;
  @override
  final IPerson? user;
  @override
  final List<TargetType>? memberTypes;

  @override
  IBelong? space;
  @override
  late List<ICohort> cohorts;

  @override
  late List<IStorage> storages;

  @override
  IAuthority? superAuth;
  @override
  Future<IAuthority?> loadSuperAuth({bool reload = false}) async {
    if (superAuth != null || reload) {
      var res = await kernel.queryAuthorityTree(IdPageModel(
        id: metadata.id,
        page: pageAll,
      ));
      if (res.success) {
        superAuth = Authority(res.data as XAuthority, this);
      }
    }
    return superAuth;
  }

  @override
  Future<ICohort?> createCohort(TargetModel data) async {
    data.typeName = TargetType.cohort.label;
    var metadata = await create(data);
    if (metadata != null) {
      metadata.belong = this.metadata;
      var cohort = Cohort(metadata, this, metadata.belongId ?? '');
      if (this.metadata.typeName != TargetType.person.label) {
        if (!(await pullSubTarget(cohort))) {
          return null;
        }
      }
      cohorts.add(cohort);
      await cohort.pullMembers([user!.metadata]);
      return cohort;
    }
    return null;
  }

  @override
  Future<DiskInfoType> getDiskInfo() async {
    final data = await kernel.diskInfo(id, relations);
    return data.data!;
  }

  @override
  void loadMemberChats(List<XTarget> newmembers, bool isAdd) {
    super.loadMemberChats(members, isAdd);
    newmembers = newmembers.where((i) => i.id != userId).toList();
    if (isAdd) {
      var labels = id == user?.id ? ['好友'] : [name, '同事'];
      for (var i in newmembers) {
        if (!memberChats.any((a) => a.id == i.id)) {
          memberChats.add(Session(i.id, this, i, tags: labels));
        }
      }
    } else {
      memberChats = memberChats
          .where(
            (i) => newmembers.every((a) => a.id != i.sessionId),
          )
          .toList();
    }
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await super.loadContent(reload: reload);
    await loadSuperAuth(reload: reload);
    return true;
  }

  @override
  List<OperateModel> operates({int? mode}) {
    var operates = super.operates(); ///////
    if (hasRelationAuth()) {
      operates.insert(
        0,
        OperateModel.fromJson(TargetOperates.newCohort.toJson()),
      );
    }
    return operates;
  }

  @override
  List<ITarget> get shareTarget;

  @override
  List<ISession> get cohortChats; /////////
  @override
  List<ITarget> get parentTarget;
  @override
  Future<bool> applyJoin(List<XTarget> members);

  @override
  Future<bool> sendAuthorityChangeMsg(
      String operate, XAuthority authority) async {
    var res = await kernel.dataNotify(DataNotityType(
      data: {
        operate,
        authority,
        user?.metadata,
      },
      flag: 'authority',
      onlineOnly: true,
      belongId: metadata.belongId!,
      relations: relations,
      onlyTarget: true,
      ignoreSelf: true,
      targetId: metadata.id,
    ));
    return res.success;
  }
}
