


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'base_frequently_used_list_state.dart';

class BaseFrequentlyUsedItem extends StatelessWidget {
  final FrequentlyUsed recent;
  final VoidCallback? onTap;
  const BaseFrequentlyUsedItem({Key? key, required this.recent, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80.w,
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
                : recent.avatar is IoniconsData
                    ? Container(
                        height: 48.w,
                        width: 48.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: XColors.themeColor,
                            borderRadius: BorderRadius.circular(16.w)),
                        child: Icon(
                          recent.avatar,
                          color: Colors.white,
                          size: 30.w,
                        ),
                      )
                    : ImageWidget(
                        recent.avatar,
                        size: 48.w,
                      ),
            SizedBox(
              height: 5.h,
            ),
            Text(
              recent.name ?? "",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18.sp,
                  color: const Color.fromARGB(255, 52, 52, 54),
                  overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
    );
  }
}
