import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class FileBinding extends BaseBindings<FileController> {
  @override
  FileController getController() {
   return FileController();
  }

}