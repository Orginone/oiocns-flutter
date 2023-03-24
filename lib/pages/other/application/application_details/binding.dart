import 'package:get/get.dart';

import '../../../../dart/core/getx/base_bindings.dart';
import 'logic.dart';

class ApplicationDetailsBinding extends BaseBindings<ApplicationDetailsController> {
  @override
  ApplicationDetailsController getController() {
   return ApplicationDetailsController();
  }

}
