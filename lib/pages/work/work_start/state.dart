import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/work/index.dart';

class WorkStartState extends BaseGetState{

  var defines = <IWork>[].obs;

  late ITarget target;
  WorkStartState(){
    defines.value = Get.arguments['defines'];
    target = Get.arguments['target'];
  }

}