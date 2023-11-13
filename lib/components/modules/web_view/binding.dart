import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';


class WebViewBinding extends BaseBindings<WebViewController> {
  @override
  WebViewController getController() {
   return WebViewController();
  }

}