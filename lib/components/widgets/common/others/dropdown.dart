/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-30 10:26:34
 * @LastEditors: 
 * @LastEditTime: 2022-11-30 10:27:35
 */
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';

/// 下拉菜单
class DropdownWidget extends StatelessWidget {
  /// 点击菜单
  final Function(KeyValueModel? val)? onChanged;
  final Function(bool isOpen)? onMenuStateChange;

  /// 数据项列表
  final List<KeyValueModel>? items;

  /// 选中数据值
  final KeyValueModel? selectedValue;

  /// 提示文字
  final String? hintText;

  /// 提示文字
  final Color? hintTextColor;

  /// 图标颜色
  final Color? iconColor;

  /// 按钮 padding
  final EdgeInsetsGeometry? buttonPadding;
  final bool needIcon;
  final TextAlign? textAlign;

  const DropdownWidget({
    Key? key,
    this.items,
    this.selectedValue,
    this.hintText,
    this.onChanged,
    this.buttonPadding,
    this.iconColor,
    this.onMenuStateChange,
    this.needIcon = true,
    this.hintTextColor,
    this.textAlign,
  }) : super(key: key);

  Widget _buildView() {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<KeyValueModel>(
        // 扩展
        isExpanded: true,
        // 提示组件
        hint: Row(
          children: [
            Expanded(
              child: TextWidget.body1(
                hintText ?? 'Select Item',
                textAlign: textAlign ?? TextAlign.end,
                color: hintTextColor ?? AppColors.primary,
              ),
            ),
          ],
        ),
        // 下拉项列表
        items: items
            ?.map((item) => DropdownMenuItem<KeyValueModel>(
                  value: item,
                  child: TextWidget.body1(item.value),
                ))
            .toList(),
        // 选中项
        value: selectedValue,
        // dropdownOverButton: true,
        // 改变事件
        onChanged: onChanged,
        onMenuStateChange: (isOpen) => onMenuStateChange?.call(isOpen),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
