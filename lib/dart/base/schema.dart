//度量特性定义
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/model/asset_creation_config.dart';

import 'model.dart';

class XAttribute {
  /// 雪花ID
  String? id;

  /// 名称
  String? name;

  /// 编号
  String? code;

  /// 规则
  Rule? rule;

  /// 备注
  String? remark;

  /// 共享用户ID
  String? shareId;

  /// 归属用户ID
  String? belongId;

  /// 工作职权Id
  String? authId;

  /// 属性Id
  String? propId;

  /// 表单Id
  String? formId;

  /// 状态
  int? status;

  /// 创建人员ID
  String? createUser;

  /// 更新人员ID
  String? updateUser;

  /// 修改次数
  String? version;

  /// 创建时间
  String? createTime;

  /// 更新时间
  String? updateTime;

  /// 附加过属性的物
  List<XProperty>? linkPropertys;

  /// 属性关系
  List<XAttrLinkProp>? links;

  /// 关联属性
  XProperty? property;

  /// 工作职权
  XAuthority? authority;

  /// 特性对应的表单
  XForm? form;

  /// 创建度量标准的用户
  XTarget? belong;

  Fields? fields;

  XAttribute({
    this.id,
    this.name,
    this.code,
    this.rule,
    this.remark,
    this.shareId,
    this.belongId,
    this.authId,
    this.propId,
    this.formId,
    this.status,
    this.createUser,
    this.updateUser,
    this.version,
    this.createTime,
    this.updateTime,
    this.linkPropertys,
    this.links,
    this.property,
    this.authority,
    this.form,
    this.belong,
    this.fields,
  });

