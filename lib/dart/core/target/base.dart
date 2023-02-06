import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/authority/identity.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/species/ispecies.dart';

import '../../base/common/uint.dart';
import '../enum.dart';
import 'itarget.dart';

class BaseTarget extends ITarget {
  late List<String> memberTypes;
  late List<String> createTargetType;

  @override
  String get id {
    return target.id;
  }
  @override
  String get name {
    return target.name;
  }
  @override
  String get teamName {
    return target.team?.name ?? name;
  }

  @override
  List<ITarget> get subTeam {
    return [];
  }

  @override
  TargetShare get shareInfo {
    final TargetShare result = TargetShare(
      name: teamName,
      typeName: typeName,
    );
    // result.avatar = parseAvatar(target.avatar);
    return result;
  }
  KernelApi kernel = KernelApi.getInstance();

  BaseTarget(XTarget target) {
    // key = generateUuid();
    target = target;
    createTargetType = [];
    joinTargetType = [];
    searchTargetType = [];
    ownIdentitys = [];
    identitys = [];
    memberTypes = [];
    typeName = target.typeName;
    // appendTarget(target);
  }

  @override
  Future<XTargetArray> loadMembers(PageRequest page) async {
    final res = await kernel.querySubTargetById(IDReqSubModel(
      page: PageRequest(
        limit: page.limit,
        offset: page.offset,
        filter: page.filter,
      ),
      id: target.id,
      typeNames: [target.typeName],
      subTypeNames: memberTypes,
    ));
    // appendTarget(res.data);
    return res.data!;
  }

  @override
  Future<bool> pullMember(XTarget target) async {
    return pullMembers([target.id], target.typeName);
  }

  @override
  Future<bool> pullMembers(List<String> ids, String type) async {
    if (memberTypes.contains(type)) {
      final res = await kernel.pullAnyToTeam(TeamPullModel(
        id: target.id,
        targetIds: ids,
        targetType: type,
        teamTypes: [target.typeName],
      ));
      return res.success;
    }
    return false;
  }

  @override
  Future<bool> removeMember(XTarget target) async {
    return removeMembers([target.id], target.typeName);
  }

  @override
  Future<bool> removeMembers(List<String> ids, String type) async {
    if (memberTypes.contains(type)) {
      final res = await kernel.removeAnyOfTeam(TeamPullModel(
        id: target.id,
        targetIds: ids,
        targetType: type,
        teamTypes: [target.typeName],
      ));
      return res.success;
    }
    return false;
  }

  Future<bool> pullSubTeam(XTarget team) async {
    if (subTeamTypes.contains(team.typeName)) {
      final res = await kernel.pullAnyToTeam(TeamPullModel(
        id: target.id,
        targetIds: [team.id],
        targetType: team.typeName,
        teamTypes: [target.typeName],
      ));
      return res.success;
    }
    return false;
  }
  
  @override
  Future<IIdentity?> createIdentity(IdentityModel params) async {
    params.belongId = target.id;
    final res = await kernel.createIdentity(params);
    if (res.success && res.data != null) {
      final newItem = Identity(res.data!);
      identitys.add(newItem);
      return newItem;
    }
    return null;
  }
  
  Future<ResultType<XTarget>> createSubTarget(TargetModel data) async {
    if (createTargetType.contains(data.typeName)) {
      final res = await createTarget(data);
      if (res.success) {
        await kernel.pullAnyToTeam(TeamPullModel(  id: target.id,
          teamTypes: [target.typeName],
          targetIds: [res.data!.id],
          targetType: data.typeName));
      }
      return res;
    }
    return ResultType(code: 400,msg: unAuthorizedError,success: false);
  }

  Future<ResultType<dynamic>> deleteSubTarget(
   String id,
   String typeName,
  String  spaceId,
  )async {
    var req=IdReqModel(
      id: id,
      typeName: typeName);
      req.belongId=spaceId;
    return await kernel.deleteTarget(req);
  }

   Future<ResultType<dynamic>> deleteTarget()async {
     var req=IdReqModel(
      id: id,
      typeName: target.typeName,);
      req.belongId=target.belongId;
    return await kernel.deleteTarget(req);
  }

