Map<String, dynamic> chatDefaultConfig = {
  "type": "chat",
  "groups": [
    {
      "label": "全部",
      "value": "all",
      "allowEdit":true,
    },
    {
      "label": "常用",
      "value": "common",
      "allowEdit":true,
    },
    {
      "label": "最近",
      "value": "recent",
      "allowEdit":false,
    },
    {
      "label": "未读",
      "value": "unread",
      "allowEdit":true,
    },
    {
      "label": "单聊",
      "value": "single",
      "allowEdit":true,
    },
    {
      "label": "群聊",
      "value": "group",
      "allowEdit":true,
    },
  ]
};

Map<String, dynamic> workDefaultConfig = {
  "type": "work",
  "groups": [
    {
      "label": "全部",
      "value": "all",
      "allowEdit":true,
    },
    {
      "label": "常用",
      "value": "common",
      "allowEdit":true,
    },
    {
      "label": "发起",
      "value": "create",
      "allowEdit":true,
    },
    {
      "label": "待办",
      "value": "todo",
      "allowEdit":false,
    },
    {
      "label": "已办",
      "value": "done",
      "allowEdit":true,
    },
    {
      "label": "我发起",
      "value": "apply",
      "allowEdit":true,
    },
  ]
};

Map<String, dynamic> storeDefaultConfig = {
  "type": "store",
  "groups": [
    {
      "label": "全部",
      "value": "all",
      "allowEdit":true,
    },
    {
      "label": "常用",
      "value": "common",
      "allowEdit":false,
    },
    {
      "label": "文件",
      "value": "file",
      "allowEdit":true,
    },
    {
      "label": "数据",
      "value": "thing",
      "allowEdit":true,
    },
    {
      "label": "应用",
      "value": "application",
      "allowEdit":true,
    },
    {
      "label": "资源",
      "value": "resource",
      "allowEdit":true,
    },
    {
      "label": "其他",
      "value": "other",
      "allowEdit":true,
    },
  ]
};

Map<String, dynamic> settingDefaultConfig = {
  "type": "setting",
  "groups": [
    {
      "label": "全部",
      "value": "all",
      "allowEdit":true,
    },
    {
      "label": "常用",
      "value": "common",
      "allowEdit":false,
    },
    {
      "label": "最近",
      "value": "recent",
      "allowEdit":true,
    },
  ]
};