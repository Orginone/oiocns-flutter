import 'dart:async';

import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/anystore.dart';
import 'package:orginone/dart/base/api/storehub.dart';
import 'package:orginone/util/http_util.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

class KernelApi {
  final Logger log = Logger("KernelApi");

  final StoreHub _storeHub;
  final HttpUtil _requester;
  final Map<String, List<Function>> _methods;
  final AnyStore _anystore;

  static KernelApi? _instance;

  KernelApi(String url, {required HttpUtil request})
      : _storeHub = StoreHub(url),
        _methods = {},
        _requester = request,
        _anystore = AnyStore.getInstance() {
    _storeHub.on("Receive", receive);
  }

  /// 获取单例
  /// @param {string} url 集线器地址，默认为 "/orginone/kernel/hub"
  /// @returns {KernelApi} 内核api单例
  static KernelApi getInstance({String url = '/orginone/kernel/hub'}) {
    _instance ??= KernelApi(url, request: HttpUtil());
    return _instance!;
  }

  /// 任意数据存储对象
  /// @returns {AnyStore | undefined} 可能为空的存储对象
  AnyStore get anystore {
    return _anystore;
  }

  /// 是否在线
  /// @returns {boolean} 在线状态
  bool get isOnline {
    return _storeHub.isConnected;
  }

  start() async {
    await _anystore.start();
    _storeHub.start();
  }

  stop() async {
    _methods.clear();
    await _storeHub.dispose();
    await _anystore.stop();
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
  Future<ResultType<dynamic>> login(String account, String password) async {
    Map<String, dynamic> req = {
      "account": account,
      "pwd": password,
    };
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('Login', args: [req]);
    }
    return await _restRequest("login", req);
  }

