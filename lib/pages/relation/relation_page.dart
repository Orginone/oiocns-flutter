import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/common/widgets/image.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/main_base.dart';

/// 关系页面
class RelationPage extends StatelessWidget {
  late InfoListPageModel? relationModel;
  late dynamic datas;
  RelationPage({super.key, dynamic datas}) {
    relationModel = null;
    this.datas = datas ?? RoutePages.getRouteParams();
  }

  @override
  Widget build(BuildContext context) {
    if (null == relationModel) {
      datas = RoutePages.getRouteParams();
      load();
    }

    return InfoListPage(
      relationModel!,
      getActions: _getActions,
    );
  }

  void load() {
    relationModel =
        InfoListPageModel(title: RoutePages.getRouteTitle() ?? "关系", tabItems: [
      createTabItemsModel(title: "全部"),
      if (null == datas) ...[
        createTabItemsModel(title: "个人"),
        createTabItemsModel(title: "单位")
      ]
    ]);
    if (relationCtrl.user.members.isEmpty) {
      relationCtrl.user.loadMembers();
    }
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    List<IEntity<dynamic>> initDatas = [];
    if (null == datas) {
      initDatas = getFirstLevelDirectories(title);
    } else if (datas is List) {
      initDatas = datas;
    }

    return TabItemsModel(
        title: title,
        content: ListWidget(
          initDatas: initDatas,
          getDatas: ([dynamic parentData]) {
            dynamic param = RoutePages.getParentRouteParam();
            if (null == parentData) {
              if (param is IEntity) {
                return loadDirectories(param);
              }
              return [];
            } else if (parentData is ICompany &&
                parentData.typeName == TargetType.company.label) {
              return loadDirectories(parentData);
            } else if (parentData is IPerson &&
                parentData.typeName == TargetType.person.label) {
              return loadDirectories(parentData);
            } else if (parentData.typeName == SpaceEnum.firend.label) {
              return loadFriends();
            } else if (parentData.typeName == SpaceEnum.groups.label &&
                RoutePages.getRouteLevel() == 1) {
              return loadGroups();
            } else if (parentData.typeName == SpaceEnum.resources.label) {
              return loadStoreResources();
            } else if (parentData.typeName == SpaceEnum.member.label) {
              return loadMembers(parentData);
            } else if (parentData.typeName == SpaceEnum.cohorts.label &&
                RoutePages.getRouteLevel() == 1) {
              return loadCohorts();
            } else if (parentData.typeName == SpaceEnum.internalAgent.label &&
                RoutePages.getRouteLevel() == 1) {
              return loadInternalAgent(parentData);
            }

            return [];
          },
          getAction: (dynamic data) {
            if (data is! IDirectory && data is! IStorage) {
              return GestureDetector(
                onTap: () {
                  print('>>>>>>======点击了感叹号');
                  RoutePages.jumpRelationInfo(data: data);
                },
                child: const XImageWidget.asset(width: 35, height: 35, ''),
              );
            }
            return null;
          },
          onTap: (dynamic data, List children) {
            print('>>>>>>======点击了列表项 ${data.name}');
            if (children.isNotEmpty) {
              RoutePages.jumpRelation(parentData: data, listDatas: children);
            } else {
              RoutePages.jumpRelationMember(data: data);
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

  // 获得二级目录
  List<Directory> loadDirectories(IEntity target) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;

    DirectoryGroupType.getType(target.typeName)?.types.forEach((e) {
      tmpDir = XDirectory(
          id: id.toString(), directoryId: id.toString(), isDeleted: false);
      tmpDir.name = e.label;
      tmpDir.typeName = e.label;
      datas.add(Directory(tmpDir,
          getCurrentCompany(companyId: target.id) ?? relationCtrl.user));
    });
    return datas;
  }

  List<Directory> getLevelDirectories(data) {
    return [];
  }

  List<XTarget> loadFriends() {
    return relationCtrl.user.members;
  }

  List<XTarget> loadMembers(dynamic data) {
    if (data is IDepartment) {
      return data.members ?? [];
    }
    return getCurrentCompany()?.members ?? [];
  }

  /// 加载群组
  List<ICohort> loadGroups() {
    // 人员群组
    if (RoutePages.getRootRouteParam().typeName == TargetType.person.label) {
      return relationCtrl.user.cohorts ?? [];
    } else {
      // 单位群组
      return getCurrentCompany()?.cohorts ?? [];
    }
  }

  List<IEntity> loadStoreResources() {
    // 人员群组
    if (RoutePages.getRootRouteParam().typeName == TargetType.person.label) {
      return relationCtrl.user.storages;
    } else {
      return getCurrentCompany()?.storages ?? [];
    }
  }

  /// 获得当前单位
  ICompany? getCurrentCompany({String? companyId}) {
    return relationCtrl.user
        .findCompany(companyId ?? RoutePages.getRootRouteParam().id);
  }

  /// 加载组织
  List<ITarget> loadCohorts() {
    return getCurrentCompany()
            ?.shareTarget
            .where((element) => element.typeName == TargetType.group.label)
            .toList() ??
        [];
  }

  /// 加载内设机构
  List<IDepartment> loadInternalAgent(parent) {
    return getCurrentCompany()?.departments ?? [];
  }

  List<Widget> _getActions() {
    return [];
  }
}
