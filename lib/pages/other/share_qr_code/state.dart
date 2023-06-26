


import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class ShareQrCodeState extends BaseGetState{
  late XEntity entity;

  ShareQrCodeState(){
    entity = Get.arguments['entity'];
  }
}