  XAttribute.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'] ?? "";
    code = json['code'] ?? "";
    rule =
        json['rule'] != null ? Rule.fromJson(jsonDecode(json["rule"])) : null;
    remark = json['remark'] ?? "";
    shareId = json['shareId'] ?? "";
    belongId = json['belongId'] ?? "";
    authId = json['authId'] ?? "";
    propId = json['propId'] ?? "";
    formId = json['formId'] ?? "";
    status = json['status'] ?? "";
    createUser = json['createUser'] ?? "";
    updateUser = json['updateUser'] ?? "";
    version = json['version'] ?? "";
    createTime = json['createTime'] ?? "";
    updateTime = json['updateTime'] ?? "";
    linkPropertys = (json['linkPropertys'] as List<dynamic>?)
        ?.map((item) => XProperty.fromJson(item as Map<String, dynamic>))
        .toList();
    links = (json['links'] as List<dynamic>?)
        ?.map((item) => XAttrLinkProp.fromJson(item as Map<String, dynamic>))
        .toList();
    property = json['property'] != null
        ? XProperty.fromJson(json['property'] as Map<String, dynamic>)
        : null;
    authority = json['authority'] != null
        ? XAuthority.fromJson(json['authority'] as Map<String, dynamic>)
        : null;
    form = json['form'] != null
        ? XForm.fromJson(json['form'] as Map<String, dynamic>)
        : null;
    belong = json['belong'] != null
        ? XTarget.fromJson(json['belong'] as Map<String, dynamic>)
        : null;
    fields = toFields();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['rule'] = rule;
    data['remark'] = remark;
    data['shareId'] = shareId;
    data['belongId'] = belongId;
    data['authId'] = authId;
    data['propId'] = propId;
    data['formId'] = formId;
    data['status'] = status;
    data['createUser'] = createUser;
    data['updateUser'] = updateUser;
    data['version'] = version;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    if (linkPropertys != null) {
      data['linkPropertys'] = linkPropertys!.map((x) => x.toJson()).toList();
    }
    if (links != null) {
      data['links'] = links!.map((x) => x.toJson()).toList();
    }
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (authority != null) {
      data['authority'] = authority!.toJson();
    }
    if (form != null) {
      data['form'] = form!.toJson();
    }
    if (belong != null) {
      data['belong'] = belong!.toJson();
    }
    return data;
  }

  Fields toFields() {
    String? type;
    String? router;
    switch (rule?.widget) {
      case "text":
      case "number":
      case 'digit':
      case "money":
      case "string":
        type = "input";
        break;
      case "dict":
      case "select":
      case "treeSelect":
        type = "select";
        break;
      case "date":
      case "datetime":
      case "dateTimeRange":
        type = "selectDate";
        break;
      case "person":
        type = "selectPerson";
        break;
      case "dept":
      case "department":
        type = "selectDepartment";
        break;
      case "identity":
      case "auth":
      case "group":
      case 'radio':
      case 'checkbox':
      case 'file':
      case 'upload':
        break;
      default:
        type = 'input';
        break;
    }

    Map<dynamic, String> select = {};
    rule?.dictItems?.forEach((element) {
      select[element.value] = element.name;
    });
    return Fields(
      title: name,
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
}

class XAttrLinkProp {
  /// 雪花ID
  String id;

  /// 特性ID
  String attrId;

  /// 属性ID
  String propId;

  /// 归属用户ID
  String belongId;

  /// 状态
  int status;

  /// 创建人员ID
  String createUser;

  /// 更新人员ID
  String updateUser;

  /// 修改次数
  String version;

  /// 创建时间
  String createTime;

  /// 更新时间
  String updateTime;

  /// 关联的属性
  XProperty? property;

  /// 关联的特性
  XAttribute? attribute;

  XAttrLinkProp({
    required this.id,
    required this.attrId,
    required this.propId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.property,
    this.attribute,
  });

  factory XAttrLinkProp.fromJson(Map<String, dynamic> json) {
    return XAttrLinkProp(
      id: json['id'],
      attrId: json['attrId'],
      propId: json['propId'],
      belongId: json['belongId'],
      status: json['status'],
      createUser: json['createUser'],
      updateUser: json['updateUser'],
      version: json['version'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      property: json['property'] != null ? XProperty.fromJson(json['property']) : null,
      attribute: json['attribute'] != null ? XAttribute.fromJson(json['attribute']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['attrId'] = attrId;
    data['propId'] = propId;
    data['belongId'] = belongId;
    data['status'] = status;
    data['createUser'] = createUser;
    data['updateUser'] = updateUser;
    data['version'] = version;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    if (property != null) {
      data['property'] = property!.toJson();
    }
    if (attribute != null) {
      data['attribute'] = attribute!.toJson();
    }
    return data;
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
  XAttributeArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((e) {
        result!.add(XAttribute.fromJson(e));
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

//权限定义查询返回集合
class XPropertyArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XProperty>? result;

  //构造方法
  XPropertyArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XPropertyArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XProperty.fromJson(json));
      });
    }
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
SettingController setting = Get.find();

//属性定义
class XProperty {
  // 雪花ID
  String? id;
  // 名称
  String? name;
  // 编号
  String? code;
  // 值类型
  String? valueType;
  // 计量单位
  String? unit;
  // 备注
  String? remark;
  // 类别ID
  String? speciesId;
  // 字典的类型ID
  String? dictId;
  // 来源用户ID
  String? sourceId;
  // 归属用户ID
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
  // 给物的度量标准
  List<XAttribute>? linkAttributes;
  // 特性关系
  List<XAttrLinkProp>? links;
  // 创建的特性集
  List<XAttribute>? attributes;
  // 附加过属性的物
  List<XThing>? things;
  // 属性的物的度量
  List<XThingProp>? propThingValues;
  // 属性对应的类别
  XSpecies? species;
  // 字典类型
  XDict? dict;
  // 归属的用户
  XTarget? belong;

  XProperty(
      { this.id,
         this.name,
         this.code,
         this.valueType,
         this.unit,
         this.remark,
         this.speciesId,
         this.dictId,
         this.sourceId,
         this.belongId,
         this.status,
         this.createUser,
         this.updateUser,
         this.version,
         this.createTime,
         this.updateTime,
        this.linkAttributes,
        this.links,
        this.attributes,
        this.things,
        this.propThingValues,
        this.species,
        this.dict,
        this.belong});
  factory XProperty.fromJson(Map<String, dynamic> json) {
    return XProperty(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      valueType: json['valueType'],
      unit: json['unit'],
      remark: json['remark'],
      speciesId: json['speciesId'],
      dictId: json['dictId'],
      sourceId: json['sourceId'],
      belongId: json['belongId'],
      status: json['status'],
      createUser: json['createUser'],
      updateUser: json['updateUser'],
      version: json['version'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      linkAttributes: (json['linkAttributes'] as List<dynamic>?)
          ?.map((e) => XAttribute.fromJson(e))
          .toList(),
      links: (json['links'] as List<dynamic>?)
          ?.map((e) => XAttrLinkProp.fromJson(e))
          .toList(),
      attributes: (json['attributes'] as List<dynamic>?)
          ?.map((e) => XAttribute.fromJson(e))
          .toList(),
      things: (json['things'] as List<dynamic>?)
          ?.map((e) => XThing.fromJson(e))
          .toList(),
      propThingValues: (json['propThingValues'] as List<dynamic>?)
          ?.map((e) => XThingProp.fromJson(e))
          .toList(),
      species: json['species'] != null
          ? XSpecies.fromJson(json['species'])
          : null,
      dict: json['dict'] != null ? XDict.fromJson(json['dict']) : null,
      belong: json['belong'] != null ? XTarget.fromJson(json['belong']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'code': code,
      'valueType': valueType,
      'unit': unit,
      'remark': remark,
      'speciesId': speciesId,
      'dictId': dictId,
      'sourceId': sourceId,
      'belongId': belongId,
      'status': status,
      'createUser': createUser,
      'updateUser': updateUser,
      'version': version,
      'createTime': createTime,
      'updateTime': updateTime,
      'linkAttributes': linkAttributes?.map((attr) => attr.toJson()).toList(),
      'links': links?.map((link) => link.toJson()).toList(),
      'attributes': attributes?.map((attr) => attr.toJson()).toList(),
      'things': things?.map((thing) => thing.toJson()).toList(),
      'propThingValues': propThingValues?.map((prop) => prop.toJson()).toList(),
      'species': species?.toJson(),
      'dict': dict?.toJson(),
      'belong': belong?.toJson(),
    };
    return data;
  }
}


class XThingProp {
  // 雪花ID
  String id;
  // 属性ID
  String propId;
  // 元数据ID
  String thingId;
  // 值
  String value;
  // 状态
  int status;
  // 创建人员ID
  String createUser;
  // 更新人员ID
  String updateUser;
  // 修改次数
  String version;
  // 创建时间
  String createTime;
  // 更新时间
  String updateTime;
  // 历史度量
  List<XThingPropHistroy>? histroy;
  // 度量的标准
  XProperty? property;
  // 度量的物
  XThing? thing;

  XThingProp({
    required this.id,
    required this.propId,
    required this.thingId,
    required this.value,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.histroy,
    this.property,
    this.thing,
  });

  factory XThingProp.fromJson(Map<String, dynamic> json) {
    return XThingProp(
      id: json['id'],
      propId: json['propId'],
      thingId: json['thingId'],
      value: json['value'],
      status: json['status'],
      createUser: json['createUser'],
      updateUser: json['updateUser'],
      version: json['version'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      histroy: json['histroy'] != null
          ? List<XThingPropHistroy>.from(json['histroy'].map((x) => XThingPropHistroy.fromJson(x)))
          : null,
      property: json['property'] != null ? XProperty.fromJson(json['property']) : null,
      thing: json['thing'] != null ? XThing.fromJson(json['thing']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['propId'] = this.propId;
    data['thingId'] = this.thingId;
    data['value'] = this.value;
    data['status'] = this.status;
    data['createUser'] = this.createUser;
    data['updateUser'] = this.updateUser;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    if (this.histroy != null) {
      data['histroy'] = this.histroy!.map((x) => x.toJson()).toList();
    }
    if (this.property != null) {
      data['property'] = this.property!.toJson();
    }
    if (this.thing != null) {
      data['thing'] = this.thing!.toJson();
    }
    return data;
  }
}

class XThingPropHistroy {
  String id;
  String thingPropId;
  String value;
  int status;
  String createUser;
  String updateUser;
  String version;
  String createTime;
  String updateTime;
  XThingProp? thingProp;

  XThingPropHistroy({
    required this.id,
    required this.thingPropId,
    required this.value,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.thingProp,
  });

  factory XThingPropHistroy.fromJson(Map<String, dynamic> json) {
    return XThingPropHistroy(
      id: json['id'],
      thingPropId: json['thingPropId'],
      value: json['value'],
      status: json['status'],
      createUser: json['createUser'],
      updateUser: json['updateUser'],
      version: json['version'],
      createTime: json['createTime'],
      updateTime: json['updateTime'],
      thingProp: json['thingProp'] != null ? XThingProp.fromJson(json['thingProp']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['thingPropId'] = this.thingPropId;
    data['value'] = this.value;
    data['status'] = this.status;
    data['createUser'] = this.createUser;
    data['updateUser'] = this.updateUser;
    data['version'] = this.version;
    data['createTime'] = this.createTime;
    data['updateTime'] = this.updateTime;
    if (this.thingProp != null) {
      data['thingProp'] = this.thingProp!.toJson();
    }
    return data;
  }
}



//权限定义
class XAuthority {
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

  String? parentId;

  // 创建组织/个人
  String? belongId;

  String? icon;

  String? shareId;
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

  // 上下级职权
  XAuthority? parent;

  // 上下级职权
  List<XAuthority>? nodes;

  // 创建职权标准的组织/个人
  XTarget? belong;

  // 职权对应的身份
  List<XIdentity>? identitys;

  // 职权可操作的类别
  List<XSpecies>? authSpecies;

  // 职权可操作的度量
  List<XAttribute>? autAttrs;

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
  XAuthority.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    remark = json["remark"];
    public = json["public"];
    parentId = json["parentId"];
    belongId = json["belongId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    icon = json['icon'];
    shareId = json['shareId'];
    parent =
        json["parent"] != null ? XAuthority.fromJson(json["parent"]) : null;
    belong = json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;

    if (json["nodes"] != null) {
      nodes = [];
      json["nodes"].forEach((json) {
        nodes!.add(XAuthority.fromJson(json));
      });
    }

    if (json["identitys"] != null) {
      identitys = [];
      json["identitys"].forEach((json) {
        identitys!.add(XIdentity.fromJson(json));
      });
    }

    if (json["authSpecies"] != null) {
      authSpecies = [];
      json["authSpecies"].forEach((json) {
        authSpecies!.add(XSpecies.fromJson(json));
      });
    }
    if (json["autAttrs"] != null) {
      autAttrs = [];
      json["autAttrs"].forEach((json) {
        autAttrs!.add(XAttribute.fromJson(json));
      });
    }
  }

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
    json['shareId'] = shareId;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json['icon'] = icon;
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

//权限定义查询返回集合
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

  String? icon;

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
  XDict.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    remark = json["remark"];
    public = json["public"];
    speciesId = json["speciesId"];
    belongId = json["belongId"];
    status = json["status"];
    createUser = json["createUser"];
    icon = json['icon'];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    dictItems = json["dictItems"] != null
        ? List<XDictItem>.from(json['dictItems'].map((x) => XDictItem.fromJson(x)))
        : null;
    dictAttrs = json["dictAttrs"] != null
        ? List<XAttribute>.from(json['dictAttrs'].map((x) => XAttribute.fromJson(x)))
        : null;
    belong = json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;
    species =
        json["species"] != null ? XSpecies.fromJson(json["species"]) : null;
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
    json['icon'] = icon;
    json["belong"] = belong?.toJson();
    json["species"] = species?.toJson();
    return json;
  }
}

//字典类型查询返回集合
class XDictArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XDict>? result;

  //构造方法
  XDictArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XDictArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XDict.fromJson(json));
      });
    }
  }

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
  String name;

  // 值
  String value;

  // 公开的
  bool? public;

  // 创建组织/个人
  String belongId;

  // 字典类型ID
  String dictId;

  // 状态
  int status;

  // 创建人员ID
  String createUser;

  // 更新人员ID
  String updateUser;

  // 修改次数
  String version;

  // 创建时间
  String createTime;

  // 更新时间
  String updateTime;

  // 字典类型
  XDict? dict;

  // 创建类别标准的组织/个人
  XTarget? belong;

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
        dict = json["dict"] != null ? XDict.fromJson(json["dict"]) : null,
        belong =
            json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;

  //通过动态数组解析成List
  static List<XDictItem> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<XDictItem> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        if (item is Map<String, dynamic>) {
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
class XWorkDefine {
  // 雪花ID
  final String? id;

  // 名称
  final String? name;

  // 是否创建实体
  final bool? isCreate;


  final String? icon;

  // 编码
  final String? code;

  // 归属组织/个人Id
  final String? belongId;

  // 分类id
  final String? speciesId;

  // 权限Id
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
  final List<XWorkNode>? nodes;

  // 流程的实例
  final List<XWorkInstance>? instances;

  // 归属组织/个人
  final XTarget? target;

  //数据源id
  final String? sourceIds;

  //构造方法
  XWorkDefine({
    this.sourceIds,
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
    required this.nodes,
    required this.instances,
    required this.target,
    this.icon,
    required this.isCreate,
  });

  //通过JSON构造
  XWorkDefine.fromJson(Map<String, dynamic> json)
      : sourceIds = json["sourceIds"],
        id = json["id"],
        name = json["name"],
        code = json["code"],
        belongId = json["belongId"],
        speciesId = json["speciesId"],
        authId = json["authId"],
        public = json["public"],
        content = json["content"],
        remark = json["remark"],
        status = json["status"],
        icon = json['icon'],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        isCreate = json['isCreate'],
        nodes =
            json["nodes"] != null ? XWorkNode.fromList(json["nodes"]) : null,
        instances = json["instances"] != null
            ? XWorkInstance.fromList(json["instances"])
            : null,
        target =
            json["target"] != null ? XTarget.fromJson(json["target"]) : null;

  //通过动态数组解析成List
  static List<XWorkDefine> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkDefine> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkDefine.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["sourceIds"] = sourceIds;
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
    json["nodes"] = nodes;
    json["instances"] = instances;
    json["target"] = target?.toJson();
    return json;
  }
}

//流程定义查询返回集合
class XWorkDefineArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XWorkDefine>? result;

  //构造方法
  XWorkDefineArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkDefineArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];

    List<Map<String, dynamic>>? list;

    if (json["result"] != null) {
      list = [];
      json["result"].forEach((e) {
        list!.add(e);
      });
    }
    result = XWorkDefine.fromList(list);
  }

  //通过动态数组解析成List
  static List<XWorkDefineArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkDefineArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkDefineArray.fromJson(item));
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
class XWorkInstance {
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

  // 表单数据
  String? data;

  // 回调钩子
  String? hook;

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
  XWorkDefine? define;

  // 审批任务
  List<XWorkTaskHistory>? historyTasks;

  // 归属
  String? belongId;

  // 填写的表单Id集合
  String? operationIds;

  // 物的Id集合
  String? thingIds;

  //构造方法
  XWorkInstance({
    this.id,
    this.defineId,
    this.productId,
    this.belongId,
    this.title,
    this.contentType,
    this.content,
    this.data,
    this.hook,
    this.status,
    this.createUser,
    this.updateUser,
    this.version,
    this.createTime,
    this.updateTime,
    this.define,
    this.historyTasks,
    this.operationIds,
    this.thingIds,
  });

  //通过JSON构造
  XWorkInstance.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    operationIds = json["operationIds"];
    thingIds = json["thingIds"];
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
    if (json["tasks"] != null) {
      historyTasks = [];
      json["tasks"].forEach((json) {
        historyTasks!.add(XWorkTaskHistory.fromJson(json));
      });
    }
    define =
        json["define"] != null ? XWorkDefine.fromJson(json["define"]) : null;
  }

  //通过动态数组解析成List
  static List<XWorkInstance> fromList(List<Map<String, dynamic>> list) {
    List<XWorkInstance> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkInstance.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["operationIds"] = operationIds;
    json["thingIds"] = thingIds;
    json["historyTasks"] = historyTasks;
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
    json["historyTasks"] = historyTasks;
    json["define"] = define?.toJson();
    return json;
  }
}

class Node {
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

  // 节点审批操作人类型 暂只支持 '角色'
  String? destType;

  // 节点审批操作Id 如 '角色Id'
  String? destId;

  // 节点审批操作名称 如 '角色名称'
  String? destName;

  // 子节点
  Node? children;

  // 节点归属
  String? belongId;

  //构造方法
  Node({
    required this.id,
    required this.code,
    required this.type,
    required this.name,
    required this.num,
    required this.destType,
    required this.destId,
    required this.destName,
    required this.children,
    required this.belongId,
  }); //通过JSON构造
  Node.fromJson(Map<String, dynamic> json) {
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
        json["children"] != null ? Node.fromJson(json["children"]) : null;
  }

  //通过动态数组解析成List
  static List<Node> fromList(List<Map<String, dynamic>> list) {
    List<Node> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(Node.fromJson(item));
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
    return json;
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

//流程实例查询返回集合
class XWorkInstanceArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XWorkInstance>? result;

  //构造方法
  XWorkInstanceArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkInstanceArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    List<Map<String, dynamic>> list = [];

    if (json["result"] != null) {
      json["result"].forEach((e) {
        list.add(e);
      });
    }
    result = XWorkInstance.fromList(list);
  }

  //通过动态数组解析成List
  static List<XWorkInstanceArray> fromList(List<Map<String, dynamic>> list) {
    List<XWorkInstanceArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkInstanceArray.fromJson(item));
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
class XWorkNode {
  // 雪花ID
  String? id;

  // 节点编号
  String? code;

  // 节点类型
  String? nodeType;

  // 节点名称
  String? name;

  // 审批数量
  int? count;

  // 节点审批操作人类型 暂只支持 '角色'
  String? destType;

  // 节点审批操作Id 如 '角色Id'
  dynamic destId;

  // 节点审批操作名称 如 '角色名称'
  String? destName;

  // 节点归属
  String? belongId;

  //构造方法
  XWorkNode({
    required this.id,
    required this.code,
    required this.nodeType,
    required this.name,
    required this.count,
    required this.destType,
    required this.destId,
    required this.destName,
    required this.belongId,
  });

  //通过JSON构造
  XWorkNode.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    nodeType = json["nodeType"];
    name = json["name"];
    count = json["count"];
    destType = json["destType"];
    destId = json["destId"];
    destName = json["destName"];
    belongId = json["belongId"];
  }

  //通过动态数组解析成List
  static List<XWorkNode> fromList(List<Map<String, dynamic>> list) {
    List<XWorkNode> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkNode.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["id"] = id;
    json["code"] = code;
    json["nodeType"] = nodeType;
    json["name"] = name;
    json["count"] = count;
    json["destType"] = destType;
    json["destId"] = destId;
    json["destName"] = destName;
    json["belongId"] = belongId;
    return json;
  }
}

//流程定义节点查询返回集合
class XWorkNodeArray {
  // 便宜量
  final int offset;

  // 最大数量
  final int limit;

  // 总数
  final int total;

  // 结果
  final List<XWorkNode>? result;

  //构造方法
  XWorkNodeArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkNodeArray.fromJson(Map<String, dynamic> json)
      : offset = json["offset"],
        limit = json["limit"],
        total = json["total"],
        result = XWorkNode.fromList(json["result"]);

  //通过动态数组解析成List
  static List<XWorkNodeArray> fromList(List<Map<String, dynamic>> list) {
    List<XWorkNodeArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkNodeArray.fromJson(item));
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
class XWorkRecord {
  // 雪花ID
  String? id;

  // 审批人员
  String? targetId;

  // 节点任务
  String? taskId;

  // 评论
  String? comment;

  // 内容
  String? data;

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

  // 历史
  XWorkTask? task;

  //构造方法
  XWorkRecord(
      {required this.id,
      required this.targetId,
      required this.taskId,
      required this.comment,
      required this.data,
      required this.status,
      required this.createUser,
      required this.updateUser,
      required this.version,
      required this.createTime,
      required this.updateTime,
      required this.task});

  //通过JSON构造
  XWorkRecord.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    targetId = json["targetId"];
    taskId = json["taskId"];
    comment = json["comment"];
    data = json["data"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    task = json["task"] != null ? XWorkTask.fromJson(json["task"]) : null;
  }

  //通过动态数组解析成List
  static List<XWorkRecord> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkRecord> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkRecord.fromJson(item));
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
    json["data"] = data;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["historyTask"] = task?.toJson();
    return json;
  }
}

