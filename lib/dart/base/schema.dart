//度量特性定义
import 'dart:convert';

import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/model/asset_creation_config.dart';
import 'package:orginone/util/common_tree_management.dart';

import 'model.dart';

class XAttribute {
  // 雪花ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 值类型
  String? valueType;

  // 公开的
  bool? public;

  // 单位
  String? unit;

  // 选择字典的类型ID
  String? dictId;

  // 备注
  String? remark;

  // 类别ID
  String? speciesId;

  // 创建组织/个人
  String? belongId;

  // 工作职权Id
  String? authId;

  // 状态
  int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 特性的物的度量
   List<XThingAttr>? attrThingValues;

  // 特性度量过的的物
   List<XThing>? things;

  // 标准要求
   List<XRuleAttr>? ruleAttrs;

  // 字典类型
   XDict? dict;

  // 度量特性对应的类别
   XSpecies? species;

  // 工作职权
   XAuthority? authority;

  // 创建度量标准的组织/个人
   XTarget? belong;

  //构造方法
  XAttribute({
    required this.id,
    required this.name,
    required this.code,
    required this.valueType,
    required this.public,
    required this.unit,
    required this.dictId,
    required this.remark,
    required this.speciesId,
    required this.belongId,
    required this.authId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.attrThingValues,
    required this.things,
    required this.ruleAttrs,
    required this.dict,
    required this.species,
    required this.authority,
    required this.belong,
  });

  //通过JSON构造
  XAttribute.fromJson(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    code = json["code"];
    valueType = json["valueType"];
    public = json["public"];
    unit = json["unit"];
    dictId = json["dictId"];
    remark = json["remark"];
    speciesId = json["speciesId"];
    belongId = json["belongId"];
    authId = json["authId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    attrThingValues = json["attrThingValues"]!=null?XThingAttr.fromList(json["attrThingValues"]):null;
    things = json["things"]!=null?XThing.fromList(json["things"]):null;
    ruleAttrs = json["ruleAttrs"]!=null?XRuleAttr.fromList(json["ruleAttrs"]):null;
    dict = json["dict"]!=null?XDict.fromJson(json["dict"]):null;
    species = json["species"]!=null?XSpecies.fromJson(json["species"]):null;
    authority =json["authority"]!=null?XAuthority.fromJson(json["authority"]):null;
    belong = json["belong"]!=null?XTarget.fromJson(json["belong"]):null;
  }

  //通过动态数组解析成List
  static List<XAttribute> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XAttribute> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XAttribute.fromJson(item));
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
    json["valueType"] = valueType;
    json["public"] = public;
    json["unit"] = unit;
    json["dictId"] = dictId;
    json["remark"] = remark;
    json["speciesId"] = speciesId;
    json["belongId"] = belongId;
    json["authId"] = authId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["attrThingValues"] = attrThingValues;
    json["things"] = things;
    json["ruleAttrs"] = ruleAttrs;
    json["dict"] = dict?.toJson();
    json["species"] = species?.toJson();
    json["authority"] = authority?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//度量特性定义查询返回集合
class XAttributeArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XAttribute>? result;

  //构造方法
  XAttributeArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XAttributeArray.fromJson(Map<String, dynamic> json){
       offset = json["offset"];
        limit = json["limit"];
        total = json["total"];
       List<Map<String,dynamic>>? list;
       if(json["result"]!=null){
         list = [];
         json["result"].forEach((e){
           list!.add(e);
         });
       }
        result = XAttribute.fromList(list);
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

class XOperationRelation {
  // 雪花ID
  final String id;

  // 子表分类ID
  final String speciesId;

  // 表单设计
  final String operationId;

  // 归属个人/组织
  final String belongId;

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
  final String updateTime; //构造方法
  XOperationRelation({
    required this.id,
    required this.operationId,
    required this.speciesId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
  });

  //通过JSON构造
  XOperationRelation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        operationId = json["operationId"],
        speciesId = json["speciesId"],
        belongId = json["belongId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"];

  //通过动态数组解析成List
  static List<XOperationRelation> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperationRelation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperationRelation.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["speciesId"] = speciesId;
    json["belongId"] = belongId;
    json["operationId"] = operationId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    return json;
  }
}

//度量特性定义查询返回集合
class XOperationRelationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XOperationRelation>? result;

  //构造方法
  XOperationRelationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOperationRelationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XOperationRelation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XOperationRelationArray> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperationRelationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperationRelationArray.fromJson(item));
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

//职权定义
class XAuthority {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  String code;

  // 备注
  String remark;

  // 公开的
  bool public;

  // 上级职权ID
  final String parentId;

  // 创建组织/个人
  final String belongId;

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
  String updateTime;

  // 上下级职权
  final XAuthority? parent;

  // 上下级职权
  final List<XAuthority>? nodes;

  // 创建职权标准的组织/个人
  final XTarget? belong;

  // 职权对应的身份
  final List<XIdentity>? identitys;

  // 职权可操作的类别
  final List<XSpecies>? authSpecies;

  // 职权可操作的度量
  final List<XAttribute>? autAttrs;

  //构造方法
  XAuthority({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.public,
    required this.parentId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.parent,
    required this.nodes,
    required this.belong,
    required this.identitys,
    required this.authSpecies,
    required this.autAttrs,
  });

  //通过JSON构造
  XAuthority.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        remark = json["remark"],
        public = json["public"],
        parentId = json["parentId"],
        belongId = json["belongId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        parent = XAuthority.fromJson(json["parent"]),
        nodes = XAuthority.fromList(json["nodes"]),
        belong = XTarget.fromJson(json["belong"]),
        identitys = XIdentity.fromList(json["identitys"]),
        authSpecies = XSpecies.fromList(json["authSpecies"]),
        autAttrs = XAttribute.fromList(json["autAttrs"]);

  //通过动态数组解析成List
  static List<XAuthority> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XAuthority> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XAuthority.fromJson(item));
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
    json["remark"] = remark;
    json["public"] = public;
    json["parentId"] = parentId;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["parent"] = parent?.toJson();
    json["nodes"] = nodes;
    json["belong"] = belong?.toJson();
    json["identitys"] = identitys;
    json["authSpecies"] = authSpecies;
    json["autAttrs"] = autAttrs;
    return json;
  }
}

//职权定义查询返回集合
class XAuthorityArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XAuthority>? result;

  //构造方法
  XAuthorityArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XAuthorityArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XAuthority.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XAuthorityArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XAuthorityArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XAuthorityArray.fromJson(item));
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

//字典类型
class XDict {
  // 雪花ID
  String? id;

  // 名称
  String? name;

  // 编号
   String? code;

  // 备注
  String? remark;

  // 公开的
  bool? public;

  // 类别ID
   String? speciesId;

  // 创建组织/个人
  String? belongId;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 字典项
   List<XDictItem>? dictItems;

  // 使用该字典的度量标准
   List<XAttribute>? dictAttrs;

  // 创建类别标准的组织/个人
   XTarget? belong;

  // 字典归属的分类
   XSpecies? species;

  //构造方法
  XDict({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.public,
    required this.speciesId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.dictItems,
    required this.dictAttrs,
    required this.belong,
    required this.species,
  });

  //通过JSON构造
  XDict.fromJson(Map<String, dynamic> json){
    id = json["id"];
    name = json["name"];
    code = json["code"];
    remark = json["remark"];
    public = json["public"];
    speciesId = json["speciesId"];
    belongId = json["belongId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    dictItems = json["dictItems"]!=null?XDictItem.fromList(json["dictItems"]):null;
    dictAttrs = json["dictAttrs"]!=null?XAttribute.fromList(json["dictAttrs"]):null;
    belong = json["belong"]!=null?XTarget.fromJson(json["belong"]):null;
    species = json["species"]!=null?XSpecies.fromJson(json["species"]):null;
  }


  //通过动态数组解析成List
  static List<XDict> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XDict> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XDict.fromJson(item));
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
    json["remark"] = remark;
    json["public"] = public;
    json["speciesId"] = speciesId;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["dictItems"] = dictItems;
    json["dictAttrs"] = dictAttrs;
    json["belong"] = belong?.toJson();
    json["species"] = species?.toJson();
    return json;
  }
}

//字典类型查询返回集合
class XDictArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XDict>? result;

  //构造方法
  XDictArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XDictArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XDict.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XDictArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XDictArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XDictArray.fromJson(item));
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

//枚举字典项
class XDictItem {
  // 雪花ID
  final String id;

  // 名称
  final String name;

  // 值
  final String value;

  // 公开的
  final bool? public;

  // 创建组织/个人
  final String belongId;

  // 字典类型ID
  final String dictId;

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

  // 字典类型
  final XDict? dict;

  // 创建类别标准的组织/个人
  final XTarget? belong;

  //构造方法
  XDictItem({
    required this.id,
    required this.name,
    required this.value,
    required this.public,
    required this.belongId,
    required this.dictId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.dict,
    required this.belong,
  });

  //通过JSON构造
  XDictItem.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        value = json["value"],
        public = json["public"],
        belongId = json["belongId"],
        dictId = json["dictId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        dict = json["dict"]!=null?XDict.fromJson(json["dict"]):null,
        belong =json["belong"]!=null?XTarget.fromJson(json["belong"]):null;

  //通过动态数组解析成List
  static List<XDictItem> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<XDictItem> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        if(item is Map<String,dynamic>){
          retList.add(XDictItem.fromJson(item));
        }
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
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["dict"] = dict?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//枚举字典项查询返回集合
class XDictItemArray {
  // 便宜量
  final int? offset;

  // 最大数量
  final int? limit;

  // 总数
  final int? total;

  // 结果
  final List<XDictItem>? result;

  //构造方法
  XDictItemArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XDictItemArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XDictItem.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XDictItemArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XDictItemArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XDictItemArray.fromJson(item));
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

//应用资源分发
class XExtend {
  // 雪花ID
  final String id;

  // 源对象
  final String sourceId;

  // 目标类型
  final String destType;

  // 目标对象Id
  final String destId;

  // 所属组织/个人
  final String belongId;

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

  // 资源归属的组织/个人
  final XTarget? belong;

  //构造方法
  XExtend({
    required this.id,
    required this.sourceId,
    required this.destType,
    required this.destId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.belong,
  });

  //通过JSON构造
  XExtend.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        sourceId = json["sourceId"],
        destType = json["destType"],
        destId = json["destId"],
        belongId = json["belongId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XExtend> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XExtend> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XExtend.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["sourceId"] = sourceId;
    json["destType"] = destType;
    json["destId"] = destId;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["belong"] = belong?.toJson();
    return json;
  }
}

//应用资源分发查询返回集合
class XExtendArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XExtend>? result;

  //构造方法
  XExtendArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XExtendArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XExtend.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XExtendArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XExtendArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XExtendArray.fromJson(item));
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

//流程定义
class XFlowDefine {
  // 雪花ID
  final String? id;

