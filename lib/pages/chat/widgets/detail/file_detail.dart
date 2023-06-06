import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'image_detail.dart';
import 'shadow_widget.dart';

class FileDetail extends BaseDetail {
  final bool showShadow;

  FileDetail({
    this.showShadow = false,
    required super.isSelf,
    required super.message,
    super.constraints,
    super.clipBehavior = Clip.hardEdge,
    super.padding = EdgeInsets.zero,
    super.bgColor,
    super.isReply = false,
  });


  @override
  Widget build(BuildContext context) {
    String extension = message.body?.extension ?? '';
    if (imageExtension.contains(extension.toLowerCase())) {
      return ImageDetail(
        isSelf: isSelf,
        message: message,
      );
    }
    return super.build(context);
  }

  @override
  Widget body(BuildContext context) {


    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(
        minWidth: 200.w, minHeight: 70.h, maxWidth: 250.w, maxHeight: 100.h);

    Widget child = Container(
      constraints: boxConstraints,
      color: bgColor != null ? Colors.transparent : Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    message.body?.name ?? "",
                    style: XFonts.size24Black0,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  getFileSizeString(bytes: message.body?.size ?? 0),
                  style: XFonts.size16Black9,
                ),
              ],
            ),
          ),
          ImageWidget(Images.iconFile, size: 40.w),
        ],
      ),
    );

    if (showShadow) {
      child = ShadowWidget(
        child: child,
      );
    }
    return child;
  }

  @override
  void onTap(BuildContext context) {
    Get.toNamed(Routers.messageFile, arguments: message.body?.toJson());
  }
}
