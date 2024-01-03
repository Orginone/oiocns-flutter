

import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class FileReaderState extends BaseGetState{
  late FileItemShare file;

  FileReaderState(){
    file = Get.arguments['file'];
  }
}