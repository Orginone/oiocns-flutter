/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-29 15:26:05
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-15 21:39:07
 */
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';

/// 主导航栏
AppBar mainAppBarWidget({
  Key? key,
  Function()? onTap, // 点击事件
  Function()? actionOnTap, // 点击事件
  Widget? leading, // 左侧按钮
  Widget? title, // 左侧按钮
  String? hintText, // 输入框默认提示文字
  String? titleString, // 标题
  String? actionString, // 标题
  String? avatarUrl, //头像url  必传
  double? titleSpace, // 标题间距
  double? iconSize,
  bool? centerTitle,
  List<Widget>? actions,
}) {
  return AppBar(
    // 最左侧按钮
    leading: leading == null
        ? _avatar(avatarUrl!, onTap).unconstrained()
        : leading.unconstrained(),
    // 按钮和标题组件间距
    titleSpacing: titleSpace ?? 0,
    centerTitle: centerTitle ?? false,
    // 标题组件
    title: title ??
        (hintText != null
            ? InputWidget.textBorder(
                hintText: hintText,
                readOnly: true,
                onTap: onTap,
              )
            : Text(titleString ?? "")),
    // 右侧按钮组
    actions: actions ?? _actions(iconSize, actionString, actionOnTap),
  );
}

Widget _avatar(String avatarUrl, Function()? onTap) {
  return avatarUrl.startsWith('http')
      ? ImageWidget.url(
          avatarUrl,
          width: 40.w,
          height: 40.w,
          fit: BoxFit.fill,
          radius: 40.w,
        ).onTap(() => onTap?.call())
      : ImageWidget.asset(
          avatarUrl,
          width: 40.w,
          height: 40.w,
          fit: BoxFit.fill,
          radius: 40.w,
        ).onTap(() => onTap?.call());
}

List<Widget> _actions(
    double? iconSize, String? actionString, Function()? onTap) {
  return <Widget>[
    <Widget>[
      TextWidget.title3(
        actionString ?? '-',
      ).center().paddingRight(AppSpace.listItem).onTap(() => onTap?.call()),
// 搜索
      IconWidget.svg(AssetsSvgs.iSearchSvg,
              size: iconSize ?? 20, color: Colors.white)
          .paddingRight(AppSpace.page)
          .onTap(() => onTap?.call()),
    ].toRow(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center),
  ];
}