  // 名称
  final String? name;

  // 编码
  final String? code;

  // 归属组织/个人Id
  final String? belongId;

  // 分类id
  final String? speciesId;

  // 职权Id
  final String? authId;

  // 公开的
  final bool? public;

  // 流程内容Json
  final String? content;

  // 备注
  final String? remark;

  // 状态
  final int? status;

  // 创建人员ID
  final String? createUser;

  // 更新人员ID
  final String? updateUser;

  // 修改次数
  final String? version;

  // 创建时间
  final String? createTime;

  // 更新时间
  final String? updateTime;

  // 流程定义节点
  final List<XFlowNode>? flowNodes;

  // 流程的实例
  final List<XFlowInstance>? flowInstances;

  // 应用单与流程对应
  final List<XFlowRelation>? flowRelations;

  // 归属组织/个人
  final XTarget? target;

  //构造方法
  XFlowDefine({
    required this.id,
    required this.name,
    required this.code,
    required this.belongId,
    required this.speciesId,
    required this.authId,
    required this.public,
    required this.content,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.flowNodes,
    required this.flowInstances,
    required this.flowRelations,
    required this.target,
  });

  //通过JSON构造
  XFlowDefine.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        speciesId = json["speciesId"],
        authId = json["authId"],
        public = json["public"],
        content = json["content"],
        remark = json["remark"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        flowNodes = json["flowNodes"]!=null?XFlowNode.fromList(json["flowNodes"]):null,
        flowInstances = json["flowInstances"]!=null?XFlowInstance.fromList(json["flowInstances"]):null,
        flowRelations = json["flowRelations"]!=null?XFlowRelation.fromList(json["flowRelations"]):null,
        target = json["target"]!=null?XTarget.fromJson(json["target"]):null;

  //通过动态数组解析成List
  static List<XFlowDefine> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowDefine> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowDefine.fromJson(item));
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
    json["authId"] = authId;
    json["speciesId"] = speciesId;
    json["public"] = public;
    json["content"] = content;
    json["remark"] = remark;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["flowNodes"] = flowNodes;
    json["flowInstances"] = flowInstances;
    json["flowRelations"] = flowRelations;
    json["target"] = target?.toJson();
    return json;
  }
}

//流程定义查询返回集合
class XFlowDefineArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XFlowDefine>? result;

  //构造方法
  XFlowDefineArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowDefineArray.fromJson(Map<String, dynamic> json){
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];

    List<Map<String,dynamic>>? list;

    if(json["result"]!=null){
      list = [];
      json["result"].forEach((e){
        list!.add(e);
      });
    }
    result = XFlowDefine.fromList(list);
  }

  //通过动态数组解析成List
  static List<XFlowDefineArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowDefineArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowDefineArray.fromJson(item));
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

//流程实例
class XFlowInstance {
  // 雪花ID
  String? id;

  // 流程定义Id
   String? defineId;

  // 应用Id
   String? productId;

  // 标题
   String? title;

  // 展示内容类型
   String? contentType;

  // 展示内容
   String? content;

  // 单数据
   String? data;

  // 回调钩子
   String? hook;

  // 归属
   String? belongId;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 流程任务
   List<XFlowTask>? flowTasks;

  // 流程实例任务
   List<XFlowTaskHistory>? flowTaskHistory;

  // 流程的定义
   XFlowDefine? flowDefine;

  //构造方法
  XFlowInstance({
    required this.id,
    required this.defineId,
    required this.productId,
    required this.belongId,
    required this.title,
    required this.contentType,
    required this.content,
    required this.data,
    required this.hook,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.flowTasks,
    required this.flowTaskHistory,
    required this.flowDefine,
  });

  //通过JSON构造
  XFlowInstance.fromJson(Map<String, dynamic> json){
        id = json["id"];
        defineId = json["defineId"];
        belongId = json["belongId"];
        productId = json["productId"];
        title = json["title"];
        contentType = json["contentType"];
        content = json["content"];
        data = json["data"];
        hook = json["hook"];
        status = json["status"];
        createUser = json["createUser"];
        updateUser = json["updateUser"];
        version = json["version"];
        createTime = json["createTime"];
        updateTime = json["updateTime"];
        flowTasks = json["tasks"]!=null?XFlowTask.fromList(json["tasks"]):null;
        if(json["tasks"]!=null){
          flowTasks = [];
          json["tasks"].forEach((json){
            flowTasks!.add(XFlowTask.fromJson(json));
          });
        }
        if(json["historyTasks"]!=null){
          flowTaskHistory = [];
          json["historyTasks"].forEach((json){
            flowTaskHistory!.add(XFlowTaskHistory.fromJson(json));
          });
        }

        flowDefine = json["define"]!=null?XFlowDefine.fromJson(json["define"]):null;
  }

  //通过动态数组解析成List
  static List<XFlowInstance> fromList(List<Map<String, dynamic>> list) {
    List<XFlowInstance> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowInstance.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["defineId"] = defineId;
    json["productId"] = productId;
    json["belongId"] = belongId;
    json["title"] = title;
    json["contentType"] = contentType;
    json["content"] = content;
    json["data"] = data;
    json["hook"] = hook;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["flowTasks"] = flowTasks;
    json["flowTaskHistory"] = flowTaskHistory;
    json["flowDefine"] = flowDefine?.toJson();
    return json;
  }
}

class FlowNode {
  // 雪花ID
  String? id;

  // 前端定义的编码 代替原先的NodeId
  String? code;

  // 节点类型
  String? type;

  // 节点名称
  String? name;

  // 审批数量
  int? num;

  // 节点审批操作人类型 暂只支持 '身份'
  String? destType;

  // 节点审批操作Id 如 '身份Id'
  String? destId;

  // 节点审批操作名称 如 '身份名称'
  String? destName;

  // 子节点
  FlowNode? children;

  // 分支节点
  List<Branche>? branches;

  // 节点归属
  String? belongId;

  //绑定基本信息
  List<XBindOperation>? operations;

  //构造方法
  FlowNode({
    required this.id,
    required this.code,
    required this.type,
    required this.name,
    required this.num,
    required this.destType,
    required this.destId,
    required this.destName,
    required this.children,
    required this.branches,
    required this.belongId,
  }); //通过JSON构造
  FlowNode.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    belongId = json["belongId"];
    type = json["type"];
    name = json["name"];
    num = json["num"];
    destType = json["destType"];
    destId = json["destId"];
    destName = json["destName"];
    children =
        json["children"] != null ? FlowNode.fromJson(json["children"]) : null;
    if (json['operations'] != null) {
      operations = [];
      json['operations'].forEach((json) {
        operations!.add(XBindOperation.fromJson(json));
      });
    }
  }

  //通过动态数组解析成List
  static List<FlowNode> fromList(List<Map<String, dynamic>> list) {
    List<FlowNode> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(FlowNode.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["code"] = code;
    json["type"] = type;
    json["belongId"] = belongId;
    json["name"] = name;
    json["num"] = num;
    json["destType"] = destType;
    json["destId"] = destId;
    json["destName"] = destName;
    json["children"] = children;
    json["branches"] = branches;
    return json;
  }
}

class Branche {
  //名称
  final String? name;
  //父节点
  final String? parentId;
  // 分支条件
  final List<Condition> conditions;
  // 分支子节点
  final FlowNode children;
  //构造方法
  Branche({
    required this.name,
    required this.parentId,
    required this.conditions,
    required this.children,
  });
}

class Condition {
  // 规则
  final String paramKey;
  // 键
  final String key;
  // 类型
  final String type;
  // 值
  final String val;
  //构造方法
  Condition({
    required this.paramKey,
    required this.key,
    required this.type,
    required this.val,
  });
}

//流程实例查询返回集合
class XFlowInstanceArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
   int? total;

  // 结果
  List<XFlowInstance>? result;

  //构造方法
  XFlowInstanceArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowInstanceArray.fromJson(Map<String, dynamic> json){
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    List<Map<String,dynamic>> list = [];

    if(json["result"]!=null){
      json["result"].forEach((e){
        list.add(e);
      });
    }
    result = XFlowInstance.fromList(list);
  }

  //通过动态数组解析成List
  static List<XFlowInstanceArray> fromList(List<Map<String, dynamic>> list) {
    List<XFlowInstanceArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowInstanceArray.fromJson(item));
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

//流程定义节点
class XFlowNode {
  // 雪花ID
   String? id;

  // 节点编号
   String? code;

  // 节点名称
   String? name;

  // 审批人数
   int? count;

  // 流程定义Id
   String? defineId;

  // 节点规则
   String? rules;

  // 节点分配目标Id
   String? destId;

  // 节点分配目标组织集合
   String? orgIds;

  // destType
   String? destType;

  // 节点类型
   String? nodeType;

  // 备注
   String? remark;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 流程实例任务
   List<XFlowTask>? flowTasks;

  // 流程实例任务
   List<XFlowTaskHistory>? flowTaskHistory;

  // 流程的定义
   XFlowDefine? flowDefine;

   //绑定基本信息
   List<XBindOperation>? bindOperations;
  //构造方法
  XFlowNode({
    required this.id,
    required this.code,
    required this.name,
    required this.count,
    required this.defineId,
    required this.rules,
    required this.destId,
    required this.orgIds,
    required this.destType,
    required this.nodeType,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.flowTasks,
    required this.flowTaskHistory,
    required this.flowDefine,
  });

