import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/widgets/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/config/unified.dart';

double defaultWidth = 10.w;

abstract class BaseDetail extends StatelessWidget {
  final IMessage message;
  final ISession? chat;
  final BoxConstraints? constraints;
  final Clip? clipBehavior;
  final EdgeInsets? padding;
  final Color? bgColor;
  final bool isSelf;
  final bool isReply;

  const BaseDetail(
      {Key? key,
      this.constraints,
      this.clipBehavior = Clip.hardEdge,
      this.padding = EdgeInsets.zero,
      this.bgColor,
      required this.isSelf,
      required this.message,
      this.isReply = false,
      this.chat})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextDirection textDirection =
        isSelf ? TextDirection.rtl : TextDirection.ltr;
    Color color = bgColor ?? (isSelf ? XColors.tinyLightBlue : Colors.white);

    Widget child = body(context);

    if (isReply) {
      ShareIcon? shareIcon;
      if (isSelf) {
        shareIcon = relationCtrl.user.share;
      } else {
        if (chat!.share.typeName == TargetType.person.label) {
          shareIcon = chat!.share;
        } else if (chat!.members.isNotEmpty) {
          var target = chat!.members
              .firstWhere((element) => element.id == message.metadata.fromId);
          shareIcon = target.shareIcon();
        } else {
          shareIcon = message.from;
        }
      }
      child = Text.rich(TextSpan(children: [
        WidgetSpan(
            child: TargetText(
              userId: message.metadata.fromId,
              text: ": ",
              style: XFonts.chatSMInfo,
              shareIcon: message.from,
            ),
            alignment: PlaceholderAlignment.bottom),
        WidgetSpan(child: child, alignment: PlaceholderAlignment.bottom),
      ]));
    }

    return GestureDetector(
      onTap: () {
        onTap(context);
      },
      child: Container(
        constraints: constraints ?? BoxConstraints(maxWidth: 350.w),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        margin: textDirection == TextDirection.ltr
            ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
            : EdgeInsets.only(right: defaultWidth),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
        ),
        clipBehavior: clipBehavior ?? Clip.none,
        child: child,
      ),
    );
  }

  Widget body(BuildContext context);

  void onTap(BuildContext context) {}
}