//流程节点数据查询返回集合
class XWorkRecordArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XWorkRecord>? result;

  //构造方法
  XWorkRecordArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkRecordArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XWorkRecord.fromJson(json));
      });
    }
  }

  //通过动态数组解析成List
  static List<XWorkRecordArray> fromList(List<Map<String, dynamic>> list) {
    List<XWorkRecordArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkRecordArray.fromJson(item));
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


class XThingArchives {
  String? id;
  String? creater;
  String? createTime;
  String? modifiedTime;
  String? status;
  bool isSelected = false;
  List<Archive>? archives;

  XThingArchives(
      {this.id, this.creater, this.createTime, this.modifiedTime, this.status});

  XThingArchives.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    creater = json['Creater'];
    createTime = json['CreateTime'];
    modifiedTime = json['ModifiedTime'];
    status = json['Status'];
    archives = [];
    json.keys.forEach((element) {
      if (element.length >= 15 && element.contains("T")) {
        archives!.add(Archive.fromJson(json[element], element));
      }
    });
  }
}

class Archive {
  // 流程的定义
  XWorkInstance? instance;

  // 流程节点
  XWorkNode? node;

  XWorkRecord? record;

  int? personId;

  String? data;

  String? id;

  Archive(
      {this.id,
      this.instance,
      this.node,
      this.record,
      this.data,
      this.personId});