  //通过JSON构造
  XFlowNode.fromJson(Map<String, dynamic> json){
    id = json["id"];
    code = json["code"];
    name = json["name"];
    count = json["count"];
    defineId = json["defineId"];
    rules = json["rules"];
    destId = json["destId"];
    orgIds = json["orgIds"];
    destType = json["destType"];
    nodeType = json["nodeType"];
    remark = json["remark"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    flowTasks = json["flowTasks"]!=null?XFlowTask.fromList(json["flowTasks"]):null;
    flowTaskHistory = json["flowTaskHistory"]!=null?XFlowTaskHistory.fromList(json["flowTaskHistory"]):null;
    flowDefine = json["flowDefine"]!=null?XFlowDefine.fromJson(json["flowDefine"]):null;
    if(json['bindOperations']!=null){
      bindOperations = [];
      json['bindOperations'].forEach((json){
        bindOperations!.add(XBindOperation.fromJson(json));
      });
    }
  }

  //通过动态数组解析成List
  static List<XFlowNode> fromList(List<Map<String, dynamic>> list) {
    List<XFlowNode> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowNode.fromJson(item));
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
    json["count"] = count;
    json["defineId"] = defineId;
    json["rules"] = rules;
    json["destId"] = destId;
    json["orgIds"] = orgIds;
    json["destType"] = destType;
    json["nodeType"] = nodeType;
    json["remark"] = remark;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["flowTasks"] = flowTasks;
    json["flowTaskHistory"] = flowTaskHistory;
    json["flowDefine"] = flowDefine?.toJson();
    return json;
  }
}


class XBindOperation{
  String? id;
  String? name;
  String? code;
  bool? public;
  String? remake;
  String? speciesId;
  String? belongId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;
  List<XOperationItem> operationItems = [];

  XBindOperation();

  XBindOperation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    public = json['public'];
    remake = json['remake'];
    speciesId = json['speciesId'];
    belongId = json['belongId'];
    status = json['status'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
  }

  Future<void> getOperationItems() async {
    var settingCtrl = Get.find<SettingController>();
    var space = settingCtrl.space;
    ResultType<XOperationItemArray> result = await KernelApi.getInstance()
        .queryOperationItems(IdSpaceReq(
            id: id!,
            spaceId: space.id,
            page: PageRequest(offset: 0, limit: 20, filter: '')));
    operationItems = result.data?.result ?? [];
    for (var element in operationItems) {
      if (element.rule?.widget == "dict") {
        XAttribute? attr = await CommonTreeManagement().findXAttribute(
            specieId: speciesId!, attributeId: element.attrId ?? "");
        if (attr != null) {
          element.rule!.dictItems = attr.dict!.dictItems;
        }
      }
      element.fields = element.toFields();
    }
  }
}
//流程定义节点查询返回集合
class XFlowNodeArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XFlowNode>? result;

  //构造方法
  XFlowNodeArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowNodeArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XFlowNode.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XFlowNodeArray> fromList(List<Map<String, dynamic>> list) {
    List<XFlowNodeArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowNodeArray.fromJson(item));
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

//流程节点数据
class XFlowRecord {
  // 雪花ID
   String? id;

  // 审批人员
   String? targetId;

  // 节点任务
   String? taskId;

  // 评论
   String? comment;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 流程的定义
   XFlowTaskHistory? flowTaskHistory;

  // 审批人员
   XTarget? target;

  //构造方法
  XFlowRecord({
    required this.id,
    required this.targetId,
    required this.taskId,
    required this.comment,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.flowTaskHistory,
    required this.target,
  });

  //通过JSON构造
  XFlowRecord.fromJson(Map<String, dynamic> json){
    id = json["id"];
    targetId = json["targetId"];
    taskId = json["taskId"];
    comment = json["comment"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    flowTaskHistory = json["historyTasks"]!=null?XFlowTaskHistory.fromJson(json["historyTasks"]):null;
    target = json["target"]!=null?XTarget.fromJson(json["target"]):null;
  }

  //通过动态数组解析成List
  static List<XFlowRecord> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowRecord> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowRecord.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["targetId"] = targetId;
    json["taskId"] = taskId;
    json["comment"] = comment;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["flowTaskHistory"] = flowTaskHistory?.toJson();
    json["target"] = target?.toJson();
    return json;
  }
}

//流程节点数据查询返回集合
class XFlowRecordArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XFlowRecord>? result;

  //构造方法
  XFlowRecordArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowRecordArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XFlowRecord.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XFlowRecordArray> fromList(List<Map<String, dynamic>> list) {
    List<XFlowRecordArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowRecordArray.fromJson(item));
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

//流程对应
class XFlowRelation {
  // 雪花ID
  final String id;

  // 业务标准Id
  final String operationId;

  // 流程定义Id
  final String defineId;

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

  // 应用资源
  final XOperation? operation;

  // 流程的定义
  final XFlowDefine? define;

  //构造方法
  XFlowRelation({
    required this.id,
    required this.operationId,
    required this.defineId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.operation,
    required this.define,
  });

  //通过JSON构造
  XFlowRelation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        operationId = json["operationId"],
        defineId = json["defineId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        operation = XOperation.fromJson(json["operation"]),
        define = XFlowDefine.fromJson(json["define"]);

  //通过动态数组解析成List
  static List<XFlowRelation> fromList(List<Map<String, dynamic>> list) {
    List<XFlowRelation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowRelation.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["operationId"] = operationId;
    json["defineId"] = defineId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["operation"] = operation?.toJson();
    json["define"] = define?.toJson();
    return json;
  }
}

//流程对应查询返回集合
class XFlowRelationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XFlowRelation>? result;

  //构造方法
  XFlowRelationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowRelationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XFlowRelation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XFlowRelationArray> fromList(List<Map<String, dynamic>> list) {
    List<XFlowRelationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowRelationArray.fromJson(item));
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

//流程任务
class XFlowTask {
  // 雪花ID
   String? id;

  // 流程定义节点id
   String? nodeId;

  // 流程实例id
   String? instanceId;

  // 节点分配目标Id
   String? identityId;

  // 审批人员
   String? personIds;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

  // 任务审批的身份
   XIdentity? identity;

  // 流程节点
   XFlowNode? flowNode;

  // 流程的定义
   XFlowInstance? flowInstance;

  //构造方法
  XFlowTask({
    required this.id,
    required this.nodeId,
    required this.instanceId,
    required this.identityId,
    required this.personIds,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.identity,
    required this.flowNode,
    required this.flowInstance,
  });

  //通过JSON构造
  XFlowTask.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nodeId = json["nodeId"],
        instanceId = json["instanceId"],
        identityId = json["identityId"],
        personIds = json["personIds"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        identity = json["identity"]!=null?XIdentity.fromJson(json["identity"]):null,
        flowNode = json["node"]!=null?XFlowNode.fromJson(json["node"]):null,
        flowInstance = json["instance"]!=null?XFlowInstance.fromJson(json["instance"]):null;

  //通过动态数组解析成List
  static List<XFlowTask> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowTask> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowTask.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["nodeId"] = nodeId;
    json["instanceId"] = instanceId;
    json["identityId"] = identityId;
    json["personIds"] = personIds;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["identity"] = identity?.toJson();
    json["flowNode"] = flowNode?.toJson();
    json["flowInstance"] = flowInstance?.toJson();
    return json;
  }
}

//流程任务查询返回集合
class XFlowTaskArray {
  // 便宜量
   int? offset;

  // 最大数量
   int? limit;

  // 总数
   int? total;

  // 结果
   List<XFlowTask>? result;

  //构造方法
  XFlowTaskArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });
  //通过JSON构造
  XFlowTaskArray.fromJson(Map<String, dynamic> json){
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    List<Map<String,dynamic>>? list;
    if(json["result"]!=null){
      list = [];
      json["result"].forEach((e){
        list!.add(e);
      });
    }

    result = XFlowTask.fromList(list);
  }

  //通过动态数组解析成List
  static List<XFlowTaskArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowTaskArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowTaskArray.fromJson(item));
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

//流程任务
class XFlowTaskHistory {
  // 雪花ID
  String? id;

  // 流程定义节点id
   String? nodeId;

  // 流程实例id
   String? instanceId;

  // 节点分配目标Id
   String? identityId;

  // 状态
   int? status;

  // 创建人员ID
   String? createUser;

  // 更新人员ID
   String? updateUser;

  // 修改次数
   String? version;

  // 创建时间
   String? createTime;

  // 更新时间
   String? updateTime;

   //备注
   String? comment;

  // 流程节点记录
  List<XFlowRecord>? flowRecords;

  // 任务审批的身份
  XIdentity? identity;

  // 流程节点
  XFlowNode? flowNode;

  // 流程的定义
  XFlowInstance? flowInstance;

  XFlowTask? historyTask;

  //构造方法
  XFlowTaskHistory({
    required this.id,
    required this.nodeId,
    required this.instanceId,
    required this.identityId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.flowRecords,
    required this.identity,
    required this.flowNode,
    required this.flowInstance,
  });

  //通过JSON构造
  XFlowTaskHistory.fromJson(Map<String, dynamic> json){
    id = json["id"];
    nodeId = json["nodeId"];
    instanceId = json["instanceId"];
    identityId = json["identityId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    comment = json["comment"];
    if (json["records"] != null) {
      flowRecords = [];
      json["records"].forEach((json) {
        flowRecords!.add(XFlowRecord.fromJson(json));
      });
    }
    identity =
        json["identity"] != null ? XIdentity.fromJson(json["identity"]) : null;
    flowNode = json["node"] != null ? XFlowNode.fromJson(json["node"]) : null;
    historyTask = json['historyTask'] != null
        ? XFlowTask.fromJson(json['historyTask'])
        : null;
    flowInstance = json["flowInstance"] != null
        ? XFlowInstance.fromJson(json["flowInstance"])
        : null;
  }

  //通过动态数组解析成List
  static List<XFlowTaskHistory> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowTaskHistory> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowTaskHistory.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["nodeId"] = nodeId;
    json["instanceId"] = instanceId;
    json["identityId"] = identityId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["flowRecords"] = flowRecords;
    json["identity"] = identity?.toJson();
    json["flowNode"] = flowNode?.toJson();
    json["flowInstance"] = flowInstance?.toJson();
    return json;
  }
}

//流程任务查询返回集合
class XFlowTaskHistoryArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XFlowTaskHistory>? result;

  //构造方法
  XFlowTaskHistoryArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFlowTaskHistoryArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    List<XFlowTaskHistory> retList = [];
    List<Map<String, dynamic>> list = [];

    if (json["result"] != null) {
      json["result"].forEach((e) {
        list.add(e);
      });
    }
    result = XFlowTaskHistory.fromList(list);
  }

  //通过动态数组解析成List
  static List<XFlowTaskHistoryArray> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XFlowTaskHistoryArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XFlowTaskHistoryArray.fromJson(item));
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

//身份证明
class XIdProof {
  // 雪花ID
  final String id;

  // 身份ID
  final String identityId;

  // 对象ID
  final String targetId;

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

  // 身份证明证明的组织/个人
  final XTarget? target;

  // 身份证明证明的身份
  final XIdentity? identity;

  //构造方法
  XIdProof({
    required this.id,
    required this.identityId,
    required this.targetId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.target,
    required this.identity,
  });

