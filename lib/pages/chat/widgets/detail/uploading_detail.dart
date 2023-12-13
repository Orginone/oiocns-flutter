import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';

import 'file_detail.dart';
import 'image_detail.dart';

class UploadingDetail extends StatelessWidget {
  IMessage message;
  late FileItemShare fileItemShare;
  final bool isSelf;

  UploadingDetail({super.key, required this.isSelf, required this.message}) {
    fileItemShare = message.msgBody.isNotEmpty
        ? FileItemShare.fromJson(jsonDecode(message.msgBody))
        : FileItemShare();
  }

  @override
  Widget build(BuildContext context) {
    String extension = fileItemShare.extension ?? "";
    double progress = message.progress ?? 0;
    Widget body;
    if (imageExtension.contains(extension.toLowerCase())) {
      body = ImageDetail(
        isSelf: isSelf,
        message: message,
        showShadow: true,
      );
    } else {
      body = FileDetail(
        isSelf: isSelf,
        message: message,
        showShadow: true,
      );
    }

    Widget gradient = Stack(
      alignment: Alignment.center,
      fit: StackFit.passthrough,
      children: [
        body,
        Text(
          '${(progress * 100).toStringAsFixed(0)}%',
          style: TextStyle(color: Colors.white, fontSize: 24.sp),
        ),
      ],
    );
    return gradient;
  }
}
