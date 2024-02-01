/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-29 16:45:17
 * @LastEditors: 
 * @LastEditTime: 2022-11-29 16:50:33
 */
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

/// 图片浏览组件
class GalleryWidget extends StatelessWidget {
  /// 初始图片位置
  final int initialIndex;

  /// 图片列表
  final List<String> items;

  const GalleryWidget({
    Key? key,
    required this.initialIndex,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // 点击返回
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        // 全屏, 高度将扩展为包括应用栏的高度
        extendBodyBehindAppBar: true,

        // 背景黑色
        backgroundColor: Colors.black,

        // 导航栏 保留一个返回按钮
        appBar: AppBar(),

        // 图片内容
        body: PhotoViewGallery.builder(
          // 允许滚动超出边界，但之后内容会反弹回来。
          scrollPhysics: const BouncingScrollPhysics(),
          // 图片列表
          builder: (BuildContext context, int index) {
            return PhotoViewGalleryPageOptions(
              // 图片内容
              imageProvider: NetworkImage(items[index]),
              // 初始尺寸 容器尺寸
              initialScale: PhotoViewComputedScale.contained,
              // 最小尺寸 容器尺寸
              minScale: PhotoViewComputedScale.contained,
              // 最大尺寸 容器尺寸 4 倍
              maxScale: PhotoViewComputedScale.covered * 4,
            );
          },

          // loading 载入标记
          loadingBuilder: (context, event) => CircularProgressIndicator(
            // 标记颜色
            backgroundColor: AppColors.highlight,
            // 进度
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / (event.expectedTotalBytes ?? 0),
          ).tightSize(30).center(),

          // 图片个数
          itemCount: items.length,

          // 初始控制器，默认图片位置
          pageController: PageController(initialPage: initialIndex),
        ),
      ),
    );
  }
}
