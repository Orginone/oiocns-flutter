import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/common/models/file/asserts/asset_creation_config.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/enums.dart';

import 'package:orginone/utils/encryption_util.dart';
import 'package:orginone/utils/icons.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/common/models/thing/thing_model.dart' as thing;

import 'common/lists.dart';

/// 内核请求模型
class ReqestType {
  // 模块
  final String module;

  // 方法
  final String action;

  // 参数
  final dynamic params;

  ReqestType({
    required this.module,
    required this.action,
    required this.params,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["module"] = module;
    json["action"] = action;
    json["params"] = params;
    return json;
  }
}

// 请求数据核类型定义
class DataProxyType {
  String flag; // 标签
  String module; // 模块
  String action; // 方法
  String belongId; // 归属
  String? copyId; // 抄送
  dynamic params; // 参数
  List<String> relations; // 关系举证(用户鉴权[user=>relations=>target],最大支持2级关系)

  DataProxyType({
    required this.flag,
    required this.module,
    required this.action,
    required this.belongId,
    this.copyId,
    required this.params,
    required this.relations,
  });

  factory DataProxyType.fromJson(Map<String, dynamic> json) {
    return DataProxyType(
      flag: json['flag'] as String, // 标签
      module: json['module'] as String, // 模块
      action: json['action'] as String, // 方法
      belongId: json['belongId'] as String, // 归属
      copyId: json['copyId'] as String?, // 抄送
      params: json['params'], // 参数
      relations: List<String>.from(json['relations'] as List), // 关系举证
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flag': flag, // 标签
      'module': module, // 模块
      'action': action, // 方法
      'belongId': belongId, // 归属
      if (copyId != null) 'copyId': copyId, // 抄送
      'params': params, // 参数
      'relations': relations, // 关系举证
    };
  }
}

// 请求数据核类型定义
class DataNotityType {
  // 数据
  dynamic data;
  // 通知的用户
  String targetId;
  // 是否忽略自己
  bool ignoreSelf;
  // 忽略的连接ID
  String? ignoreConnectionId;
  // 标签
  String flag;
  // 关系举证(用户鉴权[user=>relations=>target],最大支持2级关系)
  List<String> relations;
  // 归属用户
  String belongId;
  // 通知用户自身
  bool onlyTarget;
  // 仅通知在线用户
  bool onlineOnly;
  //被操作方Id
  String? subTargetId;

  DataNotityType({
    required this.data,
    required this.targetId,
    required this.ignoreSelf,
    this.ignoreConnectionId,
    required this.flag,
    required this.relations,
    required this.belongId,
    required this.onlyTarget,
    required this.onlineOnly,
    this.subTargetId,
  });
  DataNotityType.fromJson(Map<String, dynamic> json)
      : data = json['data'],
        targetId = json['targetId'],
        ignoreSelf = json['ignoreSelf'] ?? false,
        ignoreConnectionId = json['ignoreConnectionId'],
        flag = json['flag'],
        relations =
            null != json['relations'] ? json['relations'].cast<String>() : [],
        belongId = json['belongId'],
        onlyTarget = json['onlyTarget'],
        onlineOnly = json['onlineOnly'],
        subTargetId = json['subTargetId'];

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'targetId': targetId,
      'ignoreSelf': ignoreSelf,
      'ignoreConnectionId': ignoreConnectionId,
      'flag': flag,
      'relations': relations,
      'belongId': belongId,
      'onlyTarget': onlyTarget,
      'onlineOnly': onlineOnly,
      'subTargetId': subTargetId,
    };
  }
}

// 代理请求类型定义
class HttpRequestType {
// 目标地址
  String uri;
  // 请求方法
  String method;
  // 请求头
  Map<String, String> header;
  // 请求体
  String content;
  HttpRequestType({
    required this.uri,
    required this.method,
    required this.header,
    required this.content,
  });

  Map<String, dynamic> toJson() {
    return {
      'uri': uri,
      'method': method,
      'header': header,
      'content': content,
    };
  }
}

// Http请求响应类型定义
class HttpResponseType {
// 状态码
  late int status;
  // 响应类型
  late String contentType;
  // 响应头
  late Map<String, List<dynamic>> header;
  // 响应体
  late String content;

  HttpResponseType.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        contentType = json['contentType'],
        header = json['header'],
        content = json['content'];
}

// 返回类型定义
class LoadResult<T> {
  // 数据
  T? data;
  // 分组数量
  final int groupCount;
  // 总数
  final int totalCount;
  final List<dynamic> summary;
  //http代码
  final int code;
  // 消息
  final String msg;
  // 是否成功标志
  final bool success;
  LoadResult({
    required this.code,
    this.data,
    required this.groupCount,
    required this.totalCount,
    required this.summary,
    required this.msg,
    required this.success,
  });

  LoadResult.fromJson(Map<String, dynamic> json)
      : data = json["data"],
        groupCount = json["groupCount"] ?? 0,
        totalCount = json["totalCount"] ?? 0,
        summary = json["summary"] ?? [],
        code = json["code"],
        msg = json["msg"],
        success = json["success"];

  factory LoadResult.fromJsonSerialize(Map<String, dynamic> json,
      [T Function(Map<String, dynamic>)? serialize]) {
    var data = (null != serialize && json['data'] != null)
        ? serialize(json['data'])
        : json['data'];
    // LogUtil.d('LoadResult.fromJsonSerialize--');
    // if (serialize != null) {
    //   LogUtil.d(serialize(json['data']));
    // }
    // LogUtil.d(data);
    return LoadResult(
        data: data,
        groupCount: json["groupCount"] ?? 0,
        totalCount: json["totalCount"] ?? 0,
        summary: json['summary'] == null
            ? []
            : List<String>.from(json['summary'] as List),
        code: json["code"] ?? 400,
        msg: json["msg"] ?? "",
        success: json["success"] ?? false);
  }
}

/// 统一返回结构模型
class ResultType<T> {
  // 代码，成功为200
  late final int code;

  // 数据
  T? data;

  // 消息
  late final String msg;

  // 是否成功标志
  late final bool success;

  ResultType({
    required this.code,
    this.data,
    required this.msg,
    required this.success,
  });

  ResultType.fromJson(Map<String, dynamic> json)
      : msg = json["msg"] ?? '',
        data = json["data"],
        code = json["code"] ?? 400,
        success = json["success"] ?? false;

  ResultType.fromObj(ResultType resultT, T this.data)
      : msg = resultT.msg,
        success = resultT.success,
        code = resultT.code;

  ResultType.fromJsonSerialize(
      ResultType<dynamic> json, T Function(Map<String, dynamic>) serialize) {
    msg = json.msg ?? "";
    if (json.data != null && json.success) {
      if (json.data is List) {
        data = serialize({'data': json.data});
      } else if (json.data is Map) {
        data = serialize(json.data);
      } else if (json.data is T) {
        data = json.data as T;
      }
    }
    code = json.code ?? 400;
    success = json.success ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'data': data,
      'msg': msg,
      'success': success,
    };
  }
}

/// 事件接收模型
class ReceiveType {
  // 用户
  String userId;
  // 对象
  String target;
  // 数据
  dynamic data;
  ReceiveType({required this.userId, required this.target, required this.data});
  factory ReceiveType.fromJson(Map<String, dynamic> json) {
    return ReceiveType(
      userId: json['userId'] ?? '',
      target: json['target'] ?? '',
      data: json['data'] as dynamic,
    );
  }
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'target': target,
      };
}

/// 在线信息
class OnlineInfo {
  /// 用户Id
  late String userId;

  /// 连接Id
  late String connectionId;

  /// 远端地址
  late String remoteAddr;

  /// 上线时间
  late String onlineTime;

  /// 认证时间
  late String authTime;

  /// 请求次数
  late int requestCount;

  /// 终端类型
  late String endPointType;

  OnlineInfo({
    required this.userId,
    required this.connectionId,
    required this.remoteAddr,
    required this.onlineTime,
    required this.authTime,
    required this.requestCount,
    required this.endPointType,
  });
}

/// 在线信息查询接口
class OnlineSet {
  /// 用户连接
  final List<OnlineInfo>? users;

  /// 存储连接
  final List<OnlineInfo>? storages;

  OnlineSet({this.users, this.storages});
}

// 分页返回定义
class PageResult<T> {
  // 偏移量
  int offset;
  // 最大数量
  int limit;
  // 总数
  int total;
  // 结果
  List<T> result;
  PageResult({
    required this.total,
    required this.offset,
    required this.limit,
    required this.result,
  });

  factory PageResult.fromJson(Map<String, dynamic> json,
      [List<T> Function(List<dynamic>)? resultCF]) {
    return PageResult(
      total: json.containsKey('total') ? json['total'] as int : 0,
      offset: json.containsKey('offset') ? json['offset'] as int : 0,
      limit: json.containsKey('limit') ? json['limit'] as int : 0,
      result: json.containsKey('result')
          ? null != resultCF
              ? resultCF(json['result'])
              : List<T>.from(json['result'] as List)
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'offset': offset,
      'limit': limit,
      'result': result,
    };
  }
}

class DynamicCodeModel {
  // 动态密码Id
  String dynamicId;
  // 账户(手机号)
  String account;
  // 平台入口
  String platName;

  DynamicCodeModel({
    required this.dynamicId,
    required this.account,
    required this.platName,
  });

  DynamicCodeModel.fromJson(Map<String, dynamic> json)
      : dynamicId = json['dynamicId'],
        account = json['account'],
        platName = json['platName'];

  Map<String, dynamic> toJson() {
    return {
      'dynamicId': dynamicId,
      'account': account,
      'platName': platName,
    };
  }
}

class LoginModel {
  // 账户(手机号/账号)
  String account;
  // 密码
  String? password;
  // 动态密码Id
  String? dynamicId;
  // 动态密码
  String? dynamicCode;
  LoginModel({
    required this.account,
    this.password,
    this.dynamicId,
    this.dynamicCode,
  });
}

class RegisterModel {
  // 账户(手机号)
  String account;
  // 密码
  String password;
  // 动态密码Id
  String dynamicId;
  // 动态密码
  String dynamicCode;
  // 名称
  String name;
  // 描述
  String remark;
  RegisterModel({
    required this.account,
    required this.password,
    required this.dynamicId,
    required this.dynamicCode,
    required this.name,
    required this.remark,
  });

  Map<String, dynamic> toJson() {
    return {
      'account': account,
      'password': password,
      'dynamicId': dynamicId,
      'dynamicCode': dynamicCode,
      'name': name,
      'remark': remark,
    };
  }
}

//认证结果返回
class TokenResultModel {
  // 授权码
  String accessToken;
  // 过期时间
  int expiresIn;
  // 作者
  String author;
  // 协议
  String license;
  // 授权码类型
  String tokenType;
  // 用户信息
  XTarget target;
  // 私钥
  String? privateKey;

  TokenResultModel({
    required this.accessToken,
    required this.expiresIn,
    required this.author,
    required this.license,
    required this.tokenType,
    required this.target,
    this.privateKey,
  });
  TokenResultModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['accessToken'],
        expiresIn = json['expiresIn'],
        author = json['author'],
        license = json['license'],
        tokenType = json['tokenType'],
        target = XTarget.fromJson(json['target']),
        privateKey = json['privateKey'];
}

// 注册消息类型
class RegisterType {
  // 昵称
  final String nickName;

  // 姓名
  final String name;

  // 电话
  final String phone;

  // 账户
  final String account;

  // 密码
  final String password;

  // 座右铭
  final String motto;

  // 头像
  final String avatar;

  RegisterType({
    required this.nickName,
    required this.name,
    required this.phone,
    required this.account,
    required this.password,
    required this.motto,
    required this.avatar,
  });

  //通过JSON构造
  RegisterType.fromJson(Map<String, dynamic> json)
      : nickName = json["nickName"],
        name = json["name"],
        phone = json["phone"],
        account = json["account"],
        password = json["password"],
        motto = json["motto"],
        avatar = json["avatar"];

  //通过动态数组解析成List
  static List<RegisterType> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<RegisterType> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(RegisterType.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["nickName"] = nickName;
    json["name"] = name;
    json["phone"] = phone;
    json["account"] = account;
    json["password"] = password;
    json["motto"] = motto;
    json["avatar"] = avatar;
    return json;
  }
}

class IdPair {
  // 唯一ID
  final String id;
  final String value;

  IdPair(this.id, this.value);
}

// 请求数据核类型定义
class PageModel {
  // 偏移量
  int offset;
  // 最大数量
  int limit;
  //过滤条件
  String filter;

  PageModel({
    required this.filter,
    required this.offset,
    required this.limit,
  });

  factory PageModel.fromJson(Map<String, dynamic> json) {
    return PageModel(
      filter: json['filter'] as String,
      offset: json['offset'] as int,
      limit: json['limit'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter': filter,
      'offset': offset,
      'limit': limit,
    };
  }
}

class IdModel {
  // 唯一ID
  final String id;

  IdModel(
    this.id,
  );

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

class IdPageModel {
  // 唯一ID
  final String id;
  //分页
  final PageModel? page;

  IdPageModel({
    required this.id,
    this.page,
  });

  factory IdPageModel.fromJson(Map<String, dynamic> json) {
    return IdPageModel(
        id: json['id'] as String, page: json['page'] as PageModel);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'page': page};
  }
}

class IdArrayModel {
  // 唯一ID
  final List<String> ids;
  //分页
  final PageModel? page;

  IdArrayModel(
    this.ids,
    this.page,
  );
}

class EntityModel {
  // 雪花ID
  final String id;
  // 名称
  final String name;
  // 编号
  final String code;
  // 备注
  final String remark;
  // 图标
  final String icon;
  // 归属用户ID
  final String belongId;
  // 类型
  final String typeName;
  // 状态
  final int status;
  // 创建人员ID
  final String createUser;
  // 更新人员ID
  final String updateUser;
  // 修改次数
  final String version;
  // 创建时间
  final String createTime;
  // 更新时间
  final String updateTime;

  EntityModel(
      this.id,
      this.name,
      this.code,
      this.remark,
      this.icon,
      this.belongId,
      this.typeName,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime);
}

class AuthorityModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  String? icon;

  // 公开的
  bool? public;

  // 父类别ID
  String? parentId;

  // 共享用户
  String? shareId;

  // 备注
  String? remark;

  //构造方法
  AuthorityModel({
    this.id,
    this.name,
    this.code,
    this.public,
    this.parentId,
    this.shareId,
    this.remark,
    this.icon,
  });

  //通过JSON构造
  AuthorityModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        public = json["public"],
        parentId = json["parentId"],
        shareId = json["shareId"],
        icon = json['icon'],
        remark = json["remark"];

  //通过动态数组解析成List
  static List<AuthorityModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<AuthorityModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(AuthorityModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["public"] = public;
    json["parentId"] = parentId;
    json["shareId"] = shareId;
    json['icon'] = icon;
    json["remark"] = remark;
    return json;
  }
}

class IdentityModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 权限Id
  String? authId;

  // 共享用户Id
  String? shareId;

  // 备注
  String? remark;

  //构造方法
  IdentityModel({
    this.id,
    this.name,
    this.code,
    this.authId,
    this.shareId,
    this.remark,
  });

  //通过JSON构造
  IdentityModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        authId = json["authId"],
        shareId = json["shareId"],
        remark = json["remark"];

  //通过动态数组解析成List
  static List<IdentityModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdentityModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdentityModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["authId"] = authId;
    json["shareId"] = shareId;
    json["remark"] = remark;
    return json;
  }
}

class TargetModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 类型名
  String typeName;

  // 头像
  String? icon;

  // 创建组织/个人
  String? belongId;

  // 团队名称
  String? teamName;

  // 团队代号
  String? teamCode;

  // 团队备注
  String? remark;

  bool? public;

  //构造方法
  TargetModel({
    this.id,
    this.name,
    this.code,
    required this.typeName,
    this.icon,
    this.belongId,
    this.teamName,
    this.teamCode,
    this.remark,
    this.public,
  });

  //通过JSON构造
  TargetModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        typeName = json["typeName"],
        icon = json["icon"],
        belongId = json["belongId"],
        teamName = json["teamName"],
        teamCode = json["teamCode"],
        public = json['public'],
        remark = json["remark"];

  //通过动态数组解析成List
  static List<TargetModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<TargetModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(TargetModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["typeName"] = typeName;
    json["icon"] = icon;
    json["belongId"] = belongId;
    json["teamName"] = teamName;
    json["teamCode"] = teamCode;
    json["remark"] = remark;
    json['public'] = public;
    return json;
  }
}

class GiveModel {
  // 唯一ID
  final String id;

  // 子ID
  final List<String> subIds;

  //构造方法
  GiveModel({
    required this.id,
    required this.subIds,
  });

  //通过JSON构造
  GiveModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        subIds = json["subIds"];

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["subIds"] = subIds;
    return json;
  }
}

class GainModel {
  // 唯一ID
  final String id;

  // 子ID
  final String subId;

  //构造方法
  GainModel({
    required this.id,
    required this.subId,
  });

  //通过JSON构造
  GainModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        subId = json["subId"];

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["subId"] = subId;
    return json;
  }
}

class ApprovalModel {
  // 唯一ID
  final String? id;

  // 状态
  final int? status;

  //构造方法
  ApprovalModel({
    this.id,
    this.status,
  });

  //通过JSON构造
  ApprovalModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        status = json["status"];

  //通过动态数组解析成List
  static List<ApprovalModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ApprovalModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ApprovalModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["status"] = status;
    return json;
  }
}

class SearchModel {
  // 名称
  final String name;
  // 类型数组
  final List<String> typeNames;
  // 分页
  PageModel? page;

  SearchModel(this.name, this.typeNames, {this.page});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["typeNames"] = typeNames;
    json["page"] = page;
    return json;
  }
}

class GetSubsModel {
  // 唯一ID
  final String id;

  // 加入的节点类型
  final List<String> subTypeNames;

  // 分页
  final PageModel page;

  GetSubsModel(
      {required this.id, required this.subTypeNames, required this.page});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["subTypeNames"] = subTypeNames;
    json["page"] = page.toJson();
    return json;
  }
}

class MsgSendModel {
  // 接收方Id
  final String toId;

  // 工作空间ID
  final String belongId;

  // 消息类型
  final String msgType;

  // 消息体
  final String msgBody;

  //构造方法
  MsgSendModel({
    required this.toId,
    required this.belongId,
    required this.msgType,
    required this.msgBody,
  });

  //通过JSON构造
  MsgSendModel.fromJson(Map<String, dynamic> json)
      : belongId = json["belongId"],
        toId = json["toId"],
        msgType = json["msgType"],
        msgBody = json["msgBody"];

  //通过动态数组解析成List
  static List<MsgSendModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<MsgSendModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(MsgSendModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["belongId"] = belongId;
    json["toId"] = toId;
    json["msgType"] = msgType;
    json["msgBody"] = msgBody;
    return json;
  }
}

class MsgTagModel {
  // 工作空间ID
  String? belongId;

  // id
  String? id;

  // 消息类型
  List<String>? ids;

  // 消息体
  List<String>? tags;

  MsgTagModel({this.belongId, this.id, this.ids, this.tags});

  MsgTagModel.fromJson(Map<String, dynamic> json) {
    belongId = json["belongId"];
    id = json["id"];
    ids = json["ids"] != null ? List.castFrom(json["ids"]) : null;
    tags = json["tags"] != null ? List.castFrom(json["tags"]) : null;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["belongId"] = belongId;
    json["id"] = id;
    json["ids"] = ids;
    json["tags"] = tags;
    return json;
  }
}

/// 聊天消息类型
class ChatMessageType extends Xbase {
  late String fromId; // 发起方Id
  late String toId; // 接收方Id
  late String sessionId; // 接收会话Id
  late String typeName; // 类型
  late String content; // 内容
  late List<CommentType> comments; // 评注

  ChatMessageType({
    required this.fromId,
    required this.toId,
    required this.sessionId,
    required this.typeName,
    required this.content,
    required this.comments,
    required super.id,
  });
  ChatMessageType.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    fromId = json['fromId'] ?? '';
    toId = json['toId'] ?? '';
    sessionId = json['sessionId'] ?? '';
    typeName = json['typeName'] ?? '';
    content = json['content'] ?? '';
    comments = json['comments'] != null
        ? Lists.fromList(json['comments'], CommentType.fromJson)
        : [];
  }

  ChatMessageType.fromFileUpload(String id, this.toId, this.sessionId,
      String fileName, String filePath, String ext,
      [int size = 0])
      : super.fromJson({'id': fileName}) {
    fromId = id;
    typeName = MessageType.uploading.label;
    content = jsonEncode(FileItemShare(
            extension: '.$ext', shareLink: filePath, name: fileName, size: size)
        .toJson());
    comments = [];
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      ...super.toJson(),
      'fromId': fromId,
      'toId': toId,
      'sessionId': sessionId,
      'typeName': typeName,
      'content': content,
      'comments': comments.map((e) => e.toJson()).toList(),
    };
  }
}

class CommentType {
  late String label; // 标签名称
  late String userId; // 人员Id
  late String time; // 时间
  // 回复某个人
  late String? replyTo;

  CommentType(
      {required this.label,
      required this.userId,
      required this.time,
      this.replyTo});
  CommentType.fromJson(Map<String, dynamic> json) {
    label = json['label'];
    userId = json['userId'] ?? "";
    time = json['time'];
    replyTo = json['replyTo'];
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'userId': userId,
      'time': time,
      'replyTo': replyTo,
    };
  }
}

class PropertyModel {
  String? id; // 唯一ID
  String? name; // 名称
  String? code; // 编号
  String? valueType; // 值类型
  String? unit; // 计量单位
  String? info; // 附加信息
  String? directoryId; // 目录ID
  String? speciesId; // 分类标签ID
  String? sourceId; // 来源用户ID
  String? remark; // 备注

  PropertyModel({
    this.id,
    this.name,
    this.code,
    this.valueType,
    this.unit,
    this.info,
    this.directoryId,
    this.speciesId,
    this.sourceId,
    this.remark,
  });

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      valueType: json['valueType'],
      unit: json['unit'],
      info: json['info'],
      directoryId: json['directoryId'],
      speciesId: json['speciesId'],
      sourceId: json['sourceId'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'code': code,
      'valueType': valueType,
      'unit': unit,
      'info': info,
      'directoryId': directoryId,
      'speciesId': speciesId,
      'sourceId': sourceId,
      'remark': remark,
    };
    return data;
  }
}

class DirectoryModel {
  String? id; // 唯一ID
  String? name; // 名称
  String? code; // 编号
  String? icon; // 图标
  String? parentId; // 父目录ID
  String? shareId; // 共享用户ID
  String? remark; // 备注

  DirectoryModel({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.parentId,
    this.shareId,
    this.remark,
  });

  factory DirectoryModel.fromJson(Map<String, dynamic> json) {
    return DirectoryModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
      parentId: json['parentId'],
      shareId: json['shareId'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
      'parentId': parentId,
      'shareId': shareId,
      'remark': remark,
    };
  }
}

class SpeciesModel {
  String? id; // 唯一ID
  String? name; // 名称
  String? code; // 编号
  String? typeName; // 类型
  String? icon; // 图标
  String? remark; // 备注
  String? sourceId; // 来源用户ID
  String? directoryId; // 目录ID

  SpeciesModel({
    this.id,
    this.name,
    this.code,
    this.typeName,
    this.icon,
    this.remark,
    this.sourceId,
    this.directoryId,
  });

  factory SpeciesModel.fromJson(Map<String, dynamic> json) {
    return SpeciesModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      typeName: json['typeName'],
      icon: json['icon'],
      remark: json['remark'],
      sourceId: json['sourceId'],
      directoryId: json['directoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'code': code,
      'typeName': typeName,
      'icon': icon,
      'remark': remark,
      'sourceId': sourceId == "" ? null : sourceId,
      'directoryId': directoryId,
    };
    return json;
  }
}

class SpeciesItemModel {
  String? id; // 唯一ID
  String? name; // 键
  String? code; // 编号
  String? icon; // 图标
  String? info; // 附加信息
  String? speciesId; // 类型ID
  String? parentId; // 父类目ID
  String? remark; // 备注

  SpeciesItemModel({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.info,
    this.speciesId,
    this.parentId,
    this.remark,
  });

  factory SpeciesItemModel.fromJson(Map<String, dynamic> json) {
    return SpeciesItemModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
      info: json['info'],
      speciesId: json['speciesId'],
      parentId: json['parentId'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
      'info': info,
      'speciesId': speciesId,
      'parentId': parentId,
      'remark': remark,
    };
    return json;
  }
}

class AttributeModel {
  /// 唯一ID
  String? id;

  /// 名称
  String? name;

  /// 编号
  String? code;

  /// 规则
  String? rule;

  /// 属性Id
  String? propId;

  /// 工作职权Id
  String? authId;

  /// 表单项Id
  String? formId;

  /// 备注
  String? remark;

  AttributeModel({
    this.id,
    this.name,
    this.code,
    this.rule,
    this.propId,
    this.authId,
    this.formId,
    this.remark,
  });

  factory AttributeModel.fromJson(Map<String, dynamic> json) {
    return AttributeModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      rule: json['rule'],
      propId: json['propId'],
      authId: json['authId'],
      formId: json['formId'],
      remark: json['remark'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['rule'] = rule;
    data['propId'] = propId;
    data['authId'] = authId;
    data['formId'] = formId;
    data['remark'] = remark;
    return data;
  }
}

class FormModel {
  String? id; // 唯一ID
  String? name; // 名称
  String? code; // 编号
  String? rule; // 规则
  String? icon; // 图标
  String? typeName; // 类型
  String? remark; // 备注
  String? directoryId; // 目录ID

  FormModel({
    this.id,
    this.name,
    this.code,
    this.rule,
    this.icon,
    this.typeName,
    this.remark,
    this.directoryId,
  });

  factory FormModel.fromJson(Map<String, dynamic> json) {
    return FormModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      rule: json['rule'],
      icon: json['icon'],
      typeName: json['typeName'],
      remark: json['remark'],
      directoryId: json['directoryId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'rule': rule,
      'icon': icon,
      'typeName': typeName,
      'remark': remark,
      'directoryId': directoryId,
    };
  }
}

class ApplicationModel {
  String? id; // 唯一ID
  String? name; // 名称
  String? code; // 编号
  String? icon; // 图标
  String? typeName; // 类型
  String? remark; // 备注
  String? directoryId; // 目录ID
  String? parentId; // 父级ID
  String? resource; // 资源

  ApplicationModel({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.typeName,
    this.remark,
    this.directoryId,
    this.parentId,
    this.resource,
  });

  factory ApplicationModel.fromJson(Map<String, dynamic> json) {
    return ApplicationModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
      typeName: json['typeName'],
      remark: json['remark'],
      directoryId: json['directoryId'],
      parentId: json['parentId'],
      resource: json['resource'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['icon'] = icon;
    data['typeName'] = typeName;
    data['remark'] = remark;
    data['directoryId'] = directoryId;
    data['parentId'] = parentId;
    data['resource'] = resource;
    return data;
  }
}

class ThingModel {
  // 唯一ID
  final String? id;

  // 内容
  final String data;

  // 归属id
  final String? belongId;

  //构造方法
  ThingModel({
    this.id,
    required this.data,
    this.belongId,
  });

  //通过JSON构造
  ThingModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        data = json["data"],
        belongId = json["belongId"];

  //通过动态数组解析成List
  static List<ThingModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ThingModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ThingModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["data"] = data;
    json["belongId"] = belongId;
    return json;
  }
}

class SetPropModel {
  String id; // 物的唯一ID
  List<IdPair>? data; // 特性数据

  SetPropModel({
    required this.id,
    this.data,
  });
}

class GetDirectoryModel {
  late String id; // 唯一ID
  late bool upTeam; // 是否向上递归用户
  late PageModel page; // 分页

  GetDirectoryModel({
    required this.id,
    required this.upTeam,
    required this.page,
  });