  //通过JSON构造
  XIdProof.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        identityId = json["identityId"],
        targetId = json["targetId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        target = XTarget.fromJson(json["target"]),
        identity = XIdentity.fromJson(json["identity"]);

  //通过动态数组解析成List
  static List<XIdProof> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XIdProof> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XIdProof.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["identityId"] = identityId;
    json["targetId"] = targetId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["target"] = target?.toJson();
    json["identity"] = identity?.toJson();
    return json;
  }
}

//身份证明查询返回集合
class XIdProofArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XIdProof>? result;

  //构造方法
  XIdProofArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XIdProofArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XIdProof.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XIdProofArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XIdProofArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XIdProofArray.fromJson(item));
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

//身份
class XIdentity {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  String code;

  // 备注
  String remark;

  // 职权Id
  final String authId;

  // 创建组织/个人
  final String belongId;

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
  String updateTime;

  // 身份证明
  final List<XIdProof>? idProofs;

  // 身份集关系
  final List<XTeamIdentity>? identityTeams;

  // 赋予身份的组织/个人
  final List<XTarget>? givenTargets;

  // 身份所属的未完成流程的任务
  final List<XFlowTask>? flowTasks;

  // 身份所属的未完成流程的任务
  final List<XFlowTaskHistory>? flowTaskHistory;

  // 身份集对于组织
  final List<XTeam>? teams;

  // 身份的类别
  final XAuthority? authority;

  // 创建身份的组织/个人
  final XTarget? belong;

  //构造方法
  XIdentity({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.authId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.idProofs,
    required this.identityTeams,
    required this.givenTargets,
    required this.flowTasks,
    required this.flowTaskHistory,
    required this.teams,
    required this.authority,
    required this.belong,
  });

  //通过JSON构造
  XIdentity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        remark = json["remark"],
        authId = json["authId"],
        belongId = json["belongId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        idProofs = XIdProof.fromList(json["idProofs"]),
        identityTeams = XTeamIdentity.fromList(json["identityTeams"]),
        givenTargets = XTarget.fromList(json["givenTargets"]),
        flowTasks = XFlowTask.fromList(json["flowTasks"]),
        flowTaskHistory = XFlowTaskHistory.fromList(json["flowTaskHistory"]),
        teams = XTeam.fromList(json["teams"]),
        authority = XAuthority.fromJson(json["authority"]),
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XIdentity> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XIdentity> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XIdentity.fromJson(item));
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
    json["remark"] = remark;
    json["authId"] = authId;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["idProofs"] = idProofs;
    json["identityTeams"] = identityTeams;
    json["givenTargets"] = givenTargets;
    json["flowTasks"] = flowTasks;
    json["flowTaskHistory"] = flowTaskHistory;
    json["teams"] = teams;
    json["authority"] = authority?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//身份查询返回集合
class XIdentityArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XIdentity>? result;

  //构造方法
  XIdentityArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XIdentityArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XIdentity.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XIdentityArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XIdentityArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XIdentityArray.fromJson(item));
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

//及时通讯
class XImMsg {
  // 雪花ID
  final String id;

  // 工作空间Id
  final String spaceId;

  // 发起方Id
  final String fromId;

  // 接收方Id
  final String toId;

  // 消息类型
  final String msgType;

  // 消息体
  String msgBody;

  // 状态
  final int? status;

  // 创建人员ID
  final String createUser;

  // 更新人员ID
  final String updateUser;

  // 修改次数
  final String? version;

  // 创建时间
  final String? createTime;

  // 更新时间
  final String updateTime;

  // 显示文本
  String showTxt;

  // 是否允许编辑
  late bool allowEdit;

  //构造方法
  XImMsg({
    required this.id,
    required this.spaceId,
    required this.fromId,
    required this.toId,
    required this.msgType,
    required this.msgBody,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.showTxt,
    required this.allowEdit,
  });

  //通过JSON构造
  XImMsg.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        spaceId = json["spaceId"],
        fromId = json["fromId"],
        toId = json["toId"],
        msgType = json["msgType"],
        msgBody = json["msgBody"] ?? "",
        status = json["status"],
        createUser = json["createUser"] ?? "",
        updateUser = json["updateUser"] ?? "",
        version = json["version"],
        showTxt = json["showTxt"] ?? "",
        createTime = json["createTime"] ?? "",
        updateTime = json["updateTime"] ?? "";

  //通过动态数组解析成List
  static List<XImMsg> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<XImMsg> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XImMsg.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["spaceId"] = spaceId;
    json["fromId"] = fromId;
    json["toId"] = toId;
    json["msgType"] = msgType;
    json["msgBody"] = msgBody;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["showTxt"] = showTxt;
    return json;
  }
}

//及时通讯查询返回集合
class XImMsgArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XImMsg>? result;

  //构造方法
  XImMsgArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XImMsgArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"] ?? 0,
        limit = json["limit"],
        total = json["total"] ?? 0,
        result = XImMsg.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XImMsgArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XImMsgArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XImMsgArray.fromJson(item));
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

//操作日志
class XLog {
  // 雪花ID
  final String id;

  // 类型
  final String type;

  // 模块
  final String module;

  // 内容
  final String content;

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

  //构造方法
  XLog({
    required this.id,
    required this.type,
    required this.module,
    required this.content,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
  });

  //通过JSON构造
  XLog.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        type = json["type"],
        module = json["module"],
        content = json["content"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"];

  //通过动态数组解析成List
  static List<XLog> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XLog> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XLog.fromJson(item));
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
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    return json;
  }
}

//操作日志查询返回集合
class XLogArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XLog>? result;

  //构造方法
  XLogArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XLogArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XLog.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XLogArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XLogArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XLogArray.fromJson(item));
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

//交易市场
class XMarket {
  // 雪花ID
  final String id;

  // 名称
  final String name;

  // 编号
  final String code;

  // 备注
  final String remark;

  // 加入操作是否公开的
  final bool joinPublic;

  // 售卖操作是否公开
  final bool sellPublic;

  // 购买操作是否公开
  final bool buyPublic;

  // 图片
  final String photo;

  // 创建组织/个人
  final String belongId;

  // 市场监管组织/个人
  final String samrId;

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

  // 市场暂存区
  final List<XStaging>? stags;

  // 上架市场的商品
  final List<XMerchandise>? merchandises;

  // 市场与组织/个人关系
  final List<XMarketRelation>? targetRelations;

  // 市场归属的组织/个人
  final XTarget? belong;

  // 市场监管的组织/个人
  final XTarget? samr;

  //构造方法
  XMarket({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.joinPublic,
    required this.sellPublic,
    required this.buyPublic,
    required this.photo,
    required this.belongId,
    required this.samrId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.stags,
    required this.merchandises,
    required this.targetRelations,
    required this.belong,
    required this.samr,
  });

  //通过JSON构造
  XMarket.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        remark = json["remark"],
        joinPublic = json["joinPublic"],
        sellPublic = json["sellPublic"],
        buyPublic = json["buyPublic"],
        photo = json["photo"],
        belongId = json["belongId"],
        samrId = json["samrId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        stags = XStaging.fromList(json["stags"]),
        merchandises = XMerchandise.fromList(json["merchandises"]),
        targetRelations = XMarketRelation.fromList(json["targetRelations"]),
        belong = XTarget.fromJson(json["belong"]),
        samr = XTarget.fromJson(json["samr"]);

  //通过动态数组解析成List
  static List<XMarket> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMarket> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMarket.fromJson(item));
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
    json["remark"] = remark;
    json["photo"] = photo;
    json["belongId"] = belongId;
    json["samrId"] = samrId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["stags"] = stags;
    json["buyPublic"] = buyPublic;
    json["joinPublic"] = joinPublic;
    json["pubsellPubliclic"] = sellPublic;
    json["merchandises"] = merchandises;
    json["targetRelations"] = targetRelations;
    json["belong"] = belong?.toJson();
    json["samr"] = samr?.toJson();
    return json;
  }
}

//交易市场查询返回集合
class XMarketArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XMarket>? result;

  //构造方法
  XMarketArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XMarketArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XMarket.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XMarketArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMarketArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMarketArray.fromJson(item));
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

//组织/个人与市场关系
class XMarketRelation {
  // 雪花ID
  final String id;

  // 市场ID
  final String marketId;

  // 组织/个人ID
  final String targetId;

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

  // 关系的度量
  final List<XThingAttr>? marketRelationValues;

  // 市场
  final XMarket? market;

  // 组织/个人ID
  final XTarget? target;

  //构造方法
  XMarketRelation({
    required this.id,
    required this.marketId,
    required this.targetId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.marketRelationValues,
    required this.market,
    required this.target,
  });

  //通过JSON构造
  XMarketRelation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        marketId = json["marketId"],
        targetId = json["targetId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        marketRelationValues =
            XThingAttr.fromList(json["marketRelationValues"]),
        market = XMarket.fromJson(json["market"]),
        target = XTarget.fromJson(json["target"]);

  //通过动态数组解析成List
  static List<XMarketRelation> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMarketRelation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMarketRelation.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["marketId"] = marketId;
    json["targetId"] = targetId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["marketRelationValues"] = marketRelationValues;
    json["market"] = market?.toJson();
    json["target"] = target?.toJson();
    return json;
  }
}

//组织/个人与市场关系查询返回集合
class XMarketRelationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XMarketRelation>? result;

  //构造方法
  XMarketRelationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XMarketRelationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XMarketRelation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XMarketRelationArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMarketRelationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMarketRelationArray.fromJson(item));
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

//商品信息
class XMerchandise {
  // 雪花ID
  final String id;

  // 标题
  final String caption;

  // 产品ID
  final String productId;

  // 单价
  final double price;

  // 出售权属
  final String sellAuth;

  // 有效期
  final String days;

  // 商品出售市场ID
  final String marketId;

  // 描述信息
  final String information;

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

  // 商品采购暂存
  final List<XStaging>? stags;

  // 采购订单
  final List<XOrderDetail>? orders;

  // 商品对应的产品
  final XProduct? product;

  // 商品上架的市场
  final XMarket? market;

  //构造方法
  XMerchandise({
    required this.id,
    required this.caption,
    required this.productId,
    required this.price,
    required this.sellAuth,
    required this.days,
    required this.marketId,
    required this.information,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.stags,
    required this.orders,
    required this.product,
    required this.market,
  });