  /// 创建字典类型
  /// @param {DictModel} params 请求参数
  /// @returns {ResultType<XDict>} 请求结果
  Future<ResultType<XDict>> createDict(DictModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'CreateDict',
      params: params,
    ));
  }

  /// 创建日志记录
  /// @param {LogModel} params 请求参数
  /// @returns {ResultType<XLog>} 请求结果
  Future<ResultType<XLog>> createLog(LogModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'CreateLog',
      params: params,
    ));
  }

  /// 创建字典项
  /// @param {DictItemModel} params 请求参数
  /// @returns {ResultType<XDictItem>} 请求结果
  Future<ResultType<XDictItem>> createDictItem(DictItemModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'CreateDictItem',
      params: params,
    ));
  }

  /// 删除字典类型
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDict(IdReqModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'DeleteDict',
      params: params,
    ));
  }

  /// 删除字典项
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDictItem(IdReqModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'DeleteDictItem',
      params: params,
    ));
  }

  /// 更新字典类型
  /// @param {DictModel} params 请求参数
  /// @returns {ResultType<XDict>} 请求结果
  Future<ResultType<XDict>> updateDict(DictModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'UpdateDict',
      params: params,
    ));
  }

  /// 更新字典项
  /// @param {DictItemModel} params 请求参数
  /// @returns {ResultType<XDictItem>} 请求结果
  Future<ResultType<XDictItem>> updateDictItem(DictItemModel params) async {
    return await request(ReqestType(
      module: 'base',
      action: 'UpdateDictItem',
      params: params,
    ));
  }

  /// 创建类别
  /// @param {SpeciesModel} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> createSpecies(SpeciesModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'CreateSpecies',
      params: params,
    ));
  }

  /// 创建度量标准
  /// @param {AttributeModel} params 请求参数
  /// @returns {ResultType<XAttribute>} 请求结果
  Future<ResultType<XAttribute>> createAttribute(AttributeModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'CreateAttribute',
      params: params,
    ));
  }

  /// 创建物
  /// @param {ThingModel} params 请求参数
  /// @returns {ResultType<XThing>} 请求结果
  Future<ResultType<XThing>> createThing(ThingModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'CreateThing',
      params: params,
    ));
  }

  /// 删除类别
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteSpecies(IdReqModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'DeleteSpecies',
      params: params,
    ));
  }

  /// 删除度量标准
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteAttribute(IdReqModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'DeleteAttribute',
      params: params,
    ));
  }

  /// 删除物
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteThing(IdReqModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'DeleteThing',
      params: params,
    ));
  }

  /// 更新类别
  /// @param {SpeciesModel} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> updateSpecies(SpeciesModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'UpdateSpecies',
      params: params,
    ));
  }

  /// 更新度量标准
  /// @param {AttributeModel} params 请求参数
  /// @returns {ResultType<XAttribute>} 请求结果
  Future<ResultType<XAttribute>> updateAttribute(AttributeModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'UpdateAttribute',
      params: params,
    ));
  }

  /// 更新物
  /// @param {ThingModel} params 请求参数
  /// @returns {ResultType<XThing>} 请求结果
  Future<ResultType<XThing>> updateThing(ThingModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'UpdateThing',
      params: params,
    ));
  }

  /// 物添加类别
  /// @param {ThingSpeciesModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingAddSpecies(ThingSpeciesModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'ThingAddSpecies',
      params: params,
    ));
  }

  /// 物添加度量数据
  /// @param {ThingAttrModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingAddAttribute(ThingAttrModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'ThingAddAttribute',
      params: params,
    ));
  }

  /// 物移除类别
  /// @param {ThingSpeciesModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingRemoveSpecies(ThingSpeciesModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'ThingRemoveSpecies',
      params: params,
    ));
  }

  /// 物移除度量数据
  /// @param {ThingAttrModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingRemoveAttribute(ThingAttrModel params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'ThingRemoveAttribute',
      params: params,
    ));
  }

  /// 查询分类树
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> querySpeciesTree(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'QuerySpeciesTree',
      params: params,
    ));
  }

  /// 查询分类的度量标准
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XAttributeArray>} 请求结果
  Future<ResultType<XAttributeArray>> querySpeciesAttrs(
      IdSpaceReq params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'QuerySpeciesAttrs',
      params: params,
    ));
  }

  /// 物的元数据查询
  /// @param {ThingAttrReq} params 请求参数
  /// @returns {ResultType<XThingAttrArray>} 请求结果
  Future<ResultType<XThingAttrArray>> queryThingData(
      ThingAttrReq params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'QueryThingData',
      params: params,
    ));
  }

  /// 物的历史元数据查询
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XThingAttrHistroyArray>} 请求结果
  Future<ResultType<XThingAttrHistroyArray>> queryThingHistroyData(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'QueryThingHistroyData',
      params: params,
    ));
  }

  /// 物的关系元数据查询
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryThingRelationData(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'thing',
      action: 'QueryThingRelationData',
      params: params,
    ));
  }

  /// 创建职权
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> createAuthority(AuthorityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'CreateAuthority',
      params: params,
    ));
  }

  /// 创建身份
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> createIdentity(IdentityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'CreateIdentity',
      params: params,
    ));
  }

  /// 创建组织/个人
  /// @param {TargetModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> createTarget(TargetModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'CreateTarget',
      params: params,
    ));
  }

  /// 创建标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<XRuleStd>} 请求结果
  Future<ResultType<XRuleStd>> createRuleStd(RuleStdModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'CreateRuleStd',
      params: params,
    ));
  }

  /// 删除职权
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteAuthority(IdReqModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'DeleteAuthority',
      params: params,
    ));
  }

  /// 删除身份
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteIdentity(IdReqModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'DeleteIdentity',
      params: params,
    ));
  }

  /// 删除组织/个人
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteTarget(IdReqModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'DeleteTarget',
      params: params,
    ));
  }

  /// 删除标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteRuleStd(RuleStdModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'DeleteRuleStd',
      params: params,
    ));
  }

  /// 递归删除组织/个人
  /// @param {RecursiveReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveDeleteTarget(
      RecursiveReqModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RecursiveDeleteTarget',
      params: params,
    ));
  }

  /// 更新职权
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> updateAuthority(AuthorityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'UpdateAuthority',
      params: params,
    ));
  }

  /// 更新身份
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> updateIdentity(IdentityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'UpdateIdentity',
      params: params,
    ));
  }

  /// 更新组织/个人
  /// @param {TargetModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> updateTarget(TargetModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'UpdateTarget',
      params: params,
    ));
  }

  /// 更新标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<XRuleStd>} 请求结果
  Future<ResultType<XRuleStd>> updateRuleStd(RuleStdModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'UpdateRuleStd',
      params: params,
    ));
  }

  /// 分配身份
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> giveIdentity(GiveIdentityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'GiveIdentity',
      params: params,
    ));
  }

  /// 移除身份
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeIdentity(GiveIdentityModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RemoveIdentity',
      params: params,
    ));
  }

  /// 申请加入组织/个人
  /// @param {JoinTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> applyJoinTeam(JoinTeamModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'ApplyJoinTeam',
      params: params,
    ));
  }

  /// 加入组织/个人申请审批
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<XRelation>} 请求结果
  Future<ResultType<XRelation>> joinTeamApproval(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'JoinTeamApproval',
      params: params,
    ));
  }

  /// 拉组织/个人加入组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> pullAnyToTeam(TeamPullModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'PullAnyToTeam',
      params: params,
    ));
  }

  /// 取消申请加入组织/个人
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelJoinTeam(IdReqModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'CancelJoinTeam',
      params: params,
    ));
  }

  /// 从组织/个人移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeAnyOfTeam(TeamPullModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RemoveAnyOfTeam',
      params: params,
    ));
  }

  /// 递归从组织及子组织/个人移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveRemoveAnyOfTeam(
      TeamPullModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RecursiveRemoveAnyOfTeam',
      params: params,
    ));
  }

  /// 从组织/个人及归属组织移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeAnyOfTeamAndBelong(
      TeamPullModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RemoveAnyOfTeamAndBelong',
      params: params,
    ));
  }

  /// 退出组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> exitAnyOfTeam(ExitTeamModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'ExitAnyOfTeam',
      params: params,
    ));
  }

  /// 递归退出组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveExitAnyOfTeam(ExitTeamModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'RecursiveExitAnyOfTeam',
      params: params,
    ));
  }

  /// 退出组织及退出组织归属的组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> exitAnyOfTeamAndBelong(ExitTeamModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'ExitAnyOfTeamAndBelong',
      params: params,
    ));
  }

  /// 根据ID查询组织/个人信息
  /// @param {IdArrayReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryTargetById(IdArrayReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTargetById',
      params: params,
    ));
  }

  /// 查询加入关系
  /// @param {RelationReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryRelationById(
      RelationReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryRelationById',
      params: params,
    ));
  }

  /// 根据名称和类型查询组织/个人
  /// @param {NameTypeModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> queryTargetByName(NameTypeModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTargetByName',
      params: params,
    ));
  }

  /// 模糊查找组织/个人根据名称和类型
  /// @param {NameTypeModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> searchTargetByName(
      NameTypeModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'SearchTargetByName',
      params: params,
    ));
  }

  /// 查询组织制定的标准
  /// @param {IDBelongTargetReq} params 请求参数
  /// @returns {ResultType<XAttributeArray>} 请求结果
  Future<ResultType<XAttributeArray>> queryTeamRuleAttrs(
      IDBelongTargetReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTeamRuleAttrs',
      params: params,
    ));
  }

  /// 根据ID查询子组织/个人
  /// @param {IDReqSubModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> querySubTargetById(
      IDReqSubModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QuerySubTargetById',
      params: params,
    ));
  }

  /// 根据ID查询归属的组织/个人
  /// @param {IDReqSubModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryBelongTargetById(
      IDReqSubModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryBelongTargetById',
      params: params,
    ));
  }

  /// 查询组织/个人加入的组织/个人
  /// @param {IDReqJoinedModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryJoinedTargetById(
      IDReqJoinedModel params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryJoinedTargetById',
      params: params,
    ));
  }

  /// 查询加入组织/个人申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryJoinTeamApply(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryJoinTeamApply',
      params: params,
    ));
  }

  /// 查询组织/个人加入审批
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryTeamJoinApproval(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTeamJoinApproval',
      params: params,
    ));
  }

  /// 查询组织职权树
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> queryAuthorityTree(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryAuthorityTree',
      params: params,
    ));
  }

  /// 查询职权子职权
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XAuthorityArray>} 请求结果
  Future<ResultType<XAuthorityArray>> querySubAuthoritys(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QuerySubAuthoritys',
      params: params,
    ));
  }

  /// 查询组织职权
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XAuthorityArray>} 请求结果
  Future<ResultType<XAuthorityArray>> queryTargetAuthoritys(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTargetAuthoritys',
      params: params,
    ));
  }

  /// 查询组织身份
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> queryTargetIdentitys(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTargetIdentitys',
      params: params,
    ));
  }

  /// 查询职权身份
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> queryAuthorityIdentitys(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryAuthorityIdentitys',
      params: params,
    ));
  }

  /// 查询赋予身份的组织/个人
  /// @param {IDBelongTargetReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryIdentityTargets(
      IDBelongTargetReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryIdentityTargets',
      params: params,
    ));
  }

  /// 查询在当前空间拥有角色的组织
  /// @param {SpaceAuthReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryTargetsByAuthority(
      SpaceAuthReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QueryTargetsByAuthority',
      params: params,
    ));
  }

  /// 查询在当前空间拥有的身份
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> querySpaceIdentitys(IdReq params) async {
    return await request(ReqestType(
      module: 'target',
      action: 'QuerySpaceIdentitys',
      params: params,
    ));
  }

  /// 创建即使消息
  /// @param {ImMsgModel} params 请求参数
  /// @returns {ResultType<XImMsg>} 请求结果
  Future<ResultType<XImMsg>> createImMsg(ImMsgModel params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'CreateImMsg',
      params: params,
    ));
  }

  /// 消息撤回
  /// @param {XImMsg} params 请求参数
  /// @returns {ResultType<XImMsg>} 请求结果
  Future<ResultType<XImMsg>> recallImMsg(XImMsg params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'RecallImMsg',
      params: params,
    ));
  }

  /// 查询聊天会话
  /// @param {ChatsReqModel} params 请求参数
  /// @returns {ResultType<ChatResponse>} 请求结果
  Future<ResultType<ChatResponse>> queryImChats(ChatsReqModel params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'QueryImChats',
      params: params,
    ));
  }

  /// 查询群历史消息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XImMsgArray>} 请求结果
  Future<ResultType<XImMsgArray>> queryCohortImMsgs(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'QueryCohortImMsgs',
      params: params,
    ));
  }

  /// 查询好友聊天消息
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XImMsgArray>} 请求结果
  Future<ResultType<XImMsgArray>> queryFriendImMsgs(IdSpaceReq params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'QueryFriendImMsgs',
      params: params,
    ));
  }

  /// 根据ID查询名称
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<NameModel>} 请求结果
  Future<ResultType<NameModel>> queryNameBySnowId(IdReq params) async {
    return await request(ReqestType(
      module: 'chat',
      action: 'QueryNameBySnowId',
      params: params,
    ));
  }

  /// 创建市场
  /// @param {MarketModel} params 请求参数
  /// @returns {ResultType<XMarket>} 请求结果
  Future<ResultType<XMarket>> createMarket(MarketModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateMarket',
      params: params,
    ));
  }

  /// 产品上架:产品所有者
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> createMerchandise(
      MerchandiseModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateMerchandise',
      params: params,
    ));
  }

  /// 创建产品
  /// @param {ProductModel} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> createProduct(ProductModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateProduct',
      params: params,
    ));
  }

  /// 创建产品资源
  /// @param {ResourceModel} params 请求参数
  /// @returns {ResultType<XResource>} 请求结果
  Future<ResultType<XResource>> createProductResource(
      ResourceModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateProductResource',
      params: params,
    ));
  }

  /// 商品加入暂存区
  /// @param {StagingModel} params 请求参数
  /// @returns {ResultType<XStaging>} 请求结果
  Future<ResultType<XStaging>> createStaging(StagingModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateStaging',
      params: params,
    ));
  }

  /// 创建订单:商品直接购买
  /// @param {OrderModel} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> createOrder(OrderModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateOrder',
      params: params,
    ));
  }

  /// 创建订单:暂存区下单
  /// @param {OrderModelByStags} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> createOrderByStags(
      OrderModelByStags params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateOrderByStags',
      params: params,
    ));
  }

  /// 创建订单支付
  /// @param {OrderPayModel} params 请求参数
  /// @returns {ResultType<XOrderPay>} 请求结果
  Future<ResultType<XOrderPay>> createOrderPay(OrderPayModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateOrderPay',
      params: params,
    ));
  }

  /// 创建对象拓展操作
  /// @param {SourceExtendModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> createSourceExtend(SourceExtendModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CreateSourceExtend',
      params: params,
    ));
  }

  /// 删除市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMarket(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteMarket',
      params: params,
    ));
  }

  /// 下架商品:商品所有者
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMerchandise(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteMerchandise',
      params: params,
    ));
  }

  /// 下架商品:市场管理员
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMerchandiseByManager(
      IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteMerchandiseByManager',
      params: params,
    ));
  }

  /// 删除产品
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteProduct(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteProduct',
      params: params,
    ));
  }

  /// 删除产品资源(产品所属者可以操作)
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteProductResource(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteProductResource',
      params: params,
    ));
  }

  /// 移除暂存区商品
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteStaging(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteStaging',
      params: params,
    ));
  }

  /// 创建对象拓展操作
  /// @param {SourceExtendModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteSourceExtend(SourceExtendModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeleteSourceExtend',
      params: params,
    ));
  }

  /// 根据Code查询市场
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> queryMarketByCode(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryMarketByCode',
      params: params,
    ));
  }

  /// 查询拥有的市场
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> queryOwnMarket(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryOwnMarket',
      params: params,
    ));
  }

  /// 查询软件共享仓库的市场
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> getPublicMarket() async {
    return await request(ReqestType(
      module: 'market',
      action: 'GetPublicMarket',
      params: {},
    ));
  }

  /// 查询市场成员集合
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryMarketMember(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryMarketMember',
      params: params,
    ));
  }

  /// 查询市场对应的暂存区
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XStagingArray>} 请求结果
  Future<ResultType<XStagingArray>> queryStaging(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryStaging',
      params: params,
    ));
  }

  /// 根据ID查询订单信息
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> getOrderInfo(IdReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'GetOrderInfo',
      params: params,
    ));
  }

  /// 根据ID查询订单详情项
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XOrderDetail>} 请求结果
  Future<ResultType<XOrderDetail>> getOrderDetailById(
      IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'GetOrderDetailById',
      params: params,
    ));
  }

  /// 卖方:查询出售商品的订单列表
  /// @param {IDStatusPageReq} params 请求参数
  /// @returns {ResultType<XOrderDetailArray>} 请求结果
  Future<ResultType<XOrderDetailArray>> querySellOrderList(
      IDStatusPageReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QuerySellOrderList',
      params: params,
    ));
  }

  /// 卖方:查询指定商品的订单列表
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XOrderDetailArray>} 请求结果
  Future<ResultType<XOrderDetailArray>> querySellOrderListByMerchandise(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QuerySellOrderListByMerchandise',
      params: params,
    ));
  }

  /// 买方:查询购买订单列表
  /// @param {IDStatusPageReq} params 请求参数
  /// @returns {ResultType<XOrderArray>} 请求结果
  Future<ResultType<XOrderArray>> queryBuyOrderList(
      IDStatusPageReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryBuyOrderList',
      params: params,
    ));
  }

  /// 查询订单支付信息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XOrderPayArray>} 请求结果
  Future<ResultType<XOrderPayArray>> queryPayList(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryPayList',
      params: params,
    ));
  }

  /// 申请者:查询加入市场申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryJoinMarketApply(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryJoinMarketApply',
      params: params,
    ));
  }

  /// 管理者:查询加入市场申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryJoinMarketApplyByManager(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryJoinMarketApplyByManager',
      params: params,
    ));
  }

  /// 申请者:查询商品上架申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiseApply(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryMerchandiseApply',
      params: params,
    ));
  }

  /// 市场:查询商品上架申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiesApplyByManager(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryMerchandiesApplyByManager',
      params: params,
    ));
  }

  /// 查询市场中所有商品
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> searchMerchandise(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'SearchMerchandise',
      params: params,
    ));
  }

  /// 查询产品详细信息
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> getProductInfo(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'GetProductInfo',
      params: params,
    ));
  }

  /// 查询产品资源列表
  /// @param {IDWithBelongPageReq} params 请求参数
  /// @returns {ResultType<XResourceArray>} 请求结果
  Future<ResultType<XResourceArray>> queryProductResource(
      IDWithBelongPageReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryProductResource',
      params: params,
    ));
  }

  /// 查询组织/个人产品
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XProductArray>} 请求结果
  Future<ResultType<XProductArray>> querySelfProduct(IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QuerySelfProduct',
      params: params,
    ));
  }

  /// 根据产品查询商品上架信息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiseListByProduct(
      IDBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryMerchandiseListByProduct',
      params: params,
    ));
  }

  /// 查询指定产品/资源的拓展信息
  /// @param {SearchExtendReq} params 请求参数
  /// @returns {ResultType<IdNameArray>} 请求结果
  Future<ResultType<IdNameArray>> queryExtendBySource(
      SearchExtendReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryExtendBySource',
      params: params,
    ));
  }

  /// 查询可用产品
  /// @param {UsefulProductReq} params 请求参数
  /// @returns {ResultType<XProductArray>} 请求结果
  Future<ResultType<XProductArray>> queryUsefulProduct(
      UsefulProductReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryUsefulProduct',
      params: params,
    ));
  }

  /// 查询可用资源列表
  /// @param {UsefulResourceReq} params 请求参数
  /// @returns {ResultType<XResourceArray>} 请求结果
  Future<ResultType<XResourceArray>> queryUsefulResource(
      UsefulResourceReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QueryUsefulResource',
      params: params,
    ));
  }

  /// 更新市场
  /// @param {MarketModel} params 请求参数
  /// @returns {ResultType<XMarket>} 请求结果
  Future<ResultType<XMarket>> updateMarket(MarketModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateMarket',
      params: params,
    ));
  }

  /// 更新商品信息
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> updateMerchandise(
      MerchandiseModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateMerchandise',
      params: params,
    ));
  }

  /// 更新产品
  /// @param {ProductModel} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> updateProduct(ProductModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateProduct',
      params: params,
    ));
  }

  /// 更新产品资源
  /// @param {ResourceModel} params 请求参数
  /// @returns {ResultType<XResource>} 请求结果
  Future<ResultType<XResource>> updateProductResource(
      ResourceModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateProductResource',
      params: params,
    ));
  }

  /// 更新订单
  /// @param {OrderModel} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> updateOrder(OrderModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateOrder',
      params: params,
    ));
  }

  /// 更新订单项
  /// @param {OrderDetailModel} params 请求参数
  /// @returns {ResultType<XOrderDetail>} 请求结果
  Future<ResultType<XOrderDetail>> updateOrderDetail(
      OrderDetailModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'UpdateOrderDetail',
      params: params,
    ));
  }

  /// 退出市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> quitMarket(IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'QuitMarket',
      params: params,
    ));
  }

  /// 申请加入市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelation>} 请求结果
  Future<ResultType<XMarketRelation>> applyJoinMarket(
      IDWithBelongReq params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'ApplyJoinMarket',
      params: params,
    ));
  }

  /// 拉组织/个人加入市场
  /// @param {MarketPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> pullAnyToMarket(MarketPullModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'PullAnyToMarket',
      params: params,
    ));
  }

  /// 取消加入市场
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelJoinMarket(IdReqModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CancelJoinMarket',
      params: params,
    ));
  }

  /// 取消订单详情
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelOrderDetail(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'CancelOrderDetail',
      params: params,
    ));
  }

  /// 移除市场成员
  /// @param {MarketPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeMarketMember(MarketPullModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'RemoveMarketMember',
      params: params,
    ));
  }

  /// 审核加入市场申请
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalJoinApply(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'ApprovalJoinApply',
      params: params,
    ));
  }

  /// 交付订单详情中的商品
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deliverMerchandise(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'DeliverMerchandise',
      params: params,
    ));
  }

  /// 退还商品
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> rejectMerchandise(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'RejectMerchandise',
      params: params,
    ));
  }

  /// 商品上架审核
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalMerchandise(ApprovalModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'ApprovalMerchandise',
      params: params,
    ));
  }

  /// 产品上架:市场拥有者
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> pullProductToMarket(
      MerchandiseModel params) async {
    return await request(ReqestType(
      module: 'market',
      action: 'PullProductToMarket',
      params: params,
    ));
  }

  /// 创建流程定义
  /// @param {XFlowDefine} params 请求参数
  /// @returns {ResultType<XFlowDefine>} 请求结果
  Future<ResultType<XFlowDefine>> createDefine(XFlowDefine params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'CreateDefine',
      params: params,
    ));
  }

  /// 创建流程实例(启动流程)
  /// @param {FlowInstanceModel} params 请求参数
  /// @returns {ResultType<XFlowInstance>} 请求结果
  Future<ResultType<XFlowInstance>> createInstance(
      FlowInstanceModel params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'CreateInstance',
      params: params,
    ));
  }

  /// 创建流程绑定
  /// @param {FlowRelationModel} params 请求参数
  /// @returns {ResultType<XFlowRelation>} 请求结果
  Future<ResultType<XFlowRelation>> createFlowRelation(
      FlowRelationModel params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'CreateFlowRelation',
      params: params,
    ));
  }

  /// 删除流程定义
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDefine(IdReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'DeleteDefine',
      params: params,
    ));
  }

  /// 删除流程实例(发起人撤回)
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteInstance(IdReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'DeleteInstance',
      params: params,
    ));
  }

  /// 删除流程绑定
  /// @param {FlowRelationModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteFlowRelation(FlowRelationModel params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'DeleteFlowRelation',
      params: params,
    ));
  }

  /// 查询流程定义
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XFlowDefineArray>} 请求结果
  Future<ResultType<XFlowDefineArray>> queryDefine(IdReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'QueryDefine',
      params: params,
    ));
  }

  /// 查询发起的流程实例
  /// @param {FlowReq} params 请求参数
  /// @returns {ResultType<XFlowInstanceArray>} 请求结果
  Future<ResultType<XFlowInstanceArray>> queryInstance(FlowReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'QueryInstance',
      params: params,
    ));
  }

  /// 查询待审批任务
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XFlowTaskArray>} 请求结果
  Future<ResultType<XFlowTaskArray>> queryApproveTask(IdReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'QueryApproveTask',
      params: params,
    ));
  }

  /// 查询待审阅抄送
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XFlowTaskHistoryArray>} 请求结果
  Future<ResultType<XFlowTaskHistoryArray>> queryNoticeTask(
      IdReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'QueryNoticeTask',
      params: params,
    ));
  }

  /// 查询审批记录
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XFlowTaskHistoryArray>} 请求结果
  Future<ResultType<XFlowTaskHistoryArray>> queryRecord(
      IdSpaceReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'QueryRecord',
      params: params,
    ));
  }

  /// 流程节点审批
  /// @param {ApprovalTaskReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalTask(ApprovalTaskReq params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'ApprovalTask',
      params: params,
    ));
  }

  /// 重置流程定义
  /// @param {XFlowDefine} params 请求参数
  /// @returns {ResultType<XFlowDefine>} 请求结果
  Future<ResultType<XFlowDefine>> resetDefine(XFlowDefine params) async {
    return await request(ReqestType(
      module: 'flow',
      action: 'ResetDefine',
      params: params,
    ));
  }

  Future<dynamic> request(ReqestType req) async {
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('Request', args: [req]);
    } else {
      return await _restRequest('Request', req);
    }
  }

  Future<dynamic> requests(List<ReqestType> reqs) async {
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('Requests', args: reqs);
    } else {
      return await _restRequest('Requests', reqs);
    }
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
