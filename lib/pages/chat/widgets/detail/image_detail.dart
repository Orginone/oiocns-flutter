import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:orginone/dart/base/api/kernelapi_old.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/widgets/photo_widget.dart';

import 'shadow_widget.dart';

class ImageDetail extends BaseDetail {
  final bool showShadow;

  ImageDetail({
    this.showShadow = false,
    required super.isSelf,
    super.constraints = const BoxConstraints(maxWidth: 200),
    super.bgColor,
    required super.message,
    super.clipBehavior = Clip.hardEdge,
    super.padding = EdgeInsets.zero,
    super.isReply = false,
    super.chat
  });

  @override
  Widget body(BuildContext context) {
    dynamic link = message.body?.shareLink ?? '';

    if (message.body?.path != null && link == '') {
      link = File(message.body!.path!);
    }

    Map<String, String> headers = {
      "Authorization": kernel.anystore.accessToken,
    };

    Widget child = ImageWidget(link, httpHeaders: headers);

    if (showShadow) {
      child = ShadowWidget(
        child: child,
      );
    }

    return child;
  }

  @override
  void onTap(BuildContext context) {
    dynamic link = message.body?.shareLink ?? '';

    if (message.body?.path != null && link == '') {
      link = File(message.body!.path!);
    }
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
