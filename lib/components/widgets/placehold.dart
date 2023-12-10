/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-29 15:05:10
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-07 14:54:43
 */
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';

/// 占位图组件
class PlaceholdWidget extends StatelessWidget {
  // 资源图片地址
  final String? assetImagePath;

  const PlaceholdWidget({
    Key? key,
    this.assetImagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return XImageWidget.asset(assetImagePath ?? AssetsImages.homePlaceholderPng)
        .paddingHorizontal(AppSpace.page)
        .center();
  }
}
