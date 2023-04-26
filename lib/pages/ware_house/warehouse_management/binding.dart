import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class WarehouseManagementBinding extends BaseBindings<WarehouseManagementController> {
  @override
  WarehouseManagementController getController() {
   return WarehouseManagementController();
  }

}