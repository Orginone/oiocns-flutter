import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/extension/index.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/text_widget.dart';

import 'logic.dart';
import 'state.dart';

class ShareQrCodePage
    extends BaseGetView<ShareQrCodeController, ShareQrCodeState> {
  const ShareQrCodePage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: '我的二维码',
        backgroundColor: GYColors.backgroundColor,
        body: buildMainView());
  }

  Widget buildMainView() {
    return <Widget>[
      buildUserQrInfoView(),
      buildActions().paddingHorizontal(GYSpace.paragraph)
    ].toColumn();
  }

  Widget buildUserQrInfoView() {
    return Container(
      padding: EdgeInsets.only(
          top: GYSpace.paragraph * 2,
          bottom: GYSpace.paragraph,
          left: GYSpace.paragraph,
          right: GYSpace.paragraph),
      child: RepaintBoundary(
          key: controller.globalKey,
          child: <Widget>[
            infoView(),
            buildQRImageView().paddingTop(GYSpace.paragraph),
            buildTipTextView().paddingTop(GYSpace.card),
          ]
              .toColumn()
              .paddingAll(GYSpace.paragraph)
              .card(color: GYColors.white)),
    );
  }

  /// 用户信息相关
  Widget infoView() {
    var image = state.entity.avatarThumbnail();
    return <Widget>[
      ImageWidget(image, size: 60.w, fit: BoxFit.fill, radius: 5.w)
          .paddingRight(GYSpace.listItem),
      <Widget>[
        TextWidget(
          text: state.entity.name ?? '',
          style: GYTextStyles.titleMedium,
        ),
        Text(
          state.entity.remark ?? '',
          style: GYTextStyles.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ).width(300.w).paddingTop(GYSpace.button),
      ].toColumn(crossAxisAlignment: CrossAxisAlignment.start)
    ].toRow();
  }

  ///二维码
  Align buildQRImageView() {
    var image = state.entity.avatarThumbnail();
    return const Align(
      alignment: Alignment.center,
      // child: QrImage(
      //   data: '${Constant.host}/${state.entity.id}',
      //   version: QrVersions.auto,
      //   size: 330.w,
      //   embeddedImage: image != null ? MemoryImage(image) : null,
      //   errorCorrectionLevel: QrErrorCorrectLevel.H,
      //   embeddedImageStyle: QrEmbeddedImageStyle(size: Size(60.w, 60.w)),
      //   dataModuleStyle: const QrDataModuleStyle(
      //     dataModuleShape: QrDataModuleShape.square,
      //     color: Colors.black,
      //   ),
      //   eyeStyle: const QrEyeStyle(
      //     eyeShape: QrEyeShape.square,
      //     color: Colors.black,
      //   ),
      // ),
    );
  }

  ///提示语
  TextWidget buildTipTextView() {
    return const TextWidget(
      text: '扫一扫上面的二维码图案，一起分享吧',
      style: TextStyle(
        color: GYColors.gray_99,
        fontSize: 12,
      ),
    );
  }

  Widget buildActions() {
    return <Widget>[
      buildButton(
          iconData: Icons.qr_code_scanner_sharp,
          title: '扫一扫',
          onTap: () => controller.scan(),
          color: GYColors.green),
      buildButton(
          iconData: Icons.share_sharp,
          title: '分享到好友/群',
          onTap: () => controller.share(),
          color: GYColors.blue),
      buildButton(
          iconData: Icons.download_sharp,
          title: '保存到手机',
          onTap: () => controller.save(),
          color: GYColors.green),
    ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween);
  }

  buildButton(
      {required String title,
      required IconData iconData,
      required Color color,
      required Function onTap}) {
    return <Widget>[
      Icon(
        iconData,
        color: color,
      ).paddingAll(GYSpace.listRow + 3).card(color: GYColors.white),
      TextWidget(
        text: title,
        style: GYTextStyles.bodySmall,
      ).paddingTop(GYRadius.button)
    ].toColumn().onTap(() => onTap());
  }
}