  Archive.fromJson(Map<String, dynamic> json, this.id) {
    instance = json['instance'] != null
        ? XWorkInstance.fromJson(json['instance'])
        : null;
    node = json['node'] != null ? XWorkNode.fromJson(json['node']) : null;
    record =
        json['record'] != null ? XWorkRecord.fromJson(json['record']) : null;
    personId = json['personId'];
    // data = json['data'];
  }
}


//流程任务查询返回集合
class XWorkTaskArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XWorkTask>? result;

  //构造方法
  XWorkTaskArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkTaskArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((e) {
        result!.add(XWorkTask.fromJson(e));
      });
    }

  }

  //通过动态数组解析成List
  static List<XWorkTaskArray> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkTaskArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkTaskArray.fromJson(item));
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
class XWorkTaskHistory {
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

  // 流程节点记录
  List<XWorkRecord>? records;

  // 任务审批的身份
  XIdentity? identity;

  // 流程的定义
  XWorkInstance? instance;

  // 流程节点
  XWorkNode? node;

  //构造方法
  XWorkTaskHistory({
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
    required this.records,
    required this.identity,
    required this.instance,
    required this.node,
  });

  //通过JSON构造
  XWorkTaskHistory.fromJson(Map<String, dynamic> json) {
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
    identity =
        json["identity"] != null ? XIdentity.fromJson(json["identity"]) : null;
    node = json["node"] != null ? XWorkNode.fromJson(json["node"]) : null;
    instance = json["instance"] != null
        ? XWorkInstance.fromJson(json["instance"])
        : null;
    if (json["records"] != null) {
      records = [];
      json["records"].forEach((json) {
        records!.add(XWorkRecord.fromJson(json));
      });
    }
  }

  //通过动态数组解析成List
  static List<XWorkTaskHistory> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkTaskHistory> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkTaskHistory.fromJson(item));
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
    json["Records"] = records?.map((e) => e.toJson()).toList();
    json["identity"] = identity?.toJson();
    json["Node"] = node?.toJson();
    json["Instance"] = instance?.toJson();
    return json;
  }
}

//流程任务查询返回集合
class XWorkTaskHistoryArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XWorkTaskHistory>? result;

  //构造方法
  XWorkTaskHistoryArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XWorkTaskHistoryArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    List<XWorkTaskHistory> retList = [];
    List<Map<String, dynamic>> list = [];

    if (json["result"] != null) {
      json["result"].forEach((e) {
        list.add(e);
      });
    }
    result = XWorkTaskHistory.fromList(list);
  }

  //通过动态数组解析成List
  static List<XWorkTaskHistoryArray> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<XWorkTaskHistoryArray> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(XWorkTaskHistoryArray.fromJson(item));
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

