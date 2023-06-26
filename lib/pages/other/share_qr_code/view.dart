import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
      body: QrImage(
        data: '${Constant.host}/${state.entity.id}',
        version: QrVersions.auto,
        size:Get.width,
        embeddedImage: image!=null?MemoryImage(image):null,
      ),
    );
  }
}
