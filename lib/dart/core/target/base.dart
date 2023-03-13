import 'dart:convert';
import 'dart:core';

import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/authority/identity.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:uuid/uuid.dart';

import '../../base/common/uint.dart';
import '../enum.dart';
import '../thing/ispecies.dart';
import '../thing/species.dart';
import 'itarget.dart';

class BaseTarget extends ITarget {
  static Uuid uuid = const Uuid();

  late List<TargetType> memberTypes;
  late List<TargetType> createTargetType;

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
    if (target.avatar.isNotEmpty) {
      var map = jsonDecode(target.avatar);
      result.avatar = FileItemShare.fromJson(map);
    }
    return result;
  }

  KernelApi kernel = KernelApi.getInstance();

  BaseTarget(XTarget target) {
    key = uuid.v4();
    this.target = target;
    createTargetType = [];
    joinTargetType = [];
    searchTargetType = [];
    ownIdentitys = [];
    identitys = [];
    memberTypes = [TargetType.person];
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
      subTypeNames: memberTypes.map((e) => e.label).toList(),
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
    if (memberTypes.contains(type as TargetType)) {
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
    return removeMembers([target.id], type: target.typeName);
  }

  @override
  Future<bool> removeMembers(List<String> ids, {String type = ''}) async {
    if (memberTypes.contains(type as TargetType)) {
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
    if (subTeamTypes.contains(team.typeName as TargetType)) {
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
    if (createTargetType.contains(data.typeName as TargetType)) {
      final res = await createTarget(data);
      if (res.success) {
        await kernel.pullAnyToTeam(TeamPullModel(
            id: target.id,
            teamTypes: [target.typeName],
            targetIds: [res.data!.id],
            targetType: data.typeName));
      }
      return res;
    }
    return ResultType(code: 400, msg: unAuthorizedError, success: false);
  }

  Future<ResultType<dynamic>> deleteSubTarget(
    String id,
    String typeName,
    String spaceId,
  ) async {
    var req = IdReqModel(id: id, typeName: typeName);
    req.belongId = spaceId;
    return await kernel.deleteTarget(req);
  }

  Future<ResultType<dynamic>> deleteTarget() async {
    var req = IdReqModel(
      id: id,
      typeName: target.typeName,
    );
    req.belongId = target.belongId;
    return await kernel.deleteTarget(req);
  }

  /// 根据编号查询组织/个人
  /// @param code 编号
  /// @param TypeName 类型
  /// @returns
  Future<XTargetArray> searchTargetByName(
    String code,
    List<TargetType> typeNames,
  ) async {
    typeNames = searchTargetType.where((a) => typeNames.contains(a)).toList();
    if (typeNames.isNotEmpty) {
      final res = await kernel.searchTargetByName(NameTypeModel(
          name: code,
          typeNames: List<String>.from(typeNames),
          page: PageRequest(
            offset: 0,
            filter: code,
            limit: Constants.maxUint16,
          )));
      if (res.success && res.data != null) {
        // appendTarget(res.data);
        return res.data!;
      }
    }
    // logger.warn(unAuthorizedError);
    return XTargetArray(total: 0, offset: 0, limit: 0, result: []);
  }

  /// 申请加入组织/个人 (好友申请除外)
  /// @param destId 加入的组织/个人id
  /// @param typeName 对象
  /// @returns
  Future<bool> applyJoin(String destId, TargetType typeName) async {
    if (joinTargetType.contains(typeName.name as TargetType)) {
      final res = await kernel.applyJoinTeam(JoinTeamModel(
        id: destId,
        targetId: target.id,
        teamType: typeName.name,
        targetType: target.typeName,
      ));
      return res.success;
    }
    // logger.warn(unAuthorizedError);
    return false;
  }

  /// 取消加入组织/个人
  /// @param id 申请Id/目标Id
  /// @returns
  Future<ResultType<dynamic>> cancelJoinTeam(id) async {
    var req = IdReqModel(id: id, typeName: target.typeName);
    req.belongId = id;
    return await kernel.cancelJoinTeam(req);
  }

  /// 审批我的加入组织/个人申请
  /// @param id
  /// @param status
  /// @returns
  Future<ResultType<dynamic>> approvalJoinApply(
    String id,
    int status,
  ) async {
    return await kernel.joinTeamApproval(ApprovalModel(id: id, status: status));
  }

  Future<XTargetArray> getjoinedTargets(
    List<TargetType> typeNames,
    String spaceId,
  ) async {
    typeNames = typeNames.where((a) => joinTargetType.contains(a)).toList();
    if (typeNames.isNotEmpty) {
      final res = await kernel.queryJoinedTargetById(IDReqJoinedModel(
          id: target.id,
          typeName: target.typeName,
          page: PageRequest(offset: 0, filter: '', limit: Constants.maxUint16),
          spaceId: spaceId,
          joinTypeNames: typeNames.map((item) => item.label).toList()));
      if (res.data != null) {
        return res.data!;
      }
    }
    return XTargetArray(total: 0, offset: 0, limit: 0, result: []);
  }

  /// 获取子组织/个人
  /// @returns 返回好友列表
  Future<ResultType<XTargetArray>> getSubTargets(
    List<TargetType> typeNames,
  ) async {
    return await kernel.querySubTargetById(IDReqSubModel(
      id: id,
      typeNames: [target.typeName],
      subTypeNames: typeNames.map((e) => e.label).toList(),
      page: PageRequest(offset: 0, filter: '', limit: Constants.maxUint16),
    ));
  }

  /// 拉自身进组织(创建组织的时候调用)
  /// @param target 目标对象
  /// @returns
  Future<ResultType<dynamic>> join(XTarget target) async {
    if (joinTargetType.contains(target.typeName as TargetType)) {
      return await kernel.pullAnyToTeam(TeamPullModel(
        id: target.id,
        teamTypes: [target.typeName],
        targetType: target.typeName,
        targetIds: [target.id],
      ));
    }
    return ResultType(code: 400, msg: unAuthorizedError, success: false);
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
    if (createTargetType.contains(data.typeName as TargetType)) {
      return await kernel.createTarget(data);
    } else {
      return ResultType<XTarget>(
          code: 401, msg: unAuthorizedError, success: false);
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
  @override
  Future<bool> judgeHasIdentity(List<String> codes) async {
    if (ownIdentitys.isNotEmpty) {
      await getOwnIdentitys(reload: true);
    }
    return ownIdentitys
        .where((a) => codes.contains(a.authority?.code ?? ''))
        .isNotEmpty;
  }

  Future<List<XIdentity>> getOwnIdentitys({bool reload = false}) async {
    if (!reload && ownIdentitys.isNotEmpty) {
      return ownIdentitys;
    }
    final res = await kernel.querySpaceIdentitys(IdReq(id: target.id));
    if (res.success && res.data?.result != null) {
      ownIdentitys = res.data!.result!;
    }
    return ownIdentitys;
  }

  /// 查询组织职权树
  /// @param id
  /// @returns
  @override
  Future<IAuthority?> loadAuthorityTree({bool reload = false}) async {
    if (!reload && authorityTree != null) {
      return authorityTree;
    }
    await getOwnIdentitys(reload: reload);
    final res = await kernel.queryAuthorityTree(IdSpaceReq(
      id: '0',
      spaceId: target.id,
      page: PageRequest(
        offset: 0,
        filter: '',
        limit: Constants.maxUint16,
      ),
    ));
    if (res.success) {
      authorityTree = Authority(res.data!, id);
    }
    return authorityTree;
  }

  @override
  Future<ITarget?> create(TargetModel data) async {
    await Future.delayed(Duration.zero);
    return null;
  }

  @override
  Future<bool> deleteIdentity(String id) async {
    var index = -1;
    for (var i = 0; i < identitys.length; i++) {
      if (identitys[i].id == id) {
        index = i;
        break;
      }
    }
    if (index > -1) {
      final res = await kernel
          .deleteIdentity(IdReqModel(id: id, typeName: target.typeName));
      if (res.success) {
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
        limit: 2 ^ 16 - 1,
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
  Future<List<ITarget>> loadSubTeam({bool reload = false}) async {
    return [];
  }

  @override
  Future<ITarget> update(TargetModel data) async {
    await updateTarget(data);
    return this;
  }

  @override
  Future<bool> delete() async {
    return false;
  }
}