//角色
class XIdentity {
  // 雪花ID
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 备注
  String? remark;

  String? authId;

  // 创建组织/个人
  String? belongId;

  // 共享用户ID
  String? shareId;

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

  // 身份证明
  List<XIdProof>? idProofs;

  // 身份集关系
  List<XTeamIdentity>? identityTeams;

  List<XTarget>? givenTargets;

  // 身份所属的未完成流程的任务
  List<XWorkTask>? Tasks;

  // 身份所属的未完成流程的任务
  List<XWorkTaskHistory>? TaskHistory;

  // 身份集对于组织
  List<XTeam>? teams;

  XAuthority? authority;

  // 创建身份的组织/个人
  XTarget? belong;

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
    required this.Tasks,
    required this.TaskHistory,
    required this.teams,
    required this.authority,
    required this.belong,
  });

  //通过JSON构造
  XIdentity.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    remark = json["remark"];
    authId = json["authId"];
    belongId = json["belongId"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    shareId = json['shareId'];
    if (json["idProofs"] != null) {
      idProofs = [];
      json["idProofs"].forEach((json) {
        idProofs!.add(XIdProof.fromJson(json));
      });
    }

    if (json["identityTeams"] != null) {
      identityTeams = [];
      json["identityTeams"].forEach((json) {
        identityTeams!.add(XTeamIdentity.fromJson(json));
      });
    }

    if (json["givenTargets"] != null) {
      givenTargets = [];
      json["givenTargets"].forEach((json) {
        givenTargets!.add(XTarget.fromJson(json));
      });
    }

    if (json["Tasks"] != null) {
      Tasks = [];
      json["Tasks"].forEach((json) {
        Tasks!.add(XWorkTask.fromJson(json));
      });
    }

    if (json["TaskHistory"] != null) {
      TaskHistory = [];
      json["TaskHistory"].forEach((json) {
        TaskHistory!.add(XWorkTaskHistory.fromJson(json));
      });
    }

    if (json["teams"] != null) {
      teams = [];
      json["teams"].forEach((json) {
        teams!.add(XTeam.fromJson(json));
      });
    }
    authority = json["authority"] != null
        ? XAuthority.fromJson(json["authority"])
        : null;
    belong = json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;
  }

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
    json["Tasks"] = Tasks;
    json["TaskHistory"] = TaskHistory;
    json["teams"] = teams;
    json["authority"] = authority?.toJson();
    json["belong"] = belong?.toJson();
    json['shareId'] = shareId;
    return json;
  }
}

//角色查询返回集合
class XIdentityArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XIdentity>? result;

  //构造方法
  XIdentityArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XIdentityArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XIdentity.fromJson(json));
      });
    }
  }

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

//及时通讯查询返回集合
class XImMsgArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<MsgSaveModel>? result;

  //构造方法
  XImMsgArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XImMsgArray.fromJson(Map<String, dynamic> json){
    offset = json["offset"] ?? 0;
    limit = json["limit"];
    total = json["total"] ?? 0;
    if(json["result"]!=null){
      result = [];
      json["result"].forEach((json){
        result!.add(MsgSaveModel.fromJson(json));
      });
    }
  }

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
  String? id;

  // 名称
  String? name;

  // 编号
  String? code;

  // 来源
  String? source;

  // 权属
  String? authority;

  // 对哪一类制定的标准
  String? typeName;

  // 归属组织/个人
  String? belongId;

  // 元数据Id
  String? thingId;

  // 订单ID
  String? orderId;

  // 过期时间
  String? endTime;

  // 图片
  String? photo;

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

  // 产品的资源
  List<XResource>? resource;

  // 上架的商品
  List<XMerchandise>? merchandises;

  // 产品的本质
  XThing? thing;

  // 订单ID
  XOrderDetail? orderSource;

  // 产品归属的组织/个人
  XTarget? belong;

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
    required this.thing,
    required this.orderSource,
    required this.belong,
  });

  //通过JSON构造
  XProduct.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    code = json["code"];
    source = json["source"];
    authority = json["authority"];
    typeName = json["typeName"];
    belongId = json["belongId"];
    thingId = json["thingId"];
    orderId = json["orderId"];
    endTime = json["endTime"];
    photo = json["photo"];
    remark = json["remark"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    if (json["resource"] != null) {
      resource = [];
      json["resource"].forEach((json) {
        resource!.add(XResource.fromJson(json));
      });
    }
    if (json["merchandises"] != null) {
      merchandises = [];
      json["merchandises"].forEach((json) {
        merchandises!.add(XMerchandise.fromJson(json));
      });
    }
    thing = json["thing"] != null ? XThing.fromJson(json["thing"]) : null;
    orderSource = json["orderSource"] != null
        ? XOrderDetail.fromJson(json["belong"])
        : null;
    belong = json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;
  }

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
    json["thing"] = thing?.toJson();
    json["orderSource"] = orderSource?.toJson();
    json["belong"] = belong?.toJson();
    return json;
  }
}

