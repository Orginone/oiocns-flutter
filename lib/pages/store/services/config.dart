import 'dart:convert';

import 'package:ionicons/ionicons.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart' hide Group;
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/pages/store/models/index.dart';

///数据模块配置文件  处理数据模块数据

///加载数据 最外层的标签数据
SubGroup loadDataTabs() {
  IPerson? user = relationCtrl.provider.user;
  List<ICompany> companys = relationCtrl.user.companys;

  List<Group> group = [];
  Set<String> distinctValues = <String>{};
  //添加全部标签
  group.add(Group(label: '全部', value: '全部', allowEdit: true));
  group.add(Group(label: user.typeName, value: user.typeName, allowEdit: true));

  for (var e in companys) {
    if (!distinctValues.contains(e.typeName)) {
      distinctValues.add(e.typeName);
      group.add(Group(label: e.typeName, value: e.typeName, allowEdit: false));
    }
  }
  SubGroup subGroup = SubGroup(type: 'store', groups: group, hidden: []);

  return subGroup;
}

SubGroup loadDynamicTabs(List<StoreTreeNavModel> children) {
  List<String> tags = [];
  for (var element in children) {
    var item = element.source ?? element.space;

    if (item != null) {
      item.groupTags.forEach((tag) {
        if (!tags.contains(tag)) {
          tags.add(tag);
        }
      });
    }
  }
  // LogUtil.d(tags);
  List<Group> group = [];
  //添加全部标签
  group.add(Group(label: '全部', value: '全部', allowEdit: true));

  for (var e in tags) {
    group.add(Group(label: e, value: e, allowEdit: false));
  }
  SubGroup subGroup = SubGroup(type: 'store', groups: group, hidden: []);

  return subGroup;
}

