import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/components/widgets/photo_widget.dart';

import 'shadow_widget.dart';

class ImageDetail extends BaseDetail {
  final bool showShadow;
  late final FileItemShare msgBody;

  ImageDetail(
      {super.key,
      this.showShadow = false,
      required super.isSelf,
      super.constraints = const BoxConstraints(maxWidth: 200),
      super.bgColor,
      required super.message,
      super.clipBehavior = Clip.hardEdge,
      super.padding = EdgeInsets.zero,
      super.isReply = false,
      super.chat}) {
    msgBody = FileItemShare.fromJson(jsonDecode(message.msgBody));
  }

  @override
  Widget body(BuildContext context) {
    dynamic link = msgBody.shareLink ?? '';
    dynamic thumbnail = msgBody.thumbnailUint8List;
    // TODO 待处理小的预览图
    if (thumbnail != null) {
      link = thumbnail;
    } else if (!link.startsWith('/orginone/kernel/load/')) {
      link = File(link);
    } else {
      link = '${Constant.host}$link';
    }

    Map<String, String> headers = {
      "Authorization": kernel.accessToken,
    };
    // LogUtil.d('ImageDetail');
    // LogUtil.d(link);
    Widget child = ImageWidget(link, httpHeaders: headers, size: 200);

    if (showShadow) {
      child = ShadowWidget(
        child: child,
      );
    }

    return child;
  }

  @override
  void onTap(BuildContext context) {
    dynamic link = msgBody.shareLink ?? '';
    link = '${Constant.host}$link';
    // if (message.body?.path != null && link == '') {
    //   link = File(message.body!.path!);
    // }
    Navigator.of(context).push(
      DialogRoute(
        context: context,
        builder: (BuildContext context) {
          return PhotoWidget(
            imageProvider: CachedNetworkImageProvider(link),
          );
        },
      ),
    );
  }
}
