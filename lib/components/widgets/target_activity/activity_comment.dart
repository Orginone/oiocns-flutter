import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/widgets/common/image/team_avatar.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/main_base.dart';

//动态评论
class ActivityComment extends StatelessWidget {
  late CommentType comment;
  late void Function(CommentType comment)? onTap;

  ActivityComment({required this.comment, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> replyTo = [];
    if (comment.replyTo != null && comment.replyTo!.isNotEmpty) {
      replyTo
        ..add(const Text("回复 "))
        ..addAll(getUserAvatar(comment.replyTo!));
    }
    return GestureDetector(
        onTap: () => onTap?.call(comment),
        child: Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.all(5.w),
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                ...getUserAvatar(comment.userId),
                ...replyTo,
                // Offstage(
                //   offstage: comment.replyTo == null || comment.replyTo!.isEmpty,
                //   child: UserInfo(userId: comment.replyTo!),
                // ),
                Text(" ${comment.label}")
              ],
            )));
  }

  List<Widget> getUserAvatar(String userId) {
    XEntity? entity = relationCtrl.user?.findMetadata<XEntity>(userId);
    return [
      Padding(padding: EdgeInsets.only(left: 5.w)),
      TeamAvatar(
        info: TeamTypeInfo(userId: userId),
        size: 24.w,
      ),
      Padding(padding: EdgeInsets.only(left: 5.w)),
      Text(entity?.name ?? "",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ))
    ];
  }
}
