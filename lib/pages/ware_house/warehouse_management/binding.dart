import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class WarehouseManagementBinding extends BaseBindings<WareHouseManagementController> {
  @override
  WareHouseManagementController getController() {
   return WareHouseManagementController();
  }

}