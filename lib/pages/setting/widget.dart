import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/widget/common_widget.dart';

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
      docContent.add([
        user.code,
        user.name,
        user.team?.name ?? "",
        user.team?.code ?? "",
        user.team?.remark ?? ""
      ]);
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

class PopupMenu<T> extends StatelessWidget {
 final PopupMenuItemSelected<T>? onSelected;
 final List<PopupMenuItem<T>> items;
 final Color? color;
  const PopupMenu({Key? key, this.onSelected, required this.items, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      color: color??Colors.white,
      child: PopupMenuButton<T>(
        icon: Icon(
          Icons.more_vert_outlined,
          size: 32.w,
        ),
        itemBuilder: (BuildContext context) {
          return items;
        },
        onSelected: onSelected,
      ),
    );
  }
}
