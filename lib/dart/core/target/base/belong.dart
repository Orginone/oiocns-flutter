import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/chatmsg.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/public/operates.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/main.dart';

import 'target.dart';

abstract class IBelong extends ITarget {
  //超管权限，权限为树结构
  IAuthority? superAuth;
  //加入/管理的群
  late List<ICohort> cohorts;
  //存储资源群
  List<IStorage> storages;
  //上级用户
  List<ITarget> get parentTarget;
  //群会话
  List<IMsgChat> get cohortChats;
  //共享组织
  List<ITarget> get shareTarget;
  //加载超管权限
  Future<IAuthority?> loadSuperAuth({bool reload = false});
  //申请加用户
  Future<bool> applyJoin(List<XTarget> members);
  //设立人员群
  Future<ICohort?> createCohort(TargetModel data);
  //发送职权变更消息
  Future<bool> sendAuthorityChangeMsg(
    String operate,
    XAuthority authority,
  );

  // ///下面属于原代码的变量，新的ts内核中不存在
  // //当前用户
  // late IPerson user;

  // //归属的消息
  // late IChatMessage message;

  // //加载群
  // Future<List<ICohort>> loadCohorts({bool reload = false});
}

//自归属用户基类实现
abstract class Belong extends Target implements IBelong {
  @override
  IBelong space;
  @override
  late List<ICohort> cohorts;

  List<IStorage> storages;

  @override
  IAuthority? superAuth;

  Belong(super.metadata, super.relations, super.memberTypes, [super._user]) {
    memberTypes = [TargetType.person];
    this.user = user ?? this as IPerson;
    space = this;
    kernel.subscribed('${metadata.belongId}-${metadata.id}-authority',
        [this.key], (data) => superAuth?.receiveAuthority(data)); ///////
    cohorts = [];
    storages = [];
    // speciesTypes = [SpeciesType.store, SpeciesType.dict];
    // message = ChatMessage(this);
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

  @override
  Future<ICohort?> createCohort(TargetModel data) async {
    data.typeName = TargetType.cohort.label;
    var metadata = await create(data);
    if (metadata != null) {
      metadata.belong = this.metadata;
      var cohort = Cohort(this, metadata);
      if (this.metadata.typeName != TargetType.person.label) {
        if (!(await pullSubTarget(cohort))) {
          return null;
        }
      }
      cohorts.add(cohort);
      await cohort.pullMembers([user.metadata]);
      return cohort;
    }
    return null;
  }

  @override
  void loadMemberChats(List<XTarget> newmembers, bool isAdd) {
    super.loadMemberChats(members, isAdd);
    newmembers = newmembers.filter((i) => i.id != this.userId);
    if(isAdd){
      var labels = id == user.id?['好友']：[name,'同事'];
      newmembers.forEach((i) { 
        if (!this.memberChats.some((a) => a.id === i.id)) {
          this.memberChats.addAll(Session(i.id, this, i, labels));
        }
      });
    }else {
      memberChats = memberChats.filter((i) =>
        newMembers.every((a) => a.id != i.sessionId),
      );
    }
  }

  @override
  Future<bool> loadContent({bool reload = false}) async {
    await super.loadContent(reload: reload);
    await loadSuperAuth(reload: reload);
    return true;
  }

  @override
  List<OperateModel> operates(){
    var operates = super.operates();///////
    if(hasRelationAuth()){
      operates.unshift(targetOperates.newCohort);
    }
    return operates;
  }

  @override
  List<ITarget> get shareTarget;
  @override
  List<ITarget> get parentTarget;
  List<ISession> get cohortChats;/////////
  
  Future<bool> applyJoin(List<XTarget> members);

  Future<bool> sendAuthorityChangeMsg(String operate,XAuthority authority) async{
    var res = await kernel.dataNotify(DataNotityType(
      data: {
        operate,
        authority,
        user.metadata,
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
