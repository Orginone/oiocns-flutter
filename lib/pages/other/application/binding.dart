import 'package:get/get.dart';

import '../../../dart/core/getx/base_bindings.dart';
import 'logic.dart';

class ApplicationBinding extends BaseBindings<ApplicationController> {
  @override
  ApplicationController getController() {
   return ApplicationController();
  }

}