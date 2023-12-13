import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/widgets/team_avatar.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main.dart';

//动态评论
class ActivityComment extends StatelessWidget {
  late CommentType comment;
  late void Function(CommentType comment)? onTap;

  ActivityComment({required this.comment, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        color: XColors.entryBgColor,
        padding: EdgeInsets.all(5.w),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            ...getUserAvatar(comment.userId),
            Offstage(
              offstage: comment.replyTo == null || comment.replyTo!.isEmpty,
              child: const Text("回复 "),
            ),
            // Offstage(
            //   offstage: comment.replyTo == null || comment.replyTo!.isEmpty,
            //   child: UserInfo(userId: comment.replyTo!),
            // ),
            Text(" ${comment.label}")
          ],
        ));
  }

  List<Widget> getUserAvatar(String userId) {
    XEntity? entity = settingCtrl.user.findMetadata<XEntity>(userId);
    return [
      Padding(padding: EdgeInsets.only(left: 5.w)),
      TeamAvatar(
        info: TeamTypeInfo(userId: userId),
        size: 24.w,
      ),
      Padding(padding: EdgeInsets.only(left: 5.w)),
      Text(entity?.name ?? "",
          style: const TextStyle(
            color: XColors.themeColor,
            fontWeight: FontWeight.bold,
          ))
    ];
  }
}
