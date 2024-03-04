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
import 'package:orginone/dart/core/target/outTeam/storage.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/standard/index.dart';
import 'package:orginone/dart/core/thing/standard/page.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/log/log_util.dart';

/// 关系页面
class StorePage extends StatefulWidget {
  // late InfoListPageModel? storeModel;
  // late dynamic datas;

  // StorePage({super.key, dynamic datas}) {
  //   storeModel = null;
  //   this.datas = datas ?? RoutePages.getRouteParams(homeEnum: HomeEnum.store);
  // }
  const StorePage({super.key});
  @override
  State<StatefulWidget> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  // InfoListPageModel? get storeModel => widget.storeModel;
  // set storeModel(InfoListPageModel? storeModel) {
  //   widget.storeModel = storeModel;
  // }

  // dynamic get datas => widget.datas;
  // set datas(dynamic value) {
  //   widget.datas = value;
  // }

  late InfoListPageModel? storeModel;
  late dynamic datas;
  _StorePageState() {
    // if (relationCtrl.homeEnum.value == HomeEnum.store &&
    //     RoutePages.getRouteLevel() > 0) {
    relationCtrl.homeEnum.listen((homeEnum) {
      if (homeEnum == HomeEnum.store) {
        if (mounted) {
          setState(() {
            storeModel = null;
            datas = RoutePages.getRouteParams(homeEnum: HomeEnum.store);
          });
        }
      }
    });
    // }
  }
  @override
  void initState() {
    super.initState();
    storeModel = null;
    datas = RoutePages.getRouteParams(homeEnum: HomeEnum.store);
  }

  @override
  void didUpdateWidget(StorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // storeModel = oldWidget.storeModel;
    // datas = oldWidget.datas;
  }

