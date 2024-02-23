import 'package:orginone/dart/core/getx/base_bindings.dart';

import 'logic.dart';

class Demo1Binding extends BaseBindings<Demo1Controller> {
  @override
  Demo1Controller getController() {
    return Demo1Controller();
  }
}
