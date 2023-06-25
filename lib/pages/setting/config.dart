

import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
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
import 'package:orginone/pages/setting/home/state.dart';


List<String> memberTitle = [
  "账号",
  "昵称",
  "姓名",
  "手机号",
  "签名",
];

List<String> spaceTitle = [
  "单位简称",
  "社会统一信用代码",
  "单位全称",
  "单位代码",
  "单位简介",
];

List<String> groupTitle = [
  "组织群名称",
  "组织群编码",
  "集团简介",
];

List<String> outGroupTitle = [
  "单位简称",
  "社会统一信用",
  "单位全称",
  "单位代码",
  "单位简介",
];

List<String> identityTitle = [
  "ID",
  "角色编号",
  "角色名称",
  "权限",
  "组织",
  "备注",
];

List<String> ValueType = [
  '数值型',
  '描述型',
  '选择型',
  '分类型',
  '附件型',
  '日期型',
  '时间型',
  '用户型',
];

enum IdentityFunction {
  edit,
  delete,
  addMember,
}

enum CompanyFunction {
  roleSettings,
  addUser,
  addGroup,
}

enum UserFunction{
  record,
  addUser,
  addGroup,
}

// enum AttributeType{
//
//
//   String label,
//   const AttributeType(this.label);
//
// }

List<IAuthority> getAllAuthority(List<IAuthority> authority) {
  List<IAuthority> list = [];
  for (var element in authority) {
    list.add(element);
    if (element.children.isNotEmpty) {
      list.addAll(getAllAuthority(element.children));
    }
  }
  return list;
}

List<ITarget> getAllTarget(List<ITarget> targets) {
  List<ITarget> list = [];
  for (var element in targets) {
    list.add(element);
    if (element.subTarget.isNotEmpty) {
      list.addAll(getAllTarget(element.subTarget));
    }
  }
  return list;
}

List<ISpecies> getAllSpecies(List<ISpecies> species) {
  List<ISpecies> list = [];
  for (var element in species) {
    list.add(element);
    if (element.directory.specieses.isNotEmpty) {
      list.addAll(getAllSpecies(element.directory.specieses));
    }
  }
  return list;
}

List<IGroup> getAllOutAgency(List<IGroup> outAgencyGroup) {
  List<IGroup> list = [];
  for (var element in outAgencyGroup) {
    list.add(element);
    if (element.children.isNotEmpty) {
      list.addAll(getAllOutAgency(element.children));
    }
  }

  return list;
}