  factory GetDirectoryModel.fromJson(Map<String, dynamic> json) {
    return GetDirectoryModel(
      id: json['id'] as String,
      upTeam: json['upTeam'] as bool,
      page: PageModel.fromJson(json['page']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['upTeam'] = upTeam;
    data['page'] = PageRequest(offset: 0, limit: 9999, filter: '');
    return data;
  }
}

class AnyThingModel {
  String? id;

  /// 唯一ID
  String? name;

  /// 名称
  String? status;

  /// 状态
  String? creater;

  /// 创建人
  String? createTime;

  /// 创建时间
  String? modifiedTime;

  /// 变更时间
  bool isSelected = false;

  /// 其它信息
  Map<String, dynamic> otherInfo = {};

  Map<String, Archives> archives = {};
  AnyThingModel({
    this.id,
    this.name,
    this.status,
    this.creater,
    this.createTime,
    this.modifiedTime,
  });

  AnyThingModel.fromJson(Map<String, dynamic> json) {
    json.forEach((key, value) {
      if (key != 'Id' &&
          key != 'Name' &&
          key != 'Status' &&
          key != 'Creater' &&
          key != 'CreateTime' &&
          key != 'ModifiedTime' &&
          key != "Archives") {
        otherInfo[key] = value;
      }
    });

    if (json['Archives'] != null) {
      json['Archives'].forEach((key, value) {
        archives[key] = Archives.fromJson(value);
      });
    }

    id = json['id'] ?? json['Id'];
    name = json['name'] ?? json['Name'];
    status = json['status'].toString() ?? json['Status'].toString();
    creater = json['creater'] ?? json["createUser"] ?? json['Creater'];
    createTime = json['createTime'] ?? json['CreateTime'];
    modifiedTime = json['modifiedTime'] ?? json['ModifiedTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Id'] = id;
    data['Name'] = name;
    data['Status'] = status;
    data['Creater'] = creater;
    data['CreateTime'] = createTime;
    data['ModifiedTime'] = modifiedTime;
    data.addAll(otherInfo);
    return data;
  }
}

class WorkDefineModel {
  String? id; // 流程ID
  String? name; // 流程名称
  String? code; // 流程编号
  String? icon; // 图标
  String? remark; // 备注
  String? shareId; // 共享组织ID
  String? applicationId; // 应用ID
  String? rule; // 是否创建实体
  WorkNodeModel? resource; // 流程节点

  WorkDefineModel({
    this.id,
    this.name,
    this.code,
    this.icon,
    this.remark,
    this.shareId,
    this.applicationId,
    this.rule,
    this.resource,
  });

  factory WorkDefineModel.fromJson(Map<String, dynamic> json) {
    return WorkDefineModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      icon: json['icon'],
      remark: json['remark'],
      shareId: json['shareId'],
      applicationId: json['applicationId'],
      rule: json['rule'],
      resource: json['resource'] != null
          ? WorkNodeModel.fromJson(json['resource'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'code': code,
      'icon': icon,
      'remark': remark,
      'shareId': shareId,
      'applicationId': applicationId,
      'rule': rule,
      'resource': resource != null ? resource!.toJson() : null,
    };
    return data;
  }
}

class WorkInstanceModel {
  String? defineId; // 流程定义Id
  String? content; // 展示内容
  String? contentType; // 内容类型
  String? data; // 单数据内容
  String? title; // 标题
  String? hook; // 回调地址
  String? taskId; // 对应父流程实例节点任务Id
  String? applyId; // 发起用户ID
  String? childrenData;

  WorkInstanceModel({
    this.defineId,
    this.content,
    this.contentType,
    this.data,
    this.title,
    this.hook,
    this.taskId,
    this.applyId,
    this.childrenData,
  });

  WorkInstanceModel.fromJson(Map<String, dynamic> json) {
    defineId = json['defineId'];
    content = json['content'];
    contentType = json['contentType'];
    data = json['data'];
    title = json['title'];
    hook = json['hook'];
    taskId = json['taskId'];
    applyId = json['applyId'];
    childrenData = json['childrenData'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['defineId'] = defineId;
    data['content'] = content;
    data['contentType'] = contentType;
    data['data'] = this.data;
    data['title'] = title;
    data['hook'] = hook;
    data['taskId'] = taskId;
    data['applyId'] = applyId;
    data['childrenData'] = childrenData;
    return data;
  }
}

class InstanceDataModel {
  /// 流程节点
  WorkNodeModel? node;

  /// 流程节点
  bool? allowAdd; // 允许新增
  bool? allowEdit; // 允许变更
  bool? allowSelect; // 允许选择
  Map<String, List<FieldModel>>? fields;
  /** 表单字段 */ /// 表单id
  Map<String, List<FormEditData>>? data;

  /// 提交的表单数据 // 表单id
  Map<String, dynamic>? primary;

  /// 填写的主表信息

  InstanceDataModel({
    this.node,
    this.allowAdd,
    this.allowEdit,
    this.allowSelect,
    this.fields,
    this.data,
    this.primary,
  });

  InstanceDataModel.fromJson(Map<String, dynamic> json) {
    fields = {};
    data = {};
    if (json['fields'] != null) {
      json['fields'].forEach((key, value) {
        List<FieldModel> fieldList = [];
        if (value is List) {
          for (var fieldJson in value) {
            fieldList.add(FieldModel.fromJson(fieldJson));
          }
        }
        fields?[key] = fieldList;
      });
    }

    if (json['data'] != null) {
      json['data'].forEach((key, value) {
        List<FormEditData> formDataList = [];
        if (value is List) {
          for (var formDataJson in value) {
            formDataList.add(FormEditData.fromJson(formDataJson));
          }
        }
        data?[key] = formDataList;
      });
    }

    if (json['primary'] != null) {
      primary = Map<String, dynamic>.from(json['primary']);
    }

    node = WorkNodeModel.fromJson(json['node']);
    allowAdd = json['allowAdd'];
    allowEdit = json['allowEdit'];
    allowSelect = json['allowSelect'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['node'] = node?.toJson();
    data['allowAdd'] = allowAdd;
    data['allowEdit'] = allowEdit;
    data['allowSelect'] = allowSelect;
    data['fields'] = fields?.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));
    data['data'] = this.data?.map(
        (key, value) => MapEntry(key, value.map((e) => e.toJson()).toList()));
    data['primary'] = primary;
    return data;
  }
}

class FieldModel {
  String? id; //标识(特性标识)
  String? name; //名称(特性名称)
  String? code; //代码(属性代码)
  String? valueType; //类型(属性类型)
  String? rule; //规则(特性规则)
  String? remark; //备注(特性描述)
  List<FiledLookup>? lookups; //字典(字典项/分类项)
  late Fields field; //标识(特性标识)
  FieldModel({
    this.id,
    this.name,
    this.code,
    this.valueType,
    this.rule,
    this.remark,
    this.lookups,
  });

  FieldModel.fromJson(Map<String, dynamic> json) {
    List<FiledLookup> lookups = [];
    if (json['lookups'] != null) {
      json['lookups'].forEach((lookupJson) {
        lookups.add(FiledLookup.fromJson(lookupJson));
      });
    }
    id = json['id'];
    name = json['name'];
    code = json['code'];
    valueType = json['valueType'];
    rule = json['rule'];
    remark = json['remark'];
    this.lookups = lookups;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['valueType'] = valueType;
    data['rule'] = rule;
    data['remark'] = remark;
    data['lookups'] = lookups?.map((lookup) => lookup.toJson()).toList();
    return data;
  }
}

class FiledLookup {
  String? id;

  /// 唯一标识(项标识)
  String? text;

  /// 描述(项名称)
  String? value;

  /// 值(项代码)
  String? parentId;

  /// 父级Id(项的父级Id)
  String? icon;

  /// 图标

  FiledLookup({
    this.id,
    this.text,
    this.value,
    this.parentId,
    this.icon,
  });

  FiledLookup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    text = json['text'];
    value = json['value'];
    parentId = json['parentId'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    data['value'] = value;
    data['parentId'] = parentId;
    data['icon'] = icon;
    return data;
  }
}

class FormEditData {
  List<AnyThingModel> before = [];

  /// 操作前数据体
  List<AnyThingModel> after = [];

  /// 操作后数据体
  String? nodeId;

  /// 流程节点Id
  String? creator;

  /// 操作人
  String? createTime;

  /// 操作时间

  FormEditData({
    required this.before,
    required this.after,
    this.nodeId,
    this.creator,
    this.createTime,
  });

  FormEditData.fromJson(Map<String, dynamic> json) {
    if (json['before'] != null) {
      json['before'].forEach((itemJson) {
        before.add(AnyThingModel.fromJson(itemJson));
      });
    }

    if (json['after'] != null) {
      json['after'].forEach((itemJson) {
        after.add(AnyThingModel.fromJson(itemJson));
      });
    }
    nodeId = json['nodeId'];
    creator = json['creator'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['before'] = before.map((item) => item.toJson()).toList();
    data['after'] = after.map((item) => item.toJson()).toList();
    data['nodeId'] = nodeId;
    data['creator'] = creator;
    data['createTime'] = createTime;
    return data;
  }
}

class WorkNodeModel {
  String? id;
  String? code; // 节点编号
  String? type; // 节点类型
  String? name; // 节点名称
  WorkNodeModel? children; // 子节点
  List<Branche>? branches; // 节点分支
  int? num; // 节点审批数量
  String? destType; // 节点审批目标类型
  String? destId; // 节点审批目标Id
  String? destName; // 节点目标名称
  String? defineId; // 节点归属组织
  List<FormInfo>? forms;

  List<XForm>? primaryForms; // 主表
  List<XForm>? detailForms; // 子表

  WorkNodeModel({
    required this.id,
    required this.code,
    required this.type,
    required this.name,
    this.children,
    this.branches,
    required this.num,
    required this.destType,
    required this.destId,
    required this.destName,
    required this.defineId,
    this.forms,
    this.primaryForms,
    this.detailForms,
  });

  factory WorkNodeModel.fromJson(Map<String, dynamic> json) {
    return WorkNodeModel(
      id: json['id'],
      code: json['code'],
      type: json['type'],
      name: json['name'],
      children: json['children'] != null
          ? WorkNodeModel.fromJson(json['children'])
          : null,
      branches: json['branches'] != null
          ? List<Branche>.from(json['branches'].map((x) => Branche.fromJson(x)))
          : null,
      num: json['num'],
      destType: json['destType'],
      destId: json['destId'],
      destName: json['destName'],
      defineId: json['defineId'],
      forms: json['forms'] != null
          ? List<FormInfo>.from(json['forms'].map((x) => FormInfo.fromJson(x)))
          : null,
      primaryForms: json['primaryForms'] != null
          ? List<XForm>.from(json['primaryForms'].map((x) => XForm.fromJson(x)))
          : null,
      detailForms: json['detailForms'] != null
          ? List<XForm>.from(json['detailForms'].map((x) => XForm.fromJson(x)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['code'] = code;
    data['type'] = type;
    data['name'] = name;
    if (children != null) {
      data['children'] = children!.toJson();
    }
    if (branches != null) {
      data['branches'] = branches!.map((x) => x.toJson()).toList();
    }
    data['num'] = num;
    data['destType'] = destType;
    data['destId'] = destId;
    data['destName'] = destName;
    data['defineId'] = defineId;
    if (forms != null) {
      data['forms'] = forms?.map((x) => x.toJson()).toList();
    }

    if (primaryForms != null) {
      data['primaryForms'] = forms?.map((x) => x.toJson()).toList();
    }
    if (detailForms != null) {
      data['detailForms'] = forms?.map((x) => x.toJson()).toList();
    }
    return data;
  }
}

class FormInfo {
  String? id;
  String? typeName; // 节点名称

  FormInfo({this.id, this.typeName});

  factory FormInfo.fromJson(Map<String, dynamic> json) {
    return FormInfo(
      id: json['id'],
      typeName: json['typeName'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (id != null) {
      data['id'] = id;
    }
    if (typeName != null) {
      data['typeName'] = typeName;
    }
    return data;
  }
}

class Branche {
  List<Condition>? conditions;
  WorkNodeModel? children;

  Branche({this.conditions, this.children});

  factory Branche.fromJson(Map<String, dynamic> json) {
    return Branche(
      conditions: json['conditions'] != null
          ? List<Condition>.from(
              json['conditions'].map((x) => Condition.fromJson(x)))
          : null,
      children: json['children'] != null
          ? WorkNodeModel.fromJson(json['children'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (conditions != null) {
      data['conditions'] = conditions!.map((x) => x.toJson()).toList();
    }
    if (children != null) {
      data['children'] = children!.toJson();
    }
    return data;
  }
}

class Condition {
  // 规则
  String? paramKey;

  // 键
  String? key;

  // 类型
  String? type;

  // 值
  String? val;

  //构造方法
  Condition({
    required this.paramKey,
    required this.key,
    required this.type,
    required this.val,
  });

  Condition.fromJson(Map<String, dynamic> json) {
    paramKey = json['paramKey'];
    key = json['key'];
    type = json['type'];
    val = json['val'];
  }

  Map<String, dynamic> toJson() {
    return {
      "paramKey": paramKey,
      "key": key,
      "type": type,
      "val": val,
    };
  }
}

class QueryTaskReq {
  // 流程定义Id
  final String defineId;

  // 任务类型 审批、抄送
  final String typeName;

  QueryTaskReq(this.defineId, this.typeName);

  QueryTaskReq.fromJson(Map<String, dynamic> json)
      : defineId = json["defineId"],
        typeName = json["typeName"];

  static List<QueryTaskReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<QueryTaskReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(QueryTaskReq.fromJson(item));
      }
    }
    return retList;
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["defineId"] = defineId;
    json["typeName"] = typeName;
    return json;
  }
}

class ApprovalTaskReq {
  // 流程定义Id
  final String? id;

  // 状态
  final int? status;

  // 评论
  final String? comment;

  // 数据
  final String? data;

  //构造方法
  ApprovalTaskReq({
    this.id,
    this.status,
    this.comment,
    this.data,
  });

  //通过JSON构造
  ApprovalTaskReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        status = json["status"],
        comment = json["comment"],
        data = json["data"];

  //通过动态数组解析成List
  static List<ApprovalTaskReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ApprovalTaskReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ApprovalTaskReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["status"] = status;
    json["comment"] = comment;
    json["data"] = data;
    return json;
  }
}

class TargetMessageModel {
  late String data; // 内容
  late bool excludeOperater; // 是否剔除当前操作人
  late String targetId; // 目标用户Id集合
  late bool group; // 组织集群

  TargetMessageModel({
    required this.data,
    required this.excludeOperater,
    required this.targetId,
    required this.group,
  });

  factory TargetMessageModel.fromJson(Map<String, dynamic> json) {
    return TargetMessageModel(
      data: json['data'] as String,
      excludeOperater: json['excludeOperater'] as bool,
      targetId: json['targetId'] as String,
      group: json['group'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'excludeOperater': excludeOperater,
      'targetId': targetId,
      'group': group,
    };
  }
}

class IdentityMessageModel {
  // 内容
  late String data;
  //是否剔除当前操作人
  late bool excludeOperater;
  //身份Id
  late String identityId;
  //岗位Id
  late String stationId;
  //组织集群
  late bool group;

  IdentityMessageModel({
    required this.data,
    required this.excludeOperater,
    required this.identityId,
    required this.stationId,
    required this.group,
  });

  factory IdentityMessageModel.fromJson(Map<String, dynamic> json) {
    return IdentityMessageModel(
      data: json['data'] as String,
      excludeOperater: json['excludeOperater'] as bool,
      identityId: json['identityId'] as String,
      stationId: json['stationId'] as String,
      group: json['group'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data,
      'excludeOperater': excludeOperater,
      'identityId': identityId,
      'stationId': stationId,
      'group': group,
    };
  }
}

class TargetOperateModel {
  String? operate;
  XTarget? target;
  XTarget? subTarget;
  XTarget? operater;

  TargetOperateModel({
    this.operate,
    this.target,
    this.subTarget,
    this.operater,
  });

  TargetOperateModel.fromJson(Map<String, dynamic> json) {
    operate = json['operate'];
    target = XTarget.fromJson(json['target']);
    subTarget =
        json['subTarget'] != null ? XTarget.fromJson(json['subTarget']) : null;
    operater = XTarget.fromJson(json['operater']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'operate': operate,
      'target': target?.toJson(),
      'operater': operater?.toJson(),
    };
    if (subTarget != null) {
      data['subTarget'] = subTarget!.toJson();
    }
    return data;
  }
}

class IdentityOperateModel {
  String? operate;
  XTarget? operater;
  XIdentity? identity;
  XTarget? station;
  XTarget? subTarget;

  IdentityOperateModel({
    this.operate,
    this.operater,
    this.identity,
    this.station,
    this.subTarget,
  });

  IdentityOperateModel.fromJson(Map<String, dynamic> json) {
    operate = json['operate'];
    operater =
        json['operater'] != null ? XTarget.fromJson(json['operater']) : null;
    identity =
        json['identity'] != null ? XIdentity.fromJson(json['identity']) : null;
    station =
        json['station'] != null ? XTarget.fromJson(json['station']) : null;
    subTarget =
        json['subTarget'] != null ? XTarget.fromJson(json['subTarget']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'operate': operate,
      'operater': operater?.toJson(),
      'identity': identity?.toJson(),
      'station': station?.toJson(),
      'subTarget': subTarget?.toJson(),
    };
  }
}

///AuthorityOperateModel
class AuthorityOperateModel {
  //操作方式
  late String operate;
  //操作人
  XTarget? operater;
  //操作的职权
  XAuthority? authority;

  AuthorityOperateModel({
    required this.operate,
    required this.operater,
    required this.authority,
  });

  AuthorityOperateModel.fromJson(Map<String, dynamic> json) {
    operate = json['operate'];
    operater =
        json['operater'] != null ? XTarget.fromJson(json['operater']) : null;
    authority = json['authority'] != null
        ? XAuthority.fromJson(json['authority'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'operate': operate,
      'operater': operater?.toJson(),
      'authority': authority?.toJson(),
    };
  }
}

// 文件系统项分享数据
class ShareIcon {
  // 名称
  String name;

  // 类型
  String typeName;

  // 头像
  FileItemShare? avatar;

  //构造方法
  ShareIcon({
    required this.name,
    required this.typeName,
    this.avatar,
  }) {
    // String defaultAvatar = '';
    // if (typeName == TargetType.person.label) {
    //   defaultAvatar = AssetsImages.chatDefaultPerson;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else if (typeName == TargetType.cohort.label) {
    //   defaultAvatar = AssetsImages.chatDefaultCohort;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else if (typeName == TargetType.department.label) {
    //   defaultAvatar = AssetsImages.chatDefaultCohort;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else if (typeName == TargetType.company.label) {
    //   // defaultAvatar = AssetsImages.chatDefaultCohort;
    //   defaultAvatar = AssetsSvgs.newCompany;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else if (typeName == TargetType.storage.label) {
    //   defaultAvatar = AssetsImages.iconFile;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else if (typeName == '动态') {
    //   defaultAvatar = IconsUtils.icons['x']?['home'] ?? "";
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // } else {
    //   defaultAvatar = AssetsImages.chatDefaultCohort;
    //   avatar ??= FileItemShare(defaultAvatar: defaultAvatar);
    // }
  }

  //通过JSON构造
  ShareIcon.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        typeName = json["typeName"],
        avatar = json["avatar"] != null
            ? FileItemShare.fromJson(json["avatar"])
            : null;

  //通过动态数组解析成List
  static List<ShareIcon> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ShareIcon> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ShareIcon.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["typeName"] = typeName;
    json["avatar"] = avatar?.toJson();
    return json;
  }

  String defaultAvatar() {
    String defaultAvatar = '';
    if (typeName == TargetType.person.label) {
      defaultAvatar = AssetsImages.chatDefaultPerson;
    } else if (typeName == TargetType.cohort.label) {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == TargetType.department.label) {
      defaultAvatar = AssetsImages.chatDefaultCohort;
    } else if (typeName == TargetType.company.label) {
      // defaultAvatar = AssetsImages.chatDefaultCohort;
      defaultAvatar = AssetsSvgs.newCompany;
    } else if (typeName == TargetType.storage.label) {
      defaultAvatar = AssetsImages.iconFile;
    } else if (typeName == '动态') {
      defaultAvatar = IconsUtils.icons['x']?['home'] ?? "";
    }
    return defaultAvatar;
  }
}

// 文件系统项数据模型
class FileItemShare {
  // 大小
  int? size;
  // 名称
  String? name;
  // 视频封面
  String? poster;
  // 共享链接
  String? shareLink;
  // 文件类型
  String? contentType;
  // 拓展名
  String? extension;
  // 缩略图
  String? thumbnail;
  String? defaultAvatar;
  FileItemShare({
    this.size,
    this.name,
    this.poster,
    this.shareLink,
    this.contentType,
    this.extension,
    this.thumbnail,
    this.defaultAvatar,
  });

  //通过JSON构造
  FileItemShare.fromJson(Map<String, dynamic> json) {
    size = json["size"];
    name = json["name"];
    poster = json['poster'];
    shareLink = json["shareLink"];
    contentType = json["contentType"];
    extension = json["extension"];
    thumbnail = json["thumbnail"];
    defaultAvatar = json["defaultAvatar"];
  }

  //通过动态数组解析成List
  static List<FileItemShare> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<FileItemShare> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FileItemShare.fromJson(item));
      }
    }
    return retList;
  }

  Uint8List? get thumbnailUint8List {
    try {
      var uint8ListStr =
          thumbnail?.split(",")[1].replaceAll('\r', '').replaceAll('\n', '');
      if (uint8ListStr == null) {
        return null;
      }
      return base64Decode(uint8ListStr);
    } catch (e) {
      return null;
    }
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["size"] = size;
    json["name"] = name;
    json['poster'] = poster;
    json["shareLink"] = shareLink;
    json["contentType"] = contentType;
    json["extension"] = extension;
    json["thumbnail"] = thumbnail;
    json["defaultAvatar"] = defaultAvatar;
    return json;
  }

  static FileItemShare? parseAvatar(String? avatar) {
    if (avatar != null) {
      try {
        var share = FileItemShare.fromJson(jsonDecode(avatar));
        return share;
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}

/// 文件系统项数据模型
class FileItemModel extends FileItemShare {
  // 完整路径
  String key;

  // 创建时间
  String? dateCreated;

  // 修改时间
  String? dateModified;

  // 文件类型
  @override
  String? contentType;

  // 是否是目录
  bool isDirectory;

  // 是否包含子目录
  bool hasSubDirectories;

  FileItemModel({
    required this.key,
    required this.dateCreated,
    required this.dateModified,
    this.contentType,
    required this.isDirectory,
    required this.hasSubDirectories,
    super.size,
    super.name,
    super.shareLink,
    super.extension,
    super.thumbnail,
  });

  FileItemModel.fromJson(Map<String, dynamic> json)
      : key = json['key'] ?? "",
        isDirectory = json['isDirectory'] ?? false,
        contentType = json['contentType'],
        dateCreated = json['dateCreated'] ?? "",
        dateModified = json['dateModified'] ?? "",
        hasSubDirectories = json['hasSubDirectories'] ?? false,
        super(
          size: json["size"],
          name: json["name"],
          contentType: json['contentType'],
          shareLink: json["shareLink"],
          poster: json["poster"],
          extension: json["extension"],
          thumbnail: json["thumbnail"],
        );

  //通过动态数组解析成List
  static List<FileItemModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<FileItemModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FileItemModel.fromJson(item));
      }
    }
    return retList;
  }

  Map<String, dynamic> shareInfo() {
    String url = "${Constant.host}/orginone/anydata/bucket/load/$shareLink";
    return {
      "shareLink": url,
      "size": size,
      "name": name,
      "extension": extension,
      "thumbnail": thumbnail,
    };
  }
}

/// 桶支持的操作
enum BucketOpreates {
  list("List"),
  create("Create"),
  rename("Rename"),
  move("Move"),
  copy("Copy"),
  delete("Delete"),
  upload("Upload"),
  abortUpload("AbortUpload");

  const BucketOpreates(this.label);

  final String label;

  static String getName(BucketOpreates opreate) {
    return opreate.label;
  }
}

/// 桶操作携带的数据模型
class BucketOpreateModel {
  // 完整路径
  final String key;

  // 名称
  String? name;

  // 目标
  String? destination;

  // 操作
  late BucketOpreates operate;

  // 携带的分片数据
  FileChunkData? fileItem;

  BucketOpreateModel({
    required this.key,
    this.name,
    required this.operate,
    this.destination,
    this.fileItem,
  });

  Map<String, dynamic> toJson() {
    return {
      "key": key,
      "name": name,
      "operate": operate.label,
      "fileItem": fileItem?.toJson(),
      "destination": destination,
    };
  }
}

/// 上传文件携带的数据
class FileChunkData {
  // 分片索引
  final int index;

  // 文件大小
  final int size;

  // 上传的唯一ID
  final String uploadId;

  // 分片数据编码字符串
  final String? dataUrl;

  final List data;

  FileChunkData({
    required this.data,
    required this.index,
    required this.size,
    required this.uploadId,
    this.dataUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      "index": index,
      "size": size,
      'data': data,
      "uploadId": uploadId,
      "dataUrl": dataUrl,
    };
  }
}

/// 任务模型
class TaskModel {
  final String name;

  final int size;

  int finished;

  final DateTime createTime;

  TaskModel({
    required this.name,
    required this.size,
    required this.finished,
    required this.createTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "size": size,
      'finished': finished,
      "createTime": createTime,
    };
  }
}

/// 操作命令模型
class OperateModel {
  final String cmd;

  final int sort;

  final String label;
  final String iconType;

  final List<OperateModel>? menus;

  OperateModel({
    required this.cmd,
    required this.sort,
    required this.label,
    required this.iconType,
    required this.menus,
  });
  factory OperateModel.fromJson(Map<String, dynamic> json) {
    return OperateModel(
      cmd: json['cmd'] as String,
      sort: json['sort'] as int,
      label: json['label'] as String,
      iconType: json['iconType'] as String,
      menus: (json['menus'] as List<dynamic>?)
          ?.map((e) => OperateModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "cmd": cmd,
      "sort": sort,
      "label": label,
      "iconType": iconType,
      "menus": menus,
    };
  }

  Map<String, dynamic> toMap() {
    return {
      'sort': sort,
      'cmd': cmd,
      'label': label,
      'iconType': iconType,
    };
  }
}

/// 会话元数据
class MsgChatData {
  /// 消息类会话完整Id
  late String fullId;

  /// 会话标签
  late List<String> labels;

  /// 会话名称
  late String chatName;

  /// 会话备注
  late String chatRemark;

  /// 是否置顶
  late bool isToping;

  /// 会话未读消息数量
  late int noReadCount;

  /// 最后一次消息时间
  late int lastMsgTime;

  /// 最新消息
  late ChatMessageType? lastMessage;

  /// 提及我
  late bool mentionMe;

  /// 最近活跃
  late bool recently;

  MsgChatData({
    required this.fullId,
    required this.labels,
    required this.chatName,
    required this.chatRemark,
    required this.isToping,
    required this.noReadCount,
    required this.lastMsgTime,
    required this.lastMessage,
    required this.mentionMe,
    required this.recently,
  });

  MsgChatData.fromJson(Map<String, dynamic> json) {
    fullId = json['fullId'];
    labels = json['labels'] != null ? List.castFrom(json["labels"]) : [];
    chatName = json['chatName'];
    chatRemark = json['chatRemark'];
    isToping = json['isToping'];
    noReadCount = json['noReadCount'];
    lastMsgTime = json['lastMsgTime'];
    // TODO 临时处理解决消息排序不准确问题
    if (lastMsgTime > 9999999999999) {
      lastMsgTime = int.parse('$lastMsgTime'.substring(0, 13));
    }
    lastMessage = json['lastMessage'] != null
        ? ChatMessageType.fromJson(json['lastMessage'])
        : null;
    mentionMe = json['mentionMe'];
    recently = json['recently'] ?? false;
  }

  Map<String, dynamic> toJson() {
    return {
      "fullId": fullId,
      "labels": labels,
      "chatName": chatName,
      "chatRemark": chatRemark,
      "isToping": isToping,
      "noReadCount": noReadCount,
      "lastMsgTime": lastMsgTime,
      "lastMessage": lastMessage?.toJson(),
      "mentionMe": mentionMe,
      "recently": recently,
    };
  }
}

// 动态
class ActivityType extends Xbase {
  // 类型
  String typeName;
  // 内容
  String content;
  // 资源
  List<FileItemShare> resource;
  // 评注
  List<CommentType> comments;
  // 点赞
  List<String> likes;
  // 转发
  List<String> forward;
  // 标签
  List<String> tags;

  ActivityType({
    required this.typeName,
    required this.content,
    required this.resource,
    required this.comments,
    required this.likes,
    required this.forward,
    required this.tags,
    required super.id,
  });

  ActivityType.fromJson(Map<String, dynamic> json)
      : typeName = json['typeName'],
        content = json['content'],
        resource = null != json['resource']
            ? Lists.fromList(
                json['resource'], (data) => FileItemShare.fromJson(data))
            : [],
        comments = null != json['comments']
            ? Lists.fromList(
                json['comments'], (data) => CommentType.fromJson(data))
            : [],
        likes = null != json['likes'] ? json['likes'].cast<String>() : [],
        forward = null != json['forward'] ? json['forward'].cast<String>() : [],
        tags = null != json['tags'] ? json['tags'].cast<String>() : [],
        super(
            id: json['id'] ?? "",
            belongId: json['belongId'] ?? "",
            createUser: json['createUser'] ?? "",
            createTime: json['createTime'] ?? "",
            updateTime: json['updateTime'] ?? "",
            shareId: json['shareId'] ?? "",
            status: json['status'] ?? 0,
            updateUser: json['updateUser' ?? ""],
            version: json['version'].toString() ?? "");

  @override
  Map<String, dynamic> toJson() {
    return {
      "typeName": typeName,
      "content": content,
      "resource": resource,
      "comments": comments,
      "likes": likes,
      "forward": forward,
      "tags": tags,
      ...super.toJson(),
    };
  }
}

class LoadOptions {
  List<dynamic> filter; // 过滤条件
  int take; // 获取数量
  String group; // 分组字段
  int skip; // 跳过数量
  dynamic options; // 其他选项

  LoadOptions({
    required this.filter,
    required this.take,
    required this.group,
    required this.skip,
    required this.options,
  });
}

class DirectoryContent {
  List<XForm> forms; // 表单列表
  List<XSpecies> specieses; // 物种列表
  List<XProperty> propertys; // 属性列表
  List<XApplication> applications; // 应用列表
  List<XDirectory> directorys; // 目录列表

  DirectoryContent({
    required this.forms,
    required this.specieses,
    required this.propertys,
    required this.applications,
    required this.directorys,
  });
}

class Mapping extends Node {
  String source; // 源
  String target; // 目标
  List<SubMapping> mappings; // 映射列表

  Mapping(
      {required this.source,
      required this.target,
      required this.mappings,
      required super.id,
      required super.code,
      required super.name,
      required super.typeName,
      super.preScripts,
      super.postScripts,
      super.status});
}

class SubMapping {
  String source; // 源
  String target; // 目标
  List<SubMapping>? mappings; // 映射列表

  SubMapping({
    required this.source,
    required this.target,
    this.mappings,
  });
}

// 存储
class Store extends Node {
  String directoryId; // 目录 ID
  String workId; // 办事 ID
  List<String> formIds; // 表单 ID
  bool directIs; // 是否直接存入平台

  Store({
    required this.formIds,
    required this.directoryId,
    required this.workId,
    required this.directIs,
    required super.id,
    required super.name,
    required super.typeName,
    required super.code,
    super.preScripts,
    super.postScripts,
    super.status,
  });
}

///子配置
class SubTransfer extends Node {
  // 子配置 ID
  String nextId;

  SubTransfer(
      {required this.nextId,
      required super.code,
      required super.id,
      required super.name,
      required super.typeName,
      super.preScripts,
      super.postScripts,
      super.status});
}

class Selection {
  String type; // 类型 ('checkbox' 或 'radio')
  String key; // 关键字
  String formId; // 表单 ID

  Selection({
    required this.type,
    required this.key,
    required this.formId,
  });
}

class Environment {
  String id; // 环境 ID
  String name; // 环境名称
  KeyValue params; // 参数

  Environment({
    required this.id,
    required this.name,
    required this.params,
  });

  Environment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        params = KeyValue.from(json['params']);
}

class Script {
  String id; // 脚本 ID
  String name; // 脚本名称
  String code; // 脚本代码

  Script({
    required this.id,
    required this.name,
    required this.code,
  });
}

/// 图状态
enum GStatus {
  editable("Editable"),
  viewable("Viewable"),
  running("Running"),
  completed("Completed"),
  error("Error");

  const GStatus(this.label);

  final String label;

  static String getName(GraphStatus stasus) {
    return stasus.label;
  }
}

/// 图事件
enum GEvent {
  editRun("EditRun"),
  viewRun("ViewRun"),
  throw_("Throw"),
  completed("Completed");

  const GEvent(this.label);

  final String label;

  static String getName(GraphStatus stasus) {
    return stasus.label;
  }
}

/// 节点状态
enum NStatus {
  editable("Editable"),
  viewable("Viewable"),
  running("Running"),
  completed("Completed"),
  error("Error");

  const NStatus(this.label);

  final String label;

  static String getName(GraphStatus stasus) {
    return stasus.label;
  }
}

/// 节点类型
enum NodeType {
  form("表单"),
  table("表格"),
  request("请求"),
  subGraph("子图"),
  mapping("映射"),
  storage("存储");

  const NodeType(this.label);

  final String label;

  static String getName(GraphStatus stasus) {
    return stasus.label;
  }
}

enum GraphStatus {
  editable("Editable"),
  viewable("Viewable"),
  running("Running");

  const GraphStatus(this.label);

  final String label;

  static String getName(GraphStatus stasus) {
    return stasus.label;
  }
}

// ts中的 联合类型
// export type NodeStatus = 'Completed' | 'Error' | GraphStatus;
enum NodeStatus {
  completed("Completed"),
  error("Error"),
  editable("Editable"),
  viewable("Viewable"),
  running("Running");

  const NodeStatus(this.label);

  final String label;

  static String getName(NodeStatus stasus) {
    return stasus.label;
  }
}

enum Event {
  edit("Edit"),
  view("View"),
  run("Run");

  const Event(this.label);

  final String label;

  static String getName(Event event) {
    return event.label;
  }
}

enum ScriptPos {
  pre("pre"),
  post("post");

  const ScriptPos(this.label);

  final String label;

  static String getName(ScriptPos scriptPos) {
    return scriptPos.label;
  }
}

class Node {
  String id; // 主键
  String code; // 编码
  String name; // 名称
  String typeName; // 类型
  String? preScripts; // 前置脚本
  String? postScripts; // 后置脚本
  NStatus? status; // 后置脚本

  Node({
    required this.id,
    required this.code,
    required this.name,
    required this.typeName,
    this.preScripts,
    this.postScripts,
    this.status,
  });

  Node.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        code = json['code'],
        name = json['name'],
        typeName = json['typeName'],
        preScripts = json['preScripts'],
        postScripts = json['postScripts'],
        status = NStatus.values.singleWhere((element) =>
            element.label ==
            json['status']); //NStatus.value(json['status'] as String);
}

class Edge {
  String id; // 主键
  String start; // 开始
  String end; // 结束

  Edge({
    required this.id,
    required this.start,
    required this.end,
  });
  Edge.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        start = json['start'],
        end = json['end'];
}
// 请求

class Request extends Node {
  HttpRequestType data; //

  Request(
      {required this.data,
      required super.id,
      required super.code,
      required super.name,
      required super.typeName,
      super.preScripts,
      super.postScripts,
      super.status});
}

class Tables extends Node {
  List<String> formIds; //
  FileItemModel? file; //

  Tables(
      {required this.formIds,
      this.file,
      required super.id,
      required super.code,
      required super.name,
      required super.typeName,
      super.preScripts,
      super.postScripts,
      super.status});
}

class Sheet<T> {
  String name; //名称
  int headers; //表头行数
  List<Column> columns; //列信息
  List<T> data; //
  //

  Sheet({
    required this.name,
    required this.headers,
    required this.columns,
    required this.data,
  });
}

class Column {
  String title; //字段名称
  String dataIndex; //标识符
  String valueType; //类型
  bool? hide; //是否隐藏
  //

  Column({
    required this.title,
    required this.dataIndex,
    required this.valueType,
    this.hide,
  });
}

abstract class KeyValue {
  external factory KeyValue();
  dynamic operator [](String? key);

  void operator []=(String key, dynamic value);
  factory KeyValue.from(Map<String, dynamic> json) {
    Map aa = {};
    aa['dd'] = '';
    KeyValue result = KeyValue();
    json.forEach((String k, dynamic v) {
      result[k] = v;
    });
    return result;
  }
}

class Shift<T, S> {
  S start;
  T event;
  S end;

  Shift({required this.start, required this.event, required this.end});
}

// 迁移配置
class XTransfer extends XStandard {
  // 环境集合
  late List<Environment> envs;
  // 当前环境
  String? curEnv;
  // 节点集合
  late List<Node> nodes;
  // 边集合
  late List<Edge> edges;
  // 图数据
  late dynamic graph;
  // 是否自循环
  late final bool isSelfCirculation;
  // 退出循环脚本
  late final String judge;
  XTransfer({
    required this.envs,
    this.curEnv,
    required this.nodes,
    required this.edges,
    required this.graph,
    required this.isSelfCirculation,
    required this.judge,
    required super.directoryId,
    required super.id,
    required super.typeName,
    required super.isDeleted,
  });
  XTransfer.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    envs = Lists.fromList(json['envs'], Environment.fromJson);
    curEnv = json['curEnv'];
    nodes = Lists.fromList(json['nodes'], Node.fromJson);
    edges = Lists.fromList(json['edges'], Edge.fromJson);
    graph = json['graph'];
    isSelfCirculation = json['isSelfCirculation'];
    judge = json['judge'];
    directoryId = json['directoryId'];
    id = json['id'];
    typeName = json['typeName'];
  }
}

// 任务
class XTask {
  // 唯一标识
  String id;
  // 当前状态
  GStatus status;
  // 环境
  Environment? env;
  // 节点
  List<Node> nodes;
  // 边
  List<Edge> edges;
  // 图数据
  dynamic graph;
  // 开始时间
  DateTime startTime;
  // 结束时间
  DateTime? endTime;

  XTask({
    required this.id,
    required this.status,
    this.env,
    required this.nodes,
    required this.edges,
    required this.graph,
    required this.startTime,
    this.endTime,
  });
}

class SettingWidget {
  String name; // 按钮生成的 schema 的 key 值
  String text; // 在左侧栏按钮展示文案
  String? icon; // 在左侧栏按钮展示图标
  String? widget; // 如果是基本组件，这个字段注明它对应的 widgets
  dynamic schema; // 组件对应的 schema 片段
  dynamic setting; // 组件的配置信息，使用 form-render 的 schema 来描述

  SettingWidget({
    required this.name,
    required this.text,
    this.icon,
    this.widget,
    this.schema,
    this.setting,
  });
}

class Setting {
  String title; // 最外层的分组名称
  List<SettingWidget> widgets; // 每个组件的配置，在左侧栏是一个按钮
  bool? show;
  bool? useCommon;

  Setting({
    required this.title,
    required this.widgets,
    this.show,
    this.useCommon,
  });
}

class SchemaType {
  String displayType; // 'row' 或 'column' 的显示类型
  String type; // 'object' 的类型
  dynamic labelWidth; // 数字或字符串的标签宽度
  Map<String, dynamic> properties; // 属性的记录
  int column; // 1、2 或 3 的列数

  SchemaType({
    required this.displayType,
    required this.type,
    required this.labelWidth,
    required this.properties,
    required this.column,
  });
}

ResultType get badRequest {
  return ResultType(success: false, msg: '请求失败', code: 400);
}

ResultType getRequest([String msg = '请求失败', int code = 400]) {
  return ResultType(success: false, msg: msg, code: code);
}

class SubMethodsModel {
  List<String> keys;
  Function operation;

  SubMethodsModel({
    required this.keys,
    required this.operation,
  });

  SubMethodsModel.fromJson(Map<String, dynamic> json)
      : keys = json['keys'],
        operation = json['operation'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['keys'] = keys;
    map['operation'] = operation;

    return map;
  }
}

//TODO:以下是旧模型  待验证是否还使用 不用可以删除
class PageResp<T> {
  final int limit;
  final int total;
  final List<T> result;

  PageResp(this.limit, this.total, this.result);

  static PageResp<T> fromMap<T>(Map<String, dynamic> map, Function mapping) {
    int limit = map["limit"] ?? 0;
    int total = map["total"] ?? 0;
    List<dynamic> result = map["result"] ?? [];

    List<T> ans = result.map((item) => mapping(item) as T).toList();
    return PageResp<T>(limit, total, ans);
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["limit"] = limit;
    json["total"] = total;
    json["result"] = result;
    return json;
  }
}

class FileItemArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<FileItemModel>? result;

  //构造方法
  FileItemArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  FileItemArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((e) {
        result!.add(FileItemModel.fromJson(e));
      });
    }
  }

  //通过动态数组解析成List
  static List<XAttributeArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XAttributeArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XAttributeArray.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["offset"] = offset;
    json["limit"] = limit;
    json["total"] = total;
    json["result"] = result;
    return json;
  }
}

class IdReq {
  // 唯一ID
  final String id;

