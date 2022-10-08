import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/component/unified_text_style.dart';

import '../config/custom_colors.dart';

const EdgeInsets defaultMargin = EdgeInsets.all(10);

class TextSearch extends StatelessWidget {
  final EdgeInsets? margin;
  final Function searchingCallback;

  const TextSearch(this.searchingCallback,
      {Key? key, this.margin = defaultMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: CustomColors.searchGrey,
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
                contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                hintText: '请输入搜索内容',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
