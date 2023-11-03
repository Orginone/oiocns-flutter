/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-09 14:02:24
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-12 17:15:37
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 对话框
class ActionDialog {
  static Future normal({
    required BuildContext context,
    Widget? title, // 标题
    Widget? content, // 内容
    Widget? confirm, // 确认按钮
    Widget? cancel, // 取消按钮
    String? cancelTitle, //取消按钮标题
    String? confirmTitle, //取消按钮标题
    Color? confirmBackgroundColor, // 确认按钮背景色
    Function()? onConfirm, // 确认按钮回调
    Function()? onCancel, // 取消按钮回调
  }) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.all(AppSpace.card),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // 标题
                DefaultTextStyle(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                  child: title != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: title,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text("温馨提示"),
                        ),
                ),

                // 内容
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: DefaultTextStyle(
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                    child: content ?? Text(LocaleKeys.commonBottomRemove.tr),
                  ),
                ),
                SizedBox(height: AppSpace.listRow),

                // 取消 确认
                Row(
                  children: [
                    Expanded(
                      child: ButtonWidget.textRoundFilled(
                        cancelTitle ?? LocaleKeys.commonBottomCancel.tr,
                        height: AppSpace.normalButtonHeight,
                        borderRadius: 5,
                        bgColor: confirmBackgroundColor ?? AppColors.lightGray,
                        onTap: () {
                          Get.back(closeOverlays: true);
                          if (onCancel != null) onCancel();
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: ButtonWidget.textRoundFilled(
                        confirmTitle ?? LocaleKeys.commonBottomConfirm.tr,
                        borderRadius: 5,
                        height: AppSpace.normalButtonHeight,
                        bgColor: confirmBackgroundColor ?? AppColors.primary,
                        onTap: () {
                          Get.back(closeOverlays: true);
                          if (onConfirm != null) onConfirm();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