  //构造方法
  IdReq({
    required this.id,
  });

  //通过JSON构造
  IdReq.fromJson(Map<String, dynamic> json) : id = json["id"];

  //通过动态数组解析成List
  static List<IdReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json['page'] = PageRequest(offset: 0, limit: 9999, filter: '').toJson();
    return json;
  }
}

class CreateDefineReq {
  // 唯一Id
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 备注
  String? remark;

  //节点信息
  XWorkNode? resource;

  // 归属Id
  String? belongId;

  //分类id
  String? speciesId;

  // 权限ID
  String? authId;

  //是否公开
  bool? public;

  //数据源id
  String? sourceIds;

  //是否创建实体
  bool? isCreate;

  CreateDefineReq(
      {this.id,
      this.name,
      this.code,
      this.remark,
      this.belongId,
      this.speciesId,
      this.authId,
      this.public,
      this.sourceIds,
      this.isCreate,
      this.resource});

  CreateDefineReq.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    remark = json['remark'];
    belongId = json['belongId'];
    speciesId = json['speciesId'];
    authId = json['authId'];
    public = json['public'];
    sourceIds = json['sourceIds'];
    isCreate = json['isCreate'];
    resource =
        json['resource'] != null ? XWorkNode.fromJson(json['resource']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "code": code,
      "remark": remark,
      "belongId": belongId,
      "speciesId": speciesId,
      "authId": authId,
      "public": public,
      "isCreate": isCreate,
      "sourceIds": sourceIds,
      "resource": resource?.toJson(),
    };
  }
}