  //通过JSON构造
  XMerchandise.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        caption = json["caption"],
        productId = json["productId"],
        price = json["price"],
        sellAuth = json["sellAuth"],
        days = json["days"],
        marketId = json["marketId"],
        information = json["information"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        stags = XStaging.fromList(json["stags"]),
        orders = XOrderDetail.fromList(json["orders"]),
        product = XProduct.fromJson(json["product"]),
        market = XMarket.fromJson(json["market"]);

  //通过动态数组解析成List
  static List<XMerchandise> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMerchandise> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMerchandise.fromJson(item));
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
    json["days"] = days;
    json["marketId"] = marketId;
    json["information"] = information;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["stags"] = stags;
    json["orders"] = orders;
    json["product"] = product?.toJson();
    json["market"] = market?.toJson();
    return json;
  }
}

//商品信息查询返回集合
class XMerchandiseArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XMerchandise>? result;

  //构造方法
  XMerchandiseArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XMerchandiseArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XMerchandise.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XMerchandiseArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XMerchandiseArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XMerchandiseArray.fromJson(item));
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

//业务操作定义
class XOperation {
  // 雪花ID
  final String id;

  // 名称
  final String name;

  // 编号
  final String code;

  // 公开的
  final bool public;

  // 备注
  final String remark;

  // 类别ID
  final String speciesId;

  // 创建组织/个人
  final String belongId;

  // 绑定的流程ID
  final String defineId;

  // 角色ID
  final String beginAuthId;

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
  // 绑定的流程
  final XFlowDefine? flow;

  // 业务单详情项
  final List<XOperationItem>? items;

  // 业务单针对的分类
  final XSpecies? species;

  // 创建度量标准的组织/个人
  final XTarget? belong;

  //构造方法
  XOperation({
    required this.id,
    required this.name,
    required this.code,
    required this.public,
    required this.remark,
    required this.speciesId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.items,
    required this.species,
    required this.belong,
    required this.beginAuthId,
    required this.defineId,
    required this.flow,
  });

  //通过JSON构造
  XOperation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        public = json["public"],
        remark = json["remark"],
        speciesId = json["speciesId"],
        belongId = json["belongId"],
        beginAuthId = json["beginAuthId"],
        defineId = json["defineId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        flow = XFlowDefine.fromJson(json["flow"]),
        items = XOperationItem.fromList(json["items"]),
        species = XSpecies.fromJson(json["species"]),
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XOperation> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperation.fromJson(item));
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
    json["remark"] = remark;
    json["speciesId"] = speciesId;
    json["belongId"] = belongId;
    json["defineId"] = defineId;
    json["beginAuthId"] = beginAuthId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["items"] = items;
    json["flow"] = flow;
    json["species"] = species?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//业务操作定义查询返回集合
class XOperationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XOperation>? result;

  //构造方法
  XOperationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOperationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XOperation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XOperationArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperationArray.fromJson(item));
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

//业务单项
class XOperationItem {
  // 雪花ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 绑定的特性ID
  String? attrId;

  // 规则
  Rule? rule;

  // 备注
  String? remark;

  // 业务Id
  String? operationId;

  // 创建组织/个人
  String? belongId;

  // 状态
  int? status;

  // 创建人员ID
  String? createUser;

  // 更新人员ID
  String? updateUser;

  // 修改次数
  String? version;

  // 创建时间
  String? createTime;

  // 更新时间
  String? updateTime;

  // 业务单
  XOperation? operation;

  // 创建度量标准的组织/个人
  XTarget? belong;

  // 绑定的特性
  XAttribute? attr;

  // 子表关联的分类
  List<XSpecies>? containSpecies;

  // 子项与分类的关联
  List<XOperationRelation>? operationRelations;

  Fields? fields;

  //构造方法
  XOperationItem({
    required this.id,
    required this.name,
    required this.code,
    required this.rule,
    required this.attrId,
    required this.remark,
    required this.operationId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.operation,
    required this.belong,
    required this.attr,
    required this.containSpecies,
    required this.operationRelations,
  });

  //通过JSON构造
  XOperationItem.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    rule =
        json["rule"] != null ? Rule.fromJson(jsonDecode(json["rule"])) : null;
    attrId = json["attrId"];
    remark = json["remark"];
    operationId = json["operationId"];
    belongId = json["belongId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    operation = json["operation"] != null
        ? XOperation.fromJson(json["operation"])
        : null;
    belong = json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;
    attr = json["attr"] != null ? XAttribute.fromJson(json["attr"]) : null;
    containSpecies = json["containSpecies"] != null
        ? XSpecies.fromList(json["containSpecies"])
        : null;
    operationRelations = json["operationRelations"] != null
        ? XOperationRelation.fromList(json["operationRelations"])
        : null;
  }

  //通过动态数组解析成List
  static List<XOperationItem> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperationItem> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperationItem.fromJson(item));
      }
    }
    return retList;
  }

  Fields toFields() {
    String? type;
    String? router;
    if (rule?.widget == "text" || rule?.widget == "number") {
      type = "input";
    } else if (rule?.widget == "dict" || (rule?.widget?.contains('date')??false)) {
      type = "select";
    } else if(rule?.widget == "person"){
      type = "router";
      router = "/choicePeople";
    }

    Map<dynamic, String> select = {};
    rule?.dictItems?.forEach((element) {
      select[element.value] = element.name;
    });
    return Fields(
      title: rule?.title,
      type: type,
      required: rule?.required,
      hidden: rule?.hidden,
      readOnly: rule?.readOnly,
      code: code,
      hint: rule?.placeholder,
      select: select,
      router: router,
    );
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["rule"] = rule;
    json["remark"] = remark;
    json["operationId"] = operationId;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["operation"] = operation?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

class Rule {
  String? title;
  String? type;
  String? widget;
  bool? required;
  String? description;
  String? dictId;
  String? placeholder;
  bool? hidden;
  bool? readOnly;

  // 字典项
  List<XDictItem>? dictItems;

  Rule();

  Rule.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    widget = json['widget'];
    required = json['required'];
    description = json['description'];
    dictId = json['dictId'];
    placeholder = json['placeholder'];
    hidden = json['hidden'];
    readOnly = json['readOnly'];
  }
}

//业务单项查询返回集合
class XOperationItemArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XOperationItem>? result;

  //构造方法
  XOperationItemArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOperationItemArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];

    if (json['result'] != null) {
      result = [];
      json['result'].forEach((json) {
        result!.add(XOperationItem.fromJson(json));
      });
    }
  }

  //通过动态数组解析成List
  static List<XOperationItemArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOperationItemArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOperationItemArray.fromJson(item));
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

//采购订单
class XOrder {
  // 雪花ID
  final String id;

  // 存证ID
  final String nftId;

  // 名称
  final String name;

  // 编号
  final String code;

  // 总价
  final double price;

  // 创建组织/个人
  final String belongId;

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

  // 订单明细
  final List<XOrderDetail>? details;

  // 创建订单的组织/个人
  final XTarget? belong;

  //构造方法
  XOrder({
    required this.id,
    required this.nftId,
    required this.name,
    required this.code,
    required this.price,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.details,
    required this.belong,
  });

  //通过JSON构造
  XOrder.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        nftId = json["nftId"],
        name = json["name"],
        code = json["code"],
        price = json["price"],
        belongId = json["belongId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        details = XOrderDetail.fromList(json["details"]),
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XOrder> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrder> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrder.fromJson(item));
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
    json["price"] = price;
    json["belongId"] = belongId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["details"] = details;
    json["belong"] = belong?.toJson();
    return json;
  }
}

//采购订单查询返回集合
class XOrderArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XOrder>? result;

  //构造方法
  XOrderArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOrderArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XOrder.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XOrderArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrderArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrderArray.fromJson(item));
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

//订单详情
class XOrderDetail {
  // 雪花ID
  final String id;

  // 订单ID
  final String orderId;

  // 商品ID
  final String merchandiseId;

  // 卖方ID
  final String sellerId;

  // 卖方产品来源
  final String productSource;

  // 出售权属
  final String sellAuth;

  // 总价
  final double price;

  // 有效期
  final String days;

  // 标题
  final String caption;

  // 状态
  int status;

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

  // 订单支付明细
  final List<XOrderPay>? pays;

  // 交付产品
  final XProduct? product;

  // 售卖方
  final XTarget? seller;

  // 订单
  final XOrder? order;

  // 商品
  final XMerchandise? merchandise;

  //构造方法
  XOrderDetail({
    required this.id,
    required this.orderId,
    required this.merchandiseId,
    required this.sellerId,
    required this.productSource,
    required this.sellAuth,
    required this.price,
    required this.days,
    required this.caption,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.pays,
    required this.product,
    required this.seller,
    required this.order,
    required this.merchandise,
  });

  //通过JSON构造
  XOrderDetail.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        orderId = json["orderId"],
        merchandiseId = json["merchandiseId"],
        sellerId = json["sellerId"],
        productSource = json["productSource"],
        sellAuth = json["sellAuth"],
        price = json["price"],
        days = json["days"],
        caption = json["caption"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        pays = XOrderPay.fromList(json["pays"]),
        product = XProduct.fromJson(json["product"]),
        seller = XTarget.fromJson(json["seller"]),
        order = XOrder.fromJson(json["order"]),
        merchandise = XMerchandise.fromJson(json["merchandise"]);

  //通过动态数组解析成List
  static List<XOrderDetail> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrderDetail> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrderDetail.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["orderId"] = orderId;
    json["merchandiseId"] = merchandiseId;
    json["sellerId"] = sellerId;
    json["productSource"] = productSource;
    json["sellAuth"] = sellAuth;
    json["price"] = price;
    json["days"] = days;
    json["caption"] = caption;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["pays"] = pays;
    json["product"] = product?.toJson();
    json["seller"] = seller?.toJson();
    json["order"] = order?.toJson();
    json["merchandise"] = merchandise?.toJson();
    return json;
  }
}

//订单详情查询返回集合
class XOrderDetailArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XOrderDetail>? result;

  //构造方法
  XOrderDetailArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOrderDetailArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XOrderDetail.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XOrderDetailArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrderDetailArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrderDetailArray.fromJson(item));
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

//支付详情
class XOrderPay {
  // 雪花ID
  final String id;

  // 订单ID
  final String orderDetailId;

  // 支付总价
  final double price;

  // 支付方式
  final String paymentType;

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

  // 订单
  final XOrderDetail? orderDetail;

  //构造方法
  XOrderPay({
    required this.id,
    required this.orderDetailId,
    required this.price,
    required this.paymentType,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.orderDetail,
  });

