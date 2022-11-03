import 'package:orginone/component/bread_crumb.dart';

const Item<String> centerPoint = Item(id: "center", label: "首页");

const Item<String> chatPoint = Item(
  id: "chat",
  label: "沟通",
  children: [chatRecentPoint, chatMailPoint],
  defaultBindingItem: chatRecentPoint,
);
const Item<String> chatRecentPoint = Item(id: "chatRecent", label: "会话");
const Item<String> chatMailPoint = Item(id: "chatMail", label: "通讯录");

const Item<String> workPoint = Item(id: "work", label: "办事");
const Item<String> warehousePoint = Item(id: "warehouse", label: "仓库");
const Item<String> settingPoint = Item(id: "setting", label: "设置");
