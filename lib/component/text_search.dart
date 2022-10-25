import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_text_style.dart';

import 'unified_colors.dart';

const EdgeInsets defaultMargin = EdgeInsets.all(10);
const String defaultPlaceHolder = "请输入搜索内容";

class TextSearch extends StatelessWidget {
  final EdgeInsets? margin;
  final Function searchingCallback;
  final String? placeHolder;

  const TextSearch(
    this.searchingCallback, {
    Key? key,
    this.margin = defaultMargin,
    this.placeHolder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
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
              onChanged: (newVal) {
                searchingCallback(newVal);
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
