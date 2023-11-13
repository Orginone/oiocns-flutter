import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/index.dart' hide ImageWidget;
import 'package:orginone/config/index.dart';

/// 滚动视图
class CarouselWidget extends StatelessWidget {
  const CarouselWidget(
      {Key? key,
      this.onPageChanged,
      this.onTap,
      required this.items,
      this.currentIndex,
      this.height,
      this.indicatorColor,
      this.indicatorCircle,
      this.indicatorAlignment,
      this.indicatorLeft,
      this.indicatorRight,
      this.indicatorBottom})
      : super(key: key);

  /// 切换页码
  final Function(int, CarouselPageChangedReason)? onPageChanged;

  /// 点击
  final Function(int, KeyValueModel)? onTap;

  /// 数据列表
  final List<KeyValueModel> items;

  /// 当前选中
  final int? currentIndex;

  /// 高度
  final double? height;

  /// 指示器 颜色
  final Color? indicatorColor;

  /// 指示器 是否圆形
  final bool? indicatorCircle;

  /// 指示器 对齐方式
  final MainAxisAlignment? indicatorAlignment;

  /// 指示器 位置
  final double? indicatorLeft, indicatorRight, indicatorBottom;

  Widget _buildView() {
    List<Widget> ws = [
      // 滚动视图
      CarouselSlider(
        options: CarouselOptions(
          // 高度
          height: height,
          // 填充比例
          viewportFraction: 1,
          // 图像比例
          aspectRatio: 3.2 / 1,
          // 确定当前页面是否应该大于侧面图像， 在旋转木马中营造一种深度感。
          enlargeCenterPage: false,
          // 循环
          enableInfiniteScroll: true,
          // 自动播放
          autoPlay: true,
          // 回调页切换事件
          onPageChanged: onPageChanged,
        ),
        items: <Widget>[
          for (var i = 0; i < items.length; i++)
            ImageWidget.url(
              items[i].value,
              fit: BoxFit.fill,
            ).onTap(
              () {
                if (onTap != null) onTap!(i, items[i]);
              },
            ),
        ],
      ),

      // 指示器
      SliderIndicatorWidget(
        // 个数
        length: items.length,
        // 当前索引
        currentIndex: currentIndex ?? 0,
        // 颜色
        color: indicatorColor ?? AppColors.background,
        // 是否圆形
        isCircle: indicatorCircle ?? true,
        // 对齐方式
        alignment: indicatorAlignment ?? MainAxisAlignment.center,
      ).positioned(
        left: indicatorLeft ?? 20,
        right: indicatorRight ?? 20,
        bottom: indicatorBottom ?? 10,
      ),
    ];

    return ws.toStack();
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
