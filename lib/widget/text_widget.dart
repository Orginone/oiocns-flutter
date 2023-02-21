import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'base_common_widget.dart';


class TextWidget extends BaseCommonWidget {
  final String? text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final List? formatParams;
  final TextOverflow? overflow;
  final int? lines;
  final List<InlineSpan>? spanList;
  final double? textScaleFactor;

  TextWidget({
    Key? key,
    this.text,
    this.formatParams,
    this.style,
    this.textAlign,
    this.maxLines = 2147483647000000000,
    this.overflow = TextOverflow.ellipsis,
    this.lines,
    this.spanList,
    this.textScaleFactor = 1.0,
    bool? useRipple,
    Color? rippleColor,
    bool? blackRippleColor,
    GestureTapCallback? onTap,
    GestureLongPressCallback? onLongPress,
    GestureTapDownCallback? onTapDown,
    GestureTapCancelCallback? onTapCancel,
    double? width,
    double? height,
    bool? isCircle,
    Color? bgColor,
    BorderRadius? borderRadius,
    EdgeInsetsGeometry? padding,
    bool? isBlur,
    Color? blurColor,
    double? blurSigmaX,
    double? blurSigmaY,
    Decoration? decoration,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
    InkShowPos? inkShowPos,
    AlignmentGeometry? alignment,
    bool? enabled,
    Widget? customBg,
    Gradient? gradient,
    PopupOnEvent? popupOnEvent,
  }) : super(
    key: key,
    useRipple: useRipple,
    rippleColor: rippleColor,
    blackRippleColor: blackRippleColor,
    onTap: onTap,
    onLongPress: onLongPress,
    onTapDown: onTapDown,
    onTapCancel: onTapCancel,
    width: width,
    height: height,
    isCircle: isCircle,
    bgColor: bgColor,
    borderRadius: borderRadius,
    padding: padding,
    isBlur: isBlur,
    blurColor: blurColor,
    blurSigmaX: blurSigmaX,
    blurSigmaY: blurSigmaY,
    decoration: decoration,
    border: border,
    boxShadow: boxShadow,
    margin: margin,
    inkShowPos: inkShowPos,
    alignment: alignment,
    enabled: enabled,
    customBg: customBg,
    gradient: gradient,
    popupOnEvent: popupOnEvent,
  );

  @override
  State<StatefulWidget> createState() {
    return _TextWidgetState();
  }

  @override
  bool isContentClip() {
    return false;
  }
}

class _TextWidgetState extends BaseCommonWidgetState<TextWidget> {
  @override
  Widget? buildContentWidget() {
    if (widget.spanList != null) {
      return Text.rich(
        TextSpan(
          children: widget.spanList,
        ),
        maxLines: widget.maxLines,
        style: widget.style,
        textAlign: widget.textAlign,
        overflow: widget.overflow,
        textScaleFactor: widget.textScaleFactor,
      );
    }
    String? text = widget.text;
    if (text == null) {
      return null;
    }
    return Text(
      text,
      maxLines: widget.maxLines,
      style: widget.style,
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
    );
  }

  @override
  Widget? buildContentPlaceholderWidget() {
    if (widget.lines == null || widget.lines! <= 0) {
      return null;
    }
    String? text = widget.text;
    if (text == null) {
      return null;
    }
    return Text(
      "$text",
      maxLines: widget.lines,
      style: widget.style?.copyWith(
        backgroundColor: Colors.transparent,
        color: Colors.transparent,
      ),
      textAlign: widget.textAlign,
      overflow: widget.overflow,
      textScaleFactor: widget.textScaleFactor,
    );
  }

}

class TextResSpan extends TextSpan {
  TextResSpan({
    String? text,
    String? textId,
    List? formatParams,
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) : super(
    text: text,
    style: style,
    recognizer: recognizer,
    semanticsLabel: semanticsLabel,
  );
}
