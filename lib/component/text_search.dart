import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_text_style.dart';

import 'unified_colors.dart';

const EdgeInsets defaultMargin = EdgeInsets.all(10);
const String defaultPlaceHolder = "请输入搜索内容";

class TextSearch extends StatelessWidget {
  final EdgeInsets? margin;
  final Function? searchingCallback;
  final Function? loadingCallback;
  final Function? onTap;
  final String? placeHolder;

  const TextSearch({
    Key? key,
    this.margin = defaultMargin,
    this.onTap,
    this.searchingCallback,
    this.loadingCallback,
    this.placeHolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 500);
    Timer? timer;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: UnifiedColors.searchGrey,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10.w),
            child: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: TextField(
              onTap: () {
                if (onTap != null) {
                  onTap!();
                }
              },
              onChanged: (newVal) {
                if (searchingCallback == null) return;
                if (timer != null) {
                  timer!.cancel();
                }
                timer = Timer(duration, () => searchingCallback!(newVal));
              },
              style: text16,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(8.w, 10.h, 10.w, 8.h),
                hintText: placeHolder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
