import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/base/flow.dart';

class WorkStartState extends BaseGetState{

  var defines = <IWorkDefine>[].obs;

  WorkStartState(){
    defines.value = Get.arguments['defines'];
  }

}