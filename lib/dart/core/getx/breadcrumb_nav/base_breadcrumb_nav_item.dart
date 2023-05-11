import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/widget/unified.dart';

 class BaseBreadcrumbNavItem<T extends BaseBreadcrumbNavModel> extends StatelessWidget {
  final T item;

  final VoidCallback? onNext;

  final VoidCallback? onTap;

  const BaseBreadcrumbNavItem({
    Key? key,
    required this.item,
    this.onNext,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ImageProvider? image;
    if(item.image!=null){
      if(item.image!.contains("http")){
        image = NetworkImage(item.image!);
      }
      if(item.image is Uint8List){
        image =  MemoryImage(item.image!);
      }
    }

    return GestureDetector(
      onTap: () {
        if (onNext != null) {
          onNext!();
        } else if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.h),
        child: Row(
          children: [
            AdvancedAvatar(
              size: 60.w,
              decoration: BoxDecoration(
                  color: XColors.themeColor,
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                  image: item.image!=null?DecorationImage(image: image!,fit: BoxFit.cover):null
              ),
            ),
            Expanded(
              child: title(),
            ),
            action(),
            more(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Text(
        item.name,
        style: TextStyle(fontSize: 18.sp, color: Colors.black),
      ),
    );
  }

  Widget more() {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }

  Widget action(){
    return SizedBox();
  }

}