class NameModel {
  // 名称
  final String name;

  // 图片
  final String photo;

  //构造方法
  NameModel({
    required this.name,
    required this.photo,
  });

  //通过JSON构造
  NameModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        photo = json["photo"];

  //通过动态数组解析成List
  static List<NameModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<NameModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(NameModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["photo"] = photo;
    return json;
  }
}

class IdReqModel {
  // 唯一ID
  final String id;

  // 实体类型
  final String typeName;

  // 归属ID
  late String? belongId;

  //构造方法
  IdReqModel({
    required this.id,
    required this.typeName,
    this.belongId,
  });

  //通过JSON构造
  IdReqModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        typeName = json["typeName"],
        belongId = json["belongId"];

  //通过动态数组解析成List
  static List<IdReqModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdReqModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdReqModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeName"] = typeName;
    json["belongId"] = belongId;
    return json;
  }
}

class GetSpeciesModel {
  final String id;
  final bool upTeam;
  final String belongId;
  final String filter;

  GetSpeciesModel({
    required this.id,
    required this.upTeam,
    required this.belongId,
    required this.filter,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["upTeam"] = upTeam;
    json['belongId'] = belongId;
    json['filter'] = filter;
    return json;
  }
}

class ResetPwdModel {
  // 唯一ID
  final String account;

  // 实体类型
  final String? privateKey;

  // 归属ID
  final String? dynamicId;
  final String? dynamicCode;
  final String password;

  //构造方法
  ResetPwdModel({
    required this.account,
    required this.password,
    this.privateKey,
    this.dynamicId,
    this.dynamicCode,
  });

  //通过JSON构造
  ResetPwdModel.fromJson(Map<String, dynamic> json)
      : account = json["account"],
        password = json["password"],
        dynamicId = json["dynamicId"],
        dynamicCode = json["dynamicCode"],
        privateKey = json["privateKey"];

  //通过动态数组解析成List
  static List<ResetPwdModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ResetPwdModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ResetPwdModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["account"] = account;
    json["password"] = password;
    json["privateKey"] = privateKey;
    json["dynamicId"] = dynamicId;
    json["dynamicCode"] = dynamicCode;
    return json;
  }
}

class IdArrayReq {
  // 唯一ID数组
  final List<String> ids;

  // 分页
  final PageRequest? page;

  //构造方法
  IdArrayReq({
    required this.ids,
    this.page,
  });

  //通过JSON构造
  IdArrayReq.fromJson(Map<String, dynamic> json)
      : ids = json["ids"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IdArrayReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdArrayReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdArrayReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["ids"] = ids;
    json["page"] = page?.toJson();
    return json;
  }
}

class IdBelongReq {
  // 唯一ID
  final String belongId;

  final PageRequest page;

  IdBelongReq({
    required this.belongId,
    required this.page,
  });

  //通过JSON构造
  IdBelongReq.fromJson(Map<String, dynamic> json)
      : belongId = json["id"],
        page = PageRequest.fromJson(json["page"]);

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = belongId;
    json["page"] = page.toJson();
    return json;
  }
}

class IdSpaceReq {
  // 唯一ID
  final String id;

  // 工作空间ID
  final String spaceId;

  // 分页
  PageRequest? page;

  //构造方法
  IdSpaceReq({
    required this.id,
    required this.spaceId,
    this.page,
  });

  //通过JSON构造
  IdSpaceReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        spaceId = json["spaceId"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IdSpaceReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdSpaceReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdSpaceReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json["page"] = page?.toJson();
    return json;
  }
}

class RecordSpaceReq {
  // 唯一ID
  final List<int> status;

  // 工作空间ID
  final String spaceId;

  // 分页
  final PageRequest? page;

  //构造方法
  RecordSpaceReq({
    required this.status,
    required this.spaceId,
    required this.page,
  });

  //通过JSON构造
  RecordSpaceReq.fromJson(Map<String, dynamic> json)
      : status = json["status"],
        spaceId = json["spaceId"],
        page = PageRequest.fromJson(json["page"]);

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["status"] = status;
    json["spaceId"] = spaceId;
    json["page"] = page?.toJson();
    return json;
  }
}

class IdSpeciesReq {
  // 唯一ID
  String? id;

  // 工作空间ID
  String? spaceId;

  // 是否递归组织
  bool? recursionOrg;

  // 是否递归分类
  bool? recursionSpecies;

  // 分页
  PageRequest? page;

  //构造方法
  IdSpeciesReq({
    required this.id,
    required this.spaceId,
    required this.recursionOrg,
    required this.recursionSpecies,
    required this.page,
  });

  //通过JSON构造
  IdSpeciesReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        spaceId = json["spaceId"],
        recursionOrg = json["recursionOrg"],
        recursionSpecies = json["recursionSpecies"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IdSpaceReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdSpaceReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdSpaceReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json["recursionOrg"] = recursionOrg;
    json["recursionSpecies"] = recursionSpecies;
    json["page"] = page?.toJson();
    return json;
  }
}

class IdOperationReq {
  // 唯一ID
  String? id;

  // 工作空间ID
  String? spaceId;

  // 是否权限过滤
  bool? filterAuth;

  // 是否递归组织
  bool? recursionOrg;

  // 是否递归分类
  bool? recursionSpecies;

  // 分页
  PageRequest? page;

  IdOperationReq({
    required this.id,
    required this.spaceId,
    required this.filterAuth,
    required this.recursionOrg,
    required this.recursionSpecies,
    required this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "spaceId": spaceId,
      "filterAuth": filterAuth,
      "recursionOrg": recursionOrg,
      "recursionSpecies": recursionSpecies,
      "page": page?.toJson(),
    };
  }
}

class IdArraySpaceReq {
  // 唯一ID
  final List<String> ids;

  // 工作空间ID
  final String spaceId;

  IdArraySpaceReq({
    required this.ids,
    required this.spaceId,
  });
}

class GetSpeciesResourceModel {
  // 唯一ID
  final String id;

  // 分类唯一ID
  final String speciesId;

  // 当前归属用户ID
  final String belongId;

  // 是否向上递归用户
  final bool upTeam;

  // 是否向上递归分类
  final bool upSpecies;

  // 分页
  final PageRequest page;

  GetSpeciesResourceModel({
    required this.id,
    required this.speciesId,
    required this.belongId,
    required this.upTeam,
    required this.upSpecies,
    required this.page,
  });

  factory GetSpeciesResourceModel.fromJson(Map<String, dynamic> json) {
    return GetSpeciesResourceModel(
      id: json['id'] as String,
      speciesId: json['speciesId'] as String,
      belongId: json['belongId'] as String,
      upTeam: json['upTeam'] as bool,
      upSpecies: json['upSpecies'] as bool,
      page: PageRequest.fromJson(json['page'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speciesId': speciesId,
      'belongId': belongId,
      'upTeam': upTeam,
      'upSpecies': upSpecies,
      'page': page.toJson(),
    };
  }
}

class QueryDefineReq {
  // 分类ID
  final String? speciesId;

  // 空间ID
  final String spaceId;

  // 分页
  PageRequest? page;

  QueryDefineReq({
    required this.speciesId,
    required this.spaceId,
    this.page,
  });

  Map<String, dynamic> toJson() {
    return {
      "speciesId": speciesId,
      "spaceId": spaceId,
      "page": page?.toJson(),
    };
  }
}

class SpaceAuthReq {
  // 权限ID
  final String authId;

  // 工作空间ID
  final String spaceId;

  //构造方法
  SpaceAuthReq({
    required this.authId,
    required this.spaceId,
  });

  //通过JSON构造
  SpaceAuthReq.fromJson(Map<String, dynamic> json)
      : authId = json["authId"],
        spaceId = json["spaceId"];

  //通过动态数组解析成List
  static List<SpaceAuthReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<SpaceAuthReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(SpaceAuthReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["authId"] = authId;
    json["spaceId"] = spaceId;
    return json;
  }
}

class IDBelongReq {
  // 唯一ID
  final String id;

  // 分页
  final PageRequest? page;

  //构造方法
  IDBelongReq({
    required this.id,
    this.page,
  });

  //通过JSON构造
  IDBelongReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDBelongReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDBelongReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDBelongReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["page"] = page?.toJson();
    return json;
  }
}

class RelationReq {
  // 唯一ID
  final String id;

