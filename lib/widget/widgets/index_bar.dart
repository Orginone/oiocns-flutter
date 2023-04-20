import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';

@immutable
class IndexBar extends StatelessWidget {
  final List<String> mData;
  int mCurrentIndex = -1;
  final void Function(String str, int index, bool touchUp) indexBarCallBack;

  IndexBar({
    Key? key,
    required this.mData,
    required this.indexBarCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30.w,
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onVerticalDragDown: (DragDownDetails detail) {
          int i = detail.localPosition.dy ~/ 20.h;
          debugPrint("--->滑动开始$i");
          _updateSelectIndex(i, false);
        },
        onVerticalDragUpdate: (DragUpdateDetails detail) {
          int i = detail.localPosition.dy ~/ 20.h;
          debugPrint('---> 拖动了$i');
          _updateSelectIndex(i, false);
        },
        onVerticalDragEnd: (DragEndDetails detail) {
          debugPrint("--->滑动结束i");
          _updateSelectIndex(-1, true);
        },
        onTapUp: (TapUpDetails detail) {
          _updateSelectIndex(-1, true);
        },
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: mData.length,
            itemBuilder: (context, index) {
              return Container(
                height: 25.h,
                width: 30.w,
                color: Colors.transparent,
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      mData[index],
                      style: XFonts.size20Black3,
                    )),
              );
            }),
      ),
    );
  }

  /// 只有和上次选择不同且在范围之内的才有效
  _updateSelectIndex(int i, bool touchUp) {
    if (mCurrentIndex == i) return;
    if (touchUp) {
      indexBarCallBack("", -1, touchUp);
    } else if (mCurrentIndex != i && i >= 0 && i < mData.length) {
      mCurrentIndex = i;
      indexBarCallBack(mData[mCurrentIndex], mCurrentIndex, touchUp);
    }
  }
}
