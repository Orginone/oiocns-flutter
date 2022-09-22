import 'package:get/get.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanningController extends GetxController {
  Barcode? result;
  QRViewController? qrController;

  onQRViewCreated(QRViewController qrController) {
    qrController = qrController;
    qrController.scannedDataStream.listen((scanData) {
      result = scanData;
      update();
    });
  }
}