//产品信息查询返回集合
class XProductArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XProduct>? result;

  //构造方法
  XProductArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XProductArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XProduct.fromJson(json));
      });
    }
  }

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
      : offset = json["offset"] ?? 0,
        limit = json["limit"] ?? 2 ^ 64 - 1,
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
  String? id;

  // 编号
  String? code;

  // 名称
  String? name;

  // 产品ID
  String? productId;

  // 访问私钥
  String? privateKey;

  // 入口
  String? link;

  // 流程项
  String? s;

  // 组件
  String? components;

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

  //
  XProduct? product;

  //构造方法
  XResource({
    required this.id,
    required this.code,
    required this.name,
    required this.productId,
    required this.privateKey,
    required this.link,
    required this.s,
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
  XResource.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    code = json["code"];
    name = json["name"];
    productId = json["productId"];
    privateKey = json["privateKey"];
    link = json["link"];
    s = json["s"];
    components = json["components"];
    status = json["status"];
    createUser = json["createUser"];
    updateUser = json["updateUser"];
    version = json["version"];
    createTime = json["createTime"];
    updateTime = json["updateTime"];
    product =
        json["product"] != null ? XProduct.fromJson(json["product"]) : null;
  }

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
    json["s"] = s;
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

class XWorkTask {
  String id;
  String nodeId;
  String title;
  String approveType;
  String taskType;
  int count;
  String defineId;
  String shareId;
  String belongId;
  String instanceId;
  String identityId;
  String content;
  String remark;
  int status;
  String createUser;
  String updateUser;
  String version;
  String createTime;
  String updateTime;
  List<XWorkRecord>? records;
  XWorkNode? node;
  XWorkInstance? instance;

  XWorkTask({
    required this.id,
    required this.nodeId,
    required this.title,
    required this.approveType,
    required this.taskType,
    required this.count,
    required this.defineId,
    required this.shareId,
    required this.belongId,
    required this.instanceId,
    required this.identityId,
    required this.content,
    required this.remark,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.records,
    this.node,
    this.instance,
  });

  factory XWorkTask.fromJson(Map<String, dynamic> json) {
    List<XWorkRecord>? records;
    if (json['records'] != null) {
      var recordList = json['records'] as List;
      records = recordList.map((record) => XWorkRecord.fromJson(record)).toList();
    }

    return XWorkTask(
      id: json['id']??"",
      nodeId: json['nodeId'] ??"",
      title: json['title'] ??"",
      approveType: json['approveType'] ??"",
      taskType: json['taskType'] ??"",
      count: json['count']??0,
      defineId: json['defineId']??"",
      shareId: json['shareId'] ??"",
      belongId: json['belongId'] ??"",
      instanceId: json['instanceId'] ??"",
      identityId: json['identityId']??"",
      content: json['content']??"",
      remark: json['remark'] ??"",
      status: json['status']??-1,
      createUser: json['createUser']??"",
      updateUser: json['updateUser']??"",
      version: json['version']??"",
      createTime: json['createTime']??"",
      updateTime: json['updateTime']??"",
      records: records,
      node: json['node'] != null ? XWorkNode.fromJson(json['node']) : null,
      instance: json['instance'] != null ? XWorkInstance.fromJson(json['instance']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['nodeId'] = nodeId;
    data['title'] = title;
    data['approveType'] = approveType;
    data['taskType'] = taskType;
    data['count'] = count;
    data['defineId'] = defineId;
    data['shareId'] = shareId;
    data['belongId'] = belongId;
    data['instanceId'] = instanceId;
    data['identityId'] = identityId;
    data['content'] = content;
    data['remark'] = remark;
    data['status'] = status;
    data['createUser'] = createUser;
    data['updateUser'] = updateUser;
    data['version'] = version;
    data['createTime'] = createTime;
    data['updateTime'] = updateTime;
    data['records'] = records?.map((record) =>record.toJson()).toList();
    data['node'] = node?.toJson();
    data['instance'] = instance?.toJson();
    return data;
  }
}

class XForm {
  String id;
  String name;
  String code;
  String rule;
  String remark;
  String speciesId;
  String shareId;
  String belongId;
  int status;
  String createUser;
  String updateUser;
  String version;
  String createTime;
  String updateTime;
  List<XAttribute>? attributes;
  List<XWorkNode>? bindNodes;
  XSpecies? species;
  XTarget? belong;

  XForm({
    required this.id,
    required this.name,
    required this.code,
    required this.rule,
    required this.remark,
    required this.speciesId,
    required this.shareId,
    required this.belongId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.attributes,
    this.bindNodes,
    this.species,
    this.belong,
  });

  factory XForm.fromJson(Map<String, dynamic> json) {
    List<XAttribute>? attributes;
    if (json['attributes'] != null) {
      var attributeList = json['attributes'] as List;
      attributes = attributeList.map((attribute) => XAttribute.fromJson(attribute)).toList();
    }

    List<XWorkNode>? bindNodes;
    if (json['bindNodes'] != null) {
      var nodeList = json['bindNodes'] as List;
      bindNodes = nodeList.map((node) => XWorkNode.fromJson(node)).toList();
    }

    return XForm(
      id: json['id'] ??"",
      name: json['name']??"",
      code: json['code'] ??"",
      rule: json['rule'] ??"",
      remark: json['remark'] ??"",
      speciesId: json['speciesId']??"",
      shareId: json['shareId'] ??"",
      belongId: json['belongId'] ??"",
      status: json['status'] as int,
      createUser: json['createUser'] ??"",
      updateUser: json['updateUser'] ??"",
      version: json['version']??"",
      createTime: json['createTime']??"",
      updateTime: json['updateTime']??"",
      attributes: attributes,
      bindNodes: bindNodes,
      species: json['species'] != null ? XSpecies.fromJson(json['species']) : null,
      belong: json['belong'] != null ? XTarget.fromJson(json['belong']) : null,
    );
  }
  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>>? attributeList;
    if (attributes != null) {
      attributeList = attributes!.map((attribute) => attribute.toJson()).toList();
    }

    List<Map<String, dynamic>>? bindNodeList;
    if (bindNodes != null) {
      bindNodeList = bindNodes!.map((bindNode) => bindNode.toJson()).toList();
    }

    return {
      'id': id,
      'name': name,
      'code': code,
      'rule': rule,
      'remark': remark,
      'speciesId': speciesId,
      'shareId': shareId,
      'belongId': belongId,
      'status': status,
      'createUser': createUser,
      'updateUser': updateUser,
      'version': version,
      'createTime': createTime,
      'updateTime': updateTime,
      'attributes': attributeList,
      'bindNodes': bindNodeList,
      'species': species != null ? species!.toJson() : null,
      'belong': belong != null ? belong!.toJson() : null,
    };
  }
}


class XFormItem {
  String? id;
  String? name;
  String? code;
  Rule? rule;
  String? remark;
  String? attrId;
  String? formId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;
  XForm? form;
  XAttribute? attr;
  String? value;
  Fields? fields;
  XFormItem({
    required this.id,
    required this.name,
    required this.code,
    required this.rule,
    required this.remark,
    required this.attrId,
    required this.formId,
    required this.status,
    required this.createUser,
    required this.updateUser,
    required this.version,
    required this.createTime,
    required this.updateTime,
    this.form,
    this.attr,
  });

  XFormItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    remark = json['remark'];
    attrId = json['attrId'];
    formId = json['formId'];
    rule =
        json["rule"] != null ? Rule.fromJson(jsonDecode(json["rule"])) : null;
    status = json['status'];
    createUser = json['createUser'];
    updateUser = json['updateUser'];
    version = json['version'];
    createTime = json['createTime'];
    updateTime = json['updateTime'];
    form = json['form'] != null ? XForm.fromJson(json['form']) : null;
    attr = json['attr'] != null ? XAttribute.fromJson(json['attr']) : null;
  }



  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'rule': rule,
      'remark': remark,
      'attrId': attrId,
      'formId': formId,
      'status': status,
      'createUser': createUser,
      'updateUser': updateUser,
      'version': version,
      'createTime': createTime,
      'updateTime': updateTime,
      'form': form?.toJson(),
      'attr': attr?.toJson(),
    };
  }
}

class XSpeciesArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XSpecies>? result;

  //构造方法
  XSpeciesArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XSpeciesArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XSpecies.fromJson(json));
      });
    }
  }

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
//类别定义
class XSpecies {
  // 雪花ID
  String id;

  // 名称
  String name;

  // 编号
  String code;
  // 值类型
  String valueType;
  // 备注
  String remark;

  // 公开的
  bool public;

  String typeName;

  // 父类别ID
  String parentId;

  String icon;

  String shareId;

  // 创建组织/个人
  String belongId;

  // 工作权限Id
  String authId;

  // 状态
  int status;

  // 创建人员ID
  String createUser;

  // 更新人员ID
  String updateUser;

  // 修改次数
  String version;

  // 创建时间
  String? createTime;

  // 更新时间
  String? updateTime;

  // 该类别与物的关系
  List<XThingSpec>? specThings;