  //通过JSON构造
  XOrderPay.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        orderDetailId = json["orderDetailId"],
        price = json["price"],
        paymentType = json["paymentType"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        orderDetail = XOrderDetail.fromJson(json["orderDetail"]);

  //通过动态数组解析成List
  static List<XOrderPay> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrderPay> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrderPay.fromJson(item));
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
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["orderDetail"] = orderDetail?.toJson();
    return json;
  }
}

//支付详情查询返回集合
class XOrderPayArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XOrderPay>? result;

  //构造方法
  XOrderPayArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XOrderPayArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XOrderPay.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XOrderPayArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XOrderPayArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XOrderPayArray.fromJson(item));
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

//产品信息
class XProduct {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  String code;

  // 来源
  final String source;

  // 权属
  final String authority;

  // 对哪一类制定的标准
  String typeName;

  // 归属组织/个人
  late String belongId;

  // 元数据Id
  final String thingId;

  // 订单ID
  final String orderId;

  // 过期时间
  final String endTime;

  // 图片
  final String photo;

  // 备注
  String remark;

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

  // 产品的资源
  final List<XResource> resource;

  // 上架的商品
  final List<XMerchandise> merchandises;

  // 流程对应
  final List<XFlowRelation> flowRelations;

  // 产品的本质
  final XThing thing;

  // 订单ID
  final XOrderDetail orderSource;

  // 产品归属的组织/个人
  final XTarget belong;

  //构造方法
  XProduct({
    required this.name,
    required this.code,
    required this.source,
    required this.authority,
    required this.id,
    required this.typeName,
    required this.thingId,
    required this.orderId,
    required this.endTime,
    required this.photo,
    required this.belongId,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.resource,
    required this.merchandises,
    required this.flowRelations,
    required this.thing,
    required this.orderSource,
    required this.belong,
  });

  //通过JSON构造
  XProduct.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        source = json["source"],
        authority = json["authority"],
        typeName = json["typeName"],
        belongId = json["belongId"],
        thingId = json["thingId"],
        orderId = json["orderId"],
        endTime = json["endTime"],
        photo = json["photo"],
        remark = json["remark"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        resource = XResource.fromList(json["resource"]),
        merchandises = XMerchandise.fromList(json["merchandises"]),
        flowRelations = XFlowRelation.fromList(json["flowRelations"]),
        thing = XThing.fromJson(json["thing"]),
        orderSource = XOrderDetail.fromJson(json["orderSource"]),
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XProduct> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XProduct> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XProduct.fromJson(item));
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
    json["source"] = source;
    json["authority"] = authority;
    json["typeName"] = typeName;
    json["belongId"] = belongId;
    json["thingId"] = thingId;
    json["orderId"] = orderId;
    json["endTime"] = endTime;
    json["photo"] = photo;
    json["remark"] = remark;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["resource"] = resource;
    json["merchandises"] = merchandises;
    json["flowRelations"] = flowRelations;
    json["thing"] = thing.toJson();
    json["orderSource"] = orderSource.toJson();
    json["belong"] = belong.toJson();
    return json;
  }
}

//产品信息查询返回集合
class XProductArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XProduct>? result;

  //构造方法
  XProductArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XProductArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XProduct.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XProductArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XProductArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XProductArray.fromJson(item));
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

//组织/个人关系
class XRelation {
  // 雪花ID
  final String id;

  // 对象ID
  final String targetId;

  // 组织ID
  final String teamId;

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

  // 关系的度量
  final List<XThingAttr>? attrValues;

  // 关联的组织团队
  final XTeam? team;

  // 关联的组织实体
  final XTarget? target;

  //构造方法
  XRelation({
    required this.id,
    required this.targetId,
    required this.teamId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.attrValues,
    required this.team,
    required this.target,
  });

  //通过JSON构造
  XRelation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        targetId = json["targetId"],
        teamId = json["teamId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        attrValues = XThingAttr.fromList(json["attrValues"]),
        team = XTeam.fromJson(json["team"]),
        target = XTarget.fromJson(json["target"]);

  //通过动态数组解析成List
  static List<XRelation> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRelation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRelation.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["targetId"] = targetId;
    json["teamId"] = teamId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["attrValues"] = attrValues;
    json["team"] = team?.toJson();
    json["target"] = target?.toJson();
    return json;
  }
}

//组织/个人关系查询返回集合
class XRelationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XRelation>? result;

  //构造方法
  XRelationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XRelationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"]?? 0,
        limit = json["limit"]?? 2^64 - 1,
        total = json["total"] ?? 0,
        result = XRelation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XRelationArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRelationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRelationArray.fromJson(item));
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

//应用资源
class XResource {
  // 雪花ID
  final String id;

  // 编号
  final String code;

  // 名称
  final String name;

  // 产品ID
  final String productId;

  // 访问私钥
  final String privateKey;

  // 入口
  final String link;

  // 流程项
  final String flows;

  // 组件
  final String components;

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

  //
  late XProduct? product;

  //构造方法
  XResource({
    required this.id,
    required this.code,
    required this.name,
    required this.productId,
    required this.privateKey,
    required this.link,
    required this.flows,
    required this.components,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.product,
  });

  //通过JSON构造
  XResource.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        code = json["code"],
        name = json["name"],
        productId = json["productId"],
        privateKey = json["privateKey"],
        link = json["link"],
        flows = json["flows"],
        components = json["components"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        product = XProduct.fromJson(json["product"]);

  //通过动态数组解析成List
  static List<XResource> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XResource> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XResource.fromJson(item));
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
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["product"] = product?.toJson();
    return json;
  }
}

//应用资源查询返回集合
class XResourceArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XResource>? result;

  //构造方法
  XResourceArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XResourceArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XResource.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XResourceArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XResourceArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XResourceArray.fromJson(item));
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

//规则与度量标准关系
class XRuleAttr {
  // 雪花ID
  final String id;

  // 规则ID
  final String ruleId;

  // 度量标准ID
  final String attrId;

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

  // 规则
  final XRuleStd? ruleStd;

  // 标准
  final XAttribute? attribute;

  //构造方法
  XRuleAttr({
    required this.id,
    required this.ruleId,
    required this.attrId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.ruleStd,
    required this.attribute,
  });

  //通过JSON构造
  XRuleAttr.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        ruleId = json["ruleId"],
        attrId = json["attrId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        ruleStd = XRuleStd.fromJson(json["ruleStd"]),
        attribute = XAttribute.fromJson(json["attribute"]);

  //通过动态数组解析成List
  static List<XRuleAttr> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRuleAttr> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRuleAttr.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["ruleId"] = ruleId;
    json["attrId"] = attrId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["ruleStd"] = ruleStd?.toJson();
    json["attribute"] = attribute?.toJson();
    return json;
  }
}

//规则与度量标准关系查询返回集合
class XRuleAttrArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XRuleAttr>? result;

  //构造方法
  XRuleAttrArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XRuleAttrArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XRuleAttr.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XRuleAttrArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRuleAttrArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRuleAttrArray.fromJson(item));
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

//标准要求
class XRuleStd {
  // 雪花ID
  final String id;

  // 名称
  final String name;

  // 编号
  final String code;

  // 备注
  final String remark;

  // 对哪一类制定的标准
  final String typeName;

  // 组织/个人ID
  final String targetId;

  // 容器ID
  final String containerId;

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

  // 标准要求
  final List<XRuleAttr>? ruleAttrs;

  // 组织/个人
  final XTarget? target;

  //构造方法
  XRuleStd({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.typeName,
    required this.targetId,
    required this.containerId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.ruleAttrs,
    required this.target,
  });

  //通过JSON构造
  XRuleStd.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        remark = json["remark"],
        typeName = json["typeName"],
        targetId = json["targetId"],
        containerId = json["containerId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        ruleAttrs = XRuleAttr.fromList(json["ruleAttrs"]),
        target = XTarget.fromJson(json["target"]);

  //通过动态数组解析成List
  static List<XRuleStd> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRuleStd> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRuleStd.fromJson(item));
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
    json["remark"] = remark;
    json["typeName"] = typeName;
    json["targetId"] = targetId;
    json["containerId"] = containerId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["ruleAttrs"] = ruleAttrs;
    json["target"] = target?.toJson();
    return json;
  }
}

//标准要求查询返回集合
class XRuleStdArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XRuleStd>? result;

  //构造方法
  XRuleStdArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XRuleStdArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XRuleStd.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XRuleStdArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XRuleStdArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XRuleStdArray.fromJson(item));
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

//类别定义
class XSpecies {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  final String code;

  // 备注
  String remark;

  // 公开的
  bool public;

  // 父类别ID
  final String parentId;

  // 创建组织/个人
  String belongId;

  // 工作职权Id
  String authId;

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

  // 该类别与物的关系
  final List<XThingSpec>? specThings;

  // 该类别的物
  final List<XThing>? things;

  // 类别的字典
  final List<XDict>? dicts;

  // 类别的度量标准
  final List<XAttribute>? attributes;

  // 类别的业务单
  final List<XOperation>? operations;

  // 分类的结构
  final XSpecies? parent;

  // 分类的结构
  final List<XSpecies>? nodes;

  // 工作职权
  final XAuthority? authority;

  // 创建类别标准的组织/个人
  final XTarget? belong;

  //构造方法
  XSpecies({
    required this.id,
    required this.name,
    required this.code,
    required this.remark,
    required this.public,
    required this.parentId,
    required this.belongId,
    required this.authId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.specThings,
    required this.things,
    required this.dicts,
    required this.attributes,
    required this.operations,
    required this.parent,
    required this.nodes,
    required this.authority,
    required this.belong,
  });

  //通过JSON构造
  XSpecies.fromJson(Map<String, dynamic> json)
      : id = json["id"]??"",
        name = json["name"]??"",
        code = json["code"]??"",
        remark = json["remark"]??"",
        public = json["public"]??false,
        parentId  = json["parentId"]??"",
        belongId = json["belongId"]??"",
        authId = json["authId"]??"",
        status = json["status"]??0,
        createUser = json["createUser"]??"",
        updateUser = json["updateUser"]??"",
        version = json["version"]??"",
        createTime = json["createTime"]??"",
        updateTime = json["updateTime"]??"",
        specThings = XThingSpec.fromList(json["specThings"]),
        things = XThing.fromList(json["things"]),
        dicts = XDict.fromList(json["dicts"]),
        attributes = XAttribute.fromList(json["attributes"]),
        operations = XOperation.fromList(json["operations"]),
        parent = json["parent"]!=null?XSpecies.fromJson(json["parent"]):null,
        nodes = XSpecies.fromList(json["nodes"]),
        authority = json["authority"]!=null?XAuthority.fromJson(json["authority"]):null,
        belong = json["belong"]!=null?XTarget.fromJson(json["belong"]):null;

