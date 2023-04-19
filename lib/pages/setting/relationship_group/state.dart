

import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/pages/setting/config.dart';

class RelationGroupState extends BaseGetState{

  var selectedGroup = <String>[].obs;

  var groupData = <dynamic>[].obs;

  late String head;

  late bool showPopupMenu;

  SpaceEnum? spaceEnum;

  StandardEnum? standardEnum;

  late ISpace space;

  bool get isStandard => standardEnum!=null;


  RelationGroupState(){
    showPopupMenu = Get.arguments?['showPopupMenu']?? true;

    spaceEnum = Get.arguments?['spaceEnum'];

    standardEnum = Get.arguments?['standardEnum'];

    space = Get.arguments['space'];

    head = space.teamName;
  }
}