  /// 根据编号查询组织/个人
  /// @param code 编号
  /// @param TypeName 类型
  /// @returns
Future<XTargetArray> searchTargetByName(
    String code,
List<TargetType>typeNames,
  )async {
    typeNames = searchTargetType.where((a) => typeNames.contains(a)).toList();
    if (typeNames.isNotEmpty) {
      final res = await kernel.searchTargetByName(NameTypeModel(  name: code,
        typeNames:List<String>.from(typeNames),
        page: PageRequest(
          offset: 0,
          filter: code,
          limit: Constants.maxUint16,)
        ));
        if(res.success&&res.data!=null){
      appendTarget(res.data);
      return res.data!;
        }
    }
    // logger.warn(unAuthorizedError);
    return XTargetArray(total: 0, offset: 0, limit: 0, result: [] );
  }

  /// 申请加入组织/个人 (好友申请除外)
  /// @param destId 加入的组织/个人id
  /// @param typeName 对象
  /// @returns
 Future<bool> applyJoin(String destId ,TargetType typeName ) async{
    if (joinTargetType.contains(typeName.name)) {
      final res = await kernel.applyJoinTeam({
        id: destId,
        targetId: target.id,
        teamType: typeName,
        targetType: target.typeName,
      });
      return res.success;
    }
    logger.warn(unAuthorizedError);
    return false;
  }

  /// 取消加入组织/个人
  /// @param id 申请Id/目标Id
  /// @returns
 Future<>  async cancelJoinTeam(id): Promise<model.ResultType<any>> {
    return await kernel.cancelJoinTeam({
      id,
      belongId: target.id,
      typeName: target.typeName,
    });
  }

  /// 审批我的加入组织/个人申请
  /// @param id
  /// @param status
  /// @returns
 Future<>  async approvalJoinApply(
    id,
    status: number,
  ): Promise<model.ResultType<any>> {
    return await kernel.joinTeamApproval({
      id,
      status,
    });
  }
 Future<> async getjoinedTargets(
    typeNames: TargetType[],
    spaceId,
  ): Promise<schema.XTargetArray | undefined> {
    typeNames = typeNames.filter((a) => {
      return joinTargetType.includes(a);
    });
    if (typeNames.length > 0) {
      return (
        await kernel.queryJoinedTargetById({
          id: target.id,
          typeName: target.typeName,
          page: {
            offset: 0,
            filter: '',
            limit: common.Constants.MAX_UINT_16,
          },
          spaceId: spaceId,
          JoinTypeNames: typeNames,
        })
      ).data;
    }
  }

  /// 获取子组织/个人
  /// @returns 返回好友列表
 Future<>  async getSubTargets(
    typeNames: TargetType[],
  ): Promise<model.ResultType<schema.XTargetArray>> {
    return await kernel.querySubTargetById({
      id: target.id,
      typeNames: [target.typeName],
      subTypeNames: typeNames,
      page: {
        offset: 0,
        filter: '',
        limit: common.Constants.MAX_UINT_16,
      },
    });
  }

  /// 拉自身进组织(创建组织的时候调用)
  /// @param target 目标对象
  /// @returns
  Future<ResultType<dynamic>> join(XTarget target) async {
    if (joinTargetType.contains(target.typeName)) {
      return await kernel.pullAnyToTeam(TeamPullModel(
        id: target.id,
        teamTypes: [target.typeName],
        targetType: target.typeName,
        targetIds: [target.id],
      ));
    }
    return badRequest(consts.UnauthorizedError);
  }

  /// 创建对象
  /// @param name 名称
  /// @param code 编号
  /// @param typeName 类型
  /// @param teamName team名称
  /// @param teamCode team编号
  /// @param teamRemark team备注
  /// @returns
  Future<ResultType<XTarget>> createTarget(TargetModel data) async {
    if (createTargetType.contains(data.typeName)) {
      return await kernel.createTarget(data);
    } else {
      return ResultType<XTarget>(code: 401, msg: unAuthorizedError, success: false);
    }
  }

