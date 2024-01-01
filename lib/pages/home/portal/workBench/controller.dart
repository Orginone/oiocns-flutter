import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';

import 'state.dart';

class WorkBenchController extends BaseListController<WorkBenchState> {
  @override
  final WorkBenchState state = WorkBenchState();

  late String type;
  late String key;

  WorkBenchController(this.type);

  @override
  void onInit() async {
    super.onInit();
    key = settingCtrl.subscribe((key, args) async {
      state.friendNum.value = settingCtrl.user.members.length.toString();
      state.colleagueNum.value = settingCtrl.user.companys
          .map((i) => i.members.map((e) => e.id))
          .reduce(
            (ids, current) =>
                [...ids, ...current.where((i) => !ids.contains(i))],
          )
          .length
          .toString();
      state.groupChatNum.value = settingCtrl.chats
          .where((i) => i.isMyChat && i.isGroup)
          .length
          .toString();
      state.companyNum.value = settingCtrl.user.companys.length.toString();

      state.todoCount.value = settingCtrl.work.todos.length.toString();
      settingCtrl.work
          .loadTaskCount(TaskType.done)
          .then((value) => state.completedCount.value = value.toString());
      settingCtrl.work
          .loadTaskCount(TaskType.altMe)
          .then((value) => state.copysCount.value = value.toString());
      settingCtrl.work
          .loadTaskCount(TaskType.create)
          .then((value) => state.applyCount.value = value.toString());
      state.relationNum.value = settingCtrl.chats
          .where(
            (i) => i.isMyChat && i.typeName != TargetType.group.label,
          )
          .length
          .toString();
      settingCtrl.chats.listen((value) {
        state.relationNum.value = value
            .where(
              (i) => i.isMyChat && i.typeName != TargetType.group.label,
            )
            .length
            .toString();
      });
      settingCtrl.user.getDiskInfo().then((value) {
        if (value != null) {
          state.diskInfo.value = value;
        } else {
          state.noStore.value = true;
        }
      });
      state.applications.value = await settingCtrl.loadApplications();
    }, true);
    loadSuccess();
  }

  @override
  void onReady() {}

  @override
  void onClose() {
    super.onClose();
    state.scrollController.dispose();
    if (settingCtrl.initialized) {
      settingCtrl.unsubscribe(key ?? '');
    }
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    super.loadData(isRefresh: isRefresh, isLoad: isLoad);
  }
}
