import 'package:flutter/material.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/main_bean.dart';

class TargetText extends StatefulWidget {
  final String userId;

  final ShareIcon? shareIcon;
  final String? text;

  final TextStyle? style;

  final int? maxLines;

  final TextOverflow? overflow;

  final TextAlign? textAlign;

  const TargetText(
      {Key? key,
      required this.userId,
      this.style,
      this.maxLines,
      this.overflow,
      this.textAlign,
      this.text,
      this.shareIcon})
      : super(key: key);

  @override
  State<TargetText> createState() => _TargetTextState();
}

class _TargetTextState extends State<TargetText> {
  late String userId;

  String? text;

  TextStyle? style;

  int? maxLines;

  TextOverflow? overflow;

  TextAlign? textAlign;

  ShareIcon? shareIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userId = widget.userId;
    text = widget.text;
    style = widget.style;
    maxLines = widget.maxLines;
    overflow = widget.overflow;
    textAlign = widget.textAlign;
    dynamic share = ShareIdSet[userId];
    shareIcon = widget.shareIcon ??
        ((share != null && share is ShareIcon) ? share : null);
  }

  @override
  void didUpdateWidget(covariant TargetText oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.userId != oldWidget.userId) {
      userId = widget.userId;
    }
    if (widget.text != oldWidget.text) {
      text = widget.text;
    }
    if (widget.style != oldWidget.style) {
      style = widget.style;
    }
    if (widget.maxLines != oldWidget.maxLines) {
      maxLines = widget.maxLines;
    }
    if (widget.overflow != oldWidget.overflow) {
      overflow = widget.overflow;
    }
    if (widget.textAlign != oldWidget.textAlign) {
      textAlign = widget.textAlign;
    }
    if (widget.shareIcon != oldWidget.shareIcon) {
      shareIcon = widget.shareIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (shareIcon != null) {
      return Text(
        "${shareIcon!.name}${text ?? ""}",
        style: style,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
      );
    }
    return FutureBuilder<ShareIcon>(
      builder: (context, snapshot) {
        String name = '';

        if (snapshot.hasData) {
          name = snapshot.data?.name ?? "";
        }

        return Text(
          "$name${text ?? ""}",
          style: style,
          maxLines: maxLines,
          overflow: overflow,
          textAlign: textAlign,
        );
      },
      future: Future(() => relationCtrl.provider.user.findShareById(userId)),
    );
  }
}