Future<List<SettingNavModel>> loadDir(
    List<IDirectory> dirs, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var dir in dirs) {
    await dir.loadContent(reload: true);
    SettingNavModel dirNav = SettingNavModel(
      id: dir.metadata.id!,
      source: dir,
      name: dir.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.directory,
      image: dir.metadata.avatarThumbnail(),
    );

    dirNav.children = [];
    if (dir.children.isNotEmpty) {
      dirNav.children.addAll(await loadDir(dir.children, belong));
    }
    if (dir.files.isNotEmpty) {
      dirNav.children.addAll(await loadFile(dir.files, belong));
    }
    if (dir.specieses.isNotEmpty) {
      dirNav.children.addAll(await loadSpecies(dir.specieses, belong));
    }
    if (dir.applications.isNotEmpty) {
      dirNav.children.addAll(await loadApplications(dir.applications, belong));
    }
    if (dir.propertys.isNotEmpty) {
      dirNav.children.addAll(await loadPropertys(dir.propertys, belong));
    }
    if (dir.forms.isNotEmpty) {
      dirNav.children.addAll(await loadForm(dir.forms, belong));
    }
    nav.add(dirNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadFile(
    List<ISysFileInfo> files, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var file in files) {
    SettingNavModel dirNav = SettingNavModel(
      id: file.metadata.id!,
      source: file,
      name: file.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.file,
      image: file.shareInfo().thumbnail,
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadSpecies(
    List<ISpecies> species, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var specie in species) {
    SettingNavModel specieNav = SettingNavModel(
      id: specie.metadata.id!,
      source: specie,
      name: specie.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.species,
      image: specie.metadata.avatarThumbnail(),
    );
    nav.add(specieNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadApplications(
    List<IApplication> applications, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var application in applications) {
    SettingNavModel appNav = SettingNavModel(
      id: application.metadata.id!,
      source: application,
      name: application.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.applications,
      image: application.metadata.avatarThumbnail(),
    );
    nav.add(appNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadPropertys(
    List<IProperty> propertys, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var property in propertys) {
    SettingNavModel propertyNav = SettingNavModel(
      id: property.metadata.id!,
      source: property,
      name: property.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.property,
      image: property.metadata.avatarThumbnail(),
    );
    nav.add(propertyNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadForm(
    List<IForm> forms, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var form in forms) {
    SettingNavModel formNav = SettingNavModel(
      id: form.metadata.id!,
      source: form,
      name: form.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.form,
      image: form.metadata.avatarThumbnail(),
    );
    nav.add(formNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadCohorts(
    List<ICohort> cohorts, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var cohort in cohorts) {
    SettingNavModel cohortNav = SettingNavModel(
      id: cohort.metadata.id!,
      source: cohort,
      name: cohort.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.cohorts,
      image: cohort.share.avatar?.thumbnailUint8List,
    );
    cohortNav.children = [
      SettingNavModel(
        id: SpaceEnum.cohorts.label,
        name: "${SpaceEnum.cohorts.label}文件",
        space: belong,
        spaceEnum: SpaceEnum.cohorts,
        children: [
          ...await loadFile(cohort.directory.files, belong),
          ...await loadSpecies(cohort.directory.specieses, belong),
          ...await loadApplications(cohort.directory.applications, belong),
          ...await loadForm(cohort.directory.forms, belong),
          ...await loadPropertys(cohort.directory.propertys, belong),
        ]
      ),
      SettingNavModel(
        id: SpaceEnum.cohorts.label,
        name: "${SpaceEnum.cohorts.label}成员",
        space: belong,
        spaceEnum: SpaceEnum.cohorts,
        children: cohort.members.map((e){
          return SettingNavModel(
            id: e.id!,
            name: e.name!,
            space: belong,
            source: e,
            spaceEnum: SpaceEnum.person,
            image: e.avatarThumbnail(),
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

Future<List<SettingNavModel>> loadDepartment(
    List<IDepartment> departments, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var department in departments) {
    SettingNavModel departmentNav = SettingNavModel(
      id: department.metadata.id!,
      source: department,
      name: department.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.departments,
      image: department.share.avatar?.thumbnailUint8List,
    );
    departmentNav.children = [
      SettingNavModel(
        id: SpaceEnum.departments.label,
        name: "${SpaceEnum.departments.label}文件",
        space: belong,
        spaceEnum: SpaceEnum.departments,
        children: [
          ...await loadFile(department.directory.files, belong),
          ...await loadSpecies(department.directory.specieses, belong),
          ...await loadApplications(department.directory.applications, belong),
          ...await loadForm(department.directory.forms, belong),
          ...await loadPropertys(department.directory.propertys, belong),
        ]
      ),
      SettingNavModel(
        id: SpaceEnum.departments.label,
        name: "${SpaceEnum.departments.label}成员",
        space: belong,
        spaceEnum: SpaceEnum.departments,
        children: department.members.map((e){
          return SettingNavModel(
            id: e.id!,
            name: e.name!,
            space: belong,
            source: e,
            spaceEnum: SpaceEnum.person,
            image: e.avatarThumbnail(),
          );
        }).toList(),
      ),
    ];
    if (department.directory.children.isNotEmpty) {
      departmentNav.children
          .addAll(await loadDir(department.directory.children, belong));
    }
    if(department.children.isNotEmpty){
      departmentNav.children
          .addAll(await loadDepartment(department.children, belong));
    }
    nav.add(departmentNav);
  }
  return nav;
}


Future<List<SettingNavModel>> loadGroup(
    List<IGroup> groups, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var group in groups) {
    SettingNavModel groupNav = SettingNavModel(
      id: group.metadata.id!,
      source: group,
      name: group.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.groups,
      image: group.share.avatar?.thumbnailUint8List,
    );
    groupNav.children = [
      SettingNavModel(
        id: SpaceEnum.groups.label,
        name: "${SpaceEnum.groups.label}文件",
        space: belong,
        spaceEnum: SpaceEnum.groups,
        children: [
          ...await loadFile(group.directory.files, belong),
          ...await loadSpecies(group.directory.specieses, belong),
          ...await loadApplications(group.directory.applications, belong),
          ...await loadForm(group.directory.forms, belong),
          ...await loadPropertys(group.directory.propertys, belong),
        ]
      ),
      SettingNavModel(
        id: SpaceEnum.groups.label,
        name: "${SpaceEnum.groups.label}成员",
        space: belong,
        spaceEnum: SpaceEnum.groups,
        children: group.members.map((e){
          return SettingNavModel(
            id: e.id!,
            name: e.name!,
            space: belong,
            source: e,
            spaceEnum: SpaceEnum.person,
            image: e.avatarThumbnail(),

          );
        }).toList(),
      ),
    ];
    if (group.directory.children.isNotEmpty) {
      groupNav.children
          .addAll(await loadDir(group.directory.children, belong));
    }
    if(group.children.isNotEmpty){
      groupNav.children
          .addAll(await loadGroup(group.children, belong));
    }
    nav.add(groupNav);
  }
  return nav;
}