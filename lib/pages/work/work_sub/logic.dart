import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/event/work_reload.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/pages/work/state.dart';
import 'package:orginone/routers.dart';

import 'state.dart';

class WorkSubController extends BaseListController<WorkSubState> {
  @override
  final WorkSubState state = WorkSubState();

  late String type;

  WorkSubController(this.type);

  @override
  void onInit() async {
    super.onInit();
    state.scrollController = ScrollController(debugLabel: type);
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
    super.onReceivedEvent(event);
    if (event is WorkReload && type == "todo") {
      await loadData();
    }
  }

  @override
  void onReady() {}

  void initNav() async {
    var joinedCompanies = settingCtrl.user.companys;
    List<WorkBreadcrumbNav> organization = [];
    for (var value in joinedCompanies) {
      organization.add(
        WorkBreadcrumbNav(
          name: value.metadata.name ?? "",
          id: value.metadata.id,
          space: value,
          spaceEnum: SpaceEnum.company,
          children: [
            WorkBreadcrumbNav(
                name: WorkEnum.todo.label,
                workEnum: WorkEnum.todo,
                children: [],
                space: value,
                image: WorkEnum.todo.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.completed.label,
                children: [],
                space: value,
                image: WorkEnum.completed.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.initiated.label,
                workEnum: WorkEnum.initiated,
                children: [],
                space: value,
                image: WorkEnum.initiated.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.initiationWork.label,
                workEnum: WorkEnum.initiationWork,
                children: [],
                space: value,
                image: WorkEnum.initiationWork.imagePath,
                onNext: (nav) async {
                  nav.children = await buildApplication(value.directory);
                }),
          ],
          image: value.metadata.avatarThumbnail(),
        ),
      );
    }
    state.nav = WorkBreadcrumbNav(children: [
      WorkBreadcrumbNav(
          name: settingCtrl.user.metadata.name ?? "",
          children: [
            WorkBreadcrumbNav(
                name: WorkEnum.todo.label,
                workEnum: WorkEnum.todo,
                children: [],
                space: settingCtrl.user,
                image: WorkEnum.todo.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.completed.label,
                workEnum: WorkEnum.completed,
                children: [],
                space: settingCtrl.user,
                image: WorkEnum.completed.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.initiated.label,
                workEnum: WorkEnum.initiated,
                children: [],
                space: settingCtrl.user,
                image: WorkEnum.initiated.imagePath),
            WorkBreadcrumbNav(
                name: WorkEnum.initiationWork.label,
                workEnum: WorkEnum.initiationWork,
                children: [],
                space: settingCtrl.user,
                image: WorkEnum.initiationWork.imagePath,
                onNext: (nav) async {
                  nav.children =
                      await buildApplication(settingCtrl.user.directory);
                }),
          ],
          space: settingCtrl.user,
          image: settingCtrl.user.metadata.avatarThumbnail()),
      ...organization,
    ]);
  }

  Future<List<WorkBreadcrumbNav>> buildApplication(IDirectory dir) async {
    List<WorkBreadcrumbNav> _loadModuleNav(
        List<IApplication> app, IBelong belong) {
      List<WorkBreadcrumbNav> navs = [];
      for (var value in app) {
        navs.add(WorkBreadcrumbNav(
            id: value.metadata.id ?? "",
            name: value.metadata.name ?? "",
            source: value,
            spaceEnum: SpaceEnum.module,
            workEnum: WorkEnum.initiationWork,
            space: belong,
            onNext: (item) async {
              var works = await value.loadWorks();
              List<WorkBreadcrumbNav> data = [
                ...works.map((e) {
                  return WorkBreadcrumbNav(
                    id: e.metadata.id ?? "",
                    name: e.metadata.name ?? "",
                    spaceEnum: SpaceEnum.work,
                    source: e,
                    workEnum: WorkEnum.initiationWork,
                    space: belong,
                    children: [],
                  );
                }),
                ..._loadModuleNav(value.children, belong),
              ];
              item.children = data;
            },
            children: []));
      }
      return navs;
    }

    List<WorkBreadcrumbNav> works = [];
    var applications = dir.applications;
    for (var element in applications) {
      works.add(WorkBreadcrumbNav(
          children: [],
          name: element.metadata.name!,
          id: element.id,
          image: element.metadata.avatarThumbnail(),
          space: (dir.target as IBelong),
          workEnum: WorkEnum.initiationWork,
          spaceEnum: SpaceEnum.applications,
          source: element,
          onNext: (nav) async {
            var works = await element.loadWorks();
            nav.children = [
              ...works.map((e) {
                return WorkBreadcrumbNav(
                  id: e.metadata.id ?? "",
                  name: e.metadata.name ?? "",
                  spaceEnum: SpaceEnum.work,
                  workEnum: WorkEnum.initiationWork,
                  space: (dir.target as IBelong),
                  source: e,
                  children: [],
                );
              }).toList(),
              ..._loadModuleNav(element.children, (dir.target as IBelong)),
            ];
          }));
    }
    return works;
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
    PageResult<IWorkTask> pageResult =
        await settingCtrl.work.loadDones(IdPageModel(
      id: settingCtrl.user.id,
    ));

    state.list.value = pageResult.result;
  }

  loadApply() async {
    PageResult<IWorkTask> pageResult =
        await settingCtrl.work.loadApply(IdPageModel(
      id: settingCtrl.user.id,
    ));
    state.list.value = pageResult.result;
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
      //TODO:没有这个loadMostUsed 用到时候要研究一下逻辑
      // await settingCtrl.work.loadMostUsed();
    }
  }

  void onSelected(key, WorkFrequentlyUsed app) {
    //TODO:没有这个removeMostUsed 用到时候要研究一下逻辑
    // settingCtrl.work.removeMostUsed(app.define);
  }
}
