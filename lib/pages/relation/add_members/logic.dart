import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';

import '../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class AddMembersController extends BaseController<AddMembersState> {
  @override
  final AddMembersState state = AddMembersState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();
    // var users = await setting.space
    //     .loadMembers(PageRequest(offset: 0, limit: 9999, filter: ''));

    // state.unitMember.addAll(users.result ?? []);
  }

  void selectAll() {
    state.selectAll.value = !state.selectAll.value;
    state.selectedMember.clear();
    if (state.selectAll.value) {
      state.selectedMember.addAll(state.unitMember.value);
    }
  }

  void search(String str) {
    state.showSearch.value = str.isNotEmpty;
    state.searchMember.clear();
    if (str.isNotEmpty) {
      var list = state.unitMember.where((p0) {
        return p0.code!.contains(str);
      });
      if (list.isNotEmpty) {
        state.searchMember.addAll(list.toSet());
      }
    }
  }

  void addItem(XTarget item) {
    if (state.selectedMember.contains(item)) {
      state.selectedMember.remove(item);
    } else {
      state.selectedMember.add(item);
    }
    if (state.selectedMember.length == state.unitMember.length) {
      state.selectAll.value = true;
    }
  }

  void back() {
    Get.back(result: state.selectedMember.value);
  }
}
