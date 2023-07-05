import 'dart:convert';

import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/out_team/cohort.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/file_info.dart';
import 'package:orginone/dart/core/thing/form.dart';

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
      spaceEnum: SpaceEnum.directory,
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
      id: base64.encode(utf8.encode(file.metadata.name!)),
      source: file,
      name: file.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.file,
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
    StoreTreeNav appNav = StoreTreeNav(
      id: application.metadata.id!,
      source: application,
      spaceEnum: SpaceEnum.applications,
      name: application.metadata.name!,
      space: belong,
      image: application.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(appNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadForm(List<IForm> forms, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var form in forms) {
    await form.loadContent(reload: true);
    StoreTreeNav dirNav = StoreTreeNav(
      id: form.metadata.id!,
      source: form,
      spaceEnum: SpaceEnum.form,
      name: form.metadata.name!,
      space: belong,
      image: form.metadata.avatarThumbnail(),
      children: await loadSpeciesItem(form.items,belong,form),
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<StoreTreeNav>> loadSpeciesItem(List<XSpeciesItem> species,IBelong belong,IForm form,
    [String? id]) async {
  List<StoreTreeNav> nav = [];

  for (var specie in species) {
     if(specie.parentId == id){
       StoreTreeNav specieNav = StoreTreeNav(
         id: specie.id!,
         source: specie,
         spaceEnum: SpaceEnum.species,
         name: specie.name!,
         space: belong,
         form: form,
         image: specie.avatarThumbnail(),
         children: await loadSpeciesItem(species,belong,form,specie.id),
       );
       nav.add(specieNav);
     }
  }

  return nav;
}

Future<List<StoreTreeNav>> loadCohorts(
    List<ICohort> cohorts, IBelong belong) async {
  List<StoreTreeNav> nav = [];
  for (var cohort in cohorts) {
    StoreTreeNav cohortNav = StoreTreeNav(
      id: cohort.metadata.id!,
      source: cohort,
      spaceEnum: SpaceEnum.cohorts,
      name: cohort.metadata.name!,
      space: belong,
      image: cohort.share.avatar?.thumbnailUint8List,
      children: [],
    );
    cohortNav.children = [
      StoreTreeNav(
        id: SpaceEnum.cohorts.label,
        spaceEnum: SpaceEnum.directory,
        showPopup: false,
        name: "${SpaceEnum.cohorts.label}文件",
        space: belong,
        children: await loadFile(cohort.directory.files,belong),
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
      id: group.metadata.id!,
      source: group,
      spaceEnum: SpaceEnum.groups,
      name: group.metadata.name!,
      space: belong,
      image: group.share.avatar?.thumbnailUint8List,
      children: [],
    );
    groupNav.children = [
      StoreTreeNav(
        id:SpaceEnum.groups.label ,
        showPopup: false,
        name: "${SpaceEnum.groups.label}文件",
        space: belong,
        spaceEnum: SpaceEnum.directory,
        children: await loadFile(group.directory.files,belong),
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
    StoreTreeNav targetNav = StoreTreeNav(
      id: target.metadata.id!,
      source: target,
      spaceEnum: SpaceEnum.departments,
      name: target.metadata.name!,
      space: belong,
      image: target.share.avatar?.thumbnailUint8List,
      children: [],
    );
    targetNav.children = [
      StoreTreeNav(
        id: target.metadata.typeName!,
        showPopup: false,
        name: "${target.metadata.typeName}文件",
        space: belong,
        spaceEnum: SpaceEnum.directory,
        children: await loadFile(target.directory.files,belong),
      ),
    ];
    if (target.directory.children.isNotEmpty) {
      targetNav.children
          .addAll(await loadDir(target.directory.children, belong));
    }
    nav.add(targetNav);
  }
  return nav;
}
