import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orginone/common/index.dart';

/// TextFormField 表单 输入框
class TextFormWidget extends StatefulWidget {
  /// 控制器
  final TextEditingController? controller;

  ///焦点
  final FocusNode? focusNode;

  /// 输入框样式
  final InputDecoration? decoration;

  /// 验证函数
  final String? Function(String?)? validator;

  /// 自动焦点
  final bool? autofocus;

  /// 标题
  final String? labelText;

  /// 必须输入
  final bool? isMustBeEnter;

  /// 是否密码
  final bool? isObscure;

  /// 是否只读
  final bool? readOnly;

  /// 输入法类型
  final TextInputType? keyboardType;

  /// 输入格式定义
  final List<TextInputFormatter>? inputFormatters;

  /// 提示文字
  final String? hintText;
  //左边的icon
  final Widget? prefixIcon;
  //边框
  final InputBorder? border;

  /// 点击事件
  final Function()? onTap;

  /// 内容改变的回调
  final ValueChanged<String>? onChanged;

  ///按回车时调用
  final VoidCallback? onEditingComplete;

  ///内容提交(按回车)的回调
  final ValueChanged<String>? onFieldSubmitted;

  final FormFieldSetter<String>? onSaved;
  const TextFormWidget({
    Key? key,
    this.controller,
    this.autofocus = false,
    this.labelText,
    this.isMustBeEnter = false,
    this.validator,
    this.isObscure = false,
    this.decoration,
    this.keyboardType,
    this.inputFormatters,
    this.readOnly = false,
    this.onTap,
    this.hintText,
    this.prefixIcon,
    this.border,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.focusNode,
  }) : super(key: key);

  @override
  _TextFormWidgetState createState() => _TextFormWidgetState();
}

class _TextFormWidgetState extends State<TextFormWidget> {
  // 是否显示明文按钮
  bool _isShowObscureIcon = false;

  @override
  void initState() {
    super.initState();
    _isShowObscureIcon = widget.isObscure!;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTap: () => {if (widget.onTap != null) widget.onTap!()}, // 点击事件
      onChanged: (String string) => {
        if (widget.onChanged != null) widget.onChanged!(string)
      }, //widget.onChanged, // 点击事件
      onEditingComplete: () => {
        if (widget.onEditingComplete != null) widget.onEditingComplete!()
      }, // 点击事件
      onFieldSubmitted: (String string) => {
        if (widget.onFieldSubmitted != null) widget.onFieldSubmitted!(string)
      }, // 点击事件
      onSaved: (String? string) =>
          {if (widget.onSaved != null) widget.onSaved!(string)}, // 点击事件
      readOnly: widget.readOnly!, // 是否只读
      autofocus: widget.autofocus!, // 自动焦点
      focusNode: widget.focusNode,
      keyboardType: widget.keyboardType, // 输入法类型
      controller: widget.controller, // 控制器
      decoration: widget.isObscure == true
          ? InputDecoration(
              hintText: widget.hintText, // 提示文字
              // 标题
              labelText: widget.isMustBeEnter == true
                  ? "* ${widget.labelText}"
                  : widget.labelText,
              // 密码按钮
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _isShowObscureIcon = !_isShowObscureIcon;
                  });
                },
                icon: Icon(
                  _isShowObscureIcon == true
                      ? Icons.visibility
                      : Icons.visibility_off,
                  size: 15,
                  color: AppColors.surfaceVariant,
                ),
              ),
              prefixIcon: widget.prefixIcon,
              border: widget.border,
            )
          : InputDecoration(
              hintText: widget.hintText,
              labelText: widget.isMustBeEnter == true
                  ? "* ${widget.labelText}"
                  : widget.labelText,
              prefixIcon: widget.prefixIcon,
              border: widget.border,
            ),
      // 校验
      validator: widget.validator,
      // 是否密码
      obscureText: _isShowObscureIcon,
      // 输入格式
      inputFormatters: widget.inputFormatters,
    );
  }
}
