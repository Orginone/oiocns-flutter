import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';

import 'state.dart';

class CohortActivityController extends BaseListController<CohortActivityState> {
  @override
  final CohortActivityState state = CohortActivityState();

  late String type;
  late GroupActivity cohortActivity;

  CohortActivityController(this.type, this.cohortActivity);

  @override
  void onInit() async {
    super.onInit();
    state.activityMessageList.value = cohortActivity.activityList;

    loadSuccess();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    state.scrollController.dispose();
    super.onClose();
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    if (isRefresh) {
      await cohortActivity.load(reload: true);
    } else {
      await cohortActivity.load();
      state.activityMessageList.value = cohortActivity.activityList;
    }
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }
}
