import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/standard/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';
import 'package:orginone/dart/core/thing/standard/form.dart';
import 'package:orginone/dart/core/thing/standard/property.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/pages/setting/home/state.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'dialog.dart';

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

enum UserFunction {
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
    SettingNavModel dirNav = SettingNavModel(
      id: dir.metadata.id,
      source: dir,
      name: dir.metadata.name!,
      space: belong,
      spaceEnum: SpaceEnum.directory,
      image: dir.metadata.avatarThumbnail(),
      onNext: (nav) async {
        await dir.loadContent(reload: true);
        nav.children = [
          ...await loadDir(dir.children, belong),
          ...await loadFile(dir.files, belong),
          ...await loadSpecies(dir.specieses, belong),
          ...await loadApplications(dir.applications, belong),
          ...await loadPropertys(dir.propertys, belong),
          ...await loadForm(dir.forms, belong),
        ];
      },
    );
    nav.add(dirNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadFile(
    List<ISysFileInfo> files, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var file in files) {
    SettingNavModel dirNav = SettingNavModel(
      id: base64.encode(utf8.encode(file.metadata.name!)),
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
      id: specie.metadata.id,
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
    var works = await application.loadWorks();
    SettingNavModel appNav = SettingNavModel(
        id: application.metadata.id,
        source: application,
        name: application.metadata.name!,
        space: belong,
        spaceEnum: SpaceEnum.applications,
        image: application.metadata.avatarThumbnail(),
        children: [
          ...await loadModule(application.children, belong),
          ...loadWork(works, belong),
        ]);
    nav.add(appNav);
  }
  return nav;
}

List<SettingNavModel> loadWork(List<IWork> works, ITarget target) {
  List<SettingNavModel> nav = [];
  for (var work in works) {
    SettingNavModel workNav = SettingNavModel(
      id: work.metadata.id,
      source: work,
      spaceEnum: SpaceEnum.work,
      name: work.metadata.name!,
      space: target as IBelong,
      image: work.metadata.avatarThumbnail(),
      children: [],
    );
    nav.add(workNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadModule(
    List<IApplication> applications, ITarget target) async {
  List<SettingNavModel> nav = [];
  for (var application in applications) {
    SettingNavModel appNav = SettingNavModel(
        id: application.metadata.id,
        source: application,
        spaceEnum: SpaceEnum.module,
        name: application.metadata.name!,
        space: target as IBelong,
        image: application.metadata.avatarThumbnail(),
        children: [],
        onNext: (item) async {
          var works = await application.loadWorks();
          List<SettingNavModel> nav = [
            ...await loadModule(application.children, target),
            ...loadWork(works, target),
          ];
          item.children = nav;
        });
    nav.add(appNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadPropertys(
    List<IProperty> propertys, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var property in propertys) {
    SettingNavModel propertyNav = SettingNavModel(
      id: property.metadata.id,
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
      id: form.metadata.id,
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
        id: cohort.metadata.id,
        source: cohort,
        name: cohort.metadata.name!,
        space: belong,
        spaceEnum: SpaceEnum.cohorts,
        image: cohort.share.avatar?.thumbnailUint8List,
        onNext: (nav) async {
          await cohort.loadContent(reload: true);
          nav.children = [
            SettingNavModel(
                id: SpaceEnum.cohorts.label,
                name: "${SpaceEnum.cohorts.label}文件",
                space: belong,
                showPopup: false,
                spaceEnum: SpaceEnum.directory,
                children: [
                  ...await loadFile(cohort.directory.files, belong),
                  ...await loadSpecies(cohort.directory.specieses, belong),
                  ...await loadApplications(
                      cohort.directory.applications, belong),
                  ...await loadForm(cohort.directory.forms, belong),
                  ...await loadPropertys(cohort.directory.propertys, belong),
                ]),
            SettingNavModel(
              id: SpaceEnum.cohorts.label,
              name: "${SpaceEnum.cohorts.label}成员",
              space: belong,
              showPopup: false,
              spaceEnum: SpaceEnum.person,
              children: cohort.members.map((e) {
                return SettingNavModel(
                  id: e.id,
                  name: e.name!,
                  space: belong,
                  source: e,
                  spaceEnum: SpaceEnum.person,
                  image: e.avatarThumbnail(),
                );
              }).toList(),
            ),
            ...await loadDir(cohort.directory.children, belong)
          ];
        });

    nav.add(cohortNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadDepartment(
    List<IDepartment> departments, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var department in departments) {
    SettingNavModel departmentNav = SettingNavModel(
        id: department.metadata.id,
        source: department,
        name: department.metadata.name!,
        space: belong,
        spaceEnum: SpaceEnum.departments,
        image: department.share.avatar?.thumbnailUint8List,
        onNext: (nav) async {
          await department.loadContent(reload: true);
          nav.children = [
            SettingNavModel(
                id: SpaceEnum.departments.label,
                showPopup: false,
                name: "${SpaceEnum.departments.label}文件",
                space: belong,
                spaceEnum: SpaceEnum.directory,
                children: [
                  ...await loadFile(department.directory.files, belong),
                  ...await loadSpecies(department.directory.specieses, belong),
                  ...await loadApplications(
                      department.directory.applications, belong),
                  ...await loadForm(department.directory.forms, belong),
                  ...await loadPropertys(
                      department.directory.propertys, belong),
                ]),
            SettingNavModel(
              showPopup: false,
              id: SpaceEnum.departments.label,
              name: "${SpaceEnum.departments.label}成员",
              space: belong,
              spaceEnum: SpaceEnum.person,
              children: department.members.map((e) {
                return SettingNavModel(
                  id: e.id,
                  name: e.name!,
                  space: belong,
                  source: e,
                  spaceEnum: SpaceEnum.person,
                  image: e.avatarThumbnail(),
                );
              }).toList(),
            ),
            ...await loadDir(department.directory.children, belong),
            ...await loadDepartment(department.children, belong)
          ];
        });
    nav.add(departmentNav);
  }
  return nav;
}

Future<List<SettingNavModel>> loadGroup(
    List<IGroup> groups, IBelong belong) async {
  List<SettingNavModel> nav = [];
  for (var group in groups) {
    SettingNavModel groupNav = SettingNavModel(
        id: group.metadata.id,
        source: group,
        name: group.metadata.name!,
        space: belong,
        spaceEnum: SpaceEnum.groups,
        image: group.share.avatar?.thumbnailUint8List,
        onNext: (nav) async {
          await group.loadContent(reload: true);
          nav.children = [
            SettingNavModel(
                showPopup: false,
                id: SpaceEnum.groups.label,
                name: "${SpaceEnum.groups.label}文件",
                space: belong,
                spaceEnum: SpaceEnum.directory,
                children: [
                  ...await loadFile(group.directory.files, belong),
                  ...await loadSpecies(group.directory.specieses, belong),
                  ...await loadApplications(
                      group.directory.applications, belong),
                  ...await loadForm(group.directory.forms, belong),
                  ...await loadPropertys(group.directory.propertys, belong),
                ]),
            SettingNavModel(
              id: SpaceEnum.groups.label,
              showPopup: false,
              name: "${SpaceEnum.groups.label}成员",
              space: belong,
              spaceEnum: SpaceEnum.person,
              children: group.members.map((e) {
                return SettingNavModel(
                  id: e.id,
                  name: e.name!,
                  space: belong,
                  source: e,
                  spaceEnum: SpaceEnum.person,
                  image: e.avatarThumbnail(),
                );
              }).toList(),
            ),
            ...await loadDir(group.directory.children, belong),
            ...await loadGroup(group.children, belong)
          ];
        });

    nav.add(groupNav);
  }
  return nav;
}

Future<void> loadUserSetting(Rxn<SettingNavModel> model) async {
  var user = model.value!.children.first;
  user.onNext = (nav) async {
    await user.space!.loadContent(reload: true);
    List<SettingNavModel> function = [
      SettingNavModel(
          name: "个人文件",
          space: user.space,
          children: [
            ...await loadFile(user.space!.directory.files, user.space!),
            ...await loadSpecies(user.space!.directory.specieses, user.space!),
            ...await loadApplications(
                user.space!.directory.applications, user.space!),
            ...await loadForm(user.space!.directory.forms, user.space!),
            ...await loadPropertys(
                user.space!.directory.propertys, user.space!),
          ],
          spaceEnum: SpaceEnum.directory,
          showPopup: false),
      SettingNavModel(
        name: "我的好友",
        space: user.space,
        spaceEnum: SpaceEnum.person,
        showPopup: false,
        image: user.space!.metadata.avatarThumbnail(),
        children: user.space!.members.map((e) {
          return SettingNavModel(
            name: e.name!,
            space: user.space,
            source: e,
            spaceEnum: SpaceEnum.person,
            image: e.avatarThumbnail(),
          );
        }).toList(),
      ),
    ];

    function.addAll(await loadDir(user.space!.directory.children, user.space!));
    function.addAll(await loadCohorts(user.space!.cohorts, user.space!));
    nav.children = function;
  };
}

Future<void> loadCompanySetting(Rxn<SettingNavModel> model) async {
  for (int i = 1; i < model.value!.children.length; i++) {
    var company = model.value!.children[i];
    company.onNext = (nav) async {
      await company.space!.loadContent(reload: true);
      List<SettingNavModel> function = [
        SettingNavModel(
            name: "单位文件",
            space: company.space,
            children: [
              ...await loadFile(company.space!.directory.files, company.space!),
              ...await loadSpecies(
                  company.space!.directory.specieses, company.space!),
              ...await loadApplications(
                  company.space!.directory.applications, company.space!),
              ...await loadForm(company.space!.directory.forms, company.space!),
              ...await loadPropertys(
                  company.space!.directory.propertys, company.space!),
            ],
            spaceEnum: SpaceEnum.directory,
            showPopup: false),
        SettingNavModel(
          name: "单位成员",
          space: company.space,
          spaceEnum: SpaceEnum.person,
          showPopup: false,
          image: company.space!.metadata.avatarThumbnail(),
          children: company.space!.members.map((e) {
            return SettingNavModel(
              id: e.id,
              name: e.name!,
              space: company.space,
              source: e,
              spaceEnum: SpaceEnum.person,
              image: e.avatarThumbnail(),
            );
          }).toList(),
        ),
      ];
      function.addAll(
          await loadDir(company.space!.directory.children, company.space!));
      function.addAll(await loadDepartment(
          (company.space! as Company).departments, company.space!));
      function.addAll(
          await loadGroup((company.space! as Company).groups, company.space!));
      function
          .addAll(await loadCohorts(company.space!.cohorts, company.space!));
      nav.children = function;
    };
  }
}

void createDir(SettingNavModel item,
    {bool isEdit = false, VoidCallback? callback}) {
  showCreateGeneralDialog(Get.context!, "目录",
      isEdit: isEdit,
      name: isEdit ? item.source.metadata.name! : '',
      code: isEdit ? item.source.metadata.code! : '',
      remark: isEdit ? item.source.metadata.remark! : '',
      callBack: (name, code, remark) async {
    var model = DirectoryModel(name: name, code: code, remark: remark);
    if (isEdit) {
      bool success = await item.source.update(model);
      if (success) {
        ToastUtils.showMsg(msg: "修改成功");
        item.name = name;
        item.source.metadata.name = name;
        item.source.metadata.code = code;
        item.source.metadata.remark = remark;
        callback?.call();
      }
    } else {
      IDirectory? dir;
      switch (item.spaceEnum!) {
        case SpaceEnum.directory:
          dir = await item.source.create(model);
          break;
        case SpaceEnum.user:
        case SpaceEnum.company:
          dir = await item.space!.directory.create(model);
          break;
        case SpaceEnum.person:
        case SpaceEnum.departments:
        case SpaceEnum.groups:
        case SpaceEnum.cohorts:
          dir = await item.source!.directory.create(model);
          break;
      }
      if (dir != null) {
        ToastUtils.showMsg(msg: "创建成功");
        item.children.add(SettingNavModel(
            id: dir.id,
            name: dir.metadata.name!,
            space: item.space,
            source: dir,
            spaceEnum: SpaceEnum.directory,
            image: dir.metadata.avatarThumbnail()));
        callback?.call();
      }
    }
  });
}

void uploadFile(SettingNavModel item,
    {Function([SettingNavModel? nav])? callback}) async {
  late IDirectory dir;

  switch (item.spaceEnum!) {
    case SpaceEnum.directory:
      dir = await item.source;
      break;
    case SpaceEnum.user:
    case SpaceEnum.company:
      dir = item.space!.directory;
      break;
    case SpaceEnum.person:
    case SpaceEnum.departments:
    case SpaceEnum.groups:
    case SpaceEnum.cohorts:
      dir = await item.source!.directory;
      break;
  }

  FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.any);
  if (result != null) {
    LoadingDialog.showLoading(Get.context!, msg: "上传中");
    var file = await dir.createFile(
      File(result.files.first.path!),
      progress: (progress) {
        if (progress == 1) {
          ToastUtils.showMsg(msg: "上传成功");
          LoadingDialog.dismiss(Get.context!);
        }
      },
    );
    if (file != null) {
      SettingNavModel nav = SettingNavModel(
          id: file.id,
          name: file.metadata.name!,
          source: file,
          spaceEnum: SpaceEnum.file,
          space: item.space,
          image: file.shareInfo().thumbnail);
      if (item.spaceEnum == SpaceEnum.directory) {
        item.children.add(nav);
      } else {
        item.children[0].children.add(nav);
      }
      callback?.call(nav);
    }
  }
}

void createSpecies(SettingNavModel item, String typeName,
    {bool isEdit = false, Function([SettingNavModel? nav])? callback}) {
  showCreateGeneralDialog(Get.context!, typeName,
      isEdit: isEdit,
      name: isEdit ? item.source.metadata.name! : '',
      code: isEdit ? item.source.metadata.code! : '',
      remark: isEdit ? item.source.metadata.remark! : '',
      callBack: (name, code, remark) async {
    var model = SpeciesModel(
        name: name, code: code, remark: remark, typeName: typeName);
    if (isEdit) {
      bool success = await item.source!.update(model);
      if (success) {
        ToastUtils.showMsg(msg: "修改成功");
        item.name = name;
        item.source.metadata.name = name;
        item.source.metadata.code = code;
        item.source.metadata.remark = remark;
        callback?.call();
      }
    } else {
      ISpecies? species;
      switch (item.spaceEnum!) {
        case SpaceEnum.directory:
          species = await item.source.createSpecies(model);
          break;
        case SpaceEnum.user:
        case SpaceEnum.company:
          species = await item.space!.directory.createSpecies(model);
          break;
        case SpaceEnum.person:
        case SpaceEnum.departments:
        case SpaceEnum.groups:
        case SpaceEnum.cohorts:
          species = await item.source!.directory.createSpecies(model);
          break;
      }
      if (species != null) {
        ToastUtils.showMsg(msg: "创建成功");
        var nav = SettingNavModel(
            id: species.id,
            name: species.metadata.name!,
            space: item.space,
            source: species,
            spaceEnum: SpaceEnum.species,
            image: species.metadata.avatarThumbnail());
        if (item.spaceEnum == SpaceEnum.user ||
            item.spaceEnum == SpaceEnum.company) {
          item.children[0].children.add(nav);
        } else {
          item.children.add(nav);
        }
        callback?.call(nav);
      }
    }
  });
}

void rename(SettingNavModel item, {VoidCallback? callback}) {
  showTextInputDialog(
          context: Get.context!,
          textFields: [
            DialogTextField(
              hintText: item.name,
            )
          ],
          title: "修改${item.name}名称")
      .then((str) {
    if (str != null && str[0].isNotEmpty) {
      item.source.rename(str[0]).then((value) {
        if (value) {
          ToastUtils.showMsg(msg: "修改成功");
          item.name = str[0];
          callback?.call();
        }
      });
    }
  });
}

void delete(SettingNavModel item, {VoidCallback? callback}) async {
  bool success = await item.source.delete();
  if (success) {
    ToastUtils.showMsg(msg: "删除成功");
    callback?.call();
  }
}

void createTarget(PopupMenuKey key, SettingNavModel model,
    {bool isEdit = false, Function([SettingNavModel? nav])? callback}) {
  List<TargetType> targetType = [];
  SpaceEnum? spaceEnum;
  switch (key) {
    case PopupMenuKey.createDepartment:
      targetType = [
        TargetType.department,
        TargetType.office,
        TargetType.working,
        TargetType.research,
        TargetType.laboratory
      ];
      spaceEnum = SpaceEnum.departments;
      break;
    case PopupMenuKey.createStation:
      targetType = [TargetType.station];
      spaceEnum = SpaceEnum.groups;
      break;
    case PopupMenuKey.createGroup:
      targetType = [TargetType.group];
      spaceEnum = SpaceEnum.groups;
      break;
    case PopupMenuKey.createCohort:
      targetType = [TargetType.cohort];
      spaceEnum = SpaceEnum.cohorts;
      break;
    case PopupMenuKey.createCompany:
      targetType = [
        TargetType.company,
        TargetType.hospital,
        TargetType.university
      ];
      spaceEnum = SpaceEnum.company;
      break;
  }
  var item = model.source ?? model.space;
  showCreateOrganizationDialog(Get.context!, targetType, callBack: (String name,
          String code,
          String nickName,
          String identify,
          String remark,
          TargetType type) async {
    var target = TargetModel(
      name: name,
      code: code,
      typeName: type.label,
      teamName: nickName,
      teamCode: code,
      remark: remark,
    );
    if (isEdit) {
      target.id = item.id;
      target.belongId = item.metadata.belongId;
      bool success = false;
      if (model.source == null) {
        success = await model.space!.update(target);
      } else {
        success = await model.source!.update(target);
      }
      if (success) {
        ToastUtils.showMsg(msg: "更新成功");
        model.name = name;
        if (model.source == null) {
          model.space!.metadata.name = name;
          model.space!.metadata.code = code;
          model.space!.metadata.team?.name = nickName;
          model.space!.metadata.team?.code = identify;
          model.space!.metadata.remark = remark;
        } else {
          model.source.metadata.name = name;
          model.source.metadata.code = code;
          model.source.metadata.team?.name = nickName;
          model.source.metadata.team?.code = identify;
          model.source.metadata.remark = remark;
        }
        callback?.call();
      }
    } else {
      var data;
      if (model.source == null) {
        data = await model.space!.createTarget(target);
      } else {
        data = await model.source!.createTarget(target);
      }
      if (data != null) {
        ToastUtils.showMsg(msg: "创建成功");
        var nav = SettingNavModel(
            name: data.metadata.name!,
            source: data,
            space: model.space,
            spaceEnum: spaceEnum);
        callback?.call(nav);
      }
    }
  },
      code: isEdit ? item.metadata.code : "",
      name: isEdit ? item.metadata.name : "",
      nickName: isEdit ? item.metadata?.team?.name ?? "" : "",
      identify: isEdit ? (item.metadata.team?.code ?? "" ?? "") : "",
      remark: isEdit ? (item.metadata.remark ?? "") : "",
      type: isEdit ? TargetType.getType(item.metadata.typeName) : null,
      isEdit: isEdit);
}

void createAttr(SettingNavModel item,
    {bool isEdit = false, Function([SettingNavModel? nav])? callback}) {
  showCreateAttributeDialog(Get.context!,
      onCreate: (name, code, valueType, info, remake, [unit, dict]) async {
    var data = PropertyModel(
        name: name,
        code: code,
        valueType: valueType,
        info: info,
        remark: remake,
        unit: unit,
        speciesId: dict?.id);
    if (isEdit) {
      var success = await (item.source as IProperty).update(data);
      if (success) {
        item.source.metadata.name = name;
        item.source.metadata.code = code;
        item.source.metadata.valueType = valueType;
        item.source.metadata.info = info;
        item.source.metadata.unit = unit;
        item.source.metadata.speciesId = dict?.id;
        ToastUtils.showMsg(msg: "更新成功");
        item.name = name;
        callback?.call();
      }
    } else {
      IProperty? property;
      switch (item.spaceEnum!) {
        case SpaceEnum.directory:
          property = await item.source.createProperty(data);
          break;
        case SpaceEnum.user:
        case SpaceEnum.company:
          property = await item.space!.directory.createProperty(data);
          break;
        case SpaceEnum.person:
        case SpaceEnum.departments:
        case SpaceEnum.groups:
        case SpaceEnum.cohorts:
          property = await item.source!.directory.createProperty(data);
          break;
      }
      if (property != null) {
        ToastUtils.showMsg(msg: "创建成功");

        var nav = SettingNavModel(
            id: property.id,
            name: property.metadata.name!,
            space: item.space,
            source: property,
            spaceEnum: SpaceEnum.property,
            image: property.metadata.avatarThumbnail());

        if (item.spaceEnum != SpaceEnum.user &&
            item.spaceEnum != SpaceEnum.company) {
          item.children.add(nav);
        } else {
          item.children[0].children.add(nav);
        }
        callback?.call(nav);
      }
    }
  },
      name: isEdit ? item.source.metadata.name : '',
      code: isEdit ? item.source.metadata.code : '',
      valueType: isEdit ? item.source.metadata.valueType : "",
      info: isEdit ? item.source.metadata.info : null,
      unit: isEdit ? item.source.metadata.unit : null);
}

void createApplication(SettingNavModel item,
    {bool isEdit = false, Function([SettingNavModel? nav])? callback}) {
  showClassCriteriaDialog(Get.context!, [SpeciesType.application],
      isEdit: isEdit,
      name: isEdit ? item.source.metadata.name : null,
      code: isEdit ? item.source.metadata.code : null,
      typeName: isEdit ? item.source.metadata.typeName : null,
      remark: isEdit ? item.source.metadata.remark : null,
      resource: isEdit ? item.source.metadata.resource : null, callBack:
          (String name, String code, String typeName, String remark,
              [String? resource]) async {
    var data = ApplicationModel(
        name: name,
        code: code,
        remark: remark,
        resource: resource,
        typeName: typeName);
    if (isEdit) {
      var success = await (item.source as IApplication).update(data);
      if (success) {
        item.source.metadata.name = name;
        item.source.metadata.code = code;
        item.source.metadata.typeName = typeName;
        item.source.metadata.resource = resource;
        item.source.metadata.remark = remark;
        ToastUtils.showMsg(msg: "更新成功");
        item.name = name;
        callback?.call();
      }
    } else {
      IApplication? application;
      switch (item.spaceEnum!) {
        case SpaceEnum.directory:
          application = await item.source.createApplication(data);
          break;
        case SpaceEnum.user:
        case SpaceEnum.company:
          application = await item.space!.directory.createApplication(data);
          break;
        case SpaceEnum.person:
        case SpaceEnum.departments:
        case SpaceEnum.groups:
        case SpaceEnum.cohorts:
          application = await item.source!.directory.createApplication(data);
          break;
      }
      if (application != null) {
        ToastUtils.showMsg(msg: "创建成功");
        var nav = SettingNavModel(
            id: application.id,
            name: application.metadata.name!,
            space: item.space,
            source: application,
            spaceEnum: SpaceEnum.directory,
            image: application.metadata.avatarThumbnail());

        if (item.spaceEnum != SpaceEnum.user &&
            item.spaceEnum != SpaceEnum.company) {
          item.children.add(nav);
        } else {
          item.children[0].children.add(nav);
        }
        callback?.call(nav);
      }
    }
  });
}

void shareQr(SettingNavModel item) {
  var entity;
  if (item.spaceEnum == SpaceEnum.user || item.spaceEnum == SpaceEnum.company) {
    entity = item.space!.metadata;
  } else {
    entity = item.source.metadata;
  }
  Get.toNamed(
    Routers.shareQrCode,
    arguments: {"entity": entity},
  );
}

void openChat(SettingNavModel item) {
  if (item.spaceEnum == SpaceEnum.user || item.spaceEnum == SpaceEnum.company) {
    item.space!.onMessage();
    Get.toNamed(
      Routers.messageChat,
      arguments: item.space!,
    );
  } else {
    item.source!.onMessage();
    Get.toNamed(
      Routers.messageChat,
      arguments: item.source!,
    );
  }
}
