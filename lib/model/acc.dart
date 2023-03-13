Map<String, dynamic> claimConfig = {
  "businessName": "资产申领",
  "businessCode": "claim",
  "text": [
    {
      "title": "基本信息",
      "sort": 0,
      "fields": [
        {
          "title": "单据编号",
          "code": "BILL_CODE",
          "type": "text",
          "required": true,
          "readOnly": true,
          "regx": null,
          "hidden": false,
        },
        {
          "title": "申领事由",
          "code": "APPLY_REMARK",
          "type": "input",
          "marginTop":10.0,
          "required": true,
          "readOnly": false,
          "regx": null,
          "hidden": false,
          "hint":"请填写申领事由",
          "maxLine":4
        },
      ]
    },
    {
      "title": "申领明细",
      "sort": 0,
      "fields": [
        {
          "title": "资产分类",
          "code": "ASSET_TYPE",
          "type": "router",
          "router": "/choiceAssets",
          "align": "left",
          "required": true,
          "readOnly": true,
          "regx": null,
          "hidden": false
        },
        {
          "title": "资产名称",
          "code": "ASSET_NAME",
          "type": "input",
          "align": "left",
          "hint":"请填写资产名称",
          "required": true,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "领用人",
          "code": "USER_NAME",
          "type": "text",
          "align": "left",
          "required": true,
          "readOnly": true,
          "regx": null,
          "hidden": false
        },
        {
          "title": "部门",
          "code": "USE_DEPT_NAME",
          "type": "text",
          "align": "left",
          "required": true,
          "readOnly": true,
          "regx": null,
          "hidden": false
        },
        {
          "title": "数量",
          "code": "NUM_OR_AREA",
          "type": "input",
          "align": "left",
          "hint":"请填写数量",
          "required": false,
          "readOnly": false,
          "regx": r"[0-9]",
          "hidden": false
        },
        {
          "title": "规格型号",
          "code": "SPEC_MOD",
          "type": "input",
          "align": "left",
          "text":"请填写规格型号",
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "品牌",
          "code": "BRAND",
          "type": "input",
          "align": "left",
          "hint":"请填写品牌",
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "是否信创",
          "code": "SFXC",
          "type": "select",
          "select": {true: "是", false: "否"},
          "align": "left",
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        }
      ]
    }
  ]
};

Map<String, dynamic> disposeConfig = {
  "businessName": "资产处置",
  "businessCode": "dispose",
  "text": [
    {
      "title": "基本信息",
      "sort": 0,
      "fields": [
        {
          "title": "单据编号",
          "code": "BILL_CODE",
          "type": "text",
          "required": true,
          "readOnly": true,
          "regx": null,
          "hidden": true,
        },
        {
          "title": "处置方法",
          "code": "DISPOSE_TYPE",
          "type": "select",
          "select": {
            0: "报废",
            1: "报损",
            2: "无偿调拨（划转）",
            3: "出售/出让/转让",
            4: "核销",
            5: "对外捐赠",
            6: "置换",
            7: "其他",
            8: "投资收回",
            9: "错账更正",
            10: "货币型损失",
            11: "退货",
          },
          "required": true,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "资产接收单位类型",
          "code": "IS_SYS_UNIT",
          "type": "select",
          "select": {
            0: "行政机关",
            1: "事业单位",
            2: "国有企业",
            3: "国有控股企业	",
            4: "外资企业	",
            5: "合资企业	",
            6: "社会团体	",
            7: "其他"
          },
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "资产接收单位名称",
          "code": "keepOrgName",
          "type": "input",
          "hint": "请填写资产接受单位名称",
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "资产接收单位电话",
          "code": "keepOrgPhoneNumber",
          "type": "input",
          "hint": "请填写资产接受单位电话",
          "required": false,
          "readOnly": false,
          "regx": r"[0-9]",
          "hidden": false
        },
        {
          "title": "是否评估",
          "code": "evaluated",
          "type": "select",
          "select": {1:"是", 0:"否"},
          "required": false,
          "readOnly": false,
          "regx": null,
          "hidden": false
        },
        {
          "title": "申请原因",
          "code": "REMARK",
          "type": "input",
          "hint": "请填写处置事由",
          "marginTop": 10.0,
          "required": true,
          "readOnly": false,
          "regx": null,
          "hidden": false,
          "maxLine":4
        }
      ]
    }
  ]
};