  // 该类别的物
  List<XThing>? things;

  // 类别的字典
  List<XDict>? dicts;

  // 类别的度量标准
  List<XAttribute>? attributes;

  // 分类的结构
  XSpecies? parent;

  // 分类的结构
  List<XSpecies>? nodes;

  // 工作权限
  XAuthority? authority;

  // 创建类别标准的组织/个人
  XTarget? belong;

  String unit;

  XDict? dict;
  //构造方法
  XSpecies({
    this.id = '',
    this.name = '',
    this.code = '',
    this.remark = '',
    this.public = false,
    this.parentId = '',
    this.belongId = '',
    this.authId = '',
    this.status = 0,
    this.createUser = '',
    this.updateUser = '',
    this.version = '',
    this.createTime,
    this.updateTime,
    this.specThings,
    this.things,
    this.dicts,
    this.attributes,
    this.parent,
    this.nodes,
    this.authority,
    this.belong,
    this.typeName = '',
    this.icon = '',
    this.shareId = '',
    this.valueType = '',
    this.unit = '',
    this.dict,
  });

  //通过JSON构造
  XSpecies.fromJson(Map<String, dynamic> json)
      : id = json["id"] ?? "",
        name = json["name"] ?? "",
        code = json["code"] ?? "",
        remark = json["remark"] ?? "",
        public = json["public"] ?? false,
        parentId = json["parentId"] ?? "",
        belongId = json["belongId"] ?? "",
        authId = json["authId"] ?? "",
        status = json["status"] ?? 0,
        valueType = json['valueType'] ?? '',
        unit = json['unit']??'',
        createUser = json["createUser"] ?? "",
        updateUser = json["updateUser"] ?? "",
        version = json["version"] ?? "",
        typeName = json['typeName']??"",
        icon = json['icon']??"",
        shareId = json['shareId']??"",
        createTime = json["createTime"] ?? "",
        updateTime = json["updateTime"] ?? "",
        specThings = XThingSpec.fromList(json["specThings"]),
        things = XThing.fromList(json["things"]),
        dicts = XDict.fromList(json["dicts"]),
        dict = json["dict"]!=null?XDict.fromJson(json["dict"]):null,
        attributes = json['attributes'] != null
            ? List<XAttribute>.from(json['attributes'].map((x) => XAttribute.fromJson(x)))
            : null,
        parent =
            json["parent"] != null ? XSpecies.fromJson(json["parent"]) : null,
        nodes = XSpecies.fromList(json["nodes"]),
        authority = json["authority"] != null
            ? XAuthority.fromJson(json["authority"])
            : null,
        belong =
            json["belong"] != null ? XTarget.fromJson(json["belong"]) : null;

  //通过动态数组解析成List
  static List<XSpecies> fromList(List? list) {
    if (list == null) {
      return [];
    }
    List<XSpecies> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        if (item is Map<String, dynamic>) {
          retList.add(XSpecies.fromJson(item));
        } else {
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
    json['icon'] = icon;
    json['unit'] = unit;
    json['valueType'] = valueType;
    json['shareId'] = shareId;
    json['typeName'] = typeName;
    json["attributes"] = attributes;
    json["parent"] = parent?.toJson();
    json["nodes"] = nodes;
    json["authority"] = authority?.toJson();
    json["belong"] = belong?.toJson();
    json['dict'] = dict?.toJson();
    return json;
  }
}

//类别定义查询返回集合
class XFormArray {
  // 便宜量
  int? offset;

  // 最大数量
  int? limit;

  // 总数
  int? total;

  // 结果
  List<XForm>? result;

  //构造方法
  XFormArray({
    required this.offset,
    required this.limit,
    required this.total,
    required this.result,
  });

