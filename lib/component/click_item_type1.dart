import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//点击项类型1
class ClickItemType1 extends StatelessWidget {
  //背景
  final Color? bgColor;
  //高度
  final double? height;
  //宽度
  final double? width;
  //内边距
  final EdgeInsets? padding;
  //下侧文字
  final String? text;
  //中间图标(和图片两者存其一,优先图标)
  final Icon? icon;
  //中间图片(和图标两者存其一)
  final Image? image;
  //全局的点击事件
  final Function? callback;

  const ClickItemType1({
    Key? key,
    this.bgColor = Colors.white,
    this.height,
    this.width,
    this.padding = const EdgeInsets.all(10),
    this.text,
    this.icon,
    this.image,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        callback != null ? callback!() : () {};
      },
      child: Column(
        children: [
          //图片区
          Container(
            height: height,
            width: width,
            padding: padding,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(5))
            ),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 10.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                () {
                  if (icon != null) {
                    return icon!;
                  } else if(image != null) {
                    return image!;
                  }
                  return const Icon(Icons.error);
                }(),
              ],
            ),
          ),
          //文本区
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(text ?? '')]
          )
        ],
      ),
    );
  }
}
