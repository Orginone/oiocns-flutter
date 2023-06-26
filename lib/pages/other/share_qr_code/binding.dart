import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class ShareQrCodeBinding extends BaseBindings<ShareQrCodeController> {
  @override
  ShareQrCodeController getController() {
   return ShareQrCodeController();
  }

}