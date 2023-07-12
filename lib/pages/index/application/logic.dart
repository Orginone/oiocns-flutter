import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/main.dart';

import 'state.dart';

class ApplicationController extends BaseController<ApplicationState> {
 final ApplicationState state = ApplicationState();


 Future<void> loadApps([bool reload = false]) async{
   await settingCtrl.provider.loadApps(reload);
 }


  @override
  void onReceivedEvent(event) {
     if(event is LoadApplicationDone){
       state.isSuccess.value = true;
       state.isLoading.value = false;
     }
     if(event is InitHomeData){
       loadApps(false);
     }
  }
}
