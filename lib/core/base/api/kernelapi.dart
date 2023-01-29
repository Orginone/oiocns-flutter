import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:logging/logging.dart';
import 'package:orginone/core/base/api/any_store.dart';
import 'package:orginone/core/base/api/store_hub.dart';
import 'package:orginone/core/base/model.dart';
import 'package:orginone/api_resp/api_resp.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/api_resp/message_detail.dart';
import 'package:orginone/api_resp/page_resp.dart';
import 'package:orginone/api_resp/request_entity.dart';
import 'package:orginone/api_resp/space_messages_resp.dart';
import 'package:orginone/api_resp/target.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/util/http_util.dart';
import 'package:signalr_core/signalr_core.dart';

enum ReceiveEvent {
  receive("Receive");

  final String keyWork;

  const ReceiveEvent(this.keyWork);
}

enum SendEvent {
  tokenAuth("TokenAuth"),
  getChats("GetChats"),
  sendMsg("SendMsg"),
  getPersons("GetPersons"),
  recallMsg("RecallMsg"),
  queryFriendMsg("QueryFriendMsg"),
  queryCohortMsg("QueryCohortMsg"),
  getName("GetName");

  final String keyWord;

  const SendEvent(this.keyWord);
}

class Kernel {
  Logger log = Logger("KernelApi");

  final StoreHub _kernelHub;
  final HttpUtil _requester;
  final Map<String, List<Function>> _methods;

  AnyStore get anyStore => AnyStore.getInstance;

  HubConnectionState get state => _kernelHub.state.value;

  static Kernel? _instance;

  static Kernel get getInstance {
    _instance ??= Kernel._(request: HttpUtil());
    return _instance!;
  }

  Kernel._({required HttpUtil request})
      : _kernelHub = StoreHub(
          connName: "kernelHub",
          url: Constant.kernelHub,
          timeout: const Duration(seconds: 5),
        ),
        _methods = {},
        _requester = request {
    _kernelHub.on(ReceiveEvent.receive.keyWork, receive);
    _kernelHub.addConnectedCallback(tokenAuth);
  }

  start() async {
    await anyStore.start();
    await _kernelHub.start();
  }

  stop() async {
    _methods.clear();
    await _kernelHub.stop();
    await anyStore.stop();
  }

  tokenAuth() async {
    var accessToken = getAccessToken;
    var methodName = SendEvent.tokenAuth.keyWord;
    await _kernelHub.invoke(methodName, args: [accessToken]);
  }

  receive(List<dynamic>? params) {
    if (params == null) {
      return;
    }
    log.info("最初接受到的消息: ${params.toString()}");
    Map<String, dynamic> param = params[0];
    String key = param["target"].toString().toLowerCase();
    if (_methods.containsKey(key)) {
      for (var callback in _methods[key]!) {
        callback(param["data"]);
      }
    } else {
      log.info("未订阅相关内容信息，循环接收消息中......");
      Timer(const Duration(seconds: 1), () => receive(params));
    }
  }

  on(String methodName, Function method) {
    var lowerCase = methodName.toLowerCase();
    _methods.putIfAbsent(lowerCase, () => []);
    if (_methods[lowerCase]!.contains(method)) {
      return;
    }
    _methods[lowerCase]!.add(method);
  }

  /// 登录接口
  Future<LoginResp> login(String account, String password) async {
    Map<String, dynamic> data = {
      "account": account,
      "pwd": password,
    };
    var res = await _restRequest("login", data, hasToken: false);
    return LoginResp.fromMap(res);
  }

