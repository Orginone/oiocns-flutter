


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'base_frequently_used_list_state.dart';

class BaseFrequentlyUsedItem extends StatelessWidget {
  final Recent recent;
  final VoidCallback? onTap;
  const BaseFrequentlyUsedItem({Key? key, required this.recent, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 50.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            recent.avatar == null
                ? Container(
                    height: 48.w,
                    width: 48.w,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: XColors.themeColor,
                        borderRadius: BorderRadius.circular(16.w)),
                  )
                : ImageWidget(
                    recent.avatar,
                    size: 48.w,
                  ),
            Text(
              recent.name ?? "",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromARGB(255, 52, 52, 54),
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}
