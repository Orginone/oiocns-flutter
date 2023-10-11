import 'dart:convert';

import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/dart/core/work/index.dart';

import 'store_tree/state.dart';

Future<List<StoreTreeNav>> loadDir(
    List<IDirectory> dirs, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var dir in dirs) {
    StoreTreeNav dirNav = StoreTreeNav(
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
          ...await loadApplications(dir.applications, target),
          ...await loadForm(dir.forms, target)
        ];
      },
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadFile(
    List<ISysFileInfo> files, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var file in files) {
    StoreTreeNav dirNav = StoreTreeNav(
      id: base64.encode(utf8.encode(file.metadata.name!)),
      source: file,
      name: file.metadata.name!,
      space: target,
      spaceEnum: SpaceEnum.file,
      image: file.shareInfo().thumbnail,
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadApplications(
    List<IApplication> applications, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var application in applications) {
    var works = await application.loadWorks();
    StoreTreeNav appNav = StoreTreeNav(
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

List<StoreTreeNav> loadWork(List<IWork> works, ITarget target) {
  List<StoreTreeNav> nav = [];
  for (var work in works) {
    StoreTreeNav workNav = StoreTreeNav(
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

Future<List<StoreTreeNav>> loadModule(
    List<IApplication> applications, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var application in applications) {
    StoreTreeNav appNav = StoreTreeNav(
        id: application.metadata.id,
        source: application,
        spaceEnum: SpaceEnum.module,
        name: application.metadata.name!,
        space: target,
        image: application.metadata.avatarThumbnail(),
        children: [],
        onNext: (item) async {
          var works = await application.loadWorks();
          List<StoreTreeNav> nav = [
            ...await loadModule(application.children, target),
            ...loadWork(works, target),
          ];
          item.children = nav;
        });
    nav.add(appNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadForm(List<IForm> forms, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var form in forms) {
    StoreTreeNav dirNav = StoreTreeNav(
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

List<StoreTreeNav> loadFilterItem(
    List<FieldModel> fields, ITarget target, IForm form,
    [String? id]) {
  List<StoreTreeNav> nav = [];

  List<StoreTreeNav> loadItem(List<FiledLookup> lookups) {
    List<StoreTreeNav> nav = [];
    for (var lookup in lookups) {
      StoreTreeNav specieNav = StoreTreeNav(
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
    StoreTreeNav specieNav = StoreTreeNav(
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

Future<List<StoreTreeNav>> loadCohorts(
    List<ICohort> cohorts, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var cohort in cohorts) {
    StoreTreeNav cohortNav = StoreTreeNav(
      id: cohort.metadata.id,
      source: cohort,
      spaceEnum: SpaceEnum.cohorts,
      name: cohort.metadata.name!,
      space: target,
      image: cohort.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await cohort.loadContent(reload: true);
        nav.children = [
          StoreTreeNav(
            id: SpaceEnum.cohorts.label,
            spaceEnum: SpaceEnum.directory,
            showPopup: false,
            name: "${SpaceEnum.cohorts.label}文件",
            space: cohort,
            children: [
              ...await loadFile(cohort.directory.files, cohort),
              ...await loadApplications(cohort.directory.applications, cohort),
              ...await loadForm(cohort.directory.forms, cohort),
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

Future<List<StoreTreeNav>> loadGroup(
    List<IGroup> groups, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var group in groups) {
    StoreTreeNav groupNav = StoreTreeNav(
      id: group.metadata.id,
      source: group,
      spaceEnum: SpaceEnum.groups,
      name: group.metadata.name!,
      space: group,
      image: group.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await group.loadContent(reload: true);
        nav.children = [
          StoreTreeNav(
            id: SpaceEnum.groups.label,
            showPopup: false,
            name: "${SpaceEnum.groups.label}文件",
            space: group,
            spaceEnum: SpaceEnum.directory,
            children: [
              ...await loadFile(group.directory.files, group),
              ...await loadApplications(group.directory.applications, group),
              ...await loadForm(group.directory.forms, group),
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

Future<List<StoreTreeNav>> loadTargets(
    List<ITarget> targets, ITarget target) async {
  List<StoreTreeNav> nav = [];
  for (var target in targets) {
    StoreTreeNav targetNav = StoreTreeNav(
      id: target.metadata.id,
      source: target,
      spaceEnum: SpaceEnum.departments,
      name: target.metadata.name!,
      space: target,
      image: target.share.avatar?.thumbnailUint8List,
      onNext: (nav) async {
        await target.loadContent(reload: true);
        nav.children = [
          StoreTreeNav(
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
