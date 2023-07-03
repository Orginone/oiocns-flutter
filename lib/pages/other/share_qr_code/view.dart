import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';
import 'state.dart';

class ShareQrCodePage
    extends BaseGetView<ShareQrCodeController, ShareQrCodeState> {
  @override
  Widget buildView() {
    var image = state.entity.avatarThumbnail();
    return GyScaffold(
      titleName: state.entity.name!,
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.center,
        child: QrImage(
          data: '${Constant.host}/${state.entity.id}',
          version: QrVersions.auto,
          size: 400.w,
          embeddedImage: image != null ? MemoryImage(image) : null,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          embeddedImageStyle: QrEmbeddedImageStyle(size: Size(80.w, 80.w)),
        ),
      ),
    );
  }
}
