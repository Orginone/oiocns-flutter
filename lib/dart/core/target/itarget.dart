import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/iidentity.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/thing/dict.dart';
import 'package:orginone/dart/core/thing/property.dart';

import '../market/model.dart';
import '../thing/ispecies.dart';

/// 空间类型数据
class SpaceType {
  // 唯一标识
  late String id;
  // 名称
  late String name;
  // 类型
  late TargetType typeName;
  // 头像
  late TargetShare share;
}

abstract class ITarget {
  // 唯一标识
  late String id;
  // 唯一标识
  late String key;
  // 名称
  late String name;
  // 团队名称
  late String teamName;
  // 实体对象
  late XTarget target;
  // 类型
  late String typeName;
  // 职权树
  IAuthority? authorityTree;
  // 拥有的身份
  late List<XIdentity> ownIdentitys;
  // 组织的身份
  late List<IIdentity> identitys;
  // 子组织类型
  late List<TargetType> subTeamTypes;
  // 可以加入的父组织类型
  late List<TargetType> joinTargetType;
  // 可以查询的组织类型
  late List<TargetType> searchTargetType;
  // 缓存内的子组织
  late List<ITarget> subTeam;
  // 共享信息
  late TargetShare shareInfo;

  //加载组织的空间
  ISpace? space;

  List<XTarget> members = [];

  List<ISpeciesItem> species = [];


  late Property property;

  bool isSelected = false;

  /// 新增
  /// @param data
  Future<ITarget?> create(TargetModel data);

  /// 更新
  /// @param data
  Future<ITarget> update(TargetModel data);

  /// 删除
  Future<bool> delete();

  /// 获取职权树
  /// @param reload 是否强制刷新
  Future<IAuthority?> loadAuthorityTree({bool reload = false});

  /// 加载分类树
  /// @param reload 是否强制刷新
  Future<List<ISpeciesItem>> loadSpeciesTree({bool reload = false});

  /// 判断是否拥有该身份
  /// @param id 身份id
  Future<bool> judgeHasIdentity(List<String> codes);

  /// 获取身份
  /// @return {IIdentity[]} 身份数组
  Future<List<IIdentity>> getIdentitys();

  /// 创建身份
  /// @param {model.IdentityModel} params 参数
  Future<IIdentity?> createIdentity(IdentityModel params);

  /// 删除身份
  /// @param id 身份ID
  Future<bool> deleteIdentity(String id);

  /// 加载子组织
  Future<List<ITarget>> loadSubTeam({bool reload = false});

  /// 加载组织成员
  /// @param page 分页请求
  Future<XTargetArray> loadMembers(PageRequest page);

  /// 拉取成员加入群组
  /// @param {XTarget} target 成员
  Future<bool> pullMember(XTarget target);

  /// 拉取成员加入群组
  /// @param {string[]} ids 成员ID数组
  /// @param {TargetType} type 成员类型
  Future<bool> pullMembers(List<String> ids, String type);

  /// 移除群成员
  /// @param {XTarget} target 成员
  Future<bool> removeMember(XTarget target);

  /// 移除群成员
  /// @param {string[]} ids 成员ID数组
  /// @param {TargetType} type 成员类型
  Future<bool> removeMembers(List<String> ids, {String type});
}

/// 市场相关操作方法
abstract class IMTarget {
  /// 我加入的市场
  late List<IMarket> joinedMarkets;

  /// 开放市场
  late List<IMarket> publicMarkets;

  /// 拥有的产品/应用
  late List<IProduct> ownProducts;

  /// 我发起的加入市场的申请
  late List<XMarketRelation> joinMarketApplys;

  /// 可使用的应用
  late List<XProduct> usefulProduct;

  /// 可使用的资源
  late Map<String, List<XResource>> usefulResource;

  /// 根据编号查询市场
  /// @param name 编号、名称
  /// @returns
  Future<XMarketArray?> getMarketByCode(String name);

  /// 查询商店列表
  /// @param reload 是否强制刷新
  /// @returns 商店列表
  Future<List<IMarket>> getJoinMarkets({bool reload});

  /// 查询开放市场
  /// @param reload 是否强制刷新
  /// @returns 市场
  Future<List<IMarket>> getPublicMarket({bool reload});

  /// 查询我的产品/应用
  /// @param params
  /// @param reload 是否强制刷新
  /// @returns
  Future<List<IProduct>> getOwnProducts({bool reload});

  /// 查询购买订单
  Future<XOrderArray?> getBuyOrders(int status, PageRequest page);

  /// 查询售卖订单
  Future<XOrderDetailArray?> getSellOrders(int status, PageRequest page);

  /// 查询加入市场的审批
  /// @returns
  Future<XMarketRelationArray?> queryJoinMarketApproval();

  /// 查询我发起的加入市场申请
  /// @param page 分页参数
  /// @returns
  Future<List<XMarketRelation>> getJoinMarketApplys();

  /// 申请加入市场
  /// @param id 市场ID
  /// @returns
  Future<bool> applyJoinMarket(String id);

