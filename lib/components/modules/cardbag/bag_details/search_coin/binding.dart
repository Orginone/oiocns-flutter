import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class SearchCoinBinding extends BaseBindings<SearchCoinController> {
  @override
  SearchCoinController getController() {
   return SearchCoinController();
  }

}