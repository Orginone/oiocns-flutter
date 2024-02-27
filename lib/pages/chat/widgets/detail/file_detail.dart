import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart' as model;

import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/utils/load_image.dart';

import 'image_detail.dart';
import 'shadow_widget.dart';

class FileDetail extends BaseDetail {
  final bool showShadow;
  late final model.FileItemShare msgBody;

  FileDetail(
      {super.key,
      this.showShadow = false,
      required super.isSelf,
      required super.message,
      super.constraints,
      super.clipBehavior = Clip.hardEdge,
      super.padding = EdgeInsets.zero,
      super.bgColor,
      super.isReply = false,
      super.chat}) {
    msgBody = model.FileItemShare.fromJson(jsonDecode(message.msgBody));
  }

  @override
  Widget build(BuildContext context) {
    String extension = msgBody.extension ?? '';
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
        minWidth: 280.w,
        minHeight: 90.h,
        maxWidth: MediaQuery.of(context).size.width - 110,
        maxHeight: 130.h);

    Widget child = Container(
        constraints: boxConstraints,
        color: bgColor != null ? Colors.transparent : Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Column(children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ImageWidget(AssetsImages.iconFile, size: 40.w),
                XImage.entityIcon(msgBody),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        msgBody.name ?? "",
                        style: XFonts.chatSMSysTip,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        getFileSizeString(bytes: msgBody.size ?? 0),
                        style: XFonts.size16Black9,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          SizedBox(
            // color: Colors.red,
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      _onTap(context);
                    },
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0))),
                    child: const Text("在线预览")),
                const VerticalDivider(),
                TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                        padding:
                            MaterialStateProperty.all(const EdgeInsets.all(0))),
                    child: const Text("在线编辑"))
              ],
            ),
          )
        ]));

    if (showShadow) {
      child = ShadowWidget(
        child: child,
      );
    }
    return child;
  }

  // @override
  void _onTap(BuildContext context) {
    RoutePages.jumpFile(file: model.FileItemShare.fromJson(msgBody.toJson()));
  }
}