  /// 删除发起的加入市场申请
  /// @param id 申请Id
  Future cancelJoinMarketApply(String id);

  /// 查询应用上架的审批
  /// @returns
  Future<XMerchandiseArray?> queryPublicApproval();

  /// 审批加入市场申请
  /// @param id 申请id
  /// @param status 审批状态
  /// @returns
  Future<bool> approvalJoinMarketApply(String id, int status);

  /// 审批商品上架申请
  /// @param id 申请ID
  /// @param status 审批结果
  /// @returns 是否成功
  Future<bool> approvalPublishApply(String id, int status);

  /// 创建市场
  /// @param  {model.MarketModel} 市场基础信息
  /// @param { String } params.name
  /// @param
  /// @returns
  Future<IMarket?> createMarket(MarketModel data);

  /// 创建应用
  /// @param  {model.ProductModel} 产品基础信息
  Future<IProduct?> createProduct(ProductModel model);

  /// 删除市场
  /// @param id 市场Id
  /// @returns
  Future<bool> deleteMarket(String id);

  /// 删除应用
  /// @param id 应用Id
  /// @returns
  Future<bool> deleteProduct(String id);

  /// 退出市场
  /// @param id 退出的市场Id
  /// @returns
  Future<bool> quitMarket(String id);

  /// 查询可用的应用
  /// @param reload 是否强制刷新
  Future<List<XProduct>> getUsefulProduct({bool reload});

  /// 获得可用资源
  /// @param id 应用Id
  /// @param reload 是否强制刷新
  Future<List<XResource>?> getUsefulResource(String id, {bool reload});

  /// 下单
  /// @param nftId 区块链Id
  /// @param name 订单名称
  /// @param code 订单编号
  /// @param spaceId 空间Id
  /// @param merchandiseIds 商品Id集合
  Future<XOrder?> createOrder(
    String nftId,
    String name,
    String code,
    String spaceId,
    List<String> merchandiseIds,
  );
}

abstract class IFlow {
  /// 流程定义
  late List<XFlowDefine> defines;

  /// 获取流程定义列表
  /// @param reload 是否强制刷新
  Future<List<XFlowDefine>> getDefines({bool reload = false});

  ///查询流程定义绑定项
  ///@param reload 是否强制刷新
  Future<List<XOperation>> queryFlowRelation({bool reload = false});

  ///发布流程定义（包含创建、更新）
  ///@param data
  Future<XFlowDefine?> publishDefine(CreateDefineReq data);

  /// 删除流程定义
  /// @param id 流程定义Id
  Future<bool> deleteDefine(String id);

  /// 发起流程实例
  /// @param data 流程实例参数
  Future<XFlowInstance?> createInstance(FlowInstanceModel data);

  /// 绑定应用业务与流程定义
  /// @param params
  Future<bool> bindingFlowRelation(FlowRelationModel params);
}

abstract class ISpace implements IFlow, IMTarget, ITarget {
  /// 我的群组
  late List<ICohort> cohorts;

  /// 空间类型数据
  late SpaceType spaceData;

  /// 空间职权树
  IAuthority? spaceAuthorityTree;

  late Dict dict;

  /// @description: 查询群
  ///@param reload 是否强制刷新
  ///@return {*} 查询到的群组
  Future<List<ICohort>> getCohorts({bool reload});

  /// 解散群组
  /// @param id 群组id
  /// @param belongId 群组归属id
  /// @returns
  Future<bool> deleteCohort(String id);

  /// 加载空间职权树
  /// @param reload 重新加载
  Future<IAuthority?> loadSpaceAuthorityTree([bool reload = false]);
}

/// 群组操作
abstract class ICohort implements ITarget {
  /// 查询人员
  /// @param code 人员编号
  Future<XTargetArray> searchPerson(String code);
}

/// 人员操作
abstract class IPerson implements ISpace, ITarget {
  /// 我的好友列表
  late RxList<XTarget> joinedFriend;

  /// 我加入的单位
  late RxList<ICompany> joinedCompany;

  /// 退出群组
  /// @param id 群组Id
  Future<bool> quitCohorts(String id);

  /// 申请加入群组
  /// @param id 目标Id
  /// @returns
  Future<bool> applyJoinCohort(String id);

  /// 查询群组
  /// @param code 群组编号
  Future<XTargetArray> searchCohort(String code);

  /// 获取单位列表
  /// @param reload 是否强制刷新
  /// @return 加入的单位列表
  Future<List<ICompany>> getJoinedCompanys({bool reload});

  /// 删除单位
  ///@param id 单位Id
  ///@returns
  Future<bool> deleteCompany(String id);

  /// 申请加入单位
  ///@param id 目标Id
  ///@returns
  Future<bool> applyJoinCompany(String id, TargetType typeName);

  /// 退出单位
  ///@param id 单位Id
  Future<bool> quitCompany(String id);

  /// 审批我的好友申请
  ///@param relation 申请
  ///@param status 状态
  ///@returns
  Future<bool> approvalFriendApply(XRelation relation, int status);

  ///查询我的申请
  Future<XRelationArray?> queryJoinApply();