  // 子组织/个人ID
  final List<String> subIds;

  //构造方法
  RelationReq({
    required this.id,
    required this.subIds,
  });

  //通过JSON构造
  RelationReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        subIds = json["subIds"];

  //通过动态数组解析成List
  static List<RelationReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<RelationReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(RelationReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["subIds"] = subIds;
    return json;
  }
}

// 缓存结构体
class CacheReq {
  // 缓存key
  final String key;

  // 缓存数据
  final String value;

  // 过期时间s
  final String expire;

  //构造方法
  CacheReq({
    required this.key,
    required this.value,
    required this.expire,
  });

  //通过JSON构造
  CacheReq.fromJson(Map<String, dynamic> json)
      : key = json["key"],
        value = json["value"],
        expire = json["expire"];

  //通过动态数组解析成List
  static List<CacheReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<CacheReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(CacheReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["key"] = key;
    json["value"] = value;
    json["expire"] = expire;
    return json;
  }
}

class ThingAttrReq {
  // 唯一ID
  final String id;

  //类别Id
  final String specId;

  //类别代码
  final String specCode;

  //特性Id
  final String attrId;

  //特性代码
  final String attrCode;

  //关系Id
  final String relationId;

  //是否公开
  final bool public;

  // 分页
  final PageRequest? page;

  //构造方法
  ThingAttrReq({
    required this.id,
    required this.specId,
    required this.specCode,
    required this.attrId,
    required this.attrCode,
    required this.relationId,
    required this.public,
    required this.page,
  });

  //通过JSON构造
  ThingAttrReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        specId = json["specId"],
        specCode = json["specCode"],
        attrId = json["attrId"],
        attrCode = json["attrCode"],
        relationId = json["relationId"],
        public = json["public"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<ThingAttrReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ThingAttrReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ThingAttrReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["specId"] = specId;
    json["specCode"] = specCode;
    json["attrId"] = attrId;
    json["attrCode"] = attrCode;
    json["relationId"] = relationId;
    json["public"] = public;
    json["page"] = page?.toJson();
    return json;
  }
}

class IDWithBelongReq {
  // 唯一ID
  final String id;

  // 归属ID
  final String belongId;

  //构造方法
  IDWithBelongReq({
    required this.id,
    required this.belongId,
  });

  //通过JSON构造
  IDWithBelongReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        belongId = json["belongId"];

  //通过动态数组解析成List
  static List<IDWithBelongReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDWithBelongReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDWithBelongReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["belongId"] = belongId;
    return json;
  }
}

class IDWithBelongPageReq {
  // 唯一ID
  final String id;

  // 归属ID
  final String belongId;

  // 分页
  final PageRequest? page;

  //构造方法
  IDWithBelongPageReq({
    required this.id,
    required this.belongId,
    required this.page,
  });

  //通过JSON构造
  IDWithBelongPageReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        belongId = json["belongId"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDWithBelongPageReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDWithBelongPageReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDWithBelongPageReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["belongId"] = belongId;
    json["page"] = page?.toJson();
    return json;
  }
}

class IDStatusPageReq {
  // 唯一ID
  final String id;

  // 状态
  final int status;

  // 分页
  final PageRequest? page;

  //构造方法
  IDStatusPageReq({
    required this.id,
    required this.status,
    required this.page,
  });

  //通过JSON构造
  IDStatusPageReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        status = json["status"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDStatusPageReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDStatusPageReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDStatusPageReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["status"] = status;
    json["page"] = page?.toJson();
    return json;
  }
}

class IDBelongTargetReq {
  // 唯一ID
  final String id;

  // 类型
  final String targetType;

  // 分页
  final PageRequest? page;

  //构造方法
  IDBelongTargetReq({
    required this.id,
    required this.targetType,
    required this.page,
  });

  //通过JSON构造
  IDBelongTargetReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        targetType = json["targetType"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDBelongTargetReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDBelongTargetReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDBelongTargetReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["targetType"] = targetType;
    json["page"] = page?.toJson();
    return json;
  }
}

class IDReqSubModel {
  // 唯一ID
  final String? id;

  // 实体类型
  final List<String>? typeNames;

  // 子节点类型
  final List<String>? subTypeNames;

  // 分页
  final PageRequest? page;

  //构造方法
  IDReqSubModel({
    this.id,
    this.typeNames,
    this.subTypeNames,
    this.page,
  });

  //通过JSON构造
  IDReqSubModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        typeNames = json["typeNames"],
        subTypeNames = json["subTypeNames"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDReqSubModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDReqSubModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDReqSubModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeNames"] = typeNames;
    json["subTypeNames"] = subTypeNames;
    json["page"] = page?.toJson();
    return json;
  }
}

class GetJoinedModel {
  // 唯一ID
  final String id;

  // 加入的节点类型
  final List<String> typeNames;

  // 分页
  final PageModel? page;

  GetJoinedModel({required this.id, required this.typeNames, this.page});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeNames"] = typeNames;
    json["page"] = page?.toJson();
    return json;
  }
}

class IDReqJoinedModel {
  // 唯一ID
  final String? id;

  // 实体类型
  final String? typeName;

  // 加入的节点类型
  final List<String>? joinTypeNames;

  // 工作空间ID
  final String? spaceId;

  // 分页
  final PageRequest? page;

  //构造方法
  IDReqJoinedModel({
    this.id,
    this.typeName,
    this.joinTypeNames,
    this.spaceId,
    this.page,
  });

  //通过JSON构造
  IDReqJoinedModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        typeName = json["typeName"],
        joinTypeNames = json["JoinTypeNames"],
        spaceId = json["spaceId"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<IDReqJoinedModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IDReqJoinedModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IDReqJoinedModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeName"] = typeName;
    json["JoinTypeNames"] = joinTypeNames;
    json["spaceId"] = spaceId;
    json["page"] = page?.toJson();
    return json;
  }
}

class ChatsReqModel {
  // 工作空间ID
  final String? spaceId;

  // 群组名称
  final String? cohortName;

  // 空间类型名称
  final String? spaceTypeName;

  //构造方法
  ChatsReqModel({
    this.spaceId,
    this.cohortName,
    this.spaceTypeName,
  });

  //通过JSON构造
  ChatsReqModel.fromJson(Map<String, dynamic> json)
      : spaceId = json["spaceId"],
        cohortName = json["cohortName"],
        spaceTypeName = json["spaceTypeName"];

  //通过动态数组解析成List
  static List<ChatsReqModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ChatsReqModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ChatsReqModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["cohortName"] = cohortName;
    json["spaceTypeName"] = spaceTypeName;
    return json;
  }
}

class PageRequest {
  // 偏移量
  final int offset;

  // 最大数量
  final int limit;

  //过滤条件
  final String filter;

  //构造方法
  PageRequest({
    required this.offset,
    required this.limit,
    required this.filter,
  });

  //通过JSON构造
  PageRequest.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        filter = json["filter"];

  //通过动态数组解析成List
  static List<PageRequest> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<PageRequest> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(PageRequest.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["offset"] = offset;
    json["limit"] = limit;
    json["filter"] = filter;
    return json;
  }
}

class RecursiveReqModel {
  // 唯一ID
  final String? id;

  // 实体类型
  final String? typeName;

  // 字节点类型
  final List<String>? subNodeTypeNames;

  //构造方法
  RecursiveReqModel({
    this.id,
    this.typeName,
    this.subNodeTypeNames,
  });

  //通过JSON构造
  RecursiveReqModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        typeName = json["typeName"],
        subNodeTypeNames = json["subNodeTypeNames"];

  //通过动态数组解析成List
  static List<RecursiveReqModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<RecursiveReqModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(RecursiveReqModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["typeName"] = typeName;
    json["subNodeTypeNames"] = subNodeTypeNames;
    return json;
  }
}

class IdWithNameModel {
  // 唯一ID
  final String? id;

  // 名称
  final String? name;

  //构造方法
  IdWithNameModel({
    this.id,
    this.name,
  });

  //通过JSON构造
  IdWithNameModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"];

  //通过动态数组解析成List
  static List<IdWithNameModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdWithNameModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdWithNameModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    return json;
  }
}

class IdNameArray {
  // 唯一ID数组
  final List<IdWithNameModel>? result;

  //构造方法
  IdNameArray({
    this.result,
  });

  //通过JSON构造
  IdNameArray.fromJson(Map<String, dynamic> json)
      : result = IdWithNameModel.fromList(json["result"]);

  //通过动态数组解析成List
  static List<IdNameArray> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<IdNameArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(IdNameArray.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["result"] = result;
    return json;
  }
}

class DictModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 分类id
  String? speciesId;

  // 备注
  String? remark;

  //构造方法
  DictModel({
    this.name,
    this.speciesId,
    this.code,
    this.remark,
    this.id,
  });

  //通过JSON构造
  DictModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        speciesId = json["speciesId"],
        remark = json["remark"];

  //通过动态数组解析成List
  static List<DictModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<DictModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(DictModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["speciesId"] = speciesId;
    json["remark"] = remark;
    return json;
  }
}

class DictItemModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? value;

  // 公开的
  bool? public;

  // 创建组织/个人
  String? belongId;

  // 备注
  String? dictId;

  //构造方法
  DictItemModel({
    this.id,
    this.name,
    this.value,
    this.public,
    this.belongId,
    this.dictId,
  });

  //通过JSON构造
  DictItemModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        value = json["value"],
        public = json["public"],
        belongId = json["belongId"],
        dictId = json["dictId"];

  //通过动态数组解析成List
  static List<DictItemModel> fromList(List<dynamic> list) {
    if (list == null) {
      return [];
    }
    List<DictItemModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(DictItemModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["value"] = value;
    json["public"] = public;
    json["belongId"] = belongId;
    json["dictId"] = dictId;
    return json;
  }
}

class OperationModel {
  // 唯一ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 公开的
  bool? public;

  // 创建组织/个人
  String? belongId;

  // 类别Id
  String? speciesId;

  // 流程定义Id
  String? defineId;

  // 业务发起权限Id
  String? beginAuthId;

  // 子项列表
  List<OperationItem>? items;

  // 备注
  String? remark;

  //构造方法
  OperationModel({
    this.id,
    this.name,
    this.code,
    this.public,
    this.belongId,
    this.speciesId,
    this.defineId,
    this.beginAuthId,
    this.items,
    this.remark,
  });

  //通过JSON构造
  OperationModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        public = json["public"],
        belongId = json["belongId"],
        speciesId = json["speciesId"],
        remark = json["remark"];

  //通过动态数组解析成List
  static List<OperationModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OperationModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OperationModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["public"] = public;
    json["belongId"] = belongId;
    json["speciesId"] = speciesId;
    json["remark"] = remark;
    return json;
  }
}

class OperationItemModel {
  // 创建组织/个人
  final String spaceId;

  // 业务Id
  final String operationId;

  // 子项集合
  final List<OperationItem> operationItems;

  //构造方法
  OperationItemModel({
    required this.spaceId,
    required this.operationId,
    required this.operationItems,
  });

  //通过JSON构造
  OperationItemModel.fromJson(Map<String, dynamic> json)
      : spaceId = json["spaceId"],
        operationId = json["operationId"],
        operationItems = json["operationItems"];

  //通过动态数组解析成List
  static List<OperationItemModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OperationItemModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OperationItemModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["operationId"] = operationId;
    json["operationItems"] = operationItems;
    return json;
  }
}

class OperationRelation {
  // 规则
  final String? rule;

  // 备注
  final String speciesId;

  OperationRelation({
    this.rule,
    required this.speciesId,
  });
}

class OperationItem {
  // 名称
  final String name;

  // 编号
  final String code;

  // 绑定的特性ID
  final String attrId;

  // 规则
  final String rule;

  // 备注
  final String remark;

  // 子表项下的分类Id集合
  final List<String> speciesIds;

  OperationItem({
    required this.name,
    required this.code,
    required this.attrId,
    required this.rule,
    required this.remark,
    required this.speciesIds,
  });
}

class FlowDefineModel {
  final String? id;

  // 类别id
  final String? speciesId;

  // 空间id
  final String? spaceId;

  // 状态
  final int? status;

  FlowDefineModel(
    this.id,
    this.spaceId,
    this.speciesId,
    this.status,
  );
}

class FormItemModel {
  // 唯一ID
  String id;

  // 名称
  String name;

  // 编号
  String code;

  // 规则
  String rule;

  // 备注
  String remark;

  // 特性Id
  String attrId;

  FormItemModel({
    required this.id,
    required this.name,
    required this.code,
    required this.rule,
    required this.remark,
    required this.attrId,
  });

  factory FormItemModel.fromJson(Map<String, dynamic> json) {
    return FormItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      rule: json['rule'] as String,
      remark: json['remark'] as String,
      attrId: json['attrId'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'rule': rule,
      'remark': remark,
      'attrId': attrId,
    };
  }
}

class RuleStdModel {
  // 唯一ID
  final String? id;

  // 名称
  final String? name;

  // 编号
  final String? code;

  // 组织/个人ID
  final String? targetId;

  // 类型
  final String? typeName;

  // 备注
  final String? remark;

  // 标准
  final List<String>? attrs;

  //构造方法
  RuleStdModel({
    this.id,
    this.name,
    this.code,
    this.targetId,
    this.typeName,
    this.remark,
    this.attrs,
  });

  //通过JSON构造
  RuleStdModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        targetId = json["targetId"],
        typeName = json["typeName"],
        remark = json["remark"],
        attrs = json["attrs"];

  //通过动态数组解析成List
  static List<RuleStdModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<RuleStdModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(RuleStdModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["targetId"] = targetId;
    json["typeName"] = typeName;
    json["remark"] = remark;
    json["attrs"] = attrs;
    return json;
  }
}

class LogModel {
  // 唯一ID
  final String? id;

  //类型
  final String? type;

  //模块
  final String? module;

  //内容
  final String? content;

  //构造方法
  LogModel({
    this.id,
    this.type,
    this.module,
    this.content,
  });

  //通过JSON构造
  LogModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = json["type"],
        module = json["module"],
        content = json["content"];

  //通过动态数组解析成List
  static List<LogModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<LogModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(LogModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["type"] = type;
    json["module"] = module;
    json["content"] = content;
    return json;
  }
}

class MarketModel {
  // 唯一ID
  final String? id;

  // 名称
  final String? name;

  // 编号
  final String? code;

  // 创建组织/个人
  final String? belongId;

  // 监管组织/个人
  final String? samrId;

  // 备注
  final String? remark;

  // 加入操作是否公开
  final bool? joinPublic;

  // 售卖操作是否公开
  final bool? sellPublic;

  // 购买操作是否公开
  final bool? buyPublic;

  // 照片
  final String? photo;

  //构造方法
  MarketModel({
    this.id,
    this.name,
    this.code,
    this.belongId,
    this.samrId,
    this.remark,
    this.joinPublic,
    this.sellPublic,
    this.buyPublic,
    this.photo,
  });

  //通过JSON构造
  MarketModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        samrId = json["samrId"],
        remark = json["remark"],
        joinPublic = json["joinPublic"],
        sellPublic = json["sellPublic"],
        buyPublic = json["buyPublic"],
        photo = json["photo"];

  //通过动态数组解析成List
  static List<MarketModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<MarketModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(MarketModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["belongId"] = belongId;
    json["samrId"] = samrId;
    json["remark"] = remark;
    json["joinPublic"] = joinPublic;
    json["sellPublic"] = sellPublic;
    json["buyPublic"] = buyPublic;
    json["photo"] = photo;
    return json;
  }
}

