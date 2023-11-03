/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-29 15:26:05
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-15 20:28:12
 */
import 'package:flutter/material.dart';

import '../index.dart';

/// 主导航栏
AppBar appBarWidget({
  Key? key,
  Function()? onTap, // 点击事件
  Widget? leading, // 左侧按钮
  Widget? title, // 左侧按钮
  String? hintText, // 输入框默认提示文字
  String? titleString, // 标题
  double? titleSpace, // 标题间距
  double? iconSize,
  bool? centerTitle,
  List<Widget>? actions,
}) {
  return AppBar(
    // 最左侧按钮
    leading: leading,
    // 按钮和标题组件间距
    titleSpacing: titleSpace ?? AppSpace.listItem,
    centerTitle: centerTitle,
    // 标题组件
    title: title != null
        ? title
        : hintText != null
            ? InputWidget.textBorder(
                hintText: hintText,
                readOnly: true,
                onTap: onTap,
              )
            : Text(titleString ?? ""),
    // 右侧按钮组
    actions: actions == null ? _actions(iconSize) : actions,
  );
}

List<Widget> _actions(
  double? iconSize,
) {
  return <Widget>[
// 搜索
    IconWidget.svg(
      AssetsSvgs.iSearchSvg,
      size: iconSize ?? 20,
    ).paddingRight(AppSpace.listItem),

    // 消息
    IconWidget.svg(
      AssetsSvgs.iNotificationsSvg,
      size: iconSize ?? 20,
      isDot: true,
    ).unconstrained().paddingRight(AppSpace.listItem),

    // 更多
    IconWidget.svg(
      AssetsSvgs.iIndicatorsSvg,
      size: iconSize ?? 20,
    ).paddingRight(AppSpace.page),
  ];
}
