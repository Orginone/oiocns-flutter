import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/common/widgets/image.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/log/log_util.dart';

/// 关系页面
class StorePage extends StatelessWidget {
  late InfoListPageModel? storeModel;
  late dynamic datas;
  StorePage({super.key, dynamic datas}) {
    storeModel = null;
    this.datas = datas ?? RoutePages.getRouteParams();
  }

  @override
  Widget build(BuildContext context) {
    if (null == storeModel) {
      datas = RoutePages.getRouteParams();
      load();
    }

    return InfoListPage(storeModel!);
  }

  void load() {
    storeModel =
        InfoListPageModel(title: RoutePages.getRouteTitle() ?? "数据", tabItems: [
      createTabItemsModel(title: "全部"),
      if (null == datas) ...[
        createTabItemsModel(title: "个人"),
        createTabItemsModel(title: "单位")
      ]
    ]);
    relationCtrl.user.loadMembers();
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    List<IEntity<dynamic>> initDatas = [];
    if (null == datas) {
      initDatas = getFirstLevelDirectories(title);
    } else {
      initDatas = datas;
    }
    return TabItemsModel(
        title: title,
        content: ListWidget(
          initDatas: initDatas,
          getDatas: ([dynamic parentData]) {
            if (null == parentData) {
              return loadStorages(RoutePages.getRootRouteParam());
            } else if (parentData is ICompany &&
                parentData.typeName == TargetType.company.label) {
              return loadStorages(parentData);
            } else if (parentData is IPerson &&
                parentData.typeName == TargetType.person.label) {
              return loadStorages(parentData);
            } else if (parentData is IStorage &&
                parentData.typeName == TargetType.storage.label) {
              return loadStoragesDirectory(parentData);
            } else if (parentData.typeName == SpaceEnum.dataStandards.label &&
                parentData is Directory) {
              return loadDataStandards(parentData);
            }

            return [];
          },
          getAction: (dynamic data) {
            return GestureDetector(
              onTap: () {
                LogUtil.d('>>>>>>======点击了感叹号');
              },
              child: const XImageWidget.asset(width: 35, height: 35, ''),
            );
          },
          onTap: (dynamic data, List children) {
            LogUtil.d('>>>>>>======点击了列表项 ${data.name} ${children.length}');
            if (children.isNotEmpty) {
              RoutePages.jumpStore(parentData: data, listDatas: children);
            } else {
              // RoutePages.jumpFileInfo(data: data);
            }
          },
        ));
  }

  // 获得一级目录
  List<IEntity<dynamic>> getFirstLevelDirectories(String title) {
    List<IEntity<dynamic>> datas = [];
    if (title == "个人" || title == "全部") {
      datas.add(relationCtrl.user);
    }
    if (title == "单位" || title == "全部") {
      datas.addAll(relationCtrl.user.companys.map((item) => item).toList());
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