  //通过动态数组解析成List
  static List<XSpecies> fromList(List? list) {
    if (list == null) {
      return [];
    }
    List<XSpecies> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        if(item is Map<String,dynamic>){
          retList.add(XSpecies.fromJson(item));
        }else{
          item;
        }
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
    json["remark"] = remark;
    json["public"] = public;
    json["parentId"] = parentId;
    json["belongId"] = belongId;
    json["authId"] = authId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["specThings"] = specThings;
    json["things"] = things;
    json["dicts"] = dicts;
    json["attributes"] = attributes;
    json["operations"] = operations;
    json["parent"] = parent?.toJson();
    json["nodes"] = nodes;
    json["authority"] = authority?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//类别定义查询返回集合
class XSpeciesArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XSpecies>? result;

  //构造方法
  XSpeciesArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XSpeciesArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XSpecies.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XSpeciesArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XSpeciesArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XSpeciesArray.fromJson(item));
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

//商品暂存
class XStaging {
  // 雪花ID
  final String id;

  // 商品ID
  final String merchandiseId;

  // 创建组织/个人
  final String belongId;

  // 订单采购的市场
  final String marketId;

  // 数量
  final String number;

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

  // 暂存区针对的市场
  final XMarket? market;

  // 创建的组织/个人
  final XTarget? belong;

  // 暂存的商品
  final XMerchandise? merchandise;

  //构造方法
  XStaging({
    required this.id,
    required this.merchandiseId,
    required this.belongId,
    required this.marketId,
    required this.number,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.market,
    required this.belong,
    required this.merchandise,
  });

  //通过JSON构造
  XStaging.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        merchandiseId = json["merchandiseId"],
        belongId = json["belongId"],
        marketId = json["marketId"],
        number = json["number"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        market = XMarket.fromJson(json["market"]),
        belong = XTarget.fromJson(json["belong"]),
        merchandise = XMerchandise.fromJson(json["merchandise"]);

  //通过动态数组解析成List
  static List<XStaging> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XStaging> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XStaging.fromJson(item));
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
    json["marketId"] = marketId;
    json["number"] = number;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["market"] = market?.toJson();
    json["belong"] = belong?.toJson();
    json["merchandise"] = merchandise?.toJson();
    return json;
  }
}

//商品暂存查询返回集合
class XStagingArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XStaging>? result;

  //构造方法
  XStagingArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XStagingArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XStaging.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XStagingArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XStagingArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XStagingArray.fromJson(item));
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

//组织/个人
class XTarget {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  String code;

  // 类型
  final String typeName;

  // 头像
  String avatar;

  // 归属
  String belongId;

  // 元数据
  final String thingId;

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

  // 采购订单
  final List<XOrder>? orders;

  // 身份证明
  final List<XIdProof>? idProofs;

  // 设立的市场
  final List<XMarket>? markets;

  // 标准要求
  final List<XRuleStd>? ruleStds;

  // 商品采购暂存
  final List<XStaging>? stags;

  // 拥有的产品
  final List<XProduct>? products;

  // 创建的身份
  final List<XIdentity>? identitys;

  // 监管的市场
  final List<XMarket>? samrMarkets;

  // 属于该组织/个人的物
  final List<XThing>? things;

  // 加入团队的关系
  final List<XRelation>? relations;

  // 作为团队的影子
  final XTeam? team;

  // 该组织/个人创建的字典类型
  final List<XDict>? dicts;

  // 卖出的订单详情
  final List<XOrderDetail>? sellOrder;

  // 该组织/个人创建的字典项
  final List<XDictItem>? dictItems;

  // 该组织/个人创建的类别标准
  final List<XSpecies>? species;

  // 该组织/个人创建的度量标准
  final List<XAttribute>? attributes;

  // 该组织/个人创建的职权标准
  final List<XAuthority>? authority;

  // 加入市场的关系
  final List<XMarketRelation>? marketRelations;

  // 加入的团队
  final List<XTeam>? relTeams;

  // 该组织/个人创建的业务单
  final List<XOperation>? operations;

  // 该组织或个人所属的业务单详情项
  final List<XOperationItem>? operationItems;

  // 赋予该组织/个人创建的身份
  final List<XIdentity>? givenIdentitys;

  // 该组织或个人所属的组织/个人
  final XTarget? belong;

  // 该组织或个人所属的组织/个人
  final List<XTarget>? targets;

  // 组织/个人物的本质
  final XThing? thing;

  // 归属组织/个人的应用资源分配记录
  final List<XExtend>? distributes;

  // 归属组织/个人的流程定义
  final List<XFlowDefine>? flowDefines;

  // 个人审批记录
  final List<XFlowRecord>? flowRecords;

  bool isSelected = false;

  //构造方法
  XTarget({
    required this.id,
    required this.name,
    required this.code,
    required this.typeName,
    required this.avatar,
    required this.belongId,
    required this.thingId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.orders,
    required this.idProofs,
    required this.markets,
    required this.ruleStds,
    required this.stags,
    required this.products,
    required this.identitys,
    required this.samrMarkets,
    required this.things,
    required this.relations,
    required this.team,
    required this.dicts,
    required this.sellOrder,
    required this.dictItems,
    required this.species,
    required this.attributes,
    required this.authority,
    required this.marketRelations,
    required this.relTeams,
    required this.operations,
    required this.operationItems,
    required this.givenIdentitys,
    required this.belong,
    required this.targets,
    required this.thing,
    required this.distributes,
    required this.flowDefines,
    required this.flowRecords,
  });

  //通过JSON构造
  XTarget.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        typeName = json["typeName"],
        avatar = json["avatar"] ?? "",
        belongId = json["belongId"] ?? "",
        thingId = json["thingId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        orders = XOrder.fromList(json["orders"]),
        idProofs = XIdProof.fromList(json["idProofs"]),
        markets = XMarket.fromList(json["markets"]),
        ruleStds = XRuleStd.fromList(json["ruleStds"]),
        stags = XStaging.fromList(json["stags"]),
        products = XProduct.fromList(json["products"]),
        identitys = XIdentity.fromList(json["identitys"]),
        samrMarkets = XMarket.fromList(json["samrMarkets"]),
        things = XThing.fromList(json["things"]),
        relations = XRelation.fromList(json["relations"]),
        team = json["team"]!=null?XTeam.fromJson(json["team"]):null,
        dicts = XDict.fromList(json["dicts"]),
        sellOrder = XOrderDetail.fromList(json["sellOrder"]),
        dictItems = XDictItem.fromList(json["dictItems"]),
        species = XSpecies.fromList(json["species"]),
        attributes = XAttribute.fromList(json["attributes"]),
        authority = XAuthority.fromList(json["authority"]),
        marketRelations = XMarketRelation.fromList(json["marketRelations"]),
        relTeams = XTeam.fromList(json["relTeams"]),
        operations = XOperation.fromList(json["operations"]),
        operationItems = XOperationItem.fromList(json["operationItems"]),
        givenIdentitys = XIdentity.fromList(json["givenIdentitys"]),
        belong =
            json["belong"] == null ? null : XTarget.fromJson(json["belong"]),
        targets = XTarget.fromList(json["targets"]),
        thing = json["thing"] == null ? null : XThing.fromJson(json["thing"]),
        distributes = XExtend.fromList(json["distributes"]),
        flowDefines = XFlowDefine.fromList(json["flowDefines"]),
        flowRecords = XFlowRecord.fromList(json["flowRecords"]);


  //通过动态数组解析成List
  static List<XTarget> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<XTarget> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTarget.fromJson(item));
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
    json["avatar"] = avatar;
    json["belongId"] = belongId;
    json["thingId"] = thingId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["orders"] = orders;
    json["idProofs"] = idProofs;
    json["markets"] = markets;
    json["ruleStds"] = ruleStds;
    json["stags"] = stags;
    json["products"] = products;
    json["identitys"] = identitys;
    json["samrMarkets"] = samrMarkets;
    json["things"] = things;
    json["relations"] = relations;
    json["team"] = team?.toJson();
    json["dicts"] = dicts;
    json["sellOrder"] = sellOrder;
    json["dictItems"] = dictItems;
    json["species"] = species;
    json["attributes"] = attributes;
    json["authority"] = authority;
    json["marketRelations"] = marketRelations;
    json["relTeams"] = relTeams;
    json["operations"] = operations;
    json["operationItems"] = operationItems;
    json["givenIdentitys"] = givenIdentitys;
    json["belong"] = belong?.toJson();
    json["targets"] = targets;
    json["thing"] = thing?.toJson();
    json["distributes"] = distributes;
    json["flowDefines"] = flowDefines;
    json["flowRecords"] = flowRecords;
    return json;
  }
}

//组织/个人查询返回集合
class XTargetArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int? total;

  // 结果
  final List<XTarget>? result;

  //构造方法
  XTargetArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XTargetArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"] ?? 0,
        limit = json["limit"],
        total = json["total"]??0,
        result = XTarget.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XTargetArray> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<XTargetArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTargetArray.fromJson(item));
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

//虚拟组织
class XTeam {
  // 雪花ID
  final String id;

  // 名称
  String name;

  // 编号
  String code;

  // 实体
  final String targetId;

  // 备注
  String? remark;

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

  // 加入团队的组织/个人
  final List<XTarget>? relTargets;

  // 组织身份集关系
  final List<XTeamIdentity>? teamIdentitys;

  // 加入团队的组织/个人的关系
  final List<XRelation>? relations;

  // 团队的实体
  final XTarget? target;

  // 组织的身份集
  final List<XIdentity>? identitys;

  //构造方法
  XTeam({
    required this.id,
    required this.name,
    required this.code,
    required this.targetId,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.relTargets,
    required this.teamIdentitys,
    required this.relations,
    required this.target,
    required this.identitys,
  });

  //通过JSON构造
  XTeam.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        targetId = json["targetId"],
        remark = json["remark"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        relTargets = XTarget.fromList(json["relTargets"]),
        teamIdentitys = XTeamIdentity.fromList(json["teamIdentitys"]),
        relations = XRelation.fromList(json["relations"]),
        target =
            json["target"] == null ? null : XTarget.fromJson(json["target"]),
        identitys = XIdentity.fromList(json["identitys"]);

  //通过动态数组解析成List
  static List<XTeam> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XTeam> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTeam.fromJson(item));
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
    json["remark"] = remark;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["relTargets"] = relTargets;
    json["teamIdentitys"] = teamIdentitys;
    json["relations"] = relations;
    json["target"] = target?.toJson();
    json["identitys"] = identitys;
    return json;
  }
}

