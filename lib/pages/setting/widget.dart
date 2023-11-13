import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/components/widgets/common_widget.dart';

import 'config.dart';

class UserDocument extends StatelessWidget {
  final DocumentOperation? onOperation;
  final List<PopupMenuItem>? popupMenus;
  final List<String>? title;
  final List<XTarget> unitMember;
  final bool showOperation;

  const UserDocument(
      {Key? key,
      this.onOperation,
      this.popupMenus,
      this.title,
      required this.unitMember,
      this.showOperation = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<String>> docContent = [];
    for (var user in unitMember) {
      docContent.add(
          [user.code!, user.name!, user.name!, user.code!, user.remark ?? ""]);
    }
    return CommonWidget.commonDocumentWidget(
      title: title ?? memberTitle,
      content: docContent,
      showOperation: showOperation,
      popupMenus: popupMenus,
      onOperation: onOperation,
    );
  }
}
