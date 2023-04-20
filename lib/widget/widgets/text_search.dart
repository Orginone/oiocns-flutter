import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';

enum SearchType { text, dropdown }

const EdgeInsets defaultMargin = EdgeInsets.all(10);
const String defaultPlaceHolder = "请输入搜索内容";

class TextSearch extends StatelessWidget {
  final EdgeInsets? margin;
  final Function? searchingCallback;
  final Function? loadingCallback;
  final Function? onTap;
  final String? placeHolder;
  final Color? bgColor;
  final bool hasSearchIcon;
  final SearchType type;

  const TextSearch({
    Key? key,
    this.margin = defaultMargin,
    this.onTap,
    this.searchingCallback,
    this.loadingCallback,
    this.placeHolder = defaultPlaceHolder,
    this.bgColor,
    this.hasSearchIcon = true,
    this.type = SearchType.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration duration = const Duration(milliseconds: 500);
    Timer? timer;
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.w)),
        color: bgColor ?? XColors.searchGrey,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (hasSearchIcon)
            Container(
              margin: EdgeInsets.only(left: 10.w),
              child: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          Expanded(
            child: TextField(
              readOnly: type == SearchType.dropdown,
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
              style: XFonts.size22Black3,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.fromLTRB(8.w, 12.h, 10.w, 12.h),
                hintText: placeHolder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