//虚拟组织查询返回集合
class XTeamArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XTeam>? result;

  //构造方法
  XTeamArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XTeamArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XTeam.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XTeamArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XTeamArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTeamArray.fromJson(item));
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

//身份组织
class XTeamIdentity {
  // 雪花ID
  final String id;

  // 身份ID
  final String identityId;

  // 组织ID
  final String teamId;

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

  // 身份加入的组织
  final XTeam? team;

  // 组织包含的身份
  final XIdentity? identity;

  //构造方法
  XTeamIdentity({
    required this.id,
    required this.identityId,
    required this.teamId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.team,
    required this.identity,
  });

  //通过JSON构造
  XTeamIdentity.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        identityId = json["identityId"],
        teamId = json["teamId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        team = XTeam.fromJson(json["team"]),
        identity = XIdentity.fromJson(json["identity"]);

  //通过动态数组解析成List
  static List<XTeamIdentity> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XTeamIdentity> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTeamIdentity.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["identityId"] = identityId;
    json["teamId"] = teamId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["team"] = team?.toJson();
    json["identity"] = identity?.toJson();
    return json;
  }
}

//身份组织查询返回集合
class XTeamIdentityArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XTeamIdentity>? result;

  //构造方法
  XTeamIdentityArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XTeamIdentityArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XTeamIdentity.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XTeamIdentityArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XTeamIdentityArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XTeamIdentityArray.fromJson(item));
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

//(物/存在)
class XThing {
  // 雪花ID
  final String id;

  // 链上ID
  final String chainId;

  // 名称
  final String name;

  // 编号
  final String code;

  // 归属
  final String belongId;

  // 备注
  final String remark;

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

  // 零件
  final List<XThing>? nodes;

  // 整件
  final List<XThing>? parent;

  // 物的类别关系
  final List<XThingSpec>? thingSpecies;

  // 合成物关系
  final List<XThingRelation>? relations;

  // 零件关系
  final List<XThingRelation>? subRelations;

  // 物的特性度量值
  final List<XThingAttr>? thingAttrValues;

  // 物作为产品的映射
  final List<XProduct>? products;

  // 物作为管理对象的映射
  final XTarget? target;

  // 给物的分类类别
  final List<XSpecies>? givenSpecies;

  // 给物的度量标准
  final List<XAttribute>? givenAttributes;

  // 物的归属
  final XTarget? belong;

  //构造方法
  XThing({
    required this.id,
    required this.chainId,
    required this.name,
    required this.code,
    required this.belongId,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.nodes,
    required this.parent,
    required this.thingSpecies,
    required this.relations,
    required this.subRelations,
    required this.thingAttrValues,
    required this.products,
    required this.target,
    required this.givenSpecies,
    required this.givenAttributes,
    required this.belong,
  });

  //通过JSON构造
  XThing.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        chainId = json["chainId"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        remark = json["remark"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        nodes = XThing.fromList(json["nodes"]),
        parent = XThing.fromList(json["parent"]),
        thingSpecies = XThingSpec.fromList(json["thingSpecies"]),
        relations = XThingRelation.fromList(json["relations"]),
        subRelations = XThingRelation.fromList(json["subRelations"]),
        thingAttrValues = XThingAttr.fromList(json["thingAttrValues"]),
        products = XProduct.fromList(json["products"]),
        target = XTarget.fromJson(json["target"]),
        givenSpecies = XSpecies.fromList(json["givenSpecies"]),
        givenAttributes = XAttribute.fromList(json["givenAttributes"]),
        belong = XTarget.fromJson(json["belong"]);

  //通过动态数组解析成List
  static List<XThing> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThing> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThing.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["chainId"] = chainId;
    json["name"] = name;
    json["code"] = code;
    json["belongId"] = belongId;
    json["remark"] = remark;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["nodes"] = nodes;
    json["parent"] = parent;
    json["thingSpecies"] = thingSpecies;
    json["relations"] = relations;
    json["subRelations"] = subRelations;
    json["thingAttrValues"] = thingAttrValues;
    json["products"] = products;
    json["target"] = target?.toJson();
    json["givenSpecies"] = givenSpecies;
    json["givenAttributes"] = givenAttributes;
    json["belong"] = belong?.toJson();
    return json;
  }
}

//(物/存在)查询返回集合
class XThingArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XThing>? result;

  //构造方法
  XThingArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XThingArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XThing.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XThingArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingArray.fromJson(item));
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

//物的度量特性
class XThingAttr {
  // 雪花ID
  final String id;

  // 属性ID
  final String attrId;

  // 元数据ID
  final String thingId;

  // 关系ID
  final String relationId;

  // 数值
  final double numValue;

  // 描述
  final String strValue;

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

  // 历史度量
  final List<XThingAttrHistroy>? histroy;

  // 度量的标准
  final XAttribute? attribute;

  // 度量的物
  final XThing? thing;

  // 关系的引用
  final XRelation? relation;

  // 关系的引用
  final XMarketRelation? marketrelation;

  //构造方法
  XThingAttr({
    required this.id,
    required this.attrId,
    required this.thingId,
    required this.relationId,
    required this.numValue,
    required this.strValue,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.histroy,
    required this.attribute,
    required this.thing,
    required this.relation,
    required this.marketrelation,
  });

  //通过JSON构造
  XThingAttr.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        attrId = json["attrId"],
        thingId = json["thingId"],
        relationId = json["relationId"],
        numValue = json["numValue"],
        strValue = json["strValue"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        histroy = XThingAttrHistroy.fromList(json["histroy"]),
        attribute = XAttribute.fromJson(json["attribute"]),
        thing = XThing.fromJson(json["thing"]),
        relation = XRelation.fromJson(json["relation"]),
        marketrelation = XMarketRelation.fromJson(json["marketrelation"]);

  //通过动态数组解析成List
  static List<XThingAttr> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingAttr> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingAttr.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["attrId"] = attrId;
    json["thingId"] = thingId;
    json["relationId"] = relationId;
    json["numValue"] = numValue;
    json["strValue"] = strValue;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["histroy"] = histroy;
    json["attribute"] = attribute?.toJson();
    json["thing"] = thing?.toJson();
    json["relation"] = relation?.toJson();
    json["marketrelation"] = marketrelation?.toJson();
    return json;
  }
}

//物的度量特性查询返回集合
class XThingAttrArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XThingAttr>? result;

  //构造方法
  XThingAttrArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XThingAttrArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XThingAttr.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XThingAttrArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingAttrArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingAttrArray.fromJson(item));
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

//物的度量特性历史
class XThingAttrHistroy {
  // 雪花ID
  final String id;

  // 最新度量ID
  final String thingAttrId;

  // 数值
  final double numValue;

  // 描述
  final String strValue;

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

  // 最新度量
  final XThingAttr? thingAttr;

  //构造方法
  XThingAttrHistroy({
    required this.id,
    required this.thingAttrId,
    required this.numValue,
    required this.strValue,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.thingAttr,
  });

  //通过JSON构造
  XThingAttrHistroy.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        thingAttrId = json["thingAttrId"],
        numValue = json["numValue"],
        strValue = json["strValue"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        thingAttr = XThingAttr.fromJson(json["thingAttr"]);

  //通过动态数组解析成List
  static List<XThingAttrHistroy> fromList(List<Map<String, dynamic>> list) {
    if (list == null) {
      return [];
    }
    List<XThingAttrHistroy> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingAttrHistroy.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["thingAttrId"] = thingAttrId;
    json["numValue"] = numValue;
    json["strValue"] = strValue;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["thingAttr"] = thingAttr?.toJson();
    return json;
  }
}

//物的度量特性历史查询返回集合
class XThingAttrHistroyArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XThingAttrHistroy>? result;

  //构造方法
  XThingAttrHistroyArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XThingAttrHistroyArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XThingAttrHistroy.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XThingAttrHistroyArray> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingAttrHistroyArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingAttrHistroyArray.fromJson(item));
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

//物与物关系
class XThingRelation {
  // 雪花ID
  final String id;

  // 物ID
  final String thingId;

  // 零件ID
  final String subThingId;

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

  // 合成物
  final XThing? thing;

  // 零部件
  final XThing? subThing;

  //构造方法
  XThingRelation({
    required this.id,
    required this.thingId,
    required this.subThingId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.thing,
    required this.subThing,
  });

  //通过JSON构造
  XThingRelation.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        thingId = json["thingId"],
        subThingId = json["subThingId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        thing = XThing.fromJson(json["thing"]),
        subThing = XThing.fromJson(json["subThing"]);

  //通过动态数组解析成List
  static List<XThingRelation> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingRelation> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingRelation.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["thingId"] = thingId;
    json["subThingId"] = subThingId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["thing"] = thing?.toJson();
    json["subThing"] = subThing?.toJson();
    return json;
  }
}

//物与物关系查询返回集合
class XThingRelationArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XThingRelation>? result;

  //构造方法
  XThingRelationArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XThingRelationArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XThingRelation.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XThingRelationArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingRelationArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingRelationArray.fromJson(item));
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

//物的类别关系
class XThingSpec {
  // 雪花ID
  final String id;

  // 类别ID
  final String speciesId;

  // 元数据ID
  final String thingId;

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

  // 类别
  final XSpecies? species;

  // 物
  final XThing? thing;

  //构造方法
  XThingSpec({
    required this.id,
    required this.speciesId,
    required this.thingId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    required this.species,
    required this.thing,
  });

  //通过JSON构造
  XThingSpec.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        speciesId = json["speciesId"],
        thingId = json["thingId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        species = XSpecies.fromJson(json["species"]),
        thing = XThing.fromJson(json["thing"]);

  //通过动态数组解析成List
  static List<XThingSpec> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingSpec> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingSpec.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["speciesId"] = speciesId;
    json["thingId"] = thingId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["species"] = species?.toJson();
    json["thing"] = thing?.toJson();
    return json;
  }
}

//物的类别关系查询返回集合
class XThingSpecArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XThingSpec>? result;

  //构造方法
  XThingSpecArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XThingSpecArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XThingSpec.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XThingSpecArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XThingSpecArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XThingSpecArray.fromJson(item));
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
