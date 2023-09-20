import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'base_controller.dart';
import 'base_get_state.dart';

abstract class BaseGetView<T extends BaseController, S extends BaseGetState>
    extends GetView<T> {
  const BaseGetView({super.key});

  S get state => controller.state as S;
  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    controller.context = context;
    return buildView();
  }

  Widget buildView();
}
