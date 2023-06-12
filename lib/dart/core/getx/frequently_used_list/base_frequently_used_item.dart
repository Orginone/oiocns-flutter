


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/image_widget.dart';

import 'base_frequently_used_list_state.dart';

class BaseFrequentlyUsedItem extends StatelessWidget {
  final Recent recent;
  const BaseFrequentlyUsedItem({Key? key, required this.recent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 60.w,
            width: 60.w,
            alignment: Alignment.center,
            child: ImageWidget(recent.url,size: 48.w,),
          ),
          Text(
            recent.name,
            maxLines: 1,
            style: TextStyle(
                fontSize: 14.sp,
                color: const Color.fromARGB(255, 52, 52, 54),
                overflow: TextOverflow.ellipsis),
          )
        ],
      ),
    );
  }
}