  /// 创建字典类型
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createDict(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'CreateDict',
      params: params,
    ));
  }

  /// 创建日志记录
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createLog(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'CreateLog',
      params: params,
    ));
  }

  /// 创建字典项
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createDictItem(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'CreateDictItem',
      params: params,
    ));
  }

  /// 删除字典类型
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteDict(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'DeleteDict',
      params: params,
    ));
  }

  /// 删除字典项
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteDictItem(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'DeleteDictItem',
      params: params,
    ));
  }

  /// 更新字典类型
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateDict(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'UpdateDict',
      params: params,
    ));
  }

  /// 更新字典项
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateDictItem(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'base',
      action: 'UpdateDictItem',
      params: params,
    ));
  }

  /// 创建类别
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createSpecies(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'CreateSpecies',
      params: params,
    ));
  }

  /// 创建度量标准
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createAttribute(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'CreateAttribute',
      params: params,
    ));
  }

  /// 创建物
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createThing(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'CreateThing',
      params: params,
    ));
  }

  /// 删除类别
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteSpecies(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'DeleteSpecies',
      params: params,
    ));
  }

  /// 删除度量标准
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteAttribute(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'DeleteAttribute',
      params: params,
    ));
  }

  /// 删除物
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteThing(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'DeleteThing',
      params: params,
    ));
  }

  /// 更新类别
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateSpecies(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'UpdateSpecies',
      params: params,
    ));
  }

  /// 更新度量标准
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateAttribute(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'UpdateAttribute',
      params: params,
    ));
  }

  /// 更新物
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateThing(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'UpdateThing',
      params: params,
    ));
  }

  /// 物添加类别
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic thingAddSpecies(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'ThingAddSpecies',
      params: params,
    ));
  }

  /// 物添加度量数据
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic thingAddAttribute(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'ThingAddAttribute',
      params: params,
    ));
  }

  /// 物移除类别
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic thingRemoveSpecies(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'ThingRemoveSpecies',
      params: params,
    ));
  }

  /// 物的元数据查询
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryThingData(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'QueryThingData',
      params: params,
    ));
  }

  /// 物的历史元数据查询
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryThingHistoryData(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'QueryThingHistoryData',
      params: params,
    ));
  }

  /// 物的关系元数据查询
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryThingRelationData(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'thing',
      action: 'QueryThingRelationData',
      params: params,
    ));
  }

  /// 创建职权
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createAuthority(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'CreateAuthority',
      params: params,
    ));
  }

  /// 创建身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createIdentity(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'CreateAuthority',
      params: params,
    ));
  }

  /// 创建身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<Target> createTarget(TargetModel params) async {
    Map<String, dynamic> map = await _request(RequestEntity.from(
      module: 'target',
      action: 'CreateTarget',
      params: params,
    ));
    return Target.fromMap(map);
  }

  /// 创建标准规则
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createRuleStd(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'CreateRuleStd',
      params: params,
    ));
  }

  /// 删除职权
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteAuthority(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'DeleteAuthority',
      params: params,
    ));
  }

  /// 删除身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteIdentity(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'DeleteIdentity',
      params: params,
    ));
  }

  /// 删除组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> deleteTarget(IdReqModel params) async {
    await _request(RequestEntity.from(
      module: 'target',
      action: 'DeleteTarget',
      params: params,
    ));
  }

  /// 删除标准规则
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteRuleStd(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'DeleteRuleStd',
      params: params,
    ));
  }

  /// 递归删除组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic recursiveDeleteTarget(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'RecursiveDeleteTarget',
      params: params,
    ));
  }

  /// 更新职权
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateAuthority(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'UpdateAuthority',
      params: params,
    ));
  }

  /// 更新身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateIdentity(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'UpdateIdentity',
      params: params,
    ));
  }

  /// 更新组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<Target> updateTarget(TargetModel params) async {
    Map<String, dynamic> map = await _request(RequestEntity.from(
      module: 'target',
      action: 'UpdateTarget',
      params: params,
    ));
    return Target.fromMap(map);
  }

  /// 更新标准规则
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateRuleStd(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'UpdateRuleStd',
      params: params,
    ));
  }

  /// 分配身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic giveIdentity(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'GiveIdentity',
      params: params,
    ));
  }

  /// 移除身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic removeIdentity(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'RemoveIdentity',
      params: params,
    ));
  }

  /// 申请加入组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> applyJoinTeam(JoinTeamModel params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'ApplyJoinTeam',
      params: params,
    ));
  }

  /// 加入组织/个人申请审批
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic joinTeamApproval(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'JoinTeamApproval',
      params: params,
    ));
  }

  /// 拉组织/个人加入组织/个人的团队
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> pullAnyToTeam(TeamPullModel params) async {
    await _request(RequestEntity.from(
      module: 'target',
      action: 'PullAnyToTeam',
      params: params,
    ));
  }

  /// 取消申请加入组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic cancelJoinTeam(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'CancelJoinTeam',
      params: params,
    ));
  }

  /// 从组织/个人移除组织/个人的团队
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> removeAnyOfTeam(TeamPullModel params) async {
    await _request(RequestEntity.from(
      module: 'target',
      action: 'RemoveAnyOfTeam',
      params: params,
    ));
  }

  /// 递归从组织及子组织/个人移除组织/个人的团队
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic recursiveRemoveAnyOfTeam(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'RemoveAnyOfTeam',
      params: params,
    ));
  }

  /// 从组织/个人及归属组织移除组织/个人的团队
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic removeAnyOfTeamAndBelong(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'RemoveAnyOfTeamAndBelong',
      params: params,
    ));
  }

  /// 退出组织
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> exitAnyOfTeam(ExitTeamModel params) async {
    await _request(RequestEntity.from(
      module: 'target',
      action: 'ExitAnyOfTeam',
      params: params,
    ));
  }

  /// 递归退出组织
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic recursiveExitAnyOfTeam(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'RecursiveExitAnyOfTeam',
      params: params,
    ));
  }

  /// 退出组织及退出组织归属的组织
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic exitAnyOfTeamAndBelong(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'ExitAnyOfTeamAndBelong',
      params: params,
    ));
  }

  /// 根据ID查询组织/个人信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTargetById(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTargetById',
      params: params,
    ));
  }

  /// 查询加入关系
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryRelationById(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryRelationById',
      params: params,
    ));
  }

  /// 根据名称和类型查询组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTargetByName(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTargetByName',
      params: params,
    ));
  }

  /// 模糊查找组织/个人根据名称和类型
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic searchTargetByName(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'SearchTargetByName',
      params: params,
    ));
  }

  /// 查询组织制定的标准
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTeamRuleAttrs(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTeamRuleAttrs',
      params: params,
    ));
  }

  /// 根据ID查询子组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<PageResp<Target>> querySubTargetById(IDReqSubModel params) async {
    Map<String, dynamic> ans = await _request(RequestEntity.from(
      module: 'target',
      action: 'QuerySubTargetById',
      params: params,
    ));
    return PageResp.fromMap(ans, Target.fromMap);
  }

  /// 根据ID查询子组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryBelongTargetById(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryBelongTargetById',
      params: params,
    ));
  }

  /// 查询组织/个人加入的组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<PageResp<Target>> queryJoinedTargetById(IDReqJoinedModel p) async {
    Map<String, dynamic> res = await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryJoinedTargetById',
      params: p,
    ));
    return PageResp.fromMap(res, Target.fromMap);
  }

  /// 查询组织/个人加入的组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryJoinTeamApply(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryJoinTeamApply',
      params: params,
    ));
  }

  /// 查询组织/个人加入审批
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTeamJoinApproval(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTeamJoinApproval',
      params: params,
    ));
  }

  /// 查询组织职权树
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryAuthorityTree(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryAuthorityTree',
      params: params,
    ));
  }

  /// 查询职权子职权
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic querySubAuthorities(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QuerySubAuthoritys',
      params: params,
    ));
  }

  /// 查询组织职权
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTargetAuthorities(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTargetAuthorities',
      params: params,
    ));
  }

  /// 查询组织身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTargetIdentities(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTargetIdentitys',
      params: params,
    ));
  }

  /// 查询职权身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryAuthorityIdentities(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryAuthorityIdentitys',
      params: params,
    ));
  }

  /// 查询赋予身份的组织/个人
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryIdentityTargets(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryIdentityTargets',
      params: params,
    ));
  }

  /// 查询在当前空间拥有角色的组织
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryTargetsByAuthority(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QueryTargetsByAuthority',
      params: params,
    ));
  }

  /// 查询在当前空间拥有的身份
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic querySpaceIdentities(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'target',
      action: 'QuerySpaceIdentitys',
      params: params,
    ));
  }

  /// 创建及时消息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<void> createImMsg(ImMsgModel model) {
    return _request(RequestEntity.from(
      module: 'chat',
      action: 'CreateImMsg',
      params: model,
    ));
  }

  /// 消息撤回
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<MessageDetail> recallImMsg(MessageDetail params) async {
    return await _request(RequestEntity.from(
      module: 'chat',
      action: 'RecallImMsg',
      params: params,
    ));
  }

  /// 查询聊天会话
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<List<ChatGroup>> queryImChats(ChatsReqModel params) async {
    Map<String, dynamic> resp = await _request(RequestEntity.from(
      module: 'chat',
      action: 'QueryImChats',
      params: params,
    ));
    return ChatGroup.fromList(resp["groups"]);
  }

  /// 查询群历史消息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<PageResp<MessageDetail>> queryCohortImMsgs(IdReq params) async {
    Map<String, dynamic> res = await _request(RequestEntity.from(
      module: 'chat',
      action: 'QueryCohortImMsgs',
      params: params,
    ));
    return PageResp.fromMap(res, MessageDetail.fromMap);
  }

  /// 查询好友聊天消息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  Future<PageResp<MessageDetail>> queryFriendImMsgs(IdSpaceReq params) async {
    Map<String, dynamic> res = await _request(RequestEntity.from(
      module: 'chat',
      action: 'QueryFriendImMsgs',
      params: params,
    ));
    return PageResp.fromMap(res, MessageDetail.fromMap);
  }

  /// 根据ID查询名称
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryNameBySnowId(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'chat',
      action: 'QueryNameBySnowId',
      params: params,
    ));
  }

  /// 创建市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateMarket',
      params: params,
    ));
  }

  /// 产品上架:产品所有者
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateMerchandise',
      params: params,
    ));
  }

  /// 创建产品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateProduct',
      params: params,
    ));
  }

  /// 创建产品资源
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createProductResource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateProductResource',
      params: params,
    ));
  }

  /// 商品加入暂存区
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createStaging(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateStaging',
      params: params,
    ));
  }

  /// 创建订单:商品直接购买
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createOrder(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateOrder',
      params: params,
    ));
  }

  /// 创建订单:暂存区下单
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createOrderByStags(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateOrderByStags',
      params: params,
    ));
  }

  /// 创建订单支付
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createOrderPay(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateOrderPay',
      params: params,
    ));
  }

  /// 创建对象拓展操作
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createSourceExtend(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CreateSourceExtend',
      params: params,
    ));
  }

  /// 删除市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteMarket',
      params: params,
    ));
  }

  /// 下架商品:商品所有者
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteMerchandise',
      params: params,
    ));
  }

  /// 下架商品:市场管理员
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteMerchandiseByManager(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteMerchandiseByManager',
      params: params,
    ));
  }

  /// 删除产品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteProduct',
      params: params,
    ));
  }

  /// 删除产品资源(产品所属者可以操作)
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteProductResource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteProductResource',
      params: params,
    ));
  }

  /// 移除暂存区商品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteStaging(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteStaging',
      params: params,
    ));
  }

  /// 创建对象拓展操作
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteSourceExtend(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeleteSourceExtend',
      params: params,
    ));
  }

  /// 根据Code查询市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryMarketByCode(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryMarketByCode',
      params: params,
    ));
  }

  /// 查询拥有的市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryOwnMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryOwnMarket',
      params: params,
    ));
  }

  /// 查询软件共享仓库的市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic getPublicMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'GetPublicMarket',
      params: params,
    ));
  }

  /// 查询市场成员集合
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryMarketMember(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryMarketMember',
      params: params,
    ));
  }

  /// 查询市场对应的暂存区
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryStaging(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryStaging',
      params: params,
    ));
  }

  /// 根据ID查询订单信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic getOrderInfo(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'GetOrderInfo',
      params: params,
    ));
  }

  /// 根据ID查询订单详情项
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic getOrderDetailById(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'GetOrderDetailById',
      params: params,
    ));
  }

  /// 卖方:查询出售商品的订单列表
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic querySellOrderList(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QuerySellOrderList',
      params: params,
    ));
  }

  /// 卖方:查询指定商品的订单列表
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic querySellOrderListByMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QuerySellOrderListByMerchandise',
      params: params,
    ));
  }

  /// 买方:查询购买订单列表
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryBuyOrderList(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryBuyOrderList',
      params: params,
    ));
  }

  /// 查询订单支付信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryPayList(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryPayList',
      params: params,
    ));
  }

  /// 申请者:查询加入市场申请
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryJoinMarketApply(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryJoinMarketApply',
      params: params,
    ));
  }

  /// 管理者:查询加入市场申请
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryJoinMarketApplyByManager(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryJoinMarketApplyByManager',
      params: params,
    ));
  }

  /// 管理者:查询加入市场申请
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryMerchandiseApply(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryMerchandiseApply',
      params: params,
    ));
  }

  /// 市场:查询商品上架申请
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryMerchandisesApplyByManager(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryMerchandiesApplyByManager',
      params: params,
    ));
  }

  /// 查询市场中所有商品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic searchMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'SearchMerchandise',
      params: params,
    ));
  }

  /// 查询产品详细信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic getProductInfo(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'GetProductInfo',
      params: params,
    ));
  }

  /// 查询产品资源列表
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryProductResource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryProductResource',
      params: params,
    ));
  }

  /// 查询组织/个人产品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic querySelfProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QuerySelfProduct',
      params: params,
    ));
  }

  /// 根据产品查询商品上架信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryMerchandiseListByProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryMerchandiseListByProduct',
      params: params,
    ));
  }

  /// 查询指定产品/资源的拓展信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryExtendBySource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryExtendBySource',
      params: params,
    ));
  }

  /// 查询可用产品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryUsefulProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryUsefulProduct',
      params: params,
    ));
  }

  /// 查询可用资源列表
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryUsefulResource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QueryUsefulResource',
      params: params,
    ));
  }

  /// 更新市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateMarket',
      params: params,
    ));
  }

  /// 更新商品信息
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateMerchandise',
      params: params,
    ));
  }

  /// 更新产品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateProduct(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateProduct',
      params: params,
    ));
  }

  /// 更新产品资源
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateProductResource(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateProductResource',
      params: params,
    ));
  }

  /// 更新订单
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateOrder(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateOrder',
      params: params,
    ));
  }

  /// 更新订单项
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic updateOrderDetail(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'UpdateOrderDetail',
      params: params,
    ));
  }

  /// 退出市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic quitMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'QuitMarket',
      params: params,
    ));
  }

  /// 申请加入市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic applyJoinMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'ApplyJoinMarket',
      params: params,
    ));
  }

  /// 拉组织/个人加入市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic pullAnyToMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'PullAnyToMarket',
      params: params,
    ));
  }

  /// 取消加入市场
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic cancelJoinMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CancelJoinMarket',
      params: params,
    ));
  }

  /// 取消订单详情
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic cancelOrderDetail(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'CancelOrderDetail',
      params: params,
    ));
  }

  /// 移除市场成员
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic removeMarketMember(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'RemoveMarketMember',
      params: params,
    ));
  }

  /// 审核加入市场申请
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic approvalJoinApply(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'ApprovalJoinApply',
      params: params,
    ));
  }

  /// 交付订单详情中的商品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deliverMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'DeliverMerchandise',
      params: params,
    ));
  }

  /// 退还商品
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic rejectMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'RejectMerchandise',
      params: params,
    ));
  }

  /// 商品上架审核
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic approvalMerchandise(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'ApprovalMerchandise',
      params: params,
    ));
  }

  /// 产品上架:市场拥有者
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic pullProductToMarket(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'market',
      action: 'PullProductToMarket',
      params: params,
    ));
  }

  /// 创建流程定义
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createDefine(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'CreateDefine',
      params: params,
    ));
  }

  /// 创建流程实例(启动流程)
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createInstance(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'CreateInstance',
      params: params,
    ));
  }

  /// 创建流程绑定
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic createFlowRelation(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'CreateFlowRelation',
      params: params,
    ));
  }

  /// 删除流程定义
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteDefine(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'DeleteDefine',
      params: params,
    ));
  }

  /// 删除流程实例(发起人撤回)
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteInstance(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'DeleteInstance',
      params: params,
    ));
  }

  /// 删除流程绑定
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic deleteFlowRelation(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'DeleteFlowRelation',
      params: params,
    ));
  }

  /// 查询流程定义
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryDefine(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'QueryDefine',
      params: params,
    ));
  }

  /// 查询流程定义
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryInstance(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'QueryInstance',
      params: params,
    ));
  }

  /// 查询待审批任务
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryApproveTask(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'QueryApproveTask',
      params: params,
    ));
  }

  /// 查询待审阅抄送
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryNoticeTask(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'QueryNoticeTask',
      params: params,
    ));
  }

  /// 查询审批记录
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic queryRecord(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'QueryRecord',
      params: params,
    ));
  }

  /// 流程节点审批
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic approvalTask(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'ApprovalTask',
      params: params,
    ));
  }

  /// 重置流程定义
  /// @param {any} params 请求参数
  /// @returns {ResultType} 请求结果
  dynamic resetDefine(dynamic params) async {
    return await _request(RequestEntity.from(
      module: 'flow',
      action: 'ResetDefine',
      params: params,
    ));
  }

  Future<dynamic> _request(RequestEntity request) async {
    if (_kernelHub.isConnected()) {
      try {
        dynamic res = await _kernelHub.invoke("Request", args: [request]);
        log.info("kernelHub request ===> ${request.toString()}");
        log.info("kernelHub ===> ${res.toString()}");
        return ApiResp.fromJson(res).getData();
      } on Exception catch (error) {
        Fluttertoast.showToast(msg: error.toString());
        rethrow;
      }
    }
    return await _restRequest("request", request);
  }

  Future<dynamic> _requests(List<RequestEntity> requests) async {
    if (_kernelHub.isConnected()) {
      try {
        dynamic res = await _kernelHub.invoke("Requests", args: [requests]);
        log.info("kernelHub request ===> ${requests.toString()}");
        log.info("kernelHub ===> ${res.toString()}");
        return ApiResp.fromJson(res).getData();
      } on Exception catch (error) {
        Fluttertoast.showToast(msg: error.toString());
        rethrow;
      }
    }
    return await _restRequest("requests", requests);
  }

  Future<dynamic> _restRequest(
    String methodName,
    dynamic data, {
    bool hasToken = true,
  }) async {
    return await _requester.post(
      "${Constant.kernel}/$methodName",
      data: data,
      hasToken: hasToken,
    );
  }
}
