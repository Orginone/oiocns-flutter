import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/main.dart';

import 'state.dart';

class IndexController extends BaseController<IndexState> {
 final IndexState state = IndexState();


 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadApps();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

  }

  @override
  void onReceivedEvent(event) {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
  }

  Future<void> loadApps([bool reload = false]) async{
    await settingCtrl.provider.loadApps(reload);
  }
}
