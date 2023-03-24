import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/text_high_light.dart';

class CommonWidget {
  static Widget commonCreateSubmitWidget({VoidCallback? draft,VoidCallback? submit}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: draft,
            child: Text(
              "存草稿",
              style: TextStyle(color: XColors.themeColor, fontSize: 16.sp),
            ),
          ),
          GestureDetector(
            onTap: submit,
            child: Container(
              width: 300.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: XColors.themeColor,
                borderRadius: BorderRadius.circular(4.w),
              ),
              alignment: Alignment.center,
              child: Text(
                "提交审批",
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget commonSubmitWidget({VoidCallback? submit,String text = "确定"}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: submit,
        child: Container(
          width: 300.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(4.w),
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }

  static Widget commonMultipleSubmitWidget({String str1 = "取消",String str2 = "确定",VoidCallback? onTap1,VoidCallback? onTap2}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: onTap1,
            child: Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4.w),
                border: Border.all(color: XColors.themeColor)
              ),
              alignment: Alignment.center,
              child: Text(
                str1,
                style: TextStyle(color: XColors.themeColor, fontSize: 16.sp),
              ),
            ),
          ),
          GestureDetector(
            onTap: onTap2,
            child: Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(4.w),
              ),
              alignment: Alignment.center,
              child: Text(
                str2,
                style: TextStyle(color: Colors.white, fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget commonDeleteWidget({VoidCallback? delete}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15.h),
      color: Colors.white,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: delete,
        child: Container(
          width: 300.w,
          height: 50.h,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.blueAccent,width: 0.5),
            borderRadius: BorderRadius.circular(4.w),
          ),
          alignment: Alignment.center,
          child: Text(
            "删除",
            style: TextStyle(color: Colors.blueAccent, fontSize: 16.sp),
          ),
        ),
      ),
    );
  }

  static Widget commonTextTile(String title, String content,
      {bool showLine = false,
      TextEditingController? controller,
      String? hint,
      int? maxLine,
        ValueChanged<String>? onSubmitted,
        ValueChanged<String>? onChanged,
      bool enabled = true,
      TextStyle? textStyle,
      bool required = false,List<TextInputFormatter>? inputFormatters}) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: showLine
                  ? Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                ),
                SizedBox(height: 10.h,),
                TextField(
                  controller: controller ?? TextEditingController(text: content),
                  maxLines: maxLine,
                  inputFormatters: inputFormatters,
                  enabled: enabled,
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                  style:
                      textStyle ?? TextStyle(color: Colors.black, fontSize: 20.sp),
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      hintText: hint,
                      hintStyle:
                          TextStyle(color: Colors.grey.shade300, fontSize: 20.sp),
                      border: InputBorder.none),
                ),
                SizedBox(height: 10.h,),
              ],
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          left: 10.w,
          child: required
              ? const Text(
            "*",
            style: TextStyle(color: Colors.red),
          )
              : Container(),
        ),
      ],
    );
  }

  static Widget commonChoiceTile(String title, String content,
      {bool showLine = false,
      String? hint,
      bool required = false,VoidCallback? onTap}) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 10.w, horizontal: 16.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: showLine
                  ? Border(
                      bottom: BorderSide(color: Colors.grey.shade200, width: 0.5))
                  : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: Colors.black, fontSize: 20.sp),
                ),
                GestureDetector(
                  onTap: onTap,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: content.isEmpty
                              ? Text(
                            hint ?? "请选择",
                                  style: TextStyle(
                                      color: Colors.grey.shade300,
                                      fontSize: 20.sp),
                                )
                              : Text(
                                  content,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20.sp),
                                ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 32.w,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          top: 5.h,
          left: 10.w,
          child: required
              ? const Text(
            "*",
            style: TextStyle(color: Colors.red),
          )
              : Container(),
        )
      ],
    );
  }

  static Widget commonAddDetailedWidget({VoidCallback? onTap,required String text}){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 25.h),
      width: double.infinity,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap:onTap,
        child: Container(
          color: Colors.white,
          width: 200.w,
          height: 50.h,
          alignment: Alignment.center,
          child: Text.rich(
             TextSpan(
              children: [
                const TextSpan(text: "+"),
                TextSpan(text: text),
              ],
            ),
            style: TextStyle(color: Colors.blue, fontSize: 20.sp),
          ),
        ),
      ),
    );
  }

  static Widget commonSearchBarWidget(
      {TextEditingController? controller,
      ValueChanged<String>? onSubmitted,
        ValueChanged<String>? onChanged,
      String hint = "",
      bool showLine = false,
      Color? backgroundColor,
      Color? searchColor,
      EdgeInsetsGeometry? margin,
      EdgeInsetsGeometry? padding}) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? XColors.white,
        border: showLine
            ? Border(bottom: BorderSide(color: Colors.grey.shade300))
            : null,
      ),
      child: Container(
        margin:
            margin ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        padding: padding,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 10.h),
          decoration: BoxDecoration(
              color: searchColor ?? Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.w)),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  textInputAction: TextInputAction.done,
                  onSubmitted: onSubmitted,
                  onChanged:onChanged ,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    hintText: hint,
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(width: 5.w,),
              Image.asset(Images.searchIcon,width: 28.w,height: 28.w,),
            ],
          ),
        ),
      ),
    );
  }

  static commonRadioTextWidget<T>(String name, T value,
      {T? groupValue, ValueChanged<T?>? onChanged,String? keyWord}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5.h,horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        children: [
          Radio<T>(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
          TextHighlight(content: name,keyWord: keyWord,normalStyle: TextStyle(fontSize: 16.sp,color: Colors.black87),highlightStyle: TextStyle(fontSize: 18.sp,color: Colors.black),)
        ],
      ),
    );
  }

  static commonHeadInfoWidget(String info,{Widget? action,EdgeInsetsGeometry? padding}){
    return Padding(
      padding: padding??EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              children: [
                WidgetSpan(
                    child: Container(
                      width: 5.w,
                      height: 25.h,
                      margin: EdgeInsets.only(right: 15.w),
                      color: XColors.themeColor,
                    ),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(
                    text: info,
                    style: TextStyle(fontSize: 20.sp, color: Colors.black))
              ],
            ),
          ),
          action??Container(),
        ],
      ),
    );
  }

  static commonTextContentWidget(String text,String content,{double textSize = 20,double contentSize = 20,EdgeInsetsGeometry? padding,Color? color}){
    return Container(
      padding: padding??EdgeInsets.symmetric(vertical: 15.h),
      width: double.infinity,
      decoration: BoxDecoration(
          color: color,
          border: Border(
              bottom: BorderSide(color: Colors.grey.shade300, width: 0.5))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.grey, fontSize: textSize.sp),
          ),
          Text(
            content,
            style: TextStyle(
                color: Colors.black,
                fontSize: contentSize.sp,
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  static commonMultipleChoiceButtonWidget(
      {bool isSelected = false, ValueChanged<bool>? changed}) {
    return GestureDetector(
      child: isSelected
          ? Icon(
              CupertinoIcons.smallcircle_fill_circle_fill,
              size: 32.w,
              color: Colors.blue,
            )
          : Icon(
              Icons.radio_button_off,
              size: 32.w,
            ),
      onTap: () {
        if (changed != null) {
          changed!(!isSelected);
        }
      },
    );
  }

  static commonShowChoiceDataInfo(String text,{VoidCallback? onTap}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "已选择:",
                style: TextStyle(color: Colors.grey.shade500),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                text,
                style: TextStyle(
                    color: XColors.themeColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 150.w,
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: XColors.themeColor,
                  borderRadius: BorderRadius.circular(4.w)),
              child: Text(
                "确定",
                style: TextStyle(color: Colors.white, fontSize: 22.sp),
              ),
            ),
          )
        ],
      ),
    );
  }

  static Widget commonIconButtonWidget(
      {required String iconPath,
      VoidCallback? callback,
      double size = 30,
      Color color = Colors.white,
      String? tips,
      MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center}) {
    Widget icon = Image.asset(
      iconPath,
      color: color,
      height: size.w,
      width: size.w,
    );
    if (tips != null) {
      return GestureDetector(
        onTap: callback,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: [
              icon,
              SizedBox(
                width: 10.w,
              ),
              Text(
                tips,
                style: TextStyle(color: color, fontSize: 18.sp),
              ),
            ],
          ),
        ),
      );
    }

    return IconButton(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      constraints: BoxConstraints(maxHeight: 64.w, maxWidth: 64.w),
      onPressed: callback,
      icon: icon,
    );
  }
}