  /// 查询我的审批
  Future<XRelationArray?> queryJoinApproval();

  /// 取消加入组织申请
  /// @param id 申请Id/好友Id
  /// @returns
  Future<bool> cancelJoinApply(String id);

  /// 修改密码
  /// @param password 新密码
  /// @param privateKey 私钥
  Future<bool> resetPassword(String password, String privateKey);

  /// 查询单位
  /// @param code 单位的信用代码
  Future<XTargetArray> searchCompany(String code);

  /// 查询人员
  /// @param code 人员编号
  Future<XTargetArray> searchPerson(String code);

  /// 发起好友申请
  /// @param target 人员
  Future<bool> applyFriend(XTarget target);
}

/// 单位操作
abstract class ICompany implements ISpace, ITarget {
  /// 我的子部门
  late List<IDepartment> departments;

  /// 我的子工作组
  late List<IWorking> workings;

  /// 我加入的集团
  late List<IGroup> joinedGroup;

  /// 当前用户Id
  late String userId;

  ///加载空间职权树
  Future<IAuthority?> loadSpaceAuthorityTree([bool reload = false]);

  /// 删除集团
  /// @param id 集团Id
  Future<bool> deleteGroup(String id);

  /// 删除子部门
  /// @param id 部门Id
  /// @returns
  Future<bool> deleteDepartment(String id);

  /// 删除岗位
  /// @param id 岗位Id
  /// @returns
  Future<bool> deleteStation(String id);

  /// 删除工作组
  /// @param id 工作组Id
  /// @returns
  Future<bool> deleteWorking(String id);

  ///  退出集团
  /// @param id 集团Id
  /// @returns
  Future<bool> quitGroup(String id);

  /// 获取单位下的部门（单位、部门）
  /// @param reload 是否强制刷新
  /// @returns
  Future<List<IDepartment>> getDepartments({bool reload});

  /// 获取单位下的岗位
  /// @param reload 是否强制刷新
  Future<List<IStation>> getStations({bool reload});

  /// 获取组织下的工作组（单位、部门、工作组）
  /// @param reload 是否强制刷新
  /// @returns 返回好友列表
  Future<List<IWorking>> getWorkings({bool reload});

  /// @description: 查询我加入的集团
  /// @param reload 是否强制刷新
  /// @return {*} 查询到的群组
  Future<List<IGroup>> getJoinedGroups({bool reload});

  /// 申请加入集团
  /// @param id 目标Id
  /// @returns
  Future<bool> applyJoinGroup(String id);

  /// 查询我的申请
  Future<XRelationArray?> queryJoinApply();

  /// 查询我的审批
  Future<XRelationArray?> queryJoinApproval();

  /// 取消加入申请
  /// @param id 申请Id/目标Id
  /// @returns
  Future<bool> cancelJoinApply(String id);

  /// 查询集团
  /// @param code 集团编号
  Future<XTargetArray> searchGroup(String code);
}

/// 集团操作
abstract class IGroup implements ITarget {
  /// 子集团
  late List<IGroup> subGroup;

  /// 申请加入集团
  /// @param id 目标Id
  /// @returns
  Future<bool> applyJoinGroup(String id);

  /// 创建子集团
  /// @param data 子集团基本信息
  Future<IGroup?> createSubGroup(TargetModel data);

  /// 删除子集团
  /// @param id 集团Id
  /// @returns
  Future<bool> deleteSubGroup(String id);

  /// 获取子集团
  /// @param reload 是否强制刷新
  /// @returns
  Future<List<IGroup>> getSubGroups({bool reload});
}

/// 部门操作
abstract class IDepartment implements ITarget {
  /// 工作组
  late List<IWorking> workings;

  /// 子部门
  late List<IDepartment> departments;


  List<XTarget> departmentMembers = [];

  bool isSelected = false;


  /// 获取子部门
  /// @param reload 是否强制刷新
  Future<List<IDepartment>> getDepartments({bool reload});

  /// 获取工作组
  /// @param reload 是否强制刷新
  Future<List<IWorking>> getWorkings({bool reload});

  /// 创建子部门
  Future<IDepartment?> createDepartment(TargetModel data);

  /// 创建工作组
  Future<IWorking?> createWorking(TargetModel data);

  /// 删除子部门
  Future<bool> deleteDepartment(String id);

  /// 删除工作组
  Future<bool> deleteWorking(String id);
}

/// 工作组
abstract class IWorking implements ITarget {
  /// 查询人员
  /// @param code 人员编号
  Future<XTargetArray> searchPerson(String code);
}

abstract class IStation implements ITarget {
  /// 查询人员
  /// @param code 人员编号
  Future<XTargetArray> searchPerson(String code);

  /// 加载岗位下的身份
  Future<List<XIdentity>> loadIdentitys({bool reload});

  /// 添加岗位身份
  /// @param {string[]} identitys 身份数组
  Future<bool> pullIdentitys(List<XIdentity> identitys);

  /// 移除岗位身份
  /// @param {string[]} ids 身份ID数组
  Future<bool> removeIdentitys(List<String> ids);
}
