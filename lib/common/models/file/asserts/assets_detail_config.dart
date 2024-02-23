class AssetsDetailConfig {
  String? id;
  String? belongCode;
  String? belongName;
  List<OverallDetails>? list;
  String? gmtCreate;
  String? gmtModified;
  String? updateTime;

  AssetsDetailConfig(
      {this.id,
      this.belongCode,
      this.belongName,
      this.list,
      this.gmtCreate,
      this.gmtModified,
      this.updateTime});

  AssetsDetailConfig.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    belongCode = json['belongCode'];
    belongName = json['belongName'];
    if (json['list'] != null) {
      list = <OverallDetails>[];
      json['list'].forEach((v) {
        list!.add(OverallDetails.fromJson(v));
      });
    }
    gmtCreate = json['gmtCreate'];
    gmtModified = json['gmtModified'];
    updateTime = json['UPDATE_TIME'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['belongCode'] = belongCode;
    data['belongName'] = belongName;
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['gmtCreate'] = gmtCreate;
    data['gmtModified'] = gmtModified;
    data['UPDATE_TIME'] = updateTime;
    return data;
  }
}

class OverallDetails {
  String? title;
  String? id;
  List<FieldList>? fieldList;

  OverallDetails({this.title, this.id, this.fieldList});

  OverallDetails.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    if (json['fieldList'] != null) {
      fieldList = <FieldList>[];
      json['fieldList'].forEach((v) {
        fieldList!.add(FieldList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    if (fieldList != null) {
      data['fieldList'] = fieldList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FieldList {
  String? id;
  String? code;
  String? name;
  String? formType;
  bool? required;
  bool? disabled;
  dynamic fmtKey;

  FieldList(
      {this.id,
      this.code,
      this.name,
      this.formType,
      this.required,
      this.disabled,
      this.fmtKey});

  FieldList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    formType = json['formType'];
    required = json['required'];
    disabled = json['disabled'];
    fmtKey = json['fmtKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['formType'] = formType;
    data['required'] = required;
    data['disabled'] = disabled;
    data['fmtKey'] = fmtKey;
    return data;
  }
}

Map<String, dynamic> defaultConfig = {
  "belongName": "默认配置",
  "list": [
    {
      "title": "基本信息",
      "fieldList": [
        {"code": "GS1", "name": "GS1编码"},
        {
          "code": "ASSET_NAME",
          "name": "资产名称",
        },
        {"code": "ASSET_TYPE", "name": "资产分类"},
        {"code": "ASSET_CODE", "name": "资产编码"},
        {"code": "LOCATION", "name": "存放地点"},
        {
          "code": "START_DATE",
          "name": "开始使用日期",
        },
        {
          "code": "USE_DEPT_NAME",
          "name": "使用部门",
        },
        {
          "code": "USER_NAME",
          "name": "使用人",
        },
        {
          "code": "FIXED_ASS_ACQ_CODE",
          "name": "取得方式",
        },
        {
          "code": "ESTIMATED_USEFUL_LIFE",
          "name": "预计使用年限",
        },
      ],
    },
    {
      "title": "附加信息",
      "fieldList": [
        {"code": "ACQU_DATE", "name": "取得日期"},
        {"code": "NUM_OR_AREA", "name": "数量"},
        {"code": "NUM_UNIT", "name": "计量单位"},
      ],
    },
    {
      "title": "折旧",
      "fieldList": [
        {"code": "HAVE_USED_IT", "name": "已使用期数"},
        {"code": "NET_VAL", "name": "净值"},
        {"code": "RESIDUAL_RATE", "name": "残值率"},
        {"code": "MONTH_ACC_DEP", "name": "月折旧/摊销额"},
        {"code": "ACC_DEP_MONTH", "name": "已提折旧/摊销月数"},
        {"code": "DEPRECIATION_METHOD", "name": "折旧（摊销）方法"},
        {"code": "ACC_DEP", "name": "累计折旧（摊销）"},
        {"code": "CANZHI", "name": "残值"},
        {"code": "INIT_ASSET_VAL", "name": "资产原值"},
        {"code": "VALUE_TYPE_CODE", "name": "价值类型"},
      ],
    },
  ]
};
