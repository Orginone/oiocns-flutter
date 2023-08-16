import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanState extends BaseGetState {
  var platformVersion = ''.obs;

  var qrcode = ''.obs;
}
