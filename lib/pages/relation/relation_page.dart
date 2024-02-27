import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/common/widgets/image.dart';
import 'package:orginone/components/widgets/infoListPage/index.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/index.dart';
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
import 'package:orginone/utils/log/log_util.dart';

/// 关系页面
class RelationPage extends StatefulWidget {
  // late InfoListPageModel? relationModel;
  // late dynamic datas;
  // RelationPage({super.key}) {
  //   relationModel = null;
  //   datas = RoutePages.getRouteParams(homeEnum: HomeEnum.relation);
  // }
  const RelationPage({super.key});

  @override
  State createState() => _RelationState();
}

class _RelationState extends State<RelationPage> {
  // InfoListPageModel? get relationModel => widget.relationModel;
  // set relationModel(InfoListPageModel? value) {
  //   widget.relationModel = value;
  // }

  // dynamic get datas => widget.datas;
  // set datas(dynamic value) {
  //   widget.datas = value;
  // }

  late InfoListPageModel? relationModel;
  late dynamic datas;

  _RelationState() {
    if (relationCtrl.homeEnum.value == HomeEnum.relation &&
        RoutePages.getRouteLevel() > 0) {
      relationCtrl.homeEnum.listen((homeEnum) {
        if (homeEnum == HomeEnum.relation) {
          setState(() {
            relationModel = null;
            datas = RoutePages.getRouteParams(homeEnum: HomeEnum.relation);
          });
        }
      });
    }
  }

  @override
  initState() {
    super.initState();
    relationModel = null;
    datas = RoutePages.getRouteParams(homeEnum: HomeEnum.relation);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (null == relationModel) {
      // datas = RoutePages.getRouteParams();
      load();
    }

    return InfoListPage(
      relationModel!,
      getActions: _getActions,
    );
  }

  void load() {
    dynamic param = RoutePages.getParentRouteParam();
    relationModel =
        InfoListPageModel(title: RoutePages.getRouteTitle() ?? "关系", tabItems: [
      createTabItemsModel(title: "全部"),
      if (null == datas) ...[
        createTabItemsModel(title: "个人"),
        createTabItemsModel(title: "单位")
      ] /**else if (param is ICompany)
        ...DirectoryGroupType.company.types
            .map((e) => createTabItemsModel(title: e.label))
            .toList()**/
      else if (datas is List)
        ..._createTabs(datas)
    ]);
    if (relationCtrl.user?.members.isEmpty ?? false) {
      relationCtrl.user?.loadMembers();
    }
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    List<IEntity<dynamic>> initDatas = [];
    if (null == datas) {
      initDatas = getFirstLevelDirectories(title);
    } else if (datas is List<IEntity<dynamic>>) {
      initDatas = _filterDatas(title, datas);
    }

    return TabItemsModel(
        title: title,
        content: ListWidget(
          initDatas: initDatas,
          getDatas: ([dynamic parentData]) {
            if (null == parentData) {
              dynamic param = RoutePages.getParentRouteParam();
              if (param is IEntity) {
                return loadDirectories(param);
              }
              return [];
            } else if (parentData is ICompany &&
                parentData.typeName == TargetType.company.label) {
              return [
                ...loadGroups(parentData.typeName, company: parentData),
                ...loadInternalAgent(parentData, company: parentData),
                ...loadCohorts(company: parentData),
                ...loadStoreResources(parentData.typeName, company: parentData)
              ];
              //loadDirectories(parentData);
            } else if (parentData is IPerson &&
                parentData.typeName == TargetType.person.label) {
              return [
                ...loadGroups(parentData.typeName),
                ...loadStoreResources(parentData.typeName)
              ]; //loadDirectories(parentData);
            } else if (parentData.typeName == SpaceEnum.firend.label) {
              return loadFriends();
            } else if (parentData.typeName == SpaceEnum.resources.label) {
              return loadStoreResources(
                  RoutePages.getRootRouteParam().typeName);
            } else if (parentData.typeName == SpaceEnum.member.label) {
              return loadMembers(parentData);
            } else if (parentData.typeName == SpaceEnum.internalAgent.label &&
                RoutePages.getRouteLevel() == 1) {
              return loadInternalAgent(parentData);
            }
            /**else if (parentData.typeName == SpaceEnum.groups.label &&
                RoutePages.getRouteLevel() == 1 &&
                RoutePages.getRootRouteParam().typeName !=
                    TargetType.person.label) {
              return loadGroups(RoutePages.getRootRouteParam().typeName);
            } else if (parentData.typeName == SpaceEnum.cohorts.label &&
                RoutePages.getRouteLevel() == 1) {
              return loadCohorts();
            } */

            return [];
          },
          getAction: (dynamic data) {
            if (data is! IDirectory && data is! IStorage) {
              return GestureDetector(
                onTap: () {
                  LogUtil.d('>>>>>>======点击了感叹号');
                  RoutePages.jumpRelationInfo(data: data);
                },
                child: const XImageWidget.asset(width: 35, height: 35, ''),
              );
            }
            return null;
          },
          onTap: (dynamic data, List children) {
            LogUtil.d('>>>>>>======点击了列表项 ${data.name}');
            if (children.isNotEmpty) {
              RoutePages.jumpRelation(parentData: data, listDatas: children);
            } else {
              RoutePages.jumpRelationMember(data: data);
            }
          },
        ));
  }

