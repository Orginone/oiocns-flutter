import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class SearchBinding extends BaseBindings<SearchController> {
  @override
  SearchController getController() {
   return SearchController();
  }

}
