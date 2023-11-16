import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/storehub.dart';
import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/common/emitter.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';
import 'package:orginone/utils/hive_utils.dart';
import 'package:orginone/utils/http_util.dart';
import 'package:orginone/utils/index.dart';
import 'package:orginone/utils/logger.dart';
import 'package:orginone/utils/toast_utils.dart';

class KernelApi {
  // 当前用户
  String userId = '';
// 存储集线器
  final StoreHub _storeHub;
  // axios实例
  final _http = HttpUtil();
  // 单例
  static KernelApi? _instance;
  // 单例
  // 必达消息缓存
  final Map<String, dynamic> _cacheData = {};

  // 订阅方法
  final Map<String, List<Function>> _methods;
  // 订阅方法
  final Map<String, List<Map<String, dynamic>>> _subMethods;

  // 上下线提醒
  final Emitter onlineNotify = Emitter(); //////
  // 在线的连接
  List<String> onlineIds = [];
  factory KernelApi() {
    _instance ??= KernelApi._(Constant.kernelHub);
    return _instance!;
  }

  KernelApi._(String url)
      : _methods = {},
        _subMethods = {},
        _storeHub = StoreHub(url, protocol: 'json') {
    _storeHub.on("Receive", (res) => _receive(res));

    _storeHub.onConnected(() {
      if (accessToken.isNotEmpty) {
        _storeHub.invoke("TokenAuth", args: [accessToken]).then((value) {
          ResultType res = value;
          if (res.success) {
            logger.info('连接到内核成功!');
          }
        }).catchError((err) {
          logger.warning(err);
        });
      }
    });
    start();
  }

// 获取accessToken
  String get accessToken {
    return Storage().getString('accessToken');
  }

  // 设置accessToken
  set setToken(String val) {
    Storage().setString('accessToken', val);
  }

  /// 实时获取连接状态
  /// @param callback
  onConnectedChanged(Function(dynamic) callback) async {
    Function.apply(callback, [_storeHub.isConnected]);
    _storeHub.onDisconnected(Function.apply(callback, [false]));
    _storeHub.onConnected(() => Function.apply(callback, [true]));
  }

  /// 获取单例
  /// @param {string} url 集线器地址，默认为 "/orginone/kernel/hub"
  /// @returns {KernelApi} 内核api单例
  static getInstance(String url) {
    _instance ??= KernelApi._(Constant.kernelHub);
    return _instance!;
  }

  /// 是否在线
  /// @returns {boolean} 在线状态
  bool get isOnline {
    return _storeHub.isConnected;
  }

  void restart() {
    _storeHub.restart();
  }

  Future<void> stop() async {
    _methods.clear();

    await _storeHub.dispose();
    _instance = null;
  }

  Future<void> disconnect() async {
    _storeHub.disconnect();
  }

  start() {
    _storeHub.start();
  }

  /// 连接信息
  Future<OnlineSet?> onlines() async {
    if (onlineIds.isNotEmpty) {
      var result = await _storeHub.invoke('Online');
      if (result.success && result.data != null) {
        var data = result.data as OnlineSet;
        var uids = data.users?.map((i) => i.connectionId).toList() ?? [];
        var sids = data.storages?.map((i) => i.connectionId).toList() ?? [];
        var ids = [...uids, ...sids];
        if (ids.length != onlineIds.length) {
          onlineIds = ids;
          onlineNotify.changCallback();
        }
        onlineIds = ids;
        return result.data;
      }
    }
    return null;
  }

  /// 登录到后台核心获取accessToken
  /// @param userName 用户名
  /// @param password 密码
  /// @returns Future<ResultType<dynamic>> 异步登录结果

  Future<ResultType<dynamic>> login(String userName, String password) async {
    Map<String, dynamic> req = {
      'module': 'auth',
      'action': 'Login',
      'params': {
        "account": userName,
        "password": password,
      },
    };
    dynamic raw;
    // if (_storeHub.isConnected) {
    raw = await _storeHub.invoke('Auth', args: [req]);
    // } else {
    //   raw = await _restRequest('Auth', req);
    // }

    var res = raw is ResultType ? raw : ResultType.fromJson(raw);
    if (res.success) {
      HiveUtils.putUser(UserModel.fromJson(res.data));
      setToken = res.data["accessToken"];
    }
    return res;
  }