class MerchandiseModel {
  // 唯一ID
  final String? id;

  // 标题
  final String? caption;

  // 产品ID
  final String? productId;

  // 单价
  final double? price;

  // 出售权属
  final String? sellAuth;

  // 商品出售市场ID
  final String? marketId;

  // 描述信息
  final String? information;

  // 有效期
  final String? days;

  //构造方法
  MerchandiseModel({
    this.id,
    this.caption,
    this.productId,
    this.price,
    this.sellAuth,
    this.marketId,
    this.information,
    this.days,
  });

  //通过JSON构造
  MerchandiseModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        caption = json["caption"],
        productId = json["productId"],
        price = json["price"],
        sellAuth = json["sellAuth"],
        marketId = json["marketId"],
        information = json["information"],
        days = json["days"];

  //通过动态数组解析成List
  static List<MerchandiseModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<MerchandiseModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(MerchandiseModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["caption"] = caption;
    json["productId"] = productId;
    json["price"] = price;
    json["sellAuth"] = sellAuth;
    json["marketId"] = marketId;
    json["information"] = information;
    json["days"] = days;
    return json;
  }
}

class OrderModel {
  // 唯一ID
  final String? id;

  // 存证ID
  final String? nftId;

  // 名称
  final String? name;

  // 编号
  final String? code;

  // 创建组织/个人
  final String? belongId;

  // 商品ID
  final List<String>? merchandiseIds;

  //构造方法
  OrderModel({
    this.id,
    this.nftId,
    this.name,
    this.code,
    this.belongId,
    this.merchandiseIds,
  });

  //通过JSON构造
  OrderModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nftId = json["nftId"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        merchandiseIds = json["merchandiseIds"];

  //通过动态数组解析成List
  static List<OrderModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OrderModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OrderModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["nftId"] = nftId;
    json["name"] = name;
    json["code"] = code;
    json["belongId"] = belongId;
    json["merchandiseIds"] = merchandiseIds;
    return json;
  }
}

class OrderModelByStags {
  // 唯一ID
  final String? id;

  // 存证ID
  final String? nftId;

  // 名称
  final String? name;

  // 编号
  final String? code;

  // 创建组织/个人
  final String? belongId;

  // 暂存区ID集合
  final List<String>? stagingIds;

  //构造方法
  OrderModelByStags({
    this.id,
    this.nftId,
    this.name,
    this.code,
    this.belongId,
    this.stagingIds,
  });

  //通过JSON构造
  OrderModelByStags.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nftId = json["nftId"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        stagingIds = json["stagingIds"];

  //通过动态数组解析成List
  static List<OrderModelByStags> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OrderModelByStags> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OrderModelByStags.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["nftId"] = nftId;
    json["name"] = name;
    json["code"] = code;
    json["belongId"] = belongId;
    json["stagingIds"] = stagingIds;
    return json;
  }
}

class OrderDetailModel {
  // 唯一ID
  final String? id;

  // 订单
  final String? caption;

  // 商品
  final String? days;

  // 单价
  // 卖方ID
  final int? status;

  // 空间ID
  final String? spaceId;

  //构造方法
  OrderDetailModel({
    this.id,
    this.caption,
    this.days,
    this.status,
    this.spaceId,
  });

  //通过JSON构造
  OrderDetailModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        caption = json["caption"],
        days = json["days"],
        status = json["status"],
        spaceId = json["spaceId"];

  //通过动态数组解析成List
  static List<OrderDetailModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OrderDetailModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OrderDetailModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["caption"] = caption;
    json["days"] = days;
    json["status"] = status;
    json["spaceId"] = spaceId;
    return json;
  }
}

class OrderPayModel {
  // 唯一ID
  final String? id;

  // 订单
  final String? orderDetailId;

  // 支付总价
  final double? price;

  // 支付方式
  final String? paymentType;

  //构造方法
  OrderPayModel({
    this.id,
    this.orderDetailId,
    this.price,
    this.paymentType,
  });

  //通过JSON构造
  OrderPayModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        orderDetailId = json["orderDetailId"],
        price = json["price"],
        paymentType = json["paymentType"];

  //通过动态数组解析成List
  static List<OrderPayModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<OrderPayModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(OrderPayModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["orderDetailId"] = orderDetailId;
    json["price"] = price;
    json["paymentType"] = paymentType;
    return json;
  }
}

class ProductModel {
  // 唯一ID
  final String? id;

  // 名称
  final String? name;

  // 编号
  final String? code;

  // 元数据Id
  final String? thingId;

  // 产品类型名
  final String? typeName;

  // 备注
  final String? remark;

  // 所属ID
  late String belongId;

  // 照片
  final String? photo;

  // 资源列
  final List<ResourceModel>? resources;

  //构造方法
  ProductModel({
    this.id,
    this.name,
    this.code,
    this.thingId,
    this.typeName,
    this.remark,
    required this.belongId,
    this.photo,
    this.resources,
  });

  //通过JSON构造
  ProductModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        thingId = json["thingId"],
        typeName = json["typeName"],
        remark = json["remark"],
        belongId = json["belongId"],
        photo = json["photo"],
        resources = ResourceModel.fromList(json["resources"]);

  //通过动态数组解析成List
  static List<ProductModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ProductModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ProductModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["thingId"] = thingId;
    json["typeName"] = typeName;
    json["remark"] = remark;
    json["belongId"] = belongId;
    json["photo"] = photo;
    json["resources"] = resources;
    return json;
  }
}

class ResourceModel {
  // 唯一ID
  final String? id;

  // 编号
  final String? code;

  // 名称
  final String? name;

  // 产品ID
  final String? productId;

  // 访问私钥
  final String? privateKey;

  // 入口地址
  final String? link;

  // 流程项
  final String? flows;

  // 组件
  final String? components;

  //构造方法
  ResourceModel({
    this.id,
    this.code,
    this.name,
    this.productId,
    this.privateKey,
    this.link,
    this.flows,
    this.components,
  });

  //通过JSON构造
  ResourceModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        code = json["code"],
        name = json["name"],
        productId = json["productId"],
        privateKey = json["privateKey"],
        link = json["link"],
        flows = json["flows"],
        components = json["components"];

  //通过动态数组解析成List
  static List<ResourceModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ResourceModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ResourceModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["code"] = code;
    json["name"] = name;
    json["productId"] = productId;
    json["privateKey"] = privateKey;
    json["link"] = link;
    json["flows"] = flows;
    json["components"] = components;
    return json;
  }
}

class StagingModel {
  // 唯一ID
  final String? id;

  // 商品
  final String? merchandiseId;

  // 创建组织/个人
  final String? belongId;

  //构造方法
  StagingModel({
    this.id,
    this.merchandiseId,
    this.belongId,
  });

  //通过JSON构造
  StagingModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        merchandiseId = json["merchandiseId"],
        belongId = json["belongId"];

  //通过动态数组解析成List
  static List<StagingModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<StagingModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(StagingModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["merchandiseId"] = merchandiseId;
    json["belongId"] = belongId;
    return json;
  }
}

class ThingSpeciesModel {
  // 物的唯一ID
  final String? id;

  // 赋予的类别Id
  final String? speciesId;

  // 赋予的类别代码
  final String? speciesCode;

  //构造方法
  ThingSpeciesModel({
    this.id,
    this.speciesId,
    this.speciesCode,
  });

  //通过JSON构造
  ThingSpeciesModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        speciesId = json["speciesId"],
        speciesCode = json["speciesCode"];

  //通过动态数组解析成List
  static List<ThingSpeciesModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ThingSpeciesModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ThingSpeciesModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["speciesId"] = speciesId;
    json["speciesCode"] = speciesCode;
    return json;
  }
}

class ThingAttrModel {
  // 物的唯一ID
  final String? id;

  // 基于关系ID的度量
  final String? relationId;

  // 类别Id
  final String? speciesId;

  //类别代码
  final String? specCode;

  //特性Id
  final String? attrId;

  //特性代码
  final String? attrCode;

  // 字符串类型的值
  final String? strValue;

  // 数值类型的值
  final double? numValue;

  //构造方法
  ThingAttrModel({
    this.id,
    this.relationId,
    this.speciesId,
    this.specCode,
    this.attrId,
    this.attrCode,
    this.strValue,
    this.numValue,
  });

  //通过JSON构造
  ThingAttrModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        relationId = json["relationId"],
        speciesId = json["speciesId"],
        specCode = json["specCode"],
        attrId = json["attrId"],
        attrCode = json["attrCode"],
        strValue = json["strValue"],
        numValue = json["numValue"];

  //通过动态数组解析成List
  static List<ThingAttrModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ThingAttrModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ThingAttrModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["relationId"] = relationId;
    json["speciesId"] = speciesId;
    json["specCode"] = specCode;
    json["attrId"] = attrId;
    json["attrCode"] = attrCode;
    json["strValue"] = strValue;
    json["numValue"] = numValue;
    return json;
  }
}

class JoinTeamModel {
  // 团队ID
  final String? id;

  // 团队类型
  final String? teamType;

  // 待加入团队组织/个人ID
  final String? targetId;

  // 待拉入组织/个人类型
  final String? targetType;

  //构造方法
  JoinTeamModel({
    this.id,
    this.teamType,
    this.targetId,
    this.targetType,
  });

  //通过JSON构造
  JoinTeamModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamType = json["teamType"],
        targetId = json["targetId"],
        targetType = json["targetType"];

  //通过动态数组解析成List
  static List<JoinTeamModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<JoinTeamModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(JoinTeamModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamType"] = teamType;
    json["targetId"] = targetId;
    json["targetType"] = targetType;
    return json;
  }
}

class ExitTeamModel {
  // 团队ID
  final String? id;

  // 团队类型
  final List<String>? teamTypes;

  // 待退出团队组织/个人ID
  final String? targetId;

  // 待退出组织/个人类型
  final String? targetType;

  //构造方法
  ExitTeamModel({
    this.id,
    this.teamTypes,
    this.targetId,
    this.targetType,
  });

  //通过JSON构造
  ExitTeamModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamTypes = json["teamTypes"],
        targetId = json["targetId"],
        targetType = json["targetType"];

  //通过动态数组解析成List
  static List<ExitTeamModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ExitTeamModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ExitTeamModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamTypes"] = teamTypes;
    json["targetId"] = targetId;
    json["targetType"] = targetType;
    return json;
  }
}

class TeamPullModel {
  // 团队ID
  final String? id;

  // 团队类型
  final List<String>? teamTypes;

  // 待拉入的组织/个人ID集合
  final List<String>? targetIds;

  // 待拉入组织/个人类型
  final String? targetType;

  //构造方法
  TeamPullModel({
    this.id,
    this.teamTypes,
    this.targetIds,
    this.targetType,
  });

  //通过JSON构造
  TeamPullModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        teamTypes = json["teamTypes"],
        targetIds = json["targetIds"],
        targetType = json["targetType"];

  //通过动态数组解析成List
  static List<TeamPullModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<TeamPullModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(TeamPullModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["teamTypes"] = teamTypes;
    json["targetIds"] = targetIds;
    json["targetType"] = targetType;
    return json;
  }
}

class CreateOrderByStagingModel {
  // 订单名称
  final String? name;

  // 订单编号
  final String? code;

  // 所属ID
  final String? belongId;

  // 暂存区ID
  final List<String>? stagingIds;

  //构造方法
  CreateOrderByStagingModel({
    this.name,
    this.code,
    this.belongId,
    this.stagingIds,
  });

  //通过JSON构造
  CreateOrderByStagingModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        stagingIds = json["StagingIds"];

  //通过动态数组解析成List
  static List<CreateOrderByStagingModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<CreateOrderByStagingModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(CreateOrderByStagingModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["code"] = code;
    json["belongId"] = belongId;
    json["StagingIds"] = stagingIds;
    return json;
  }
}

class GiveIdentityModel {
  // 角色ID
  final String? id;

  // 人员ID
  final List<String>? targetIds;

  //构造方法
  GiveIdentityModel({
    this.id,
    this.targetIds,
  });

  //通过JSON构造
  GiveIdentityModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        targetIds = json["targetIds"];

  //通过动态数组解析成List
  static List<GiveIdentityModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<GiveIdentityModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(GiveIdentityModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["targetIds"] = targetIds;
    return json;
  }
}

class SearchExtendReq {
  // 源ID
  final String? sourceId;

  // 源类型
  final String? sourceType;

  // 分配对象类型
  final String? destType;

  // 归属ID
  final String? spaceId;

  // TeamID
  final String? teamId;

  //构造方法
  SearchExtendReq({
    this.sourceId,
    this.sourceType,
    this.destType,
    this.spaceId,
    this.teamId,
  });

  //通过JSON构造
  SearchExtendReq.fromJson(Map<String, dynamic> json)
      : sourceId = json["sourceId"],
        sourceType = json["sourceType"],
        destType = json["destType"],
        spaceId = json["spaceId"],
        teamId = json["teamId"];

  //通过动态数组解析成List
  static List<SearchExtendReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<SearchExtendReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(SearchExtendReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["sourceId"] = sourceId;
    json["sourceType"] = sourceType;
    json["destType"] = destType;
    json["spaceId"] = spaceId;
    json["teamId"] = teamId;
    return json;
  }
}

class MarketPullModel {
  // 团队ID
  final String? marketId;

  // 待拉入的组织/个人ID集合
  final List<String>? targetIds;

  // 待拉入组织/个人类型
  final List<String>? typeNames;

  //构造方法
  MarketPullModel({
    this.marketId,
    this.targetIds,
    this.typeNames,
  });

  //通过JSON构造
  MarketPullModel.fromJson(Map<String, dynamic> json)
      : marketId = json["marketId"],
        targetIds = json["targetIds"],
        typeNames = json["typeNames"];

  //通过动态数组解析成List
  static List<MarketPullModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<MarketPullModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(MarketPullModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["marketId"] = marketId;
    json["targetIds"] = targetIds;
    json["typeNames"] = typeNames;
    return json;
  }
}

class UsefulProductReq {
  // 工作空间ID
  final String? spaceId;

  // 拓展目标所属对象类型
  final List<String>? typeNames;

  //构造方法
  UsefulProductReq({
    this.spaceId,
    this.typeNames,
  });

  //通过JSON构造
  UsefulProductReq.fromJson(Map<String, dynamic> json)
      : spaceId = json["spaceId"],
        typeNames = json["typeNames"];

  //通过动态数组解析成List
  static List<UsefulProductReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<UsefulProductReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(UsefulProductReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["typeNames"] = typeNames;
    return json;
  }
}

class UsefulResourceReq {
  // 工作空间ID
  final String? spaceId;

  // 产品ID
  final String? productId;

  // 拓展目标所属对象类型
  final List<String>? typeNames;

  //构造方法
  UsefulResourceReq({
    this.spaceId,
    this.productId,
    this.typeNames,
  });

  //通过JSON构造
  UsefulResourceReq.fromJson(Map<String, dynamic> json)
      : spaceId = json["spaceId"],
        productId = json["productId"],
        typeNames = json["typeNames"];

  //通过动态数组解析成List
  static List<UsefulResourceReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<UsefulResourceReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(UsefulResourceReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["spaceId"] = spaceId;
    json["productId"] = productId;
    json["typeNames"] = typeNames;
    return json;
  }
}

class SourceExtendModel {
  // 源对象ID
  final String? sourceId;

  // 源对象类型
  final String? sourceType;

  // 目标对象类型
  final String? destType;

  // 目标对象ID
  final List<String>? destIds;

  // 组织ID
  final String? teamId;

  // 归属ID
  final String? spaceId;

  //构造方法
  SourceExtendModel({
    this.sourceId,
    this.sourceType,
    this.destType,
    this.destIds,
    this.teamId,
    this.spaceId,
  });

