import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../index.dart';

/// 底部弹出对话框
class ActionBottomSheet {
  // 头部
  static Widget _buildHeader({
    /// 标题
    String? title,

    /// 确认事件
    Function()? onConfirm,
  }) {
    return <Widget>[
      // title
      TextWidget.title2(title ?? '').expanded(),

      // done 按钮
      ButtonWidget.text(
        LocaleKeys.commonBottomApply.tr,
        onTap: onConfirm,
      ),
    ].toRow().padding(
          left: 10,
          top: 10,
          right: 10,
        );
  }

  /// 数据对话框
  static void data({
    /// 上下文 context
    required BuildContext context,

    /// 确认事件
    required Function(List value) onConfirm,

    /// 选取器数据适配器
    required PickerAdapter adapter,

    /// 标题
    String? title,

    /// 默认选中 [index]
    List<int>? selecteds,
  }) {
    // 准备 picker
    var picker = ActionPicker.array(
      adapter: adapter,
      selecteds: selecteds,
    );

    // 调用 标准模式框
    normal(
      context: context,
      contentPadding: const EdgeInsets.all(0),
      child: <Widget>[
        // 头部栏
        _buildHeader(
          title: title,
          onConfirm: () {
            picker.doConfirm(context);
            onConfirm(picker.adapter.getSelectedValues());
          },
        ),
        // picker 内容
        picker.makePicker(),
      ].toColumn(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  // 标准 - 底部弹出 - 模式对话框
  static Future<void> normal({
    required BuildContext context,
    Widget? child,
    EdgeInsetsGeometry? contentPadding,
    bool enableDrag = true,
  }) async {
    /// 弹出底部模式对话框
    return await showMaterialModalBottomSheet(
      // 上下文 context
      context: context,
      // 背景透明
      backgroundColor: Colors.transparent,
      // 启用拖拽
      enableDrag: enableDrag,
      // 内容
      builder: (context) => SafeArea(
        minimum: const EdgeInsets.all(10),
        child: AnimatedPadding(
          padding: MediaQuery.of(context).viewInsets,
          duration: const Duration(milliseconds: 150),
          child: Container(
            padding: contentPadding ?? const EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            // 弹出视图内容区
            child: child,
          ),
        ),
      ),
    );
  }

  // Bar 对话框
  static Future<void> barModel(
    Widget child, {
    BuildContext? context,
    double? padding,
    bool enableDrag = true,
  }) async {
    /// 弹出底部模式对话框
    return await showBarModalBottomSheet(
      // 上下文 context
      context: context ?? Get.context!,
      // 背景透明
      backgroundColor: Colors.transparent,
      // 启用拖拽
      enableDrag: enableDrag,
      // expand
      expand: false,
      // 内容
      builder: (context) => SafeArea(
        child: child,
      ),
      // builder: (context) =>
      // SafeArea(child: child.paddingAll(padding ?? AppSpace.card)
      // .decorated(
      // color: AppColors.background,
      // borderRadius: BorderRadius.circular(AppRadius.sheet),
      // )
      // .clipRRect(
      //   clipBehavior: Clip.antiAlias,
      //   topLeft: AppRadius.sheet,
      //   topRight: AppRadius.sheet,
      // ),
      // ),
    );
  }

  // 底部弹出 popModal
  static Future<void> popModal({
    BuildContext? context,
    required Widget child,
    EdgeInsetsGeometry? contentPadding,
    EdgeInsets? safeAreaMinimum,
  }) async {
    return await showMaterialModalBottomSheet(
      context: context ?? Get.context!,
      backgroundColor: Colors.transparent,
      builder: (context) => SafeArea(
        minimum: safeAreaMinimum ?? EdgeInsets.zero,
        child: child,
      ),
    );
  }
}