  /// 重置密码
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType> resetPassword(
    String userName,
    String password,
    String privateKey,
  ) async {
    var req = {
      "account": userName,
      "password": password,
      "privateKey": privateKey
    };
    ResultType res;
    if (_storeHub.isConnected) {
      res = await _storeHub.invoke('ResetPassword', args: [req]);
    } else {
      res = await _restRequest("resetpassword", req);
    }

    return res;
  }

  /// 注册到后台核心获取accessToken
  /// @param name 姓名
  /// @param motto 座右铭
  /// @param phone 电话
  /// @param account 账户
  /// @param password 密码
  /// @param nickName 昵称
  /// @returns {Promise<model.ResultType<any>>} 异步注册结果

  Future<ResultType<dynamic>> register(RegisterType params) async {
    dynamic res;
    if (_storeHub.isConnected) {
      res = await _storeHub.invoke('Register', args: [params]);
    } else {
      res = await _restRequest('Register', params);
    }

    var model = ResultType.fromJson(res);
    if (res.success) {
      // ToastUtils.showMsg(msg: "私有key---${res.data['privateKey']}");
    } else {
      ToastUtils.showMsg(msg: res.msg);
    }
    return model;
  }

  /// 激活存储
  Future<ResultType<XEntity>> activateStorage(GainModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'ActivateStorage',
          params: params,
        ), (data) {
      return XEntity.fromJson(data);
    });
  }

  /// 根据ID查询实体信息
  /// @param {model.IdModel} params 请求参数
  /// @returns {model.ResultType<schema.XEntity>} 请求结果
  Future<ResultType<XEntity>> queryEntityById(IdModel params) async {
    return await request(
        ReqestType(
          module: 'core',
          action: 'QueryEntityById',
          params: params,
        ), (data) {
      return XEntity.fromJson(data);
    });
  }

  /// 创建权限
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> createAuthority(AuthorityModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'CreateAuthority',
          params: params,
        ), (data) {
      return XAuthority.fromJson(data);
    });
  }

  /// 创建角色
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> createIdentity(IdentityModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'CreateIdentity',
          params: params,
        ), (data) {
      return XIdentity.fromJson(data);
    });
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
        ), (data) {
      return XTarget.fromJson(data);
    });
  }

  /// 删除权限
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteAuthority(IdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteAuthority',
        params: params,
      ),
    );
  }

  /// 删除角色
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteIdentity(IdReqModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteIdentity',
        params: params,
      ),
    );
  }

  /// 删除组织/个人
  /// @param {IdReqModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> deleteTarget(IdModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'DeleteTarget',
        params: params,
      ),
    );
  }

  /// 更新权限
  /// @param {AuthorityModel} params 请求参数
  /// @returns {ResultType<XAuthority>} 请求结果
  Future<ResultType<XAuthority>> updateAuthority(AuthorityModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'UpdateAuthority',
          params: params,
        ), (data) {
      return XAuthority.fromJson(data);
    });
  }

  /// 更新角色
  /// @param {IdentityModel} params 请求参数
  /// @returns {ResultType<XIdentity>} 请求结果
  Future<ResultType<XIdentity>> updateIdentity(IdentityModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'UpdateIdentity',
          params: params,
        ), (data) {
      return XIdentity.fromJson(data);
    });
  }

  /// 更新用户
  /// @param {TargetModel} params 请求参数
  /// @returns {ResultType<XTarget>} 请求结果
  Future<ResultType<XTarget>> updateTarget(TargetModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'UpdateTarget',
          params: params.toJson(),
        ), (data) {
      return XTarget.fromJson(data);
    });
  }

  /// 分配身份
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> giveIdentity(GiveModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'GiveIdentity',
        params: params,
      ),
    );
  }

  /// 移除角色
  /// @param {GiveIdentityModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> removeIdentity(GiveModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveIdentity',
        params: params,
      ),
    );
  }

  /// 申请加入组织/个人
  /// @param {JoinTeamModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<bool>> applyJoinTeam(GainModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'ApplyJoinTeam',
        params: params,
      ),
    );
  }

  ///  拉入用户的团队
  /// @param {TeamPullModel} params 请求参数
  /// @returns {ResultType<bool>} 请求结果
  Future<ResultType<List<String>>> pullAnyToTeam(GiveModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'PullAnyToTeam',
        params: params,
      ),
    );
  }

  /// 移除或退出用户的团队
  /// @param {model.GainModel} params 请求参数
  /// @returns {model.ResultType<boolean>} 请求结果
  Future<ResultType<bool>> removeOrExitOfTeam(GainModel params) async {
    return await request(
      ReqestType(
        module: 'target',
        action: 'RemoveOrExitOfTeam',
        params: params,
      ),
    );
  }

  /// 根据ID查询用户信息
  /// @param {model.IdArrayModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> queryTargetById(
      IdArrayModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryTargetById',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 模糊查找用户
  /// @param {model.SearchModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> searchTargets(
      SearchModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'SearchTargets',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 根据ID查询子用户
  /// @param {model.GetSubsModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> querySubTargetById(
      GetSubsModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QuerySubTargetById',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 查询用户加入的用户
  /// @param {model.GetJoinedModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> queryJoinedTargetById(
      GetJoinedModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryJoinedTargetById',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 查询组织权限树
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<schema.XAuthority>} 请求结果
  Future<ResultType<XAuthority>> queryAuthorityTree(IdPageModel params) async {
    return await request(
        ReqestType(
          module: 'target',
          action: 'QueryAuthorityTree',
          params: params,
        ), (data) {
      return XAuthority.fromJson(data);
    });
  }

  /// 查询拥有权限的成员
  /// @param {model.GainModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> queryAuthorityTargets(
      GainModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryAuthorityTargets',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 查询组织身份
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XIdentity>>} 请求结果
  Future<ResultType<PageResult<XIdentity>>> queryTargetIdentitys(
      IdPageModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryTargetIdentitys',
          params: params,
        ), (data) {
      return XIdentity.fromList(data);
    });
  }

  /// 查询赋予身份的用户
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> queryIdentityTargets(
      IdPageModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryIdentityTargets',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 查询在当前空间拥有权限的组织
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XTarget>>} 请求结果
  Future<ResultType<PageResult<XTarget>>> queryTargetsByAuthority(
      IdPageModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryTargetsByAuthority',
          params: params,
        ), (data) {
      return XTarget.fromList(data);
    });
  }

  /// 查询赋予的身份
  /// @returns {model.ResultType<model.PageResult<schema.XIdProof>>} 请求结果
  Future<ResultType<PageResult<XIdProof>>> queryGivedIdentitys() async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryGivedIdentitys',
          params: {},
        ), (data) {
      return XIdProof.fromList(data);
    });
  }

  /// 查询组织身份集
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XIdentity>>} 请求结果
  Future<ResultType<PageResult<XIdentity>>> queryTeamIdentitys(
    IdPageModel params,
  ) async {
    return await requestPageResult(
        ReqestType(
          module: 'target',
          action: 'QueryTeamIdentitys',
          params: params,
        ), (data) {
      return XIdentity.fromList(data);
    });
  }

  /// 创建办事定义
  /// @param {model.WorkDefineModel} params 请求参数
  /// @returns {model.ResultType<schema.XWorkDefine>} 请求结果

  Future<ResultType<XWorkDefine>> createWorkDefine(
      WorkDefineModel params) async {
    return await request(
        ReqestType(
          module: 'work',
          action: 'CreateWorkDefine',
          params: params,
        ), (data) {
      return XWorkDefine.fromJson(data);
    });
  }

  /// 创建办事实例(启动办事)
  /// @param {model.WorkInstanceModel} params 请求参数
  /// @returns {model.ResultType<schema.XWorkInstance>} 请求结果

  Future<ResultType<XWorkInstance>> createWorkInstance(
      WorkInstanceModel params) async {
    return await request(
        ReqestType(
          module: 'work',
          action: 'CreateWorkInstance',
          params: params.toJson(),
        ), (data) {
      return XWorkInstance.fromJson(data);
    });
  }

  /// 删除办事定义
  /// @param {model.IdModel} params 请求参数
  /// @returns {model.ResultType<boolean>} 请求结果
  Future<ResultType<bool>> deleteWorkDefine(IdModel params) async {
    return await request(
      ReqestType(
        module: 'work',
        action: 'DeleteWorkDefine',
        params: params,
      ),
    );
  }

  /// 删除办事实例(发起人撤回)
  /// @param {model.IdModel} params 请求参数
  /// @returns {model.ResultType<boolean>} 请求结果
  Future<ResultType<bool>> recallWorkInstance(IdModel params) async {
    return await request(
      ReqestType(
        module: 'work',
        action: 'RecallWorkInstance',
        params: params,
      ),
    );
  }

  /// 查询办事定义
  /// @param {model.IdPageModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XWorkDefine>>} 请求结果
  Future<ResultType<PageResult<XWorkDefine>>> queryWorkDefine(
      IdPageModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'work',
          action: 'QueryWorkDefine',
          params: params,
        ), (data) {
      return XWorkDefine.fromList(data);
    });
  }

  /// 查询办事节点
  /// @param {model.IdModel} params 请求参数
  /// @returns {model.ResultType<model.WorkNodeModel>} 请求结果
  Future<ResultType<WorkNodeModel>> queryWorkNodes(IdReq params) async {
    return await request(
        ReqestType(
          module: 'work',
          action: 'QueryWorkNodes',
          params: params,
        ), (data) {
      return WorkNodeModel.fromJson(data);
    });
  }

  /// 查询待审批任务、抄送
  /// @param {model.IdModel} params 请求参数
  /// @returns {model.ResultType<model.PageResult<schema.XWorkTask>>} 请求结果
  Future<ResultType<PageResult<XWorkTask>>> queryApproveTask(
      IdModel params) async {
    return await requestPageResult(
        ReqestType(
          module: 'work',
          action: 'QueryApproveTask',
          params: params,
        ), (data) {
      return XWorkTask.fromList(data);
    });
  }

  /// 办事节点审批
  /// @param {model.ApprovalTaskReq} params 请求参数
  /// @returns {model.ResultType<boolean>} 请求结果
  Future<ResultType<bool>> approvalTask(ApprovalTaskReq params) async {
    return await request(
      ReqestType(
        module: 'work',
        action: 'ApprovalTask',
        params: params.toJson(),
      ),
    );
  }

  /// 根据ID查询流程实例
  /// @param  过滤参数
  /// @returns {schema.XWorkInstance | undefined} 流程实例对象
  Future<XWorkInstance?> findInstance(
    String belongId,
    String instanceId,
  ) async {
    var data = DataProxyType(
      module: 'Collection',
      action: 'Load',
      belongId: belongId,
      relations: [],
      flag: '-work-instance-',
      params: {
        'options': {
          'match': {
            'id': instanceId,
          },
          'limit': 1,
          'lookup': {
            'from': 'work-task',
            'localField': 'id',
            'foreignField': 'instanceId',
            'as': 'tasks',
          },
        },
        'collName': 'work-instance',
      },
    );
    var res = await dataProxy(data);
    if (res.success && res.data != null && res.data['data'] != null) {
      if (res.data['data'] is List && res.data['data'].length > 0) {
        return XWorkInstance.fromJson(res.data['data'][0]);
      }
    }
    return null;
  }

  /// 获取对象数据
  /// @param {string} belongId 对象所在的归属用户ID
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<DiskInfoType>> diskInfo(
    String belongId,
    List<String> relations,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Disk',
        action: 'Info',
        belongId: belongId,
        relations: relations,
        params: {},
        flag: 'diskInfo',
      ),
    );
  }

  /// 获取对象数据
  /// @param {string} belongId 对象所在的归属用户ID
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<T>> objectGet<T>(
      String belongId, List<String> relations, String key,
      [T Function(Map<String, dynamic>)? cvt]) async {
    return await dataProxy(
        DataProxyType(
          module: 'Object',
          action: 'Get',
          flag: key,
          belongId: belongId,
          relations: relations,
          params: key,
        ),
        cvt);
  }

  /// 变更对象数据
  /// @param {string} belongId 对象所在的归属用户ID
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @param {any} setData 对象新的值
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<dynamic>> objectSet(
    String belongId,
    List<String> relations,
    String key,
    dynamic setData,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Object',
        action: 'Set',
        flag: key,
        belongId: belongId,
        relations: relations,
        params: {
          "key": key,
          "setData": setData,
        },
      ),
    );
  }

  /// 删除对象数据
  /// @param {string} belongId 对象所在的归属用户ID
  /// @param {string} key 对象名称（eg: rootName.person.name）
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<dynamic>> objectDelete(
    String belongId,
    List<String> relations,
    String key,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Object',
        action: 'Delete',
        flag: key,
        belongId: belongId,
        relations: relations,
        params: key,
      ),
    );
  }

  /// 添加数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {} data 要添加的数据，对象/数组
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<T>> collectionInsert<T>(String belongId,
      List<String> relations, String collName, T data, String? copyId,
      [T Function(Map<String, dynamic>)? cvt]) async {
    return await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Insert',
        belongId: belongId,
        copyId: copyId,
        relations: relations,
        flag: collName,
        params: {"collName": collName, "data": data},
      ),
      cvt,
    );
  }

  /// 变更数据集数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {} data 要添加的数据，对象/数组
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<T>> collectionSetFields<T>(String belongId,
      List<String> relations, String collName, dynamic collSet, String? copyId,
      [T Function(Map<String, dynamic>)? fromJson]) async {
    ResultType res = await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'SetFields',
        belongId: belongId,
        copyId: copyId,
        relations: relations,
        flag: collName,
        params: {collName, collSet},
      ),
    );

    return ResultType.fromJsonSerialize(res, fromJson!);
  }

  /// 替换数据集数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {T} replace 要添加的数据，对象/数组
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<T>> collectionReplace<T>(
    String belongId,
    List<String> relations,
    String collName,
    T replace,
    String? copyId,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Replace',
        belongId: belongId,
        copyId: copyId,
        relations: relations,
        flag: collName,
        params: {collName, replace},
      ),
    );
  }

  /// 更新数据到数据集
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} update 更新操作（match匹配，update变更,options参数）
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<dynamic>> collectionUpdate(
    String belongId,
    List<String> relations,
    String collName,
    dynamic update,
    String? copyId,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Update',
        belongId: belongId,
        copyId: copyId,
        relations: relations,
        flag: collName,
        params: {collName, update},
      ),
    );
  }

  /// 从数据集移除数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} match 匹配信息
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<dynamic>> collectionRemove(
    String belongId,
    List<String> relations,
    String collName,
    dynamic match,
    String? copyId,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Remove',
        belongId: belongId,
        copyId: copyId,
        relations: relations,
        flag: collName,
        params: {collName, match},
      ),
    );
  }

  /// 查询数据集数据
  /// @param  过滤参数
  /// @returns {model.ResultType<T>} 移除异步结果
  Future<LoadResult<T>> collectionLoad<T>(
      String belongId, List<String> relations, String collName, dynamic options,
      {T Function(Map<String, dynamic>)? fromJson}) async {
    options['belongId'] = belongId;
    ResultType res = await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Load',
        belongId: belongId,
        params: {
          ...options,
          'collName': collName,
        },
        relations: relations,
        flag: '-$collName',
      ),
    );

    // if (res.data is Map && res.data['data'] is List) {
    //   res.data = res.data['data'];
    // }
    if (null != fromJson) {
      return LoadResult<T>.fromJsonSerialize(res.toJson(), fromJson);
    } else {
      return LoadResult.fromJson(res.toJson());
    }
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<dynamic>> collectionAggregate(
    String belongId,
    List<String> relations,
    String collName,
    dynamic options,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Collection',
        action: 'Aggregate',
        flag: collName,
        belongId: belongId,
        relations: relations,
        params: {collName, options},
      ),
    );
  }

  /// 从数据集查询数据
  /// @param {string} collName 数据集名称（eg: history-message）
  /// @param {any} options 聚合管道(eg: {match:{a:1},skip:10,limit:10})
  /// @param {string} belongId 对象所在的归属用户ID
  /// @returns {model.ResultType<T>} 对象异步结果
  Future<ResultType<PageResult<T>>> collectionPageRequest<T>(
    String belongId,
    List<String> relations,
    String collName,
    dynamic options,
    PageModel page,
  ) async {
    var total =
        await collectionAggregate(belongId, relations, collName, options);
    if (total.success &&
        total.data &&
        (total.data is List) &&
        total.data.length > 0) {
      options['skip'] = page.offset;
      options['limit'] = page.limit;
      var res =
          await collectionAggregate(belongId, relations, collName, options);
      return ResultType<PageResult<T>>(
        code: res.code,
        msg: res.msg,
        success: res.success,
        data: PageResult(
            offset: page.offset,
            limit: page.limit,
            total: total.data[0].length,
            result: res.data),
      );
    }

    return ResultType<PageResult<T>>(
        data: total.data,
        code: total.code,
        msg: total.msg,
        success: total.success);
  }

  /// 桶操作
  /// @param data 操作携带的数据
  /// @returns {ResultType<T>} 移除异步结果
  Future<ResultType<T>> bucketOpreate<T>(
    String belongId,
    List<String> relations,
    BucketOpreateModel data,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Bucket',
        action: 'Operate',
        belongId: belongId,
        relations: relations,
        flag: 'bucketOpreate',
        params: data,
      ),
    );
  }

  /// 加载物
  /// @param  过滤参数
  /// @returns {model.ResultType<T>} 移除异步结果

  Future<ResultType<T>> loadThing<T>(
    String belongId,
    List<String> relations,
    dynamic options,
  ) async {
    options['belongId'] = belongId;
    return await dataProxy(
      DataProxyType(
        module: 'Thing',
        action: 'Load',
        belongId: belongId,
        relations: relations,
        flag: 'loadThing',
        params: options,
      ),
    );
  }

  /// 创建物
  /// @param name 物的名称
  /// @returns {model.ResultType<model.AnyThingModel>} 移除异步结果

  Future<ResultType<AnyThingModel>> createThing<T>(
    String belongId,
    List<String> relations,
    String name,
  ) async {
    return await dataProxy(
      DataProxyType(
        module: 'Thing',
        action: 'Create',
        flag: 'createThing',
        belongId: belongId,
        relations: relations,
        params: name,
      ),
    );
  }

  /// 由内核代理一个http请求
  /// @param {model.HttpRequestType} reqs 请求体
  /// @returns 异步结果
  Future<ResultType<HttpResponseType>> httpForward(
    HttpRequestType req,
  ) async {
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('HttpForward', args: [req])
          as ResultType<HttpResponseType>;
    } else {
      var res = await _restRequest('httpForward', req.toJson());

      return ResultType<HttpResponseType>(
          code: res.code, msg: res.msg, success: res.success, data: res.data);
    }
  }

  /// 请求一个数据核方法
  /// @param {ReqestType} reqs 请求体
  /// @returns 异步结果
  Future<ResultType<T>> dataProxy<T>(DataProxyType req,
      [T Function(Map<String, dynamic>)? cvt]) async {
    dynamic raw;
    // print('dataProxy param:${req.toJson()}');
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('DataProxy', args: [req]);
    } else {
      var json = req.toJson();
      raw = await _restRequest('dataProxy', json);
    }
    logger.info('dataProxy raw:${raw.toString()}');
    if (!raw.success) {
      // ToastUtils.showMsg(msg: raw.msg);
    }
    if (null != raw.data && null != cvt) {
      return ResultType<T>.fromJsonSerialize(raw, cvt);
    } else {
      return ResultType<T>.fromJsonSerialize(raw, (data) => raw.data);
    }
  }

  /// 数据变更通知
  /// @param {ReqestType} reqs 请求体
  /// @returns 异步结果
  Future<ResultType<bool>> dataNotify(DataNotityType req) async {
    if (req.ignoreSelf) {
      req.ignoreConnectionId = _storeHub.connectionId;
    }
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('DataNotify', args: [req])
          as ResultType<bool>;
    } else {
      var res = await _restRequest('dataNotify', req.toJson());
      return ResultType.fromObj(res, res.data);
    }
  }

  /// 请求一个内核方法
  /// @param {ReqestType} reqs 请求体
  /// @returns 异步结果

  Future<ResultType<PageResult<T>>> requestPageResult<T>(ReqestType req,
      [List<T> Function(List<dynamic>)? cvt]) async {
    return request(req, (data) {
      return PageResult<T>.fromJson(data, cvt);
    });
  }

  /// 请求一个内核方法
  /// @param {ReqestType} reqs 请求体
  /// @returns 异步结果

  Future<ResultType<T>> request<T>(ReqestType req,
      [T Function(Map<String, dynamic>)? cvt]) async {
    ResultType raw;
    LogUtil.d("===> req:${req.toJson()}");
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('Request', args: [req]);
      LogUtil.d("===> res:${req.toJson()}");
    } else {
      raw = await _restRequest('Request', req.toJson());
    }
    if (!raw.success) {
      ToastUtils.showMsg(msg: raw.msg);
      return ResultType<T>.fromJson({});
    }

    // try {
    if (null != cvt) {
      return ResultType<T>.fromJsonSerialize(raw, cvt);
    } else {
      return ResultType<T>.fromJson(raw.toJson());
    }
    // } catch (e) {
    //   LogUtil.d('====err1:$e');
    //   LogUtil.d('====err2:$cvt-$T');
    //   e.printError();
    // }
    // return ResultType<T>.fromJson({});
  }

  Future<ResultType<T>> request_<T, R>(ReqestType req,
      [T Function(Map<String, dynamic>, [Function(List<dynamic>)?])? dataCF,
      List<T> Function(List<dynamic>)? resultCF]) async {
    dynamic raw;
    print("===> req:${req.toJson()}");
    if (_storeHub.isConnected) {
      raw = await _storeHub.invoke('Request', args: [req]);
    } else {
      raw = await _restRequest('request', req.toJson());
    }
    if (!raw.success) {
      ToastUtils.showMsg(msg: raw.msg);
    }
    try {
      if (null != dataCF && null != resultCF) {
        return ResultType<T>.fromJsonSerialize(raw ?? {}, (e) {
          return dataCF(e, resultCF);
        });
      } else if (null != dataCF) {
        return ResultType<T>.fromJsonSerialize(raw ?? {}, (e) {
          return dataCF(e);
        });
      } else {
        return ResultType<T>.fromJson(raw);
      }
    } catch (e) {
      print('====err1:$e');
      // print('====err2:$cvt-$T');
      e.printError();
    }
    return ResultType<T>.fromJson({});
  }

  /// 请求多个内核方法,使用同一个事务
  /// @param {model.ResultType<any>[]} reqs 请求体
  /// @returns 异步结果

  Future<ResultType<dynamic>> requests<T>(List<ReqestType> reqs) async {
    if (_storeHub.isConnected) {
      return await _storeHub.invoke('Requests', args: reqs);
    } else {
      return await _restRequest('requests', reqs.map((e) => e.toJson()));
    }
  }

  /// 订阅变更
  /// @param flag 标识
  /// @param keys 唯一标志
  /// @param operation 操作
  void subscribe(
    String flag,
    List<String> keys,
    Function(Map<String, dynamic> data) operation, //部分代码又用到dynamic，我先改了
  ) {
    if (flag.isEmpty || keys.isEmpty) {
      return;
    }
    flag = flag.toLowerCase();
    if (_subMethods[flag] == null) {
      _subMethods[flag] = [];
    }
    _subMethods[flag]?.add({
      'keys': keys,
      'operation': operation,
    });
    final data = _cacheData[flag] ?? [];
    data.forEach((item) {
      operation.call(item);
    });
    _cacheData[flag] = [];
  }

  /// 取消订阅变更
  /// @param flag 标识
  /// @param keys 唯一标志
  /// @param operation 操作
  unSubscribe(String key) {
    for (var flag in _subMethods.keys) {
      _subMethods[flag] = _subMethods[flag]!
          .where(
            (i) => !i['keys'].contains(key),
          )
          .toList();
    }
  }

  /// 监听服务端方法
  /// @param {string} methodName 方法名
  /// @returns {void} 无返回值
  void on(String? methodName, List<Function> newOperation) {
    if (methodName == null) {
      return;
    }

    methodName = methodName.toLowerCase();
    _methods.putIfAbsent(methodName, () => []);
    if (_methods[methodName] != null) {
      _methods[methodName] = [];
    }

    for (var element in newOperation) {
      if (_methods[methodName]!.contains(element)) {
        return;
      } else {
        _methods[methodName]!.add(element);
      }
    }

    // List data = _cacheData[methodName] ?? [];
    // data.map((dynamic e) {
    //   Function.apply(e, newOperation);
    // });
    // _cacheData[methodName] = [];
  }

  /// 接收服务端消息
  _receive(List<dynamic>? params) {
    if (params == null || params.isEmpty) {
      return;
    }
    Map<String, dynamic> param = params[0];
    ReceiveType res = ReceiveType.fromJson(param);
    bool onlineOnly = true;
    switch (res.target) {
      case 'DataNotify':
        {
          DataNotityType data = DataNotityType.fromJson(res.data);
          if (data.ignoreConnectionId == _storeHub.connectionId) {
            return;
          }
          var flag =
              '${data.belongId}-${data.targetId}-${data.flag}'.toLowerCase();
          var methods = _subMethods[flag];
          if (null != methods) {
            try {
              for (var m in methods) {
                m['operation'].call(data.data);
              }
            } catch (e) {
              logger.warning(e as Error);
            }
          } else {
            onlineOnly = data.onlineOnly;
          }
        }
        break;
      case 'Online':
      case 'Outline':
        {
          var connectionId = res.data['connectionId'];
          if (connectionId && connectionId.length > 0) {
            if (onlineIds.isEmpty) {
              onlineIds.add('');
              onlines();
            } else {
              if (res.target == 'Online') {
                if (onlineIds.every((i) => i != connectionId)) {
                  onlineIds.add(connectionId);
                }
              } else {
                onlineIds = onlineIds.where((i) => i != connectionId).toList();
              }
              onlineNotify.changCallback();
            }
            command.emitter('_', res.target.toLowerCase(), res.data);
          }
        }
        break;
      default:
        {
          var methods = _methods[res.target.toLowerCase()];
          if (methods != null) {
            try {
              for (var m in methods) {
                Function.apply(m, [res.data]);
              }
            } catch (e) {
              logger.warning(e as Error);
            }
          }
        }
    }
    if (!onlineOnly) {
      var data = _cacheData[res.target.toLowerCase()] ?? {};
      _cacheData[res.target.toLowerCase()] = [...data, res.data];
    }
  }

  /// 使用rest请求后端
  /// @param methodName 方法
  /// @param data 参数
  /// @returns 返回结果
  Future<ResultType<T>> _restRequest<T>(String methodName, dynamic args) async {
    final res = await _http.post(
      '${Constant.rest}/${methodName.toLowerCase()}',
      data: args,
    );

    // if (res.data && (res.data is ResultType)) {
    if (res != null && res['data'] != null) {
      final result = ResultType<T>.fromJson(res);
      if (!result.success) {
        if (result.code == 401) {
          settingCtrl.exitLogin(cleanUserLoginInfo: false);
        } else {
          logger.warning('请求失败${result.msg}');
        }
      }
      return result;
    }
    return ResultType(success: false, msg: '请求失败', code: 400); //badRequest;
  }

  // PageResult<R> Function(Map<String, dynamic> data) _pageResult<T, R>(
  //     [List<R> Function(List<dynamic>)? cvt]) {
  //   return (data) {
  //     return PageResult<R>.fromJson(data, cvt);
  //   };
  // }
}
