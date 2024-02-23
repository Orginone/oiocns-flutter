import 'package:flutter/material.dart';

class StartRatingWidget extends StatelessWidget {
  final int count; // 星星的数量，默认是5个
  final double rating; // 获得的分数
  final double totalRating; // 总分数
  final Color unSelectColor; // 未选中的颜色
  final Color selectColor; // 选中的颜色
  final double size; // 星星的大小
  final double spacing; // 星星间的间隙
  final TextStyle? style;
  // 自定义构造函数
  const StartRatingWidget({
    super.key,
    required this.rating,
    this.totalRating = 10,
    this.unSelectColor = Colors.grey,
    this.selectColor = Colors.red,
    this.size = 30,
    this.count = 5,
    this.spacing = 2,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [getUnSelectStarWidget(), getSelectStarWidget()],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            "$rating分",
            style: style ?? const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  // 获取背景：未填充的星星
  List<Widget> _getUnSelectStars() {
    return List<Widget>.generate(count, (index) {
      return Icon(
        Icons.star_outline_rounded,
        size: size,
        color: unSelectColor,
      );
    });
  }

  // 填充星星
  List<Widget> _getSelectStars() {
    return List<Widget>.generate(count, (index) {
      return Icon(
        Icons.star,
        size: size,
        color: selectColor,
      );
    });
  }

  // 获取背景星星的组件
  Widget getUnSelectStarWidget() {
    return Wrap(
      spacing: spacing,
      alignment: WrapAlignment.spaceBetween,
      children: _getUnSelectStars(),
    );
  }

  // 获取针对整个选中的星星裁剪的组件
  Widget getSelectStarWidget() {
    // 应该展示几个星星 --- 例如：4.6个星星
    final double showStarCount = count * (rating / totalRating);
    final int fillStarCount = showStarCount.floor(); // 满星的数量
    final double halfStarCount = showStarCount - fillStarCount; // 半星的数量
    // 最终需要裁剪的宽度
    final double clipWith =
        fillStarCount * (size + spacing) + halfStarCount * size;

    return ClipRect(
      clipper: StarClipper(clipWith),
      child: Wrap(
        spacing: spacing,
        alignment: WrapAlignment.spaceBetween,
        children: _getSelectStars(),
      ),
    );
  }
}

// 获取裁剪过的星星
class StarClipper extends CustomClipper<Rect> {
  double clipWidth;
  StarClipper(this.clipWidth);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, clipWidth, size.height);
  }

  @override
  bool shouldReclip(StarClipper oldClipper) {
    // TODO: implement shouldReclip
    return clipWidth != oldClipper.clipWidth;
  }
}
