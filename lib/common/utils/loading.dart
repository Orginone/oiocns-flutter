/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-11-26 11:01:40
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-13 22:50:48
 */
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:orginone/common/index.dart';

/// 提示框
class Loading {
  static const int _milliseconds = 500; // 提示 延迟毫秒, 提示体验 秒关太快
  static const int _dismissMilliseconds = 1000; // dismiss 延迟毫秒

  Loading() {
    EasyLoading.instance
      ..displayDuration =
          const Duration(milliseconds: _dismissMilliseconds) // 关闭延迟
      ..indicatorType = EasyLoadingIndicatorType.ring // 指示器类型
      ..loadingStyle = EasyLoadingStyle.custom // loading样式 自定义
      ..indicatorSize = 35.0 // 指示器大小
      ..lineWidth = 2 // 进度条宽度
      ..radius = 10.0 // 圆角
      ..progressColor = Colors.white // 进度条颜色
      ..backgroundColor = Colors.black.withOpacity(0.7) // 背景颜色
      ..indicatorColor = AppColors.primary // 指示器颜色
      ..textColor = AppColors.primary // 文字颜色
      ..maskColor = Colors.black.withOpacity(0.6) // 遮罩颜色
      ..userInteractions = true // 用户交互
      ..dismissOnTap = false; // 点击关闭
  }

  // 显示
  static void show([String? text]) {
    EasyLoading.instance.userInteractions = false; // 屏蔽交互操作
    EasyLoading.show(status: text ?? '加载中...');
  }

  // 错误
  static void error([String? text]) {
    Future.delayed(
      const Duration(milliseconds: _milliseconds),
      () => EasyLoading.showError(text ?? 'Error',
          duration: const Duration(milliseconds: _milliseconds + 1000)),
    );
  }

  // 成功
  static void success([String? text]) {
    Future.delayed(
      const Duration(milliseconds: _milliseconds),
      () => EasyLoading.showSuccess(text ?? '成功'),
    );
  }

  // toast
  static void toast(String text, {Duration? duration}) {
    EasyLoading.showToast(text, duration: duration);
  }

  // 关闭
  static Future<void> dismiss() async {
    await Future.delayed(
      const Duration(milliseconds: _dismissMilliseconds),
      () {
        EasyLoading.instance.userInteractions = true; // 恢复交互操作
        EasyLoading.dismiss();
      },
    );
  }
}
