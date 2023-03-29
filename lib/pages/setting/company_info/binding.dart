import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';


class CompanyInfoBinding extends BaseBindings<CompanyInfoController> {
  @override
  CompanyInfoController getController() {
   return CompanyInfoController();
  }

}