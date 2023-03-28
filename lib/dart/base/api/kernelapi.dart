import 'dart:async';

import 'package:logging/logging.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/anystore.dart';
import 'package:orginone/dart/base/api/storehub.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/model/user_model.dart';
import 'package:orginone/util/hive_utils.dart';
import 'package:orginone/util/http_util.dart';

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
  static KernelApi getInstance({String url = Constant.kernelHub}) {
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
    dynamic raw;
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('Login', args: [req]);
    } else {
      raw = await _restRequest("login", req);
    }
    var res = ResultType.fromJson(raw);
    if (res.success) {
      HiveUtils.putUser(UserModel.fromJson(raw['data']));
      _anystore.updateToken(res.data["accessToken"]);
    }
    return res;
  }

  /// 注册
  Future<ResultType<dynamic>> register(RegisterType params) async {
    dynamic raw;
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('Register', args: [params]);
    } else {
      raw = await _restRequest('Register', params);
    }
    var res = ResultType.fromJson(raw);
    if (res.success) {
      _anystore.updateToken(res.data ?? "");
    }
    return res;
  }

  Future<ResultType<dynamic>> genToken(String companyId) async {
    dynamic raw;
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('GenToken', args: [companyId]);
    } else {
      raw = await _restRequest('gentoken', companyId);
    }
    var res = ResultType.fromJson(raw);
    if (res.success) {
      _anystore.updateToken(res.data ?? "");
    }
    return res;
  }

  /// 创建字典类型
  /// @param {DictModel} params 请求参数
  /// @returns {ResultType<XDict>} 请求结果
  Future<ResultType<XDict>> createDict(DictModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateDict',
        params: params,
      ),
      XDict.fromJson,
    );
  }

  /// 创建业务标准
  /// @param {DictModel} params 请求参数
  /// @returns {ResultType<XOperation>} 请求结果
  Future<ResultType<XOperation>> createOperation(OperationModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateOperation',
        params: params,
      ),
      XOperation.fromJson,
    );
  }

  /*
   * 创建业务标准子项
   * @param {model.OperationItemModel} params 请求参数
   * @returns {model.ResultType<boolean>} 请求结果
   */
  Future<ResultType<bool>> createOperationItems(
      OperationItemModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateOperationItems',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 创建日志记录
  /// @param {LogModel} params 请求参数
  /// @returns {ResultType<XLog>} 请求结果
  Future<ResultType<XLog>> createLog(LogModel params) async {
    return await request(
      ReqestType(
        module: 'base',
        action: 'CreateLog',
        params: params,
      ),
      XLog.fromJson,
    );
  }

  /// 创建字典项
  /// @param {DictItemModel} params 请求参数
  /// @returns {ResultType<XDictItem>} 请求结果
  Future<ResultType<XDictItem>> createDictItem(DictItemModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateDictItem',
        params: params,
      ),
      XDictItem.fromJson,
    );
  }

  /// 删除字典类型
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDict(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteDict',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除业务标准
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteOperation(IdReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteOperation',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除字典项
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDictItem(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteDictItem',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 更新字典类型
  /// @param {DictModel} params 请求参数
  /// @returns {ResultType<XDict>} 请求结果
  Future<ResultType<XDict>> updateDict(DictModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateDict',
        params: params,
      ),
      XDict.fromJson,
    );
  }

  /// 更新字典项
  /// @param {DictItemModel} params 请求参数
  /// @returns {ResultType<XDictItem>} 请求结果
  Future<ResultType<XDictItem>> updateDictItem(DictItemModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateDictItem',
        params: params,
      ),
      XDictItem.fromJson,
    );
  }

  /*
   * 根据id查询分类
   * @param {model.IdArrayReq} params 请求参数
   * @returns {model.ResultType<schema.XSpeciesArray>} 请求结果
   */
  Future<ResultType<XSpeciesArray>> querySpeciesById(IdArrayReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QuerySpeciesById',
        params: params,
      ),
      XSpeciesArray.fromJson,
    );
  }

  /// 更新字典项
  /// @param {DictItemModel} params 请求参数
  /// @returns {ResultType<XDictItem>} 请求结果
  Future<ResultType<XDictItemArray>> queryDictItems(IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QueryDictItems',
        params: params,
      ),
      XDictItemArray.fromJson,
    );
  }

  /// 创建类别
  /// @param {SpeciesModel} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> createSpecies(SpeciesModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateSpecies',
        params: params,
      ),
      XSpecies.fromJson,
    );
  }

  /// 创建度量标准
  /// @param {AttributeModel} params 请求参数
  /// @returns {ResultType<XAttribute>} 请求结果
  Future<ResultType<XAttribute>> createAttribute(AttributeModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateAttribute',
        params: params,
      ),
      XAttribute.fromJson,
    );
  }

  /// 创建物
  /// @param {ThingModel} params 请求参数
  /// @returns {ResultType<XThing>} 请求结果
  Future<ResultType<XThing>> createThing(ThingModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'CreateThing',
        params: params,
      ),
      XThing.fromJson,
    );
  }

  /// 删除类别
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteSpecies(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteSpecies',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除度量标准
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteAttribute(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteAttribute',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除物
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteThing(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'DeleteThing',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 更新类别
  /// @param {SpeciesModel} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> updateSpecies(SpeciesModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateSpecies',
        params: params,
      ),
      XSpecies.fromJson,
    );
  }

  /// 更新度量标准
  /// @param {AttributeModel} params 请求参数
  /// @returns {ResultType<XAttribute>} 请求结果
  Future<ResultType<XAttribute>> updateAttribute(AttributeModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateAttribute',
        params: params,
      ),
      XAttribute.fromJson,
    );
  }

  /// 更新度量标准
  /// @param {AttributeModel} params 请求参数
  /// @returns {ResultType<XAttribute>} 请求结果
  Future<ResultType<XOperation>> updateOperation(OperationModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateOperation',
        params: params,
      ),
      XOperation.fromJson,
    );
  }

  /// 更新物
  /// @param {ThingModel} params 请求参数
  /// @returns {ResultType<XThing>} 请求结果
  Future<ResultType<XThing>> updateThing(ThingModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'UpdateThing',
        params: params,
      ),
      XThing.fromJson,
    );
  }

  /// 物添加类别
  /// @param {ThingSpeciesModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingAddSpecies(ThingSpeciesModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'ThingAddSpecies',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 物添加度量数据
  /// @param {ThingAttrModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingAddAttribute(ThingAttrModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'ThingAddAttribute',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 物移除类别
  /// @param {ThingSpeciesModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingRemoveSpecies(ThingSpeciesModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'ThingRemoveSpecies',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 物移除度量数据
  /// @param {ThingAttrModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> thingRemoveAttribute(ThingAttrModel params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'ThingRemoveAttribute',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 查询分类树
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XSpecies>} 请求结果
  Future<ResultType<XSpecies>> querySpeciesTree(String id) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QuerySpeciesTree',
        params: {
          "id":id,
          "page": {
            "filter": "",
          },
        },
      ),
      XSpecies.fromJson,
    );
  }

  /*
   * 查询分类字典
   * @param {model.IdSpeciesReq} params 请求参数
   * @returns {model.ResultType<schema.XDictArray>} 请求结果
   */
  Future<ResultType<XDictArray>> querySpeciesDict(IdSpeciesReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QuerySpeciesDict',
        params: params,
      ),
      XDictArray.fromJson,
    );
  }

  /// 查询分类的度量标准
  /// @param {IdSpeciesReq} params 请求参数
  /// @returns {ResultType<XAttributeArray>} 请求结果
  Future<ResultType<XAttributeArray>> querySpeciesAttrs(
      IdSpeciesReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QuerySpeciesAttrs',
        params: params,
      ),
      XAttributeArray.fromJson,
    );
  }

  /// 查询分类的业务标准
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XOperationArray>} 请求结果
  Future<ResultType<XOperationArray>> querySpeciesOperation(
      IdOperationReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QuerySpeciesOperation',
        params: params,
      ),
      XOperationArray.fromJson,
    );
  }

  /// 物的元数据查询
  /// @param {ThingAttrReq} params 请求参数
  /// @returns {ResultType<XThingAttrArray>} 请求结果
  Future<ResultType<XThingAttrArray>> queryThingData(
      ThingAttrReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QueryThingData',
        params: params,
      ),
      XThingAttrArray.fromJson,
    );
  }

  /// 物的历史元数据查询
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XThingAttrHistroyArray>} 请求结果
  Future<ResultType<XThingAttrHistroyArray>> queryThingHistroyData(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QueryThingHistroyData',
        params: params,
      ),
      XThingAttrHistroyArray.fromJson,
    );
  }

  /// 物的关系元数据查询
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryThingRelationData(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'thing',
        action: 'QueryThingRelationData',
        params: params,
      ),
      XRelationArray.fromJson,
    );
  }

  /// 创建职权
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> createAuthority(AuthorityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'CreateAuthority',
        params: params,
      ),
      XAuthority.fromJson,
    );
  }

  /// 创建身份
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> createIdentity(IdentityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'CreateIdentity',
        params: params,
      ),
      XIdentity.fromJson,
    );
  }

  /// 创建组织/个人
  /// @param {TargetModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> createTarget(TargetModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'CreateTarget',
        params: params,
      ),
      XTarget.fromJson,
    );
  }

  /// 创建标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<XRuleStd>} 请求结果
  Future<ResultType<XRuleStd>> createRuleStd(RuleStdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'CreateRuleStd',
        params: params,
      ),
      XRuleStd.fromJson,
    );
  }

  /// 删除职权
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteAuthority(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteAuthority',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除身份
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteIdentity(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteIdentity',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除组织/个人
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteTarget(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteTarget',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteRuleStd(RuleStdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteRuleStd',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 递归删除组织/个人
  /// @param {RecursiveReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveDeleteTarget(
      RecursiveReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RecursiveDeleteTarget',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 更新职权
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> updateAuthority(AuthorityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'UpdateAuthority',
        params: params,
      ),
      XAuthority.fromJson,
    );
  }

  /// 更新身份
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> updateIdentity(IdentityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'UpdateIdentity',
        params: params,
      ),
      XIdentity.fromJson,
    );
  }

  /// 更新组织/个人
  /// @param {TargetModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> updateTarget(TargetModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'UpdateTarget',
        params: params,
      ),
      XTarget.fromJson,
    );
  }

  /// 更新标准规则
  /// @param {RuleStdModel} params 请求参数
  /// @returns {ResultType<XRuleStd>} 请求结果
  Future<ResultType<XRuleStd>> updateRuleStd(RuleStdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'UpdateRuleStd',
        params: params,
      ),
      XRuleStd.fromJson,
    );
  }

  /// 分配身份
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> giveIdentity(GiveIdentityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'GiveIdentity',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 移除身份
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeIdentity(GiveIdentityModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveIdentity',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 申请加入组织/个人
  /// @param {JoinTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> applyJoinTeam(JoinTeamModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'ApplyJoinTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 加入组织/个人申请审批
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<XRelation>} 请求结果
  Future<ResultType<XRelation>> joinTeamApproval(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'JoinTeamApproval',
        params: params,
      ),
      XRelation.fromJson,
    );
  }

  /// 拉组织/个人加入组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> pullAnyToTeam(TeamPullModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'PullAnyToTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 取消申请加入组织/个人
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelJoinTeam(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'CancelJoinTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 重置密码
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> resetPassword(ResetPwdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'ResetPassword',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /*
   * 查询组织容器下的身份集
   * @param {IDBelongReq} params 请求参数
   * @returns {ResultType<schema.XIdentityArray>} 请求结果
   */
  Future<ResultType<XIdentityArray>> queryTeamIdentitys(
    IDBelongReq params,
  ) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTeamIdentitys',
        params: params,
      ),
      XIdentityArray.fromJson,
    );
  }

  /*
   * 拉身份加入组织
   * @param {TeamPullModel} params 请求参数
   * @returns {ResultType<boolean>} 请求结果
   */
  Future<ResultType<bool>> pullIdentityToTeam(
    TeamPullModel params,
  ) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'PullIdentityToTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /*
   * 从组织身份集中剔除身份
   * @param {TeamPullModel} params 请求参数
   * @returns {ResultType<boolean>} 请求结果
   */
  Future<ResultType<bool>> removeTeamIdentity(
    GiveIdentityModel params,
  ) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveTeamIdentity',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 从组织/个人移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeAnyOfTeam(TeamPullModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveAnyOfTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 递归从组织及子组织/个人移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveRemoveAnyOfTeam(
      TeamPullModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RecursiveRemoveAnyOfTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 从组织/个人及归属组织移除组织/个人的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeAnyOfTeamAndBelong(
      TeamPullModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveAnyOfTeamAndBelong',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 退出组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> exitAnyOfTeam(ExitTeamModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'ExitAnyOfTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 递归退出组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> recursiveExitAnyOfTeam(ExitTeamModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RecursiveExitAnyOfTeam',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 退出组织及退出组织归属的组织
  /// @param {ExitTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> exitAnyOfTeamAndBelong(ExitTeamModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'ExitAnyOfTeamAndBelong',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 根据ID查询组织/个人信息
  /// @param {IdArrayReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryTargetById(IdArrayReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTargetById',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询加入关系
  /// @param {RelationReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryRelationById(
      RelationReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryRelationById',
        params: params,
      ),
      XRelationArray.fromJson,
    );
  }

  /// 根据名称和类型查询组织/个人
  /// @param {NameTypeModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> queryTargetByName(NameTypeModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTargetByName',
        params: params,
      ),
      XTarget.fromJson,
    );
  }

  /// 模糊查找组织/个人根据名称和类型
  /// @param {NameTypeModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> searchTargetByName(
      NameTypeModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'SearchTargetByName',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询组织制定的标准
  /// @param {IDBelongTargetReq} params 请求参数
  /// @returns {ResultType<XAttributeArray>} 请求结果
  Future<ResultType<XAttributeArray>> queryTeamRuleAttrs(
      IDBelongTargetReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTeamRuleAttrs',
        params: params,
      ),
      XAttributeArray.fromJson,
    );
  }

  /// 根据ID查询子组织/个人
  /// @param {IDReqSubModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> querySubTargetById(
      IDReqSubModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QuerySubTargetById',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 根据ID查询归属的组织/个人
  /// @param {IDReqSubModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryBelongTargetById(
      IDReqSubModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryBelongTargetById',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询组织/个人加入的组织/个人
  /// @param {IDReqJoinedModel} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryJoinedTargetById(
      IDReqJoinedModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryJoinedTargetById',
        params: params.toJson(),
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询加入组织/个人申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryJoinTeamApply(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryJoinTeamApply',
        params: params,
      ),
      XRelationArray.fromJson,
    );
  }

  /// 查询组织/个人加入审批
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XRelationArray>} 请求结果
  Future<ResultType<XRelationArray>> queryTeamJoinApproval(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTeamJoinApproval',
        params: params,
      ),
      XRelationArray.fromJson,
    );
  }

  /// 查询组织职权树
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> queryAuthorityTree(IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryAuthorityTree',
        params: params,
      ),
      XAuthority.fromJson,
    );
  }

  /// 查询组织身份
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> queryTargetIdentitys(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTargetIdentitys',
        params: params,
      ),
      XIdentityArray.fromJson,
    );
  }

  /// 查询职权身份
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> queryAuthorityIdentitys(
      IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryAuthorityIdentitys',
        params: params,
      ),
      XIdentityArray.fromJson,
    );
  }

  /*
   * 查询拥有的职权
   * @param {model.PageRequest} params 请求参数
   * @returns {model.ResultType<schema.XAuthorityArray>} 请求结果
   */
  Future<ResultType<XAuthorityArray>> queryOwnAuthoritys(
      PageRequest params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryOwnAuthoritys',
        params: params,
      ),
      XAuthorityArray.fromJson,
    );
  }

  /*
   * 查询职权下的所有人员
   * @param {model.PageRequest} params 请求参数
   * @returns {model.ResultType<schema.XTargetArray>} 请求结果
   */
  Future<ResultType<XTargetArray>> queryAuthorityPerson(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryAuthorityPerson',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询赋予身份的组织/个人
  /// @param {IDBelongTargetReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryIdentityTargets(
      IDBelongTargetReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryIdentityTargets',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询在当前空间拥有角色的组织
  /// @param {SpaceAuthReq} params 请求参数
  /// @returns {ResultType<XTargetArray>} 请求结果
  Future<ResultType<XTargetArray>> queryTargetsByAuthority(
      SpaceAuthReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QueryTargetsByAuthority',
        params: params,
      ),
      XTargetArray.fromJson,
    );
  }

  /// 查询在当前空间拥有的身份
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XIdentityArray>} 请求结果
  Future<ResultType<XIdentityArray>> querySpaceIdentitys(IdReq params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'QuerySpaceIdentitys',
        params: params,
      ),
      XIdentityArray.fromJson,
    );
  }

  /// 创建即使消息
  /// @param {ImMsgModel} params 请求参数
  /// @returns {ResultType<XImMsg>} 请求结果
  Future<ResultType<XImMsg>> createImMsg(ImMsgModel params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'CreateImMsg',
        params: params,
      ),
      XImMsg.fromJson,
    );
  }

  /// 消息撤回
  /// @param {XImMsg} params 请求参数
  /// @returns {ResultType<XImMsg>} 请求结果
  Future<ResultType<XImMsg>> recallImMsg(XImMsg params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'RecallImMsg',
        params: params,
      ),
      XImMsg.fromJson,
    );
  }

  /// 查询聊天会话
  /// @param {ChatsReqModel} params 请求参数
  /// @returns {ResultType<ChatResponse>} 请求结果
  Future<ResultType<ChatResponse>> queryImChats(ChatsReqModel params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'QueryImChats',
        params: params,
      ),
      ChatResponse.fromJson,
    );
  }

  /// 查询群历史消息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XImMsgArray>} 请求结果
  Future<ResultType<XImMsgArray>> queryCohortImMsgs(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'QueryCohortImMsgs',
        params: params,
      ),
      XImMsgArray.fromJson,
    );
  }

  /// 查询好友聊天消息
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XImMsgArray>} 请求结果
  Future<ResultType<XImMsgArray>> queryFriendImMsgs(IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'QueryFriendImMsgs',
        params: params,
      ),
      XImMsgArray.fromJson,
    );
  }

  /// 根据ID查询名称
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<NameModel>} 请求结果
  Future<ResultType<NameModel>> queryNameBySnowId(IdReq params) async {
    return await request(
      ReqestType(
        module: 'chat',
        action: 'QueryNameBySnowId',
        params: params,
      ),
      NameModel.fromJson,
    );
  }

  /// 创建市场
  /// @param {MarketModel} params 请求参数
  /// @returns {ResultType<XMarket>} 请求结果
  Future<ResultType<XMarket>> createMarket(MarketModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateMarket',
        params: params,
      ),
      XMarket.fromJson,
    );
  }

  /// 产品上架:产品所有者
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> createMerchandise(
      MerchandiseModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateMerchandise',
        params: params,
      ),
      XMerchandise.fromJson,
    );
  }

  /// 创建产品
  /// @param {ProductModel} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> createProduct(ProductModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateProduct',
        params: params,
      ),
      XProduct.fromJson,
    );
  }

  /// 创建产品资源
  /// @param {ResourceModel} params 请求参数
  /// @returns {ResultType<XResource>} 请求结果
  Future<ResultType<XResource>> createProductResource(
      ResourceModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateProductResource',
        params: params,
      ),
      XResource.fromJson,
    );
  }

  /// 商品加入暂存区
  /// @param {StagingModel} params 请求参数
  /// @returns {ResultType<XStaging>} 请求结果
  Future<ResultType<XStaging>> createStaging(StagingModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateStaging',
        params: params,
      ),
      XStaging.fromJson,
    );
  }

  /// 创建订单:商品直接购买
  /// @param {OrderModel} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> createOrder(OrderModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateOrder',
        params: params,
      ),
      XOrder.fromJson,
    );
  }

  /// 创建订单:暂存区下单
  /// @param {OrderModelByStags} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> createOrderByStags(
      OrderModelByStags params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateOrderByStags',
        params: params,
      ),
      XOrder.fromJson,
    );
  }

  /// 创建订单支付
  /// @param {OrderPayModel} params 请求参数
  /// @returns {ResultType<XOrderPay>} 请求结果
  Future<ResultType<XOrderPay>> createOrderPay(OrderPayModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateOrderPay',
        params: params,
      ),
      XOrderPay.fromJson,
    );
  }

  /// 创建对象拓展操作
  /// @param {SourceExtendModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> createSourceExtend(SourceExtendModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CreateSourceExtend',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMarket(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteMarket',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 下架商品:商品所有者
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMerchandise(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteMerchandise',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 下架商品:市场管理员
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteMerchandiseByManager(
      IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteMerchandiseByManager',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除产品
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteProduct(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteProduct',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除产品资源(产品所属者可以操作)
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteProductResource(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteProductResource',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 移除暂存区商品
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteStaging(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteStaging',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 创建对象拓展操作
  /// @param {SourceExtendModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteSourceExtend(SourceExtendModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeleteSourceExtend',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 根据Code查询市场
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> queryMarketByCode(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryMarketByCode',
        params: params,
      ),
      XMarketArray.fromJson,
    );
  }

  /// 查询拥有的市场
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> queryOwnMarket(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryOwnMarket',
        params: params,
      ),
      XMarketArray.fromJson,
    );
  }

  /// 查询软件共享仓库的市场
  /// @returns {ResultType<XMarketArray>} 请求结果
  Future<ResultType<XMarketArray>> getPublicMarket() async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'GetPublicMarket',
        params: {},
      ),
      XMarketArray.fromJson,
    );
  }

  /// 查询市场成员集合
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryMarketMember(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryMarketMember',
        params: params,
      ),
      XMarketRelationArray.fromJson,
    );
  }

  /// 查询市场对应的暂存区
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XStagingArray>} 请求结果
  Future<ResultType<XStagingArray>> queryStaging(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryStaging',
        params: params,
      ),
      XStagingArray.fromJson,
    );
  }

  /// 根据ID查询订单信息
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> getOrderInfo(IdReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'GetOrderInfo',
        params: params,
      ),
      XOrder.fromJson,
    );
  }

  /// 根据ID查询订单详情项
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XOrderDetail>} 请求结果
  Future<ResultType<XOrderDetail>> getOrderDetailById(
      IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'GetOrderDetailById',
        params: params,
      ),
      XOrderDetail.fromJson,
    );
  }

  /// 卖方:查询出售商品的订单列表
  /// @param {IDStatusPageReq} params 请求参数
  /// @returns {ResultType<XOrderDetailArray>} 请求结果
  Future<ResultType<XOrderDetailArray>> querySellOrderList(
      IDStatusPageReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QuerySellOrderList',
        params: params,
      ),
      XOrderDetailArray.fromJson,
    );
  }

  /// 卖方:查询指定商品的订单列表
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XOrderDetailArray>} 请求结果
  Future<ResultType<XOrderDetailArray>> querySellOrderListByMerchandise(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QuerySellOrderListByMerchandise',
        params: params,
      ),
      XOrderDetailArray.fromJson,
    );
  }

  /// 买方:查询购买订单列表
  /// @param {IDStatusPageReq} params 请求参数
  /// @returns {ResultType<XOrderArray>} 请求结果
  Future<ResultType<XOrderArray>> queryBuyOrderList(
      IDStatusPageReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryBuyOrderList',
        params: params,
      ),
      XOrderArray.fromJson,
    );
  }

  /// 查询订单支付信息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XOrderPayArray>} 请求结果
  Future<ResultType<XOrderPayArray>> queryPayList(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryPayList',
        params: params,
      ),
      XOrderPayArray.fromJson,
    );
  }

  /// 申请者:查询加入市场申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryJoinMarketApply(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryJoinMarketApply',
        params: params,
      ),
      XMarketRelationArray.fromJson,
    );
  }

  /// 查询加入市场审批
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryJoinApproval(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryJoinApproval',
        params: params,
      ),
      XMarketRelationArray.fromJson,
    );
  }

  /// 管理者:查询加入市场申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelationArray>} 请求结果
  Future<ResultType<XMarketRelationArray>> queryJoinMarketApplyByManager(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryJoinMarketApplyByManager',
        params: params,
      ),
      XMarketRelationArray.fromJson,
    );
  }

  /// 申请者:查询商品上架申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiseApply(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryMerchandiseApply',
        params: params,
      ),
      XMerchandiseArray.fromJson,
    );
  }

  /// 市场:查询商品上架申请
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiesApplyByManager(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryMerchandiesApplyByManager',
        params: params,
      ),
      XMerchandiseArray.fromJson,
    );
  }

  /// 查询市场中所有商品
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> searchMerchandise(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'SearchMerchandise',
        params: params,
      ),
      XMerchandiseArray.fromJson,
    );
  }

  /// 查询产品详细信息
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> getProductInfo(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'GetProductInfo',
        params: params,
      ),
      XProduct.fromJson,
    );
  }

  /// 查询产品资源列表
  /// @param {IDWithBelongPageReq} params 请求参数
  /// @returns {ResultType<XResourceArray>} 请求结果
  Future<ResultType<XResourceArray>> queryProductResource(
      IDWithBelongPageReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryProductResource',
        params: params,
      ),
      XResourceArray.fromJson,
    );
  }

  /// 查询组织/个人产品
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XProductArray>} 请求结果
  Future<ResultType<XProductArray>> querySelfProduct(IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QuerySelfProduct',
        params: params,
      ),
      XProductArray.fromJson,
    );
  }

  /// 根据产品查询商品上架信息
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryMerchandiseListByProduct(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryMerchandiseListByProduct',
        params: params,
      ),
      XMerchandiseArray.fromJson,
    );
  }

  /// 查询指定产品/资源的拓展信息
  /// @param {SearchExtendReq} params 请求参数
  /// @returns {ResultType<IdNameArray>} 请求结果
  Future<ResultType<IdNameArray>> queryExtendBySource(
      SearchExtendReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryExtendBySource',
        params: params,
      ),
      IdNameArray.fromJson,
    );
  }

  /// 查询可用产品
  /// @param {UsefulProductReq} params 请求参数
  /// @returns {ResultType<XProductArray>} 请求结果
  Future<ResultType<XProductArray>> queryUsefulProduct(
      UsefulProductReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryUsefulProduct',
        params: params,
      ),
      XProductArray.fromJson,
    );
  }

  /// 查询可用资源列表
  /// @param {UsefulResourceReq} params 请求参数
  /// @returns {ResultType<XResourceArray>} 请求结果
  Future<ResultType<XResourceArray>> queryUsefulResource(
      UsefulResourceReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryUsefulResource',
        params: params,
      ),
      XResourceArray.fromJson,
    );
  }

  /// 更新市场
  /// @param {MarketModel} params 请求参数
  /// @returns {ResultType<XMarket>} 请求结果
  Future<ResultType<XMarket>> updateMarket(MarketModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateMarket',
        params: params,
      ),
      XMarket.fromJson,
    );
  }

  /// 更新商品信息
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> updateMerchandise(
      MerchandiseModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateMerchandise',
        params: params,
      ),
      XMerchandise.fromJson,
    );
  }

  /// 更新产品
  /// @param {ProductModel} params 请求参数
  /// @returns {ResultType<XProduct>} 请求结果
  Future<ResultType<XProduct>> updateProduct(ProductModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateProduct',
        params: params,
      ),
      XProduct.fromJson,
    );
  }

  /// 更新产品资源
  /// @param {ResourceModel} params 请求参数
  /// @returns {ResultType<XResource>} 请求结果
  Future<ResultType<XResource>> updateProductResource(
      ResourceModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateProductResource',
        params: params,
      ),
      XResource.fromJson,
    );
  }

  /// 更新订单
  /// @param {OrderModel} params 请求参数
  /// @returns {ResultType<XOrder>} 请求结果
  Future<ResultType<XOrder>> updateOrder(OrderModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateOrder',
        params: params,
      ),
      XOrder.fromJson,
    );
  }

  /// 更新订单项
  /// @param {OrderDetailModel} params 请求参数
  /// @returns {ResultType<XOrderDetail>} 请求结果
  Future<ResultType<XOrderDetail>> updateOrderDetail(
      OrderDetailModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'UpdateOrderDetail',
        params: params,
      ),
      XOrderDetail.fromJson,
    );
  }

  /// 退出市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> quitMarket(IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QuitMarket',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 申请加入市场
  /// @param {IDWithBelongReq} params 请求参数
  /// @returns {ResultType<XMarketRelation>} 请求结果
  Future<ResultType<XMarketRelation>> applyJoinMarket(
      IDWithBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'ApplyJoinMarket',
        params: params,
      ),
      XMarketRelation.fromJson,
    );
  }

  /// 拉组织/个人加入市场
  /// @param {MarketPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> pullAnyToMarket(MarketPullModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'PullAnyToMarket',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 取消加入市场
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelJoinMarket(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CancelJoinMarket',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 查询上架审批
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<XMerchandiseArray>} 请求结果
  Future<ResultType<XMerchandiseArray>> queryPublicApproval(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'QueryPublicApproval',
        params: params,
      ),
      XMerchandiseArray.fromJson,
    );
  }

  /// 取消订单详情
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> cancelOrderDetail(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CancelOrderDetail',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 移除市场成员
  /// @param {MarketPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeMarketMember(MarketPullModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'RemoveMarketMember',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 审核加入市场申请
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalJoinApply(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'ApprovalJoinApply',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 交付订单详情中的商品
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deliverMerchandise(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'DeliverMerchandise',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 退还商品
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> rejectMerchandise(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'RejectMerchandise',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 商品上架审核
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalMerchandise(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'ApprovalMerchandise',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 产品上架:市场拥有者
  /// @param {MerchandiseModel} params 请求参数
  /// @returns {ResultType<XMerchandise>} 请求结果
  Future<ResultType<XMerchandise>> pullProductToMarket(
      MerchandiseModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'PullProductToMarket',
        params: params,
      ),
      XMerchandise.fromJson,
    );
  }

  /// 创建流程实例(启动流程)
  /// @param {FlowInstanceModel} params 请求参数
  /// @returns {ResultType<XFlowInstance>} 请求结果
  Future<ResultType<XFlowInstance>> createInstance(
      FlowInstanceModel params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'CreateInstance',
        params: params.toJson(),
      ),
      XFlowInstance.fromJson,
    );
  }

  /// 创建流程绑定
  /// @param {FlowRelationModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> createFlowRelation(FlowRelationModel params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'CreateFlowRelation',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除流程定义
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteDefine(IdReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'DeleteDefine',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 删除流程实例(发起人撤回)
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteInstance(IdReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'DeleteInstance',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// 查询流程定义
  /// @param {QueryDefineReq} params 请求参数
  /// @returns {ResultType<XFlowDefineArray>} 请求结果
  Future<ResultType<XFlowDefineArray>> queryDefine(
      QueryDefineReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryDefine',
        params: params.toJson(),
      ),
      XFlowDefineArray.fromJson,
    );
  }

  /*
   * 查询流程节点(复现流程图)
   * @param {model.IdReq} params 请求参数
   * @returns {model.ResultType<schema.XFlowDefineArray>} 请求结果
   */
  Future<ResultType<FlowNode>> queryNodes(IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryNodes',
        params: params,
      ),
      FlowNode.fromJson,
    );
  }

  /**
   * 查询分类的业务标准项
   * @param {model.IdSpaceReq} params 请求参数
   * @returns {model.ResultType<schema.XOperationItemArray>} 请求结果
   */
  Future<ResultType<XOperationItemArray>> queryOperationItems(
      IdSpaceReq params) async {
    return await request(
        ReqestType(
          module: 'thing',
          action: 'QueryOperationItems',
          params: params,
        ),
        XOperationItemArray.fromJson);
  }

  /// 查询流程绑定
  /// @param {IDBelongReq} params 请求参数
  /// @returns {ResultType<XOperationArray>} 请求结果
  Future<ResultType<XOperationArray>> queryDefineRelation(
      IDBelongReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryDefineRelation',
        params: params,
      ),
      XOperationArray.fromJson,
    );
  }

  /// 查询发起的流程实例
  /// @param {FlowReq} params 请求参数
  /// @returns {ResultType<XFlowInstanceArray>} 请求结果
  Future<ResultType<XFlowInstanceArray>> queryInstance(FlowReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryInstance',
        params: params.toJson(),
      ),
      XFlowInstanceArray.fromJson,
    );
  }

  /// 查询待审批任务
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XFlowTaskArray>} 请求结果
  Future<ResultType<XFlowTaskArray>> queryApproveTask(IdReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryApproveTask',
        params: params,
      ),
      XFlowTaskArray.fromJson,
    );
  }

  /// 查询待审阅抄送
  /// @param {IdReq} params 请求参数
  /// @returns {ResultType<XFlowTaskHistoryArray>} 请求结果
  Future<ResultType<XFlowTaskHistoryArray>> queryNoticeTask(
      IdReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryNoticeTask',
        params: params,
      ),
      XFlowTaskHistoryArray.fromJson,
    );
  }

  /// 查询审批记录
  /// @param {IdSpaceReq} params 请求参数
  /// @returns {ResultType<XFlowTaskHistoryArray>} 请求结果
  Future<ResultType<XFlowTaskHistoryArray>> queryRecord(
      IdSpaceReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'QueryRecord',
        params: params.toJson(),
      ),
      XFlowTaskHistoryArray.fromJson,
    );
  }

  /// 流程节点审批
  /// @param {ApprovalTaskReq} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> approvalTask(ApprovalTaskReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'ApprovalTask',
        params: params.toJson(),
      ),
      (item) => item as bool,
    );
  }

  /// 发布流程定义
  /// @param {XFlowDefine} params 请求参数
  /// @returns {ResultType<XFlowDefine>} 请求结果
  Future<ResultType<XFlowDefine>> publishDefine(CreateDefineReq params) async {
    return await request(
      ReqestType(
        module: 'flow',
        action: 'PublishDefine',
        params: params,
      ),
      XFlowDefine.fromJson,
    );
  }

  /// 取消订单
  /// @param {ApprovalModel} params 请求参数
  /// @returns {ResultType<boolean>} 请求结果
  Future<ResultType<bool>> cancelOrder(ApprovalModel params) async {
    return await request(
      ReqestType(
        module: 'market',
        action: 'CancelOrder',
        params: params,
      ),
      (item) => item as bool,
    );
  }

  /// ******* 公共方法 *********///
  /// *** 后续迁移至终端实现 ****///
  /// ****** （资产链）Did *****///

  /// 生成助记词
  /// @param {int} language 请求参数
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> newMnemonic(int language) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'NewMnemonic',
        params: Map.from({"language": language}),
      ),
      null,
    );
  }

  /// 从助记词到私钥
  /// @param {int} index 序号
  /// @param {String} mnemonic 助记词
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> mnemonicToPrivateKey(
      int index, String mnemonic) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'MnemonicToPrivateKey',
        params: Map.from({"index": index, "mnemonic": mnemonic}),
      ),
      null,
    );
  }

  /// 从私钥到公钥
  /// @param {String} privateKey 私钥
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> privateKeyToPublicKey(String privateKey) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'PrivateKeyToPublicKey',
        params: Map.from({"privateKey": privateKey}),
      ),
      null,
    );
  }

  /// 从公钥到地址
  /// @param {String} publicKey 公钥
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> publicKeyToAddress(String publicKey) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'PublicKeyToAddress',
        params: Map.from({"publicKey": publicKey}),
      ),
      null,
    );
  }

  /// 签名
  /// @param {String} privateKey 私钥
  /// @param {String} message 消息
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> signature(
      String privateKey, String message) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'Signature',
        params: Map.from({"privateKey": privateKey, "message": message}),
      ),
      null,
    );
  }

  /// 验签
  /// @param {String} publicKey 公钥
  /// @param {List<int>} signature 签名
  /// @param {String} message 消息
  /// @returns {ResultType<dynamic>} 请求结果
  Future<ResultType<dynamic>> verify(
      String publicKey, String message, List<int> signature) async {
    return await request(
      ReqestType(
        module: 'public',
        action: 'Verify',
        params: Map.from({
          "publicKey": publicKey,
          "message": message,
          "signature": signature,
        }),
      ),
      null,
    );
  }

  Future<ResultType<T>> request<T>(
      ReqestType req, T Function(Map<String, dynamic>)? cvt) async {
    dynamic raw;
    if (_storeHub.isConnected) {
      log.info("====> req:${req.toJson()}");
      raw = await _storeHub.invoke('Request', args: [req]);
    } else {
      raw = await _restRequest('Request', req);
    }
    if (cvt != null) {
      return ResultType.fromJsonSerialize(raw, cvt);
    } else {
      return ResultType.fromJson(raw);
    }
  }

  Future<dynamic> requests<T>(List<ReqestType> reqs) async {
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