  List<IEntity<dynamic>> _filterDatas(
      String title, List<IEntity<dynamic>> datas) {
    List<IEntity<dynamic>> result = datas;
    if (title != "全部") {
      result = datas.where((element) {
        if (element.typeName == title) {
          return true;
        }
        return false;
      }).toList();
    }
    return result;
  }

  // 获得一级目录
  List<IEntity<dynamic>> getFirstLevelDirectories(String title) {
    List<IEntity<dynamic>> datas = [];
    if (null != relationCtrl.user) {
      if (title == "个人" || title == "全部") {
        datas.add(relationCtrl.user!);
      }
      if (title == "单位" || title == "全部") {
        datas.addAll(relationCtrl.user!.companys.map((item) => item).toList());
      }
    }
    return datas;
  }

  List<TabItemsModel> _createTabs(List list) {
    List<TabItemsModel> datas = [];
    List<String> tabs = [];

    for (dynamic e in list) {
      if (e is IEntity && !tabs.contains(e.typeName)) {
        tabs.add(e.typeName);
      }
    }
    // tabs.sort();
    for (String e in tabs) {
      datas.add(createTabItemsModel(title: e));
    }
    return datas;
  }

  // 获得二级目录
  List<Directory> loadDirectories(IEntity target) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;

    if (null != relationCtrl.user) {
      DirectoryGroupType.getType(target.typeName)?.types.forEach((e) {
        tmpDir = XDirectory(
            id: id.toString(), directoryId: id.toString(), isDeleted: false);
        tmpDir.name = e.label;
        tmpDir.typeName = e.label;
        datas.add(Directory(tmpDir,
            getCurrentCompany(companyId: target.id) ?? relationCtrl.user!));
      });
    }
    return datas;
  }

  List<Directory> getLevelDirectories(data) {
    return [];
  }

  List<XTarget> loadFriends() {
    return relationCtrl.user?.members ?? [];
  }

  ///加载成员
  List<XTarget> loadMembers(dynamic data) {
    if (data is IDepartment) {
      return data.members ?? [];
    }
    return getCurrentCompany()?.members ?? [];
  }

  /// 加载群组
  List<ICohort> loadGroups(String targetType, {ICompany? company}) {
    // 人员群组
    if (targetType == TargetType.person.label) {
      return relationCtrl.user?.cohorts ?? [];
    } else {
      // 单位群组
      return company?.cohorts ?? getCurrentCompany()?.cohorts ?? [];
    }
  }

  ///加载存储资源
  List<IEntity> loadStoreResources(String targetType, {ICompany? company}) {
    // 人员群组
    if (targetType == TargetType.person.label) {
      return relationCtrl.user?.storages ?? [];
    } else {
      return company?.storages ?? getCurrentCompany()?.storages ?? [];
    }
  }

  /// 获得当前单位
  ICompany? getCurrentCompany({String? companyId}) {
    return null != relationCtrl.user
        ? relationCtrl.user!
            .findCompany(companyId ?? RoutePages.getRootRouteParam().id)
        : null;
  }

  /// 加载组织
  List<ITarget> loadCohorts({ICompany? company}) {
    return company?.shareTarget
            .where((element) => element.typeName == TargetType.group.label)
            .toList() ??
        getCurrentCompany()
            ?.shareTarget
            .where((element) => element.typeName == TargetType.group.label)
            .toList() ??
        [];
  }

  /// 加载内设机构
  List<IDepartment> loadInternalAgent(parent, {ICompany? company}) {
    return company?.departments ?? getCurrentCompany()?.departments ?? [];
  }

  List<Widget> _getActions() {
    return [];
  }
}
