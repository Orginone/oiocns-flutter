/*
 * @Descripttion: 
 * @version: 
 * @Author: 
 * @Date: 
 */
import 'package:flutter/widgets.dart';
import 'package:orginone/common/widgets/icon.dart';

///页签模型
abstract class ITabModel {
  ///标题
  String title;

  ///图标
  String? icon;

  ///当前默认页签
  String? activeTabTitle;

  ///页签项
  List<TabItemsModel> tabItems;

  ITabModel(
      {required this.title,
      this.icon,
      this.activeTabTitle,
      this.tabItems = const []});
}

/// 信息列表页模型
class InfoListPageModel extends ITabModel {
  ///头像
  // Widget? avatar;

  ///菜单
  // List<TabMenuItemsModel> tabMenuItems;

  ///是否显示页签项菜单
  bool isShowTabItemsMenu;

  ///点击标签页签
  Function([String tagName, String? tabName])? onTagTap;

  ///左滑事件
  Function? onLeftSwipe;

  ///右滑事件
  Function? onRightSwipe;

  InfoListPageModel(
      {required super.title,
      // this.avatar,
      // this.tabMenuItems = const [],
      super.activeTabTitle,
      required super.tabItems,
      this.isShowTabItemsMenu = true,
      this.onLeftSwipe,
      this.onRightSwipe});
}

/// 页签菜单项模型
class TabMenuItemsModel {
  ///菜单项标题
  String? title;

  ///页签项图标
  IconWidget icons;

  ///点击操作
  Function() onTap;
  TabMenuItemsModel({this.title, required this.icons, required this.onTap});
}

/// 页签项模型
class TabItemsModel extends ITabModel {
  ///页签内容
  Widget? content;

  TabItemsModel(
      {required super.title, super.icon, super.tabItems, this.content});
}
