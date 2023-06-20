import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

class AtPersonDialog {

  static Future<XTarget?>? showDialog(BuildContext context, IMsgChat chat) {
    FocusScope.of(context).requestFocus(FocusNode());
    return showModalBottomSheet<XTarget?>(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 600.h,
            width: double.infinity,
            child: ListView.builder(
              itemBuilder: (context, index) {
                var item = chat.members[index];
                return ListTile(
                  onTap: () {
                    Navigator.pop(context, item);
                  },
                  title: Text(item.name!),
                  leading: TeamAvatar(info: TeamTypeInfo(userId: item.id),size:45.w,),
                );
              },
              itemCount: chat.members.length,
            ),
          );
        }).then((value) {
      return value;
    });
  }
}
