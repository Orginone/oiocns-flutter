import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//渲染列表项
class ListItemMetaWidget extends StatelessWidget {
  Widget title;
  Widget subTitle;
  Widget avatar;
  Widget? description;
  Function()? onTap;
  ListItemMetaWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.avatar,
      this.description,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w),
      color: Colors.white,
      child: ListTile(
        contentPadding: EdgeInsets.only(left: 0.w, right: 0.w),
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
      ),
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
