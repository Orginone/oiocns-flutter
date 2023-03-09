Map<String,dynamic> acc = {
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
          "marginBottom":0.0,
          "marginLeft":0.0,
          "marginRight":0.0,
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
          "select": {
            "是": true,
            "否": false
          },
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