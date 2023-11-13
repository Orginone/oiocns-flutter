/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-01 15:51:34
 * @LastEditors: 
 * @LastEditTime: 2022-12-01 18:35:02
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/config/index.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'picker.dart';

/// 选取图片 view
class PickerImageWidget extends StatelessWidget {
  /// 返回拍摄图片
  final Function(AssetEntity? result)? onTapTake;

  /// 返回相册图片
  final Function(List<AssetEntity>? result)? onTapAlbum;

  const PickerImageWidget({
    Key? key,
    this.onTapTake,
    this.onTapAlbum,
  }) : super(key: key);

  // 主视图
  _buildView() {
    return <Widget>[
      // 拍照
      ButtonWidget.primary(
        LocaleKeys.pickerTakeCamera.tr,
        icon: IconWidget.icon(Icons.photo_camera,
            color: Colors.red //AppColors.onPrimary,
            ),
        onTap: onTapTake == null
            ? null
            : () async {
                var result = await ActionPicker.camera(
                  context: Get.context!,
                  enableRecording: false,
                );
                onTapTake!(result);
                Get.back();
              },
      ).paddingBottom(AppSpace.listRow),

      // 相册
      ButtonWidget.secondary(
        LocaleKeys.pickerSelectAlbum.tr,
        icon: IconWidget.icon(
          Icons.photo_library,
          color: AppColors.primary,
        ),
        onTap: onTapAlbum == null
            ? null
            : () async {
                var result = await ActionPicker.assets(
                  context: Get.context!,
                  type: RequestType.image,
                );
                onTapAlbum!(result);
                Get.back();
              },
      ).paddingBottom(AppSpace.listRow),

      // 返回
      ButtonWidget.text(
        LocaleKeys.commonBottomCancel.tr,
        onTap: () => Get.back(),
      ),
    ]
        .toColumn(
          mainAxisSize: MainAxisSize.min,
        )
        .paddingAll(AppSpace.card)
        .backgroundColor(AppColors.background);
  }

  @override
  Widget build(BuildContext context) {
    return _buildView();
  }
}
