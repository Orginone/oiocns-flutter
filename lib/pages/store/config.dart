import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/dart/core/thing/form.dart';
import 'package:orginone/dart/core/thing/property.dart';
import 'package:orginone/dart/core/thing/species.dart';

import 'store_tree/state.dart';

Future<List<StoreTreeNav>> loadDir(
    List<IDirectory> dirs, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var dir in dirs) {
    await dir.loadContent(reload: true);
    StoreTreeNav dirNav = StoreTreeNav(
      source: dir,
      name: dir.metadata.name!,
      space: belong,
      image: dir.metadata.avatarThumbnail(),
      children: [],
    );

    dirNav.children = [];
    if (dir.children.isNotEmpty) {
      dirNav.children.addAll(await loadDir(dir.children, belong));
    }
    if (dir.files.isNotEmpty) {
      dirNav.children.addAll(await loadFile(dir.files, belong));
    }
    if (dir.applications.isNotEmpty) {
      dirNav.children.addAll(await loadApplications(dir.applications, belong));
    }
    if (dir.forms.isNotEmpty) {
      dirNav.children.addAll(await loadForm(dir.forms, belong));
    }
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadFile(
    List<ISysFileInfo> files, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var file in files) {
    StoreTreeNav dirNav = StoreTreeNav(
      source: file,
      name: file.metadata.name!,
      space: belong,
      image: file.shareInfo().thumbnail,
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadApplications(
    List<IApplication> applications, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var application in applications) {
    StoreTreeNav dirNav = StoreTreeNav(
      source: application,
      name: application.metadata.name!,
      space: belong,
      image: application.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadForm(List<IForm> forms, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var form in forms) {
    StoreTreeNav dirNav = StoreTreeNav(
      source: form,
      name: form.metadata.name!,
      space: belong,
      image: form.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadCohorts(
    List<ICohort> cohorts, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var cohort in cohorts) {
    StoreTreeNav cohortNav = StoreTreeNav(
      source: cohort,
      name: cohort.metadata.name!,
      space: belong,
      image: cohort.share.avatar?.thumbnailUint8List,
      children: [],
    );
    cohortNav.children = [
      StoreTreeNav(
        name: "${SpaceEnum.cohorts.label}文件",
        space: belong,
        children: cohort.directory.files.map((e) {
          return StoreTreeNav(
            name: e.filedata.name!,
            space: belong,
            source: e,
            image: e.shareInfo().thumbnail,
            children: [],
          );
        }).toList(),
      ),
    ];
    if (cohort.directory.children.isNotEmpty) {
      cohortNav.children
          .addAll(await loadDir(cohort.directory.children, belong));
    }
    nav.add(cohortNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadGroup(
    List<IGroup> groups, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var group in groups) {
    StoreTreeNav groupNav = StoreTreeNav(
      source: group,
      name: group.metadata.name!,
      space: belong,
      image: group.share.avatar?.thumbnailUint8List,
      children: [],
    );
    groupNav.children = [
      StoreTreeNav(
        name: "${SpaceEnum.groups.label}文件",
        space: belong,
        children: group.directory.files.map((e) {
          return StoreTreeNav(
            name: e.filedata.name!,
            space: belong,
            source: e,
            image: e.shareInfo().thumbnail,
            children: [],
          );
        }).toList(),
      ),
    ];
    if (group.directory.children.isNotEmpty) {
      groupNav.children.addAll(await loadDir(group.directory.children, belong));
    }
    if (group.children.isNotEmpty) {
      groupNav.children.addAll(await loadGroup(group.children, belong));
    }
    nav.add(groupNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadTargets(
    List<ITarget> targets, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var target in targets) {
    StoreTreeNav cohortNav = StoreTreeNav(
      source: target,
      name: target.metadata.name!,
      space: belong,
      image: target.share.avatar?.thumbnailUint8List,
      children: [],
    );
    cohortNav.children = [
      StoreTreeNav(
        name: "${target.metadata.typeName}文件",
        space: belong,
        children: target.directory.files.map((e) {
          return StoreTreeNav(
            name: e.filedata.name!,
            space: belong,
            source: e,
            image: e.shareInfo().thumbnail,
            children: [],
          );
        }).toList(),
      ),
    ];
    if (target.directory.children.isNotEmpty) {
      cohortNav.children
          .addAll(await loadDir(target.directory.children, belong));
    }
    nav.add(cohortNav);
  }
  return nav;
}
