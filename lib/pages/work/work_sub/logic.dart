import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/getx/base_list_controller.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/work/initiate_work/state.dart';
import 'package:orginone/pages/work/state.dart';
import 'package:orginone/utils/index.dart';

import 'state.dart';

class WorkSubController extends BaseListController<WorkSubState> {
  @override
  final WorkSubState state = WorkSubState();

  late String type;

  WorkSubController(this.type);

  StreamSubscription? sub;
  @override
  void onInit() async {
    super.onInit();
    sub = EventBusUtil().on((event) async {
      LogUtil.d(event);
      if (event is LoadTodosEvent) {
        await loadTodos();
      }
    });
    state.scrollController = ScrollController(debugLabel: type);
    if (type == "all") {
      initNav();
    }
    if (type == "todo") {
      await loadTodos();
    }
    if (type == "done") {
      await loadDones();
    }
    if (type == "alt") {
      await loadAlt();
    }
    if (type == "create") {
      await loadCreate();
    }
    loadSuccess();
  }

  @override
  void onClose() {
    EventBusUtil().cancel(sub!);
    super.onClose();
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

  ///跳转办事详情
  processDetails(IWorkTask work) async {
    //加载流程实例数据
    await work.loadInstance();
    //跳转办事详情
    Get.toNamed(Routers.processDetails, arguments: {"todo": work});
  }

  /// 全部办事 点击事件 跳转子页面
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

  ///加载已办数据
  loadDones() async {
    List<IWorkTask> tasks = await settingCtrl.work.loadContent(TaskType.done);
    state.list.value = tasks;
  }

  ///加载艾特
  loadAlt() async {
    List<IWorkTask> tasks = await settingCtrl.work.loadContent(TaskType.altMe);
    state.list.value = tasks;
  }

  //加载发起
  loadCreate() async {
    List<IWorkTask> tasks = await settingCtrl.work.loadContent(TaskType.create);
    state.list.value = tasks;
  }

  loadTodos() async {
    List<IWorkTask> todos = await settingCtrl.work.loadTodos(reload: true);
    state.list.value = todos;
    settingCtrl.work.todos.value = todos;
  }

  ///办事tab 下拉刷新
  @override
  Future<void> loadData({bool isRefresh = false, bool isLoad = false}) async {
    //待办
    if (type == "todo") {
      await loadTodos();
    }
    if (type == "done") {
      await loadDones();
    }
    if (type == "alt") {
      await loadAlt();
    }
    if (type == "create") {
      await loadCreate();
    }
  }

  void onSelected(key, WorkFrequentlyUsed app) {
    //TODO:没有这个removeMostUsed 用到时候要研究一下逻辑
    // settingCtrl.work.removeMostUsed(app.define);
  }
}
