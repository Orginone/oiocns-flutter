import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/util/event_bus_helper.dart';

import 'base_get_state.dart';

abstract class BaseController<S extends BaseGetState> extends GetxController{

  late BuildContext context;
  late S state;

  late Logger log;

  BaseController();

  @override
  void onInit() {
    super.onInit();
    log = Logger(this.toString());
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    EventBusHelper.register(context, onReceivedEvent);
  }

  @override
  void onClose() {
    super.onClose();
    EventBusHelper.unregister(context);
  }

  Future<void> loadData() async{

  }


  void onReceivedEvent(event) {}

}