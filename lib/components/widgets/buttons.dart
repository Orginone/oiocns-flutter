import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultOutlinedButton extends OutlinedButton {
  DefaultOutlinedButton(String title,
      {Key? key, required VoidCallback? onPressed})
      : super(
      key: key,
      onPressed: onPressed,
      child: Text(
        title,
        style:  TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: Colors.black87),
      ));
}

class DefaultElevatedButton extends ElevatedButton {
  DefaultElevatedButton(String title,
      {Key? key, required VoidCallback? onPressed})
      : super(
      key: key,
      onPressed: onPressed,
      child: Text(
        title,
        style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ));
}

SizedBox outlinedButton(
    String title, {
      Key? key,
      required VoidCallback? onPressed,
      VoidCallback? onLongPress,
      ValueChanged<bool>? onHover,
      ValueChanged<bool>? onFocusChange,
      ButtonStyle? style,
      FocusNode? focusNode,
      bool autofocus = false,
      double? height,
      Clip clipBehavior = Clip.none,
      TextStyle? textStyle,
    }) {
  return SizedBox(
      height: height??56.h,
      child: OutlinedButton(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        style: style,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: Text(
          title,
          style: textStyle??TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.black87),
        ),
      ));
}

SizedBox elevatedButton(
    String title, {
      Key? key,
      required VoidCallback? onPressed,
      VoidCallback? onLongPress,
      ValueChanged<bool>? onHover,
      ValueChanged<bool>? onFocusChange,
      ButtonStyle? style,
      FocusNode? focusNode,
      bool autofocus = false,
      Clip clipBehavior = Clip.none,
    }) {
  return SizedBox(
    height: 65.h,
    child: ElevatedButton(
      key: key,
      onPressed: onPressed,
      onLongPress: onLongPress,
      onHover: onHover,
      onFocusChange: onFocusChange,
      style: style,
      focusNode: focusNode,
      autofocus: autofocus,
      clipBehavior: clipBehavior,
      child: Text(
        title,
        style:  TextStyle(
            fontWeight: FontWeight.bold, fontSize: 16.sp, color: Colors.white),
      ),
    ),
  );
}