  //通过JSON构造
  SourceExtendModel.fromJson(Map<String, dynamic> json)
      : sourceId = json["sourceId"],
        sourceType = json["sourceType"],
        destType = json["destType"],
        destIds = json["destIds"],
        teamId = json["teamId"],
        spaceId = json["spaceId"];

  //通过动态数组解析成List
  static List<SourceExtendModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<SourceExtendModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(SourceExtendModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["sourceId"] = sourceId;
    json["sourceType"] = sourceType;
    json["destType"] = destType;
    json["destIds"] = destIds;
    json["teamId"] = teamId;
    json["spaceId"] = spaceId;
    return json;
  }
}

class NameTypeModel {
  // 名称
  final String? name;

  // 类型名
  final List<String>? typeNames;

  // 分页
  final PageRequest? page;

  //构造方法
  NameTypeModel({
    this.name,
    this.typeNames,
    this.page,
  });

  //通过JSON构造
  NameTypeModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        typeNames = json["typeNames"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<NameTypeModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<NameTypeModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(NameTypeModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["typeNames"] = typeNames;
    json["page"] = page?.toJson();
    return json;
  }
}

class NameCodeModel {
  // 名称
  final String? name;

  // 代码
  final String? code;

  // 分页
  final PageRequest? page;

  //构造方法
  NameCodeModel({
    this.name,
    this.code,
    this.page,
  });

  //通过JSON构造
  NameCodeModel.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        code = json["code"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<NameCodeModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<NameCodeModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(NameCodeModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["name"] = name;
    json["code"] = code;
    json["page"] = page?.toJson();
    return json;
  }
}

class ChatResponse {
  // 会话分组
  final List<GroupChatModel>? groups;

  //构造方法
  ChatResponse({
    this.groups,
  });

  //通过JSON构造
  ChatResponse.fromJson(Map<String, dynamic> json)
      : groups = GroupChatModel.fromList(json["groups"]);

  //通过动态数组解析成List
  static List<ChatResponse> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ChatResponse> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ChatResponse.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["groups"] = groups;
    return json;
  }
}

class GroupChatModel {
  // 分组ID
  final String id;

  // 名称
  final String name;

  // 会话
  final List<ChatModel>? chats;

  //构造方法
  GroupChatModel({
    required this.id,
    required this.name,
    this.chats,
  });

  //通过JSON构造
  GroupChatModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        chats = ChatModel.fromList(json["chats"]);

  //通过动态数组解析成List
  static List<GroupChatModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<GroupChatModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(GroupChatModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["chats"] = chats;
    return json;
  }
}

class ChatModel {
  // 会话ID
  final String id;

  // 名称
  final String name;

  // 头像
  final String photo;

  // 标签
  final List<String> labels;

  // 备注
  final String remark;

  // 类型名称
  final String typeName;

  //构造方法
  ChatModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.labels,
    required this.remark,
    required this.typeName,
  });

  //通过JSON构造
  ChatModel.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        photo = json["photo"],
        labels = json["labels"],
        remark = json["remark"],
        typeName = json["typeName"];

  //通过动态数组解析成List
  static List<ChatModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<ChatModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(ChatModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["photo"] = photo;
    json["labels"] = labels;
    json["remark"] = remark;
    json["typeName"] = typeName;
    return json;
  }
}

class MsgTagLabel {
  String? label;
  String? userId;
  String? time;

  MsgTagLabel({required this.label, required this.userId, required this.time});

  factory MsgTagLabel.fromJson(Map<String, dynamic> json) {
    return MsgTagLabel(
      label: json['label'],
      userId: json['userId'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'label': label,
      'userId': userId,
      'time': time,
    };
    return data;
  }
}

class FlowInstanceModel {
  // 流程定义Id
  final String defineId;

  // 空间Id
  final String? spaceId;

  // 展示内容
  final String? content;

  // 内容类型
  final String? contentType;

  // 单数据内容
  final String? data;

  // 标题
  final String? title;

  // 回调地址
  final String? hook;

  final List<String>? thingIds;

  //构造方法
  FlowInstanceModel({
    required this.defineId,
    this.spaceId,
    this.content,
    this.contentType,
    this.data,
    this.title,
    this.hook,
    this.thingIds,
  });

  //通过JSON构造
  FlowInstanceModel.fromJson(Map<String, dynamic> json)
      : defineId = json["defineId"],
        spaceId = json["SpaceId"],
        content = json["content"],
        contentType = json["contentType"],
        data = json["data"],
        title = json["title"],
        hook = json["hook"],
        thingIds = json['thingIds'];

  //通过动态数组解析成List
  static List<FlowInstanceModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<FlowInstanceModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FlowInstanceModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["defineId"] = defineId;
    json["SpaceId"] = spaceId;
    json["content"] = content;
    json["contentType"] = contentType;
    json["data"] = data;
    json["title"] = title;
    json["hook"] = hook;
    json['thingIds'] = thingIds;
    return json;
  }
}

class FlowRelationModel {
  //流程定义Id
  final String? defineId;

  // 业务标准Id
  final String? operationId;

  //构造方法
  FlowRelationModel({
    this.defineId,
    this.operationId,
  });

  //通过JSON构造
  FlowRelationModel.fromJson(Map<String, dynamic> json)
      : defineId = json["defineId"],
        operationId = json["operationId"];

  //通过动态数组解析成List
  static List<FlowRelationModel> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<FlowRelationModel> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FlowRelationModel.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["defineId"] = defineId;
    json["operationId"] = operationId;
    return json;
  }
}

class FlowReq {
  // 流程实例Id
  final String? id;

  // 空间Id
  final String? spaceId;

  // 状态
  final int? status;

  final String? speciesId;

  // 分页
  final PageRequest? page;

  //构造方法
  FlowReq({
    this.id,
    this.spaceId,
    this.status,
    this.page,
    this.speciesId,
  });

  //通过JSON构造
  FlowReq.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        spaceId = json["spaceId"],
        speciesId = json['speciesId'],
        status = json["status"],
        page = PageRequest.fromJson(json["page"]);

  //通过动态数组解析成List
  static List<FlowReq> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<FlowReq> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FlowReq.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json['speciesId'] = speciesId;
    json["status"] = status;
    json["page"] = page?.toJson();
    return json;
  }
}

class Archives {
  String? id;
  String? title;
  String? defineId;
  String? contentType;
  String? content;
  String? applyId;
  String? shareId;
  String? belongId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;

  Archives(
      {this.id,
      this.title,
      this.defineId,
      this.contentType,
      this.content,
      this.applyId,
      this.shareId,
      this.belongId,
      this.status,
      this.createUser,
      this.updateUser,
      this.version,
      this.createTime,
      this.updateTime});

  Archives.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    defineId = json['defineId'];
    contentType = json['contentType'];
    content = json['content'];
    applyId = json['applyId'];
    shareId = json['shareId'];
    belongId = json['belongId'];
    status = json['status'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['defineId'] = defineId;
    data['contentType'] = contentType;
    data['content'] = content;
    data['applyId'] = applyId;
    data['shareId'] = shareId;
    data['belongId'] = belongId;
    data['status'] = status;
    data['createUser'] = createUser;
    data['updateUser'] = updateUser;
    data['version'] = version;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    return data;
  }
}

class Tag {
  String label;
  String userId;
  String time;

  Tag({
    required this.label,
    required this.userId,
    required this.time,
  });

  Tag.fromJson(Map<String, dynamic> json)
      : label = json['label'],
        userId = json['userId'],
        time = json['time'];

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['label'] = label;
    map['userId'] = userId;
    map['time'] = time;
    return map;
  }
}

class MsgSaveModel {
  String sessionId = '';
  String belongId = '';
  String fromId = '';
  String msgType = '';
  String msgBody = '';
  String createTime = DateTime.now().toString();
  String updateTime = '';
  String id = '';
  String toId = '';
  String showTxt = '';
  bool allowEdit = false;
  List<Tag>? tags;
  late GlobalKey key;
  MsgBodyModel? body;
  MsgSaveModel({
    this.sessionId = '',
    this.belongId = '',
    this.fromId = '',
    this.msgType = '',
    this.msgBody = '',
    this.createTime = '',
    this.updateTime = '',
    this.id = '',
    this.toId = '',
    this.showTxt = '',
    this.allowEdit = false,
    this.tags,
    this.body,
  });

  MsgSaveModel.fromJson(Map<String, dynamic> json)
      : sessionId = json['sessionId'] ?? '',
        belongId = json['belongId'],
        fromId = json['fromId'] ?? '',
        msgType = json['msgType'] ?? '',
        msgBody = json['msgBody'] ?? '',
        createTime = json['createTime'],
        updateTime = json['updateTime'],
        id = json['id'],
        key = GlobalKey(debugLabel: json['id']),
        toId = json['toId'] ?? '',
        showTxt = EncryptionUtil.inflate(json['msgBody'] ?? ''),
        allowEdit = json['allowEdit'] ?? false {
    if (json['tags'] != null) {
      tags = [];
      json["tags"].forEach((json) {
        tags!.add(Tag.fromJson(json));
      });
    }
    try {
      String json = showTxt;
      if (showTxt.contains('[obj]')) {
        json = showTxt.substring(5);
        Map<String, dynamic> data = jsonDecode(json);
        if (msgType == MessageType.text.label) {
          body = MsgBodyModel.fromJson(data);
        } else {
          body = MsgBodyModel.fromJson(jsonDecode(data['body']));
        }
      } else {
        if (msgType == MessageType.text.label) {
          body = MsgBodyModel(text: json);
        } else {
          body = MsgBodyModel.fromJson(jsonDecode(json));
        }
      }
    } catch (error) {}
  }

  MsgSaveModel.fromFileUpload(
      String id, String fileName, String filePath, String ext,
      [int size = 0]) {
    fromId = id;
    msgType = MessageType.uploading.label;
    this.id = fileName;
    tags = [];
    key = GlobalKey();
    body = MsgBodyModel(
        path: filePath,
        extension: '.$ext',
        name: fileName,
        size: size,
        progress: 0);
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['sessionId'] = sessionId;
    map['belongId'] = belongId;
    map['fromId'] = fromId;
    map['msgType'] = msgType;
    map['msgBody'] = msgBody;
    map['createTime'] = createTime;
    map['updateTime'] = updateTime;
    map['id'] = id;
    map['toId'] = toId;
    map['showTxt'] = showTxt;
    map['allowEdit'] = allowEdit;
    map['body'] = body?.toJson();
    map['tags'] = tags?.map((v) => v.toJson()).toList();
    return map;
  }
}

class MsgBodyModel {
  String? text;
  List<String>? mentions;
  MsgSaveModel? cite;
  String? shareLink;
  String? path;
  String? extension;
  String? name;
  late int size;
  late double progress;
  int? milliseconds;
  List<int>? bytes;
  MsgBodyModel(
      {this.text,
      this.mentions,
      this.cite,
      this.extension,
      this.name,
      this.path,
      this.shareLink,
      this.size = 0,
      this.progress = 0,
      this.milliseconds,
      this.bytes});

  MsgBodyModel.fromJson(Map<String, dynamic> json) {
    text = json['body'];
    if (text?.contains('\$IMG') ?? false) {
      text = StringUtil.replaceAllImageLabel(text!);
    }
    if (json['mentions'] != null) {
      mentions = <String>[];
      json['mentions'].forEach((v) {
        mentions!.add(v);
      });
    }

    if (json['bytes'] != null) {
      bytes = <int>[];
      json['bytes'].forEach((v) {
        bytes!.add(v);
      });
    }
    milliseconds = json['milliseconds'];
    shareLink = json['shareLink'];
    path = json['path'];
    extension = json['extension'];
    name = json['name'];
    progress = json['progress'] ?? 0;
    size = json['size'] ?? 0;
    cite = json['cite'] != null ? MsgSaveModel.fromJson(json['cite']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    String text = this.text ?? "";
    if (text.contains('\$IMG')) {
      text = StringUtil.resetImageLabel(text);
    }
    data['body'] = text;
    data['shareLink'] = shareLink;
    data['path'] = path;
    data['name'] = name;
    data['size'] = size;
    data['progress'] = progress;
    data['extension'] = extension;
    data['mentions'] = mentions;
    if (cite != null) {
      data['cite'] = cite!.toJson();
    }
    return data;
  }
}

class WorkSubmitModel {
  late bool isHeader;
  late XForm resourceData;
  late List<thing.ThingModel> changeData;

  WorkSubmitModel(
      {required this.isHeader,
      required this.resourceData,
      this.changeData = const []});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> changeDataMap = {};

    List<Map<String, dynamic>> propertys = [];

    dynamic resourceDataMap;

    for (var element in changeData) {
      element.eidtInfo = element.eidtInfo.map((key, value) {
        if (value is FileItemModel) {
          value = jsonEncode([value.shareInfo()]);
        } else if (value is Map) {
          value = value.keys.first;
        }
        return MapEntry(key, value);
      });
      changeDataMap[element.id!] = element.eidtInfo;
    }

    // for (var element in resourceData.attributes!) {
    //   if (element.linkPropertys != null && element.linkPropertys!.isNotEmpty) {
    //     propertys
    //         .add({"attrId": element.id, ...element.linkPropertys![0].toJson()});
    //   }
    // }

    if (isHeader) {
      resourceDataMap = jsonEncode(resourceData.toJson());
    } else {
      resourceDataMap = jsonEncode({
        'data': changeData.map((e) => e.toJson()).toList(),
        'form': resourceData.toJson(),
        'propertys': propertys,
      });
    }

    Map<String, dynamic> data = {
      'isHeader': isHeader,
      'resourceData': resourceDataMap,
      'changeData': changeDataMap,
    };
    return data;
  }
}

class DiskInfoType {
  // 状态
  int ok;
  // 文件数量
  int files;
  // 对象数量
  int objects;
  // 集合数量
  int collections;
  // 文件的总大小
  int fileSize;
  // 数据的总大小
  int dataSize;
  // 数据占用磁盘的总大小
  int totalSize;
  // 文件系统挂载磁盘已使用大小
  int fsUsedSize;
  // 文件系统挂载磁盘的总大小
  int fsTotalSize;
  // 查询时间
  String getTime;

  DiskInfoType({
    required this.ok,
    required this.files,
    required this.objects,
    required this.collections,
    required this.fileSize,
    required this.dataSize,
    required this.totalSize,
    required this.fsUsedSize,
    required this.fsTotalSize,
    required this.getTime,
  });
  DiskInfoType.fromJson(Map<String, dynamic> json)
      : ok = json['ok'] ?? 0,
        files = json['filesCount'] ?? 0,
        objects = json['objects'] ?? 0,
        collections = json['collections'] ?? 0,
        fileSize = json['filesSize'] ?? 0,
        dataSize = json['dataSize'] ?? 0,
        totalSize = json['totalSize'] ?? 0,
        fsUsedSize = json['fsUsedSize'] ?? 0,
        fsTotalSize = json['fsTotalSize'] ?? 0,
        getTime = json['getTime'];
}

// 标准目录
class StandardDirectoryType extends XDirectory {
  // 排序
  int sort;
  // 内容支持类型
  List<DirectoryType>? accept;
  // 子级目录
  List<StandardDirectoryType>? children;

  StandardDirectoryType(
      {required this.sort,
      this.accept,
      this.children,
      super.directoryId = "",
      super.id = "",
      super.isDeleted = false});
  StandardDirectoryType.fromJson(Map<String, dynamic> json)
      : sort = json['sort'] ?? 0,
        accept = json['accept'] != null
            ? Lists.fromList(
                json['accept'],
                (element) =>
                    DirectoryType.getType(json['accept']) ?? DirectoryType.def)
            : null,
        children = json['children'] != null
            ? Lists.fromList(json['children'], StandardDirectoryType.fromJson)
            : null,
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'sort': sort,
      'accept': accept?.map((e) => e.label).toList(),
      'children': children?.map((e) => e.toJson()).toList(),
    };
  }
}