Future<List<StoreTreeNavModel>> loadDir(
    List<IDirectory> dirs, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var dir in dirs) {
    StoreTreeNavModel dirNav = StoreTreeNavModel(
      source: dir,
      name: dir.metadata.name!,
      space: target,
      spaceEnum: SpaceEnum.directory,
      image: dir.metadata.avatarThumbnail(),
      onNext: (nav) async {
        await dir.loadContent(reload: true);
        nav.children = [
          ...await loadDir(dir.children, target),
          ...await loadFile(dir.files, target),
          ...await loadApplications(dir.standard.applications, target),
          ...await loadForm(dir.standard.forms, target)
        ];
      },
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadFile(
    List<ISysFileInfo> files, ITarget target) async {
  List<StoreTreeNavModel> nav = [];

  // LogUtil.d('config-loadFile');

  for (var file in files) {
    // LogUtil.d(file);
    // LogUtil.d(file.shareInfo().thumbnail);
    // LogUtil.d(
    //   file.filedata.thumbnailUint8List,
    // );
    StoreTreeNavModel dirNav = StoreTreeNavModel(
      id: base64.encode(utf8.encode(file.metadata.name!)),
      source: file,
      name: file.metadata.name!,
      space: target,
      spaceEnum: SpaceEnum.file,
      image: file.shareInfo().thumbnail,
      // image: file.shareInfo().thumbnailUint8List,//可以加载
      // image: file.metadata.avatarThumbnail,
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadApplications(
    List<IApplication> applications, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var application in applications) {
    var works = await application.loadWorks();
    StoreTreeNavModel appNav = StoreTreeNavModel(
      id: application.metadata.id,
      source: application,
      spaceEnum: SpaceEnum.applications,
      name: application.metadata.name!,
      space: target,
      image: application.metadata.avatarThumbnail(),
      children: [
        ...await loadModule(application.children, target),
        ...loadWork(works, target),
      ],
    );
    nav.add(appNav);
  }
  return nav;
}

List<StoreTreeNavModel> loadWork(List<IWork> works, ITarget target) {
  List<StoreTreeNavModel> nav = [];
  for (var work in works) {
    StoreTreeNavModel workNav = StoreTreeNavModel(
      id: work.metadata.id,
      source: work,
      spaceEnum: SpaceEnum.work,
      name: work.metadata.name!,
      space: target,
      image: work.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(workNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadModule(
    List<IApplication> applications, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var application in applications) {
    StoreTreeNavModel appNav = StoreTreeNavModel(
        id: application.metadata.id,
        source: application,
        spaceEnum: SpaceEnum.module,
        name: application.metadata.name!,
        space: target,
        image: application.metadata.avatarThumbnail(),
        children: [],
        onNext: (item) async {
          var works = await application.loadWorks();
          List<StoreTreeNavModel> nav = [
            ...await loadModule(application.children, target),
            ...loadWork(works, target),
          ];
          item.children = nav;
        });
    nav.add(appNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadForm(
    List<IForm> forms, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var form in forms) {
    StoreTreeNavModel dirNav = StoreTreeNavModel(
      id: form.metadata.id,
      source: form,
      spaceEnum: SpaceEnum.form,
      name: form.metadata.name!,
      space: target,
      onNext: (nav) async {
        form.attributes;
        //TODO:无此方法  用到需要看逻辑
        // await form.loadItems();
        var filter =
            form.fields.where((element) => element.valueType == "选择型").toList();
        nav.children = loadFilterItem(filter, target, form);
      },
      image: form.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

List<StoreTreeNavModel> loadFilterItem(
    List<FieldModel> fields, ITarget target, IForm form,
    [String? id]) {
  List<StoreTreeNavModel> nav = [];

  List<StoreTreeNavModel> loadItem(List<FiledLookup> lookups) {
    List<StoreTreeNavModel> nav = [];
    for (var lookup in lookups) {
      StoreTreeNavModel specieNav = StoreTreeNavModel(
        id: lookup.id!,
        source: lookup,
        spaceEnum: SpaceEnum.filter,
        name: lookup.text ?? "",
        space: target,
        form: form,
        image: Ionicons.filter_outline,
        children: [],
      );
      nav.add(specieNav);
    }
    return nav;
  }

  for (var field in fields) {
    StoreTreeNavModel specieNav = StoreTreeNavModel(
      id: field.id!,
      source: field,
      spaceEnum: SpaceEnum.filter,
      name: field.name!,
      space: target,
      form: form,
      image: Ionicons.filter_outline,
      children: field.lookups != null ? loadItem(field.lookups!) : [],
    );
    nav.add(specieNav);
  }

  return nav;
}

Future<List<StoreTreeNavModel>> loadCohorts(
    List<ICohort> cohorts, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var cohort in cohorts) {
    StoreTreeNavModel cohortNav = StoreTreeNavModel(
      id: cohort.metadata.id,
      source: cohort,
      spaceEnum: SpaceEnum.cohorts,
      name: cohort.metadata.name!,
      space: target,
      image: cohort.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await cohort.loadContent(reload: true);
        nav.children = [
          StoreTreeNavModel(
            id: SpaceEnum.cohorts.label,
            spaceEnum: SpaceEnum.directory,
            showPopup: false,
            name: "${SpaceEnum.cohorts.label}文件",
            space: cohort,
            children: [
              ...await loadFile(cohort.directory.files, cohort),
              ...await loadApplications(
                  cohort.directory.standard.applications, cohort),
              ...await loadForm(cohort.directory.standard.forms, cohort),
            ],
          ),
        ];
        if (cohort.directory.children.isNotEmpty) {
          nav.children.addAll(await loadDir(cohort.directory.children, cohort));
        }
      },
      children: [],
    );

    nav.add(cohortNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadGroup(
    List<IGroup> groups, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var group in groups) {
    StoreTreeNavModel groupNav = StoreTreeNavModel(
      id: group.metadata.id,
      source: group,
      spaceEnum: SpaceEnum.groups,
      name: group.metadata.name!,
      space: group,
      image: group.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await group.loadContent(reload: true);
        nav.children = [
          StoreTreeNavModel(
            id: SpaceEnum.groups.label,
            showPopup: false,
            name: "${SpaceEnum.groups.label}文件",
            space: group,
            spaceEnum: SpaceEnum.directory,
            children: [
              ...await loadFile(group.directory.files, group),
              ...await loadApplications(
                  group.directory.standard.applications, group),
              ...await loadForm(group.directory.standard.forms, group),
            ],
          ),
        ];
        if (group.directory.children.isNotEmpty) {
          nav.children.addAll(await loadDir(group.directory.children, group));
        }
        if (group.children.isNotEmpty) {
          nav.children.addAll(await loadGroup(group.children, group));
        }
      },
      children: [],
    );
    nav.add(groupNav);
  }
  return nav;
}

Future<List<StoreTreeNavModel>> loadTargets(
    List<ITarget> targets, ITarget target) async {
  List<StoreTreeNavModel> nav = [];
  for (var target in targets) {
    StoreTreeNavModel targetNav = StoreTreeNavModel(
      id: target.metadata.id,
      source: target,
      spaceEnum: SpaceEnum.departments,
      name: target.metadata.name!,
      space: target,
      image: target.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await target.loadContent(reload: true);
        nav.children = [
          StoreTreeNavModel(
            id: target.metadata.typeName!,
            showPopup: false,
            name: "${target.metadata.typeName}文件",
            space: target,
            spaceEnum: SpaceEnum.directory,
            children: await loadFile(target.directory.files, target),
          ),
        ];
        if (target.directory.children.isNotEmpty) {
          nav.children.addAll(await loadDir(target.directory.children, target));
        }
      },
      children: [],
    );

    nav.add(targetNav);
  }
  return nav;
}
