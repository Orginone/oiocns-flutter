import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/components/tab_combine.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/enum.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/flow.dart';
import 'package:orginone/dart/core/todo/orgrelation.dart';
import 'package:orginone/pages/todo/config.dart';
import 'package:orginone/pages/todo/todo_list_page.dart';
import 'package:orginone/pages/todo/workbench_page.dart';
import 'package:orginone/routers.dart';

/// 办事-待办
class WorkPage extends GetView<WorkController> {
  WorkPage({super.key});

  final GlobalKey _keyGreen = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Tabs(
      tabCtrl: controller.tabController,
      top: SizedBox(
        height: 60.h,
        child: Stack(
          children: [
            SizedBox(
              width: 510.w,
              child: TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  controller: controller.tabController,
                  tabs: controller.tabs.map((item) => item.toTab()).toList(),
                  dividerColor: XColors.yellow),
            ),
            Positioned(
              key: _keyGreen,
              top: 15.h,
              right: 0,
              child: GestureDetector(
                onTap: () => _showMenu(context),
                child: Container(
                  width: 40.w,
                  height: 35.w,
                  decoration: const BoxDecoration(
                      border: Border(
                          left:
                              BorderSide(width: 1, color: XColors.lineLight2))),
                  child: Icon(
                    Icons.more_vert,
                    color: XColors.black6,
                    size: 35.w,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      views: controller.tabs.map((item) => item.toTabView()).toList(),
    );
  }

  _showMenu(BuildContext context) {
    final RenderBox? renderBox =
        _keyGreen.currentContext?.findRenderObject() as RenderBox?;
    final overlay = renderBox?.localToGlobal(Offset.zero);
    if (renderBox == null || overlay == null) return;
    RelativeRect position = RelativeRect.fromRect(
      Rect.fromLTRB(
          overlay.dx, overlay.dy + 45, overlay.dx + 50, overlay.dy + 500),
      Offset.zero & renderBox.size,
    );
    showMenu(
            context: context,
            shadowColor: XColors.black6,
            position: position,
            items: getMenu())
        .then((value) {
      if (value == 1) {}
      if (value == 2) {}
    });
  }
}

class WorkController extends TabsController {
  Map<String, dynamic> mData = {};
  late List<TabCombine> mTabs;

  // late TabController mTabController;
  final RxList<XRelation> _todoList = <XRelation>[].obs;
  final Rx<LoadStatusX> todoLoadStatus = LoadStatusX.loading.obs;

  List<XRelation> get todoList => _todoList;

  @override
  initTabs() {
    mData = getCards();
    // mTabController = TabController(length: 3, vsync: this);
    // mTabs = getTabs(mTabController);

    registerTab(XTab(
        view: const TodoListPage(),
        body: Text(
          "待办",
          style: XFonts.size22Black3,
        )));
    registerTab(XTab(
        view: const WorkbenchPage(),
        body: Text(
          "发起业务",
          style: XFonts.size22Black3,
        )));
    getTodoList(true);
  }

  //查询待办列表
  getTodoList(
    bool isRefresh,
  ) async {
    List<XRelation> list = [];
    for (int i = 0; i < 10; i++) {
      XRelation xRelation = XRelation(
          id: "id",
          targetId: "targetId",
          teamId: "teamId",
          status: 0,
          createUser: "createUser",
          updateUser: "updateUser",
          version: "version",
          createTime: "createTime",
          updateTime: "updateTime",
          attrValues: [],
          team: null,
          target: null);
      list.add(xRelation);
    }
    Future.delayed(const Duration(seconds: 2), () {
      _todoList.addAll(list);
      todoLoadStatus.value = LoadStatusX.success;
    });

    OrgTodo todo = OrgTodo("", "name", "icon");
    final todoList = await todo.getTodoList();
    debugPrint("res->$todoList");

    // OrgTodo todo2 = OrgTodo("359750750353625088", "name2", "icon");
    // final todoList2 = await todo2.getApplyList(PageRequest(offset: 0, limit: 65535, filter: ''));
    // debugPrint("res->$todoList2");
  }

  @override
  void dispose() {
    super.dispose();
    // mTabController.dispose();
  }

  createInstance() async {
    Get.toNamed(Routers.choiceGb)?.then((value) {
      if (value != null) {
        Get.toNamed(Routers.workStart, arguments: {"species": value});
      }
    });
    // //TODO:测试发起用例
    // var settingCtrl = Get.find<SettingController>();
    // var space = settingCtrl.space;
    // var define = await KernelApi.getInstance().queryDefine(
    //     QueryDefineReq(speciesId: '', spaceId: space.id, page: PageRequest(offset: 0, limit: 20, filter: '')));
    // var company = settingCtrl.company;
    //
    // var spaceID1 = settingCtrl.company?.id ?? "";
    // var spaceID2 = settingCtrl.user?.id ?? "";
    // FlowTarget ft = FlowTarget(space.target);
    // // var defines = ft.getDefines();
    // var data = await ft.createInstance(FlowInstanceModel(
    //     spaceId: "373520388493283329",
    //     content: 'https://www.npmjs.com/',
    //     contentType: 'string',
    //     data: '{}',
    //     title: '',
    //     hook: '', defineId: ''));
    // print('---->');
    // //TODO:测试发起用例
  }
}

class WorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkController());
  }
}
