


import 'package:orginone/dart/core/getx/base_list_controller.dart';

import 'base_frequently_used_list_state.dart';

class BaseFrequentlyUsedListController<S extends BaseFrequentlyUsedListState>
    extends BaseListController<S> {
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.scrollController.addListener(() {
      double x = -1 + (state.scrollController.position.pixels /
          state.scrollController.position.maxScrollExtent) * 2;
      if (x > 1) {
        x = 1;
      }
      state.scrollX.value = x;
      print(state.scrollX.value);
    });
  }

  void onTapFrequentlyUsed(used) {}
}