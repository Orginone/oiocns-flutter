import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import 'base_controller.dart';
import 'base_get_state.dart';

abstract class BaseGetPageView<T extends BaseController,S extends BaseGetState> extends StatelessWidget{

  late T controller;

  S get state => controller.state as S;
  BuildContext get context => controller.context;

  @override
  Widget build(BuildContext context) {
    controller = Get.put(getController(),tag: tag());
    controller.context = context;
    return buildView();
  }

  Widget buildView();


  T getController();

  String tag(){
    return "";
  }
}