  /// 更新组织、对象
  /// @param name 名称
  /// @param code 编号
  /// @param typeName 类型
  /// @param teamName team名称
  /// @param teamCode team编号
  /// @param teamRemark team备注
  /// @returns
  Future<bool> updateTarget(TargetModel data) async {
    data.typeName = target.typeName;
    data.teamCode = data.teamCode == '' ? data.code : data.teamCode;
    data.teamName = data.teamName == '' ? data.name : data.teamName;
    final res = await kernel.updateTarget(data);
    if (res.success) {
      target.name = data.name;
      target.code = data.code;
      target.avatar = data.avatar;
      target.belongId = data.belongId;
      if (target.team != null) {
        target.team?.name = data.teamName;
        target.team?.code = data.teamCode;
        target.team?.remark = data.teamRemark;
      }
    }
    return res.success;
  }

  /// 判断是否拥有该职权对应身份
  /// @param codes 职权编号集合
  Future<bool> judgeHasIdentity(List<String> codes) async {
    if (ownIdentitys.length == 0) {
      await getOwnIdentitys(true);
    }
    return (
      ownIdentitys.find((a) => codes.includes(a.authority?.code ?? '')) != undefined
    );
  }

  Future<List<XIdentity>> getOwnIdentitys({bool reload = false}) async {
    if (!reload && ownIdentitys.length > 0) {
      return ownIdentitys;
    }
    final res = await kernel.querySpaceIdentitys(IdReq(id: target.id));
    if (res.success && res.data.result) {
      ownIdentitys = res.data.result;
    }
    return ownIdentitys;
  }

  /// 查询组织职权树
  /// @param id
  /// @returns
  Future<IAuthority?> loadAuthorityTree({bool reload = false}) async {
    if (!reload && authorityTree != null) {
      return authorityTree;
    }
    await getOwnIdentitys(reload);
    final res = await kernel.queryAuthorityTree({
      id: target.id,
      page: {
        offset: 0,
        filter: '',
        limit: common.Constants.MAX_UINT_16,
      },
    });
    if (res.success) {
      authorityTree = new Authority(res.data, id);
    }
    return authorityTree;
  }

  Future<ISpeciesItem?> loadSpeciesTree({bool reload = false}) async {
    if (reload || !speciesTree) {
      final res = await kernel.querySpeciesTree(id, '');
      if (res.success) {
        speciesTree = new SpeciesItem(res.data, undefined);
      }
    }
    return speciesTree;
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    await Future.delayed(Duration.zero);
  }

  @override
  Future<bool> deleteIdentity(String id) async {
    var index = -1;
    for(var i=0; i<identitys.length; i++) {
      if(identitys[i].id == id) {
        index = i;
        break;
      }
    }
    if(index > -1){
        final res = await kernel.deleteIdentity(IdReqModel(id: id, typeName: target.typeName));
        if(res.success){
          identitys.removeAt(index);
          return true;
        }
    }
    return false;
  }

  @override
  Future<List<IIdentity>> getIdentitys() async {
     if (identitys.isNotEmpty) {
      return identitys;
    }
    final res = await kernel.queryTargetIdentitys(IDBelongReq(
      id: target.id,
      page: PageRequest(
        offset: 0,
        filter: '',
        limit: 2^16-1,
      ),
    ));
    if (res.success && res.data != null && res.data?.result != null) {
      for (var item in res.data!.result!) {
        identitys.add(Identity(item));
      }
    }
    return identitys;
  }

  @override
  Future<bool> judgeHasIdentity(List<String> codes) {
    // TODO: implement judgeHasIdentity
    throw UnimplementedError();
  }

  @override
  Future<IAuthority?> loadAuthorityTree({bool reload = false}) {
    // TODO: implement loadAuthorityTree
    throw UnimplementedError();
  }

  @override
  Future<ISpeciesItem?> loadSpeciesTree({bool reload = false}) {
    // TODO: implement loadSpeciesTree
    throw UnimplementedError();
  }

  @override
  Future<List<ITarget>> loadSubTeam({bool reload = false}) {
    // TODO: implement loadSubTeam
    throw UnimplementedError();
  }

  @override
  Future<ITarget> update(TargetModel data) async {
    await updateTarget(data);
    return this;
  }}
