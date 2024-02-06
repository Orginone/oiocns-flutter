import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main_base.dart';

/// 办事页面
class WorkPage extends StatefulWidget {
  late InfoListPageModel? workModel;
  late dynamic datas;
  WorkPage({super.key, dynamic datas}) {
    workModel = null;
    this.datas = datas ?? RoutePages.getRouteParams();
  }

  @override
  State<StatefulWidget> createState() => _WorkPageState();
}

class _WorkPageState extends State<WorkPage> {
  InfoListPageModel? get workModel => widget.workModel;
  dynamic get datas => widget.datas;
  set datas(dynamic datas) => widget.datas;
  set workModel(InfoListPageModel? value) => widget.workModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (null == workModel) {
      datas = RoutePages.getRouteParams();
      Future<InfoListPageModel?> dataFuture = load();
      return Center(
          child: FutureBuilder<InfoListPageModel?>(
        future: dataFuture,
        builder:
            (BuildContext context, AsyncSnapshot<InfoListPageModel?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (null != snapshot.data) {
            return InfoListPage(snapshot.data!);
          }
          return Container();
        },
      ));
    }

    return InfoListPage(workModel!);
  }

  Future<InfoListPageModel?> load() async {
    return Future(() async => workModel = InfoListPageModel(
            activeTabTitle: getActiveTabTitle() ?? "待办",
            title: RoutePages.getRouteTitle() ?? "数据",
            tabItems: [
              await createTabItemsModel(title: "常用"),
              await createTabItemsModel(title: "待办"),
              await createTabItemsModel(title: "已办"),
              await createTabItemsModel(title: "抄送"),
              await createTabItemsModel(title: "已发起"),
              await createTabItemsModel(title: "已完结")
            ]));
  }

  /// 获得激活页签
  getActiveTabTitle() {
    return RoutePages.getRouteDefaultActiveTab()?.firstOrNull;
  }

  Future<TabItemsModel> createTabItemsModel({
    required String title,
  }) async {
    List<IEntity<dynamic>> initDatas = [];
    if (null == datas) {
      initDatas = await getFirstLevelDirectories(title);
    } else {
      initDatas = datas;
    }
    return TabItemsModel(
        title: title,
        content: ListWidget(
          initDatas: initDatas,
          getDatas: ([dynamic parentData]) {
            if (null == parentData) {
              return [];
            }

            return [];
          },
          // getAction: (dynamic data) {
          //   return GestureDetector(
          //     onTap: () {
          //       print('>>>>>>======点击了感叹号');
          //     },
          //     child: const XImageWidget.asset(width: 35, height: 35, ''),
          //   );
          // },
          onTap: (dynamic data, List children) async {
            print('>>>>>>======点击了列表项 ${data.name} ${children.length}');
            if (data is IWorkTask) {
              await RoutePages.jumpWorkInfo(work: data);
            }
          },
        ));
  }

  // 获得一级目录
  Future<List<IEntity>> getFirstLevelDirectories(String title) async {
    List<IWorkTask> datas = [];
    if (title == "待办") {
      datas = relationCtrl.work.todos;
    } else if (title == "常用") {
    } else if (title == "已办") {
      datas = await relationCtrl.work.loadContent(TaskType.done);
    } else if (title == "抄送") {
      datas = await relationCtrl.work.loadContent(TaskType.altMe);
    } else if (title == "已发起") {
      datas = await relationCtrl.work.loadContent(TaskType.create);
    } else if (title == "已完结") {
      // datas = await relationCtrl.work.loadContent(TaskType.create);
    }
    return datas;
  }

  // 加载存储列表
  List<IStorage> loadStorages(ITarget target) {
    TargetType? type = TargetType.getType(target.typeName);
    if (type == TargetType.person) {
      return relationCtrl.user.storages;
    } else if (type == TargetType.company) {
      return relationCtrl.user.findCompany(target.id)?.storages ?? [];
    }
    return [];
  }

  /// 加载存储列表
  List<Directory> loadStoragesDirectory(IStorage data) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;
    DirectoryGroupType.getType(data.typeName)?.types.forEach((e) {
      tmpDir = XDirectory(
          id: id.toString(), directoryId: id.toString(), isDeleted: false);
      tmpDir.name = e.label;
      tmpDir.typeName = e.label;
      datas.add(Directory(tmpDir, relationCtrl.user));
    });
    return datas;
  }

  /// 加载数据标准
  List<Directory> loadDataStandards(Directory item) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;
    DirectoryGroupType.getType(item.typeName)?.types.forEach((e) {
      tmpDir = XDirectory(
          id: id.toString(), directoryId: id.toString(), isDeleted: false);
      tmpDir.name = e.label;
      tmpDir.typeName = e.label;
      datas.add(Directory(tmpDir, relationCtrl.user));
    });
    return datas;
  }
}
