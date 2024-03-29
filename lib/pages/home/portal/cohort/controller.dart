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
    state.activityMessageList.value = await cohortActivity.load();
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
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
    if (isRefresh) {
      await cohortActivity.load();
    }
  }
}
