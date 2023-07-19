import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class WorkSubController extends BaseListController<WorkSubState> {
  final WorkSubState state = WorkSubState();

  late String type;

  WorkSubController(this.type);

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    if (type == "all") {
      initNav();
    }
    if (type == "done") {
      await loadDones();
    }
    if (type == "apply") {
      await loadApply();
    }
    loadSuccess();
  }

  @override
  void onReceivedEvent(event) async {
    // TODO: implement onReceivedEvent
    super.onReceivedEvent(event);
    if (event is WorkReload && type == "todo") {
      await loadData();
    }
  }

  @override
  void onReady() {
    // TODO: implement onReady
  }

  void initNav() {
    var joinedCompanies = settingCtrl.user.companys;
    List<WorkBreadcrumbNav> organization = [];
    for (var value in joinedCompanies) {
      organization.add(
        WorkBreadcrumbNav(
          name: value.metadata.name ?? "",
          id: value.metadata.id!,
          space: value,
          children: [
            WorkBreadcrumbNav(
                name: WorkEnum.todo.label,
                workEnum: WorkEnum.todo,
                children: [],
                space: value,
                image: WorkEnum.todo.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.completed.label,
                workEnum: WorkEnum.completed,
                children: [],
                space: value,
                image: WorkEnum.completed.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.initiated.label,
                workEnum: WorkEnum.initiated,
                children: [],
                space: value,
                image: WorkEnum.initiated.imagePath),
          ],
          image: value.metadata.avatarThumbnail(),
        ),
      );
    }
    state.nav = WorkBreadcrumbNav(children: organization);
  }

  void jumpNext(WorkBreadcrumbNav work) {
    if (work.children.isEmpty) {
      jumpWorkList(work);
    } else {
      Get.toNamed(Routers.initiateWork,
          preventDuplicates: false, arguments: {"data": work});
    }
  }


  void jumpWorkList(WorkBreadcrumbNav work) {
    Get.toNamed(Routers.workList, arguments: {"data": work});
  }

  loadDones() async {
    state.list.value = await settingCtrl.work.loadDones(settingCtrl.user.id);
  }

  loadApply() async {
    state.list.value = await settingCtrl.work.loadApply(settingCtrl.user.id);
  }

  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    if (type == "todo") {
      await settingCtrl.work.loadTodos(reload: true);
    }
    if (type == "done") {
      await loadDones();
    }
    if (type == "apply") {
      await loadApply();
    }
    if (type == "common") {
      await settingCtrl.work.loadMostUsed();
    }
  }
}
