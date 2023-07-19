import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_controller.dart';
import 'package:orginone/dart/core/getx/submenu_list/base_submenu_state.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/model/subgroup.dart';
import 'package:orginone/model/subgroup_config.dart';
import 'package:orginone/util/hive_utils.dart';
import 'state.dart';
import 'work_sub/logic.dart';

class WorkController extends BaseSubmenuController<WorkState> {
  final WorkState state = WorkState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void initSubGroup() {
    // TODO: implement initSubGroup
    super.initSubGroup();
    var work = HiveUtils.getSubGroup('work');
    if(work==null){
      work = SubGroup.fromJson(workDefaultConfig);
      HiveUtils.putSubGroup('work', work);
    }
    state.subGroup = Rx(work);
  }


}
