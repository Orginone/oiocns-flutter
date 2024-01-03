import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orginone/config/index.dart';

import '../index.dart';

enum InputWidgetType {
  none,
  text, // 文字
  textBorder, // 边框
  textFilled, // 填充/边框
  iconTextFilled, // 图标/文本/填充/边框
  suffixTextFilled, // 后缀图标/文本/填充/边框
  search, // 搜索
}

/// 输入框
class InputWidget extends StatelessWidget {
  /// 输入框类型
  final InputWidgetType type;

  /// 事件 - 提交
  final Function(String)? onSubmitted;

  /// 事件 - tap
  final Function()? onTap;

  /// 事件 - change
  final Function(String)? onChanged;

  /// 输入控制器
  final TextEditingController? controller;

  /// 焦点
  final FocusNode? focusNode;

  /// 输入框提示文字
  final String? hintText;

  /// 键盘类型
  final TextInputType? keyboardType;

  /// 圆角
  final double? borderRadius;

  /// 密码
  final bool isObscureText;

  /// 是否自动获取焦点
  final bool autofocus;

  /// 只读
  final bool readOnly;

  /// 禁用输入
  final bool enabled;

  /// 最大行数
  final int? maxLines;

  /// 最小行数
  final int? minLines;

  /// 字体
  final double? fontSize;

  /// 图标
  final Widget? icon;
  final Widget? suffixIcon;

  /// 输入框确认操作方式
  final TextInputAction? textInputAction;

  /// 输入验证
  final List<TextInputFormatter>? inputFormatters;

  /// 填充颜色
  final Color? fillColor;

  /// 边框颜色
  final Color? borderColor;

  /// 内容 padding
  final EdgeInsetsGeometry? contentPadding;

  final TextAlign? textAlign;

  const InputWidget({
    Key? key,
    this.type = InputWidgetType.none,
    this.onSubmitted,
    this.controller,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.maxLines,
    this.minLines,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.fillColor,
    this.suffixIcon,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.onChanged,
    this.textAlign,
    this.autofocus = false,
    this.enabled = true,
  }) : super(key: key);

  /// 文本输入
  const InputWidget.text({
    Key? key,
    this.type = InputWidgetType.text,
    this.controller,
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.fillColor,
    this.suffixIcon,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.onChanged,
    this.textAlign,
    this.enabled = true,
  }) : super(key: key);

  /// 文本输入 - 边框
  const InputWidget.textBorder({
    Key? key,
    this.type = InputWidgetType.textBorder,
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.fillColor,
    this.suffixIcon,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.controller,
    this.onChanged,
    this.textAlign,
    this.enabled = true,
  }) : super(key: key);

  /// 文本输入 - 填充
  InputWidget.textFilled({
    Key? key,
    this.type = InputWidgetType.textFilled,
    Color? fillColor, // 输入颜色
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.icon,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.suffixIcon,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.onChanged,
    this.controller,
    this.textAlign,
    this.enabled = true,
  })  : fillColor = fillColor ?? AppColors.surface.withOpacity(0.5),
        super(key: key);

  /// 文本输入 - 图标文本填充
  InputWidget.iconTextFilled(
    this.icon, {
    Key? key,
    this.type = InputWidgetType.iconTextFilled,
    Color? fillColor, // 输入颜色
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.suffixIcon,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.onChanged,
    this.controller,
    this.textAlign,
    this.enabled = true,
  })  : fillColor = fillColor ?? AppColors.surface.withOpacity(0.5),
        super(key: key);

  /// 文本输入 - 后缀图标文本填充
  InputWidget.suffixTextFilled(
    this.suffixIcon, {
    Key? key,
    this.type = InputWidgetType.suffixTextFilled,
    Color? fillColor, // 输入颜色
    this.icon,
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.contentPadding,
    this.borderColor,
    this.borderRadius,
    this.onChanged,
    this.controller,
    this.textAlign,
    this.enabled = true,
  })  : fillColor = fillColor ?? AppColors.surface.withOpacity(0.5),
        super(key: key);

  /// 搜索
  InputWidget.search({
    Key? key,
    this.type = InputWidgetType.search,
    Color? fillColor, // 输入颜色
    Widget? icon,
    this.suffixIcon,
    this.onSubmitted,
    this.focusNode,
    this.hintText,
    this.keyboardType,
    this.isObscureText = false,
    this.onTap,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.textInputAction,
    this.fontSize,
    this.inputFormatters,
    this.contentPadding,
    this.borderColor,
    this.borderRadius = 11,
    this.onChanged,
    this.controller,
    this.textAlign,
    this.enabled = true,
  })  : icon = icon ??
            IconWidget.icon(
              Icons.search,
              color: AppColors.outline,
            ),
        fillColor = fillColor ?? AppColors.surface.withOpacity(0.5),
        super(key: key);

  // 边框
  InputBorder? get _border {
    switch (type) {
      case InputWidgetType.none:
      case InputWidgetType.text:
        return InputBorder.none;
      default:
        return OutlineInputBorder(
          borderSide:
              BorderSide(color: borderColor ?? AppColors.surfaceVariant),
          borderRadius: BorderRadius.all(
              Radius.circular(borderRadius ?? AppRadius.input)),
        );
    }
  }

  // 尾部图标
  Widget? get _suffixIcon {
    switch (type) {
      case InputWidgetType.search:
        return <Widget>[
          Container(
            width: 1,
            height: 16,
            color: AppColors.surfaceVariant,
          ).paddingRight(AppSpace.iconTextSmail),
          suffixIcon ??
              IconWidget.icon(
                Icons.photo_camera_outlined,
                color: AppColors.outline,
              )
        ].toRow().width(30).paddingRight(5);
      default:
        return suffixIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    var inputBorder = _border;
    return TextField(
      onTap: onTap,
      readOnly: readOnly,
      autocorrect: false,
      obscureText: isObscureText,
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      maxLines: maxLines,
      enabled: enabled,
      minLines: minLines,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      textInputAction: textInputAction,
      textAlign: textAlign ?? TextAlign.start,
      style: AppTextStyles.bodyText1?.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w500,
        color: AppColors.secondary,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        fillColor: fillColor ?? Colors.transparent,
        prefixIcon: icon,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 0,
        ),
        suffixIcon: _suffixIcon,
        suffixIconConstraints: const BoxConstraints(
          minWidth: 30,
          minHeight: 0,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.bodyText2?.copyWith(
          fontWeight: FontWeight.w300,
          color: AppColors.secondary.withOpacity(0.5),
        ),
        contentPadding: contentPadding ?? AppSpace.edgeInput,
        isCollapsed: true,
        isDense: true,
        filled: true,
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        errorBorder: inputBorder,
        focusedErrorBorder: inputBorder,
        disabledBorder: inputBorder,
      ),
    );
  }
}
