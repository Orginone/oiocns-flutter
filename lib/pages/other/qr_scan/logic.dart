import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'state.dart';

class QrScanController extends BaseController<QrScanState> {
 final QrScanState state = QrScanState();


 @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();

  }

}
