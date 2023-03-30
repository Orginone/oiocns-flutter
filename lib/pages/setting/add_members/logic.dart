import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class AddMembersController extends BaseController<AddMembersState> {
  final AddMembersState state = AddMembersState();

  SettingController get setting => Get.find();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    var users = await setting.space
        .loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));

    state.unitMember.addAll(users.result ?? []);
  }

  void selectAll() {
   state.selectAll.value = !state.selectAll.value;
  }
}