  //通过JSON构造
  XFormArray.fromJson(Map<String, dynamic> json) {
    offset = json["offset"];
    limit = json["limit"];
    total = json["total"];
    if (json["result"] != null) {
      result = [];
      json["result"].forEach((json) {
        result!.add(XForm.fromJson(json));
      });
    }
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
  String icon;

  // 归属
  String belongId;

  String? remark;

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

  // 赋予该组织/个人创建的角色
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
  final List<XWorkDefine>? Defines;

  // 个人审批记录
  final List<XWorkRecord>? Records;

  bool isSelected = false;

  //构造方法
  XTarget({
    required this.id,
    required this.name,
    required this.code,
    required this.typeName,
    required this.icon,
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
    required this.givenIdentitys,
    required this.belong,
    required this.targets,
    required this.thing,
    required this.distributes,
    required this.Defines,
    required this.Records,
    this.remark,
  });

  //通过JSON构造
  XTarget.fromJson(Map<String, dynamic> json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        remark = json['remark'],
        typeName = json["typeName"],
        icon = json["icon"] ?? "",
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
        team = json["team"] != null ? XTeam.fromJson(json["team"]) : null,
        dicts = XDict.fromList(json["dicts"]),
        sellOrder = XOrderDetail.fromList(json["sellOrder"]),
        dictItems = XDictItem.fromList(json["dictItems"]),
        species = XSpecies.fromList(json["species"]),
        attributes = json['attributes'] != null
            ? List<XAttribute>.from(json['attributes'].map((x) => XAttribute.fromJson(x)))
            : null,
        authority = XAuthority.fromList(json["authority"]),
        marketRelations = XMarketRelation.fromList(json["marketRelations"]),
        relTeams = XTeam.fromList(json["relTeams"]),
        givenIdentitys = XIdentity.fromList(json["givenIdentitys"]),
        belong =
            json["belong"] == null ? null : XTarget.fromJson(json["belong"]),
        targets = XTarget.fromList(json["targets"]),
        thing = json["thing"] == null ? null : XThing.fromJson(json["thing"]),
        distributes = XExtend.fromList(json["distributes"]),
        Defines = XWorkDefine.fromList(json["defines"]),
        Records = XWorkRecord.fromList(json["records"]);

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

  Uint8List avatarThumbnail() {
    if (icon == '') {
      return Uint8List.fromList([]);
    }
    try {
      var map = jsonDecode(icon);
      FileItemShare share = FileItemShare.fromJson(map);

      var thumbnail = share.thumbnail
              ?.split(",")[1]
              .replaceAll('\r', '')
              .replaceAll('\n', '') ??
          "";
      return base64Decode(thumbnail);
    } catch (e) {
      return Uint8List.fromList([]);
    }
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
    json["givenIdentitys"] = givenIdentitys;
    json["belong"] = belong?.toJson();
    json["targets"] = targets;
    json["thing"] = thing?.toJson();
    json["distributes"] = distributes;
    json["Defines"] = Defines;
    json["Records"] = Records;
    json['remark'] = remark;
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
        total = json["total"] ?? 0,
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
        givenAttributes = json['givenAttributes'] != null
            ? List<XAttribute>.from(json['givenAttributes'].map((x) => XAttribute.fromJson(x)))
            : null,
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

class VersionEntity {
  String? key;
  String? name;
  String? updateTime;
  List<VersionVersionMes>? versionMes;

  VersionEntity({
    required this.key,
    required this.name,
    required this.updateTime,
    required this.versionMes,
  });

  VersionEntity.fromJson(Map<String, dynamic> json)
      : key = json["Key"],
        name = json["Name"],
        updateTime = json["UpdateTime"],
        versionMes = VersionVersionMes.fromList(json["versionMes"]);

  static List<VersionEntity> fromList(List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionEntity> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionEntity.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["key"] = key;
    json["name"] = name;
    json["updateTime"] = updateTime;
    json["versionMes"] = versionMes;
    return json;
  }

  @override
  String toString() {
    return jsonEncode(this);
  }
}

class VersionVersionMes {
  VersionVersionMesUploadName? uploadName;
  String? appName;
  String? publisher;
  int? version;
  String? remark;
  String? id;
  VersionVersionMesPubTeam? pubTeam;
  VersionVersionMesPubAuthor? pubAuthor;
  String? platform;
  String? pubTime;
  int? size;
  String? name;
  String? extension;
  String? shareLink;
  String? thumbnail;

  VersionVersionMes();

  VersionVersionMes.fromJson(Map<String, dynamic> json)
      : uploadName = VersionVersionMesUploadName.fromJson(json["uploadName"]),
        appName = json["appName"],
        publisher = json["publisher"],
        version = json["version"],
        remark = json["remark"],
        id = json["id"],
        pubTeam = VersionVersionMesPubTeam.fromJson(json["pubTeam"]),
        pubAuthor = VersionVersionMesPubAuthor.fromJson(json["pubAuthor"]),
        platform = json["platform"],
        pubTime = json["pubTime"],
        size = json["size"],
        name = json["name"],
        extension = json["extension"],
        shareLink = json["shareLink"],
        thumbnail = json["thumbnail"];

  static List<VersionVersionMes> fromList(List<dynamic>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMes> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMes.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["uploadName"] = uploadName?.toJson();
    json["appName"] = appName;
    json["publisher"] = publisher;
    json["version"] = version;
    json["remark"] = remark;
    json["id"] = id;
    json["pubTeam"] = pubTeam?.toJson();
    json["pubAuthor"] = pubAuthor?.toJson();
    json["platform"] = platform;
    json["pubTime"] = pubTime;
    json["size"] = size;
    json["name"] = name;
    json["extension"] = extension;
    json["shareLink"] = shareLink;
    json["thumbnail"] = thumbnail;
    return json;
  }
}

class VersionVersionMesUploadName {
  int? size;
  String? name;
  String? extension;
  String? shareLink;
  String? thumbnail;

  VersionVersionMesUploadName();

//通过JSON构造
  VersionVersionMesUploadName.fromJson(Map<String, dynamic>? json)
      : size = json?["size"] ?? 0,
        name = json?["name"] ?? "",
        extension = json?["extension"] ?? "",
        shareLink = json?["shareLink"] ?? "",
        thumbnail = json?["thumbnail"] ?? "";

  //通过动态数组解析成List
  static List<VersionVersionMesUploadName> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMesUploadName> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMesUploadName.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["size"] = size;
    json["name"] = name;
    json["extension"] = extension;
    json["shareLink"] = shareLink;
    json["thumbnail"] = thumbnail;
    return json;
  }
}

class VersionVersionMesPubTeam {
  String? value;
  String? label;
  String? id;
  String? name;
  String? code;
  String? typeName;
  String? belongId;
  String? thingId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;
  VersionVersionMesPubTeamTeam? team;

  VersionVersionMesPubTeam();

//通过JSON构造
  VersionVersionMesPubTeam.fromJson(dynamic json)
      : value = json["value"],
        label = json["label"],
        id = json["id"],
        name = json["name"],
        code = json["code"],
        typeName = json["typeName"],
        belongId = json["belongId"],
        thingId = json["thingId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"],
        team = VersionVersionMesPubTeamTeam.fromJson(json["team"]);

  //通过动态数组解析成List
  static List<VersionVersionMesPubTeam> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMesPubTeam> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMesPubTeam.fromJson(item));
      }
    }
    return retList;
  }

  //转成JSON
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["value"] = value;
    json["label"] = label;
    json["id"] = id;
    json["name"] = name;
    json["code"] = code;
    json["typeName"] = typeName;
    json["belongId"] = belongId;
    json["thingId"] = thingId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["team"] = team?.toJson();
    return json;
  }
}

class VersionVersionMesPubTeamTeam {
  String? id;
  String? name;
  String? code;
  String? targetId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;
  String? remark;

  VersionVersionMesPubTeamTeam();

//通过JSON构造
  VersionVersionMesPubTeamTeam.fromJson(Map<String, dynamic>? json)
      : id = json?["id"] ?? "",
        name = json?["name"] ?? "",
        code = json?["code"] ?? "",
        targetId = json?["targetId"] ?? "",
        status = json?["status"] ?? 0,
        createUser = json?["createUser"] ?? "",
        updateUser = json?["updateUser"] ?? "",
        version = json?["version"] ?? "",
        createTime = json?["createTime"] ?? "",
        updateTime = json?["updateTime"] ?? "",
        remark = json?["remark"] ?? "";

  //通过动态数组解析成List
  static List<VersionVersionMesPubTeamTeam> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMesPubTeamTeam> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMesPubTeamTeam.fromJson(item));
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
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    json["remark"] = remark;
    return json;
  }
}

class VersionVersionMesPubAuthor {
  String? id;
  String? name;
  String? code;
  String? typeName;
  String? thingId;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;
  VersionVersionMesPubAuthorTeam? team;

  VersionVersionMesPubAuthor();

//通过JSON构造
  VersionVersionMesPubAuthor.fromJson(dynamic json)
      : id = json["id"],
        name = json["name"],
        code = json["code"],
        typeName = json["typeName"],
        thingId = json["thingId"],
        status = json["status"],
        createUser = json["createUser"],
        updateUser = json["updateUser"],
        version = json["version"],
        createTime = json["createTime"],
        updateTime = json["updateTime"];

  //通过动态数组解析成List
  static List<VersionVersionMesPubAuthor> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMesPubAuthor> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMesPubAuthor.fromJson(item));
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
    json["thingId"] = thingId;
    json["status"] = status;
    json["createUser"] = createUser;
    json["updateUser"] = updateUser;
    json["version"] = version;
    json["createTime"] = createTime;
    json["updateTime"] = updateTime;
    return json;
  }
}

class VersionVersionMesPubAuthorTeam {
  String? id;
  String? name;
  String? code;
  String? targetId;
  String? remark;
  int? status;
  String? createUser;
  String? updateUser;
  String? version;
  String? createTime;
  String? updateTime;

  VersionVersionMesPubAuthorTeam();

//通过JSON构造
  VersionVersionMesPubAuthorTeam.fromJson(Map<String, dynamic> json)
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
        updateTime = json["updateTime"];

  //通过动态数组解析成List
  static List<VersionVersionMesPubAuthorTeam> fromList(
      List<Map<String, dynamic>>? list) {
    if (list == null) {
      return [];
    }
    List<VersionVersionMesPubAuthorTeam> retList = [];
    if (list.isNotEmpty) {
      for (var item in list) {
        retList.add(VersionVersionMesPubAuthorTeam.fromJson(item));
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
    return json;
  }
}
