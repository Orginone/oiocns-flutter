/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-15 15:05:37
 * @LastEditors: 
 * @LastEditTime: 2022-12-15 16:21:22
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../text_utils.dart';

/// 系统工具类
class SystemUtils {
  /// 拷贝文本内容到剪切板
  static bool copyToClipboard(String? text,
      {String? successMessage, BuildContext? context}) {
    if (StringUtils.isNotEmpty(text!)) {
      Clipboard.setData(ClipboardData(text: text));
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: const Duration(seconds: 1),
            content: Text(successMessage ?? "copy success")));
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  /// 隐藏软键盘，具体可看：TextInputChannel
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// 展示软键盘，具体可看：TextInputChannel
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// 清除数据
  static void clearClientKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.clearClient');
  }
}