  @override
  Widget build(BuildContext context) {
    if (null == storeModel) {
      // datas = RoutePages.getRouteParams();
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
      ],
    ]);
    // relationCtrl.user?.loadMembers();
  }

  TabItemsModel createTabItemsModel({
    required String title,
  }) {
    List<IEntity<dynamic>> initDatas = [];
    if (null == datas) {
      initDatas = getFirstLevelDirectories(title);
    } else if (datas is List<IEntity<dynamic>>) {
      initDatas = datas;
    }
    return TabItemsModel(
        title: title,
        content: ListWidget(
          initDatas: initDatas,
          getLazyDatas: ([dynamic parentData]) async {
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
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == SpaceEnum.dataStandards.label &&
                parentData is Directory) {
              return loadDataStandards(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == SpaceEnum.businessModeling.label &&
                parentData is Directory) {
              return loadDataStandards(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.property.label &&
                parentData is Directory) {
              return loadProperties(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.species.label &&
                parentData is Directory) {
              return loadSpecies(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.dict.label &&
                parentData is Directory) {
              return loadDicts(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.app.label &&
                parentData is Directory) {
              return loadApps(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.model.label &&
                parentData is Directory) {
              return loadApps(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.form.label &&
                parentData is Directory) {
              return loadForms(parentData);
            } else if (parentData.typeName == SpaceEnum.directory.label &&
                parentData.name == DirectoryType.pageTemplate.label &&
                parentData is Directory) {
              return loadPageTemplates(parentData);
            }

            return [];
          },
          getAction: (dynamic data) {
            if (data is! IDirectory) {
              return GestureDetector(
                onTap: () {
                  LogUtil.d('>>>>>>======点击了感叹号');
                },
                child: const XImageWidget.asset(width: 35, height: 35, ''),
              );
            }
            return null;
          },
          onTap: (dynamic data, List children) {
            LogUtil.d('>>>>>>======点击了列表项 ${data.name} ${children.length}');
            // if (children.isNotEmpty) {
            RoutePages.jumpStore(parentData: data, listDatas: children);
            // LogUtil.d('jumpStore');
            // LogUtil.d(data.runtimeType);
            // LogUtil.d(data);
            // } else {
            //   // RoutePages.jumpFileInfo(data: data);
            // }
          },
        ));
  }

  // 获得一级目录
  List<IEntity<dynamic>> getFirstLevelDirectories(String title) {
    List<IEntity<dynamic>> datas = [];
    if (null != relationCtrl.user) {
      if (title == "个人" || title == "全部") {
        datas.add(relationCtrl.user!);
      }
      if (title == "单位" || title == "全部") {
        datas.addAll(
            relationCtrl.user?.companys.map((item) => item).toList() ?? []);
      }
    }
    return datas;
  }

  // 加载存储列表
  List<IStorage> loadStorages(ITarget target) {
    TargetType? type = TargetType.getType(target.typeName);
    if (type == TargetType.person) {
      return relationCtrl.user?.storages ?? [];
    } else if (type == TargetType.company) {
      return relationCtrl.user?.findCompany(target.id)?.storages ?? [];
    }
    return [];
  }

  /// 加载存储列表
  List<Directory> loadStoragesDirectory(IStorage data) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;
    if (null != relationCtrl.user) {
      DirectoryGroupType.getType(data.typeName)?.types.forEach((e) {
        tmpDir = XDirectory(
            id: "${data.id}_$id",
            directoryId: "${data.id}_$id",
            isDeleted: false);
        tmpDir.name = e.label;
        tmpDir.typeName = SpaceEnum.directory.label;
        datas.add(FixedDirectory(tmpDir, relationCtrl.user!,
            standard: getCurrentCompany()?.standard));
        id++;
      });
    }
    return datas;
  }

  /// 加载数据标准
  List<Directory> loadDataStandards(Directory item) {
    List<Directory> datas = [];
    XDirectory tmpDir;
    int id = 0;
    if (null != relationCtrl.user) {
      DirectoryGroupType.getType(item.name)?.types.forEach((e) {
        tmpDir = XDirectory(
            id: "${item.id}_$id",
            directoryId: "${item.id}_$id",
            isDeleted: false);
        tmpDir.name = e.label;
        tmpDir.typeName = SpaceEnum.directory.label;
        datas.add(FixedDirectory(tmpDir, relationCtrl.user!,
            standard: getCurrentCompany()?.standard));
        id++;
      });
    }
    return datas;
  }

  /// 获得当前单位
  ICompany? getCurrentCompany({String? companyId}) {
    return null != relationCtrl.user
        ? relationCtrl.user!
            .findCompany(companyId ?? RoutePages.getRootRouteParam().id)
        : null;
  }

  /// 加载属性
  Future<List<IProperty>> loadProperties(Directory item) async {
    List<IProperty> files = item.standard.propertys;
    print('>>>>>>======loadProperties ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadPropertys();
    }
    return files;
  }

  ///加载分类
  Future<List<ISpecies>> loadSpecies(Directory item) async {
    List<ISpecies> files = item.standard.specieses;
    print('>>>>>>======loadSpecies ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadSpecieses();
    }
    return files;
  }

  ///加载字典
  Future<List<ISpecies>> loadDicts(Directory item) async {
    List<ISpecies> files = item.standard.dicts;
    print('>>>>>>======loadDicts ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadDicts();
    }
    return files;
  }

  ///加载应用
  Future<List<IApplication>> loadApps(Directory item) async {
    List<IApplication> files = item.standard.applications;
    print('>>>>>>======loadApps ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadApplications();
    }

    return files;
  }

  ///加载表单
  Future<List<IForm>> loadForms(Directory item) async {
    List<IForm> files = item.standard.forms;
    print('>>>>>>======loadForms ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadForms();
    }

    return files;
  }

  ///加载页面模版
  Future<List<IPageTemplate>> loadPageTemplates(Directory item) async {
    List<IPageTemplate> files = item.standard.templates;
    print('>>>>>>======loadPageTemplates ${files.length}');
    if (files.isEmpty) {
      return await item.standard.loadTemplates();
    }

    return files;
  }
}
