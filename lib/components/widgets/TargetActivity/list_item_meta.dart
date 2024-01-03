import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//渲染列表项
class ListItemMetaWidget extends StatelessWidget {
  Widget title;
  Widget subTitle;
  Widget avatar;
  Widget description;
  Function()? onTap;
  ListItemMetaWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.avatar,
      required this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 10.w, right: 10.w),
      title: Row(
        children: [
          avatar,
          Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [title, subTitle]))
        ],
      ),
      subtitle: description,
      onTap: onTap,
    );

    // Container(
    //     child: Row(
    //   children: [
    //     avatar,
    //     Column(
    //       children: [title, description],
    //     )
    //   ],
    // ));
  }
}
