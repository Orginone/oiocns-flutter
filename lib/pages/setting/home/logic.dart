import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/application.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/property.dart';
import 'package:orginone/dart/core/thing/species.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/loading_dialog.dart';

import 'state.dart';

class SettingCenterController
    extends BaseBreadcrumbNavController<SettingCenterState> {
  final SettingCenterState state = SettingCenterState();

  @override
  void onReady() async {
    // TODO: implement onReady
    super.onReady();

    if (state.isRootDir) {
      LoadingDialog.showLoading(context);
      await loadUserSetting();
      await loadCompanySetting();
      state.model.refresh();
      LoadingDialog.dismiss(context);
    }
  }

  void jumpInfo(SettingNavModel model) {
    if (settingCtrl.isUserSpace(model.space)) {
      Get.toNamed(Routers.userInfo);
    } else {
      Get.toNamed(Routers.companyInfo, arguments: {"company": model.space});
    }
  }

  void onHomeNextLv(SettingNavModel model) {
    Get.toNamed(Routers.settingCenter,
        preventDuplicates: false, arguments: {"data": model});
  }

  void onDetailsNextLv(SettingNavModel model) {
    if (model.children.isEmpty && model.spaceEnum!=SpaceEnum.directory) {
      jumpDetails(model);
    } else {
      Get.toNamed(Routers.settingCenter,
          preventDuplicates: false, arguments: {"data": model});
    }
  }

  void jumpLogin() async {
    settingCtrl.exitLogin();
  }

  void jumpDetails(SettingNavModel model) {
    switch (model.spaceEnum) {
      case SpaceEnum.cardbag:
        Get.toNamed(
          Routers.cardbag,
        );
        break;
      case SpaceEnum.security:
        Get.toNamed(
          Routers.security,
        );
        break;
      case SpaceEnum.gateway:
        Get.toNamed(
          Routers.security,
        );
        break;
      case SpaceEnum.theme:
        Get.toNamed(
          Routers.security,
        );
        break;
      case SpaceEnum.departments:
        Get.toNamed(Routers.departmentInfo,
            arguments: {'depart': model.source});
        break;
      case SpaceEnum.groups:
        Get.toNamed(Routers.outAgencyInfo, arguments: {'group': model.source});
        break;
      case SpaceEnum.cohorts:
        Get.toNamed(Routers.cohortInfo, arguments: {'cohort': model.source});
        break;
      case SpaceEnum.species:
      case SpaceEnum.applications:
      case SpaceEnum.form:
      case SpaceEnum.person:
        Get.toNamed(Routers.classificationInfo, arguments: {"data": model});
        break;
      case SpaceEnum.file:
        Routers.jumpFile(file: model.source!.shareInfo(),type: "setting");
        break;
    }
  }

  Future<void> loadUserSetting() async {
    var user = state.model.value!.children[4];
    user.onNext = (nav)async{
      await user.space!.loadContent(reload: true);
      List<SettingNavModel> function = [
        SettingNavModel(name: "个人文件", space: user.space, children: [
          ...await loadFile(user.space!.directory.files, user.space!),
          ...await loadSpecies(user.space!.directory.specieses, user.space!),
          ...await loadApplications(
              user.space!.directory.applications, user.space!),
          ...await loadForm(user.space!.directory.forms, user.space!),
          ...await loadPropertys(user.space!.directory.propertys, user.space!),
        ],spaceEnum: SpaceEnum.directory,showPopup: false),
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

  Future<void> loadCompanySetting() async {
    for(int i = 5;i<state.model.value!.children.length;i++){
      var company = state.model.value!.children[i];
      company.onNext = (nav) async{
        await company.space!.loadContent(reload: true);
        List<SettingNavModel> function = [
          SettingNavModel(name: "单位文件", space: company.space, children: [
            ...await loadFile(company.space!.directory.files, company.space!),
            ...await loadSpecies(
                company.space!.directory.specieses, company.space!),
            ...await loadApplications(
                company.space!.directory.applications, company.space!),
            ...await loadForm(company.space!.directory.forms, company.space!),
            ...await loadPropertys(
                company.space!.directory.propertys, company.space!),
          ],spaceEnum: SpaceEnum.directory,showPopup: false),
          SettingNavModel(
            name: "单位成员",
            space: company.space,
            spaceEnum: SpaceEnum.company,
            showPopup: false,
            image: company.space!.metadata.avatarThumbnail(),
            children: company.space!.members.map((e) {
              return SettingNavModel(
                id: e.id!,
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
        nav.children.addAll(function);
      };
    }
  }

  void createDir(SettingNavModel item, [bool isEdit = false]) {
    showCreateGeneralDialog(context, "目录",
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
          state.model.refresh();
          if(item == state.model.value){
            updateNav();
          }
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
          state.model.refresh();
        }
      }
    });
  }

  void uploadFile(SettingNavModel item) async {
    late IDirectory dir;

    switch (item.spaceEnum!) {
      case SpaceEnum.directory:
        dir = await item.source;
        break;
      case SpaceEnum.user:
      case SpaceEnum.company:
        dir = await item.space!.directory;
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
      LoadingDialog.showLoading(context, msg: "上传中");
      var file = await dir.createFile(
        File(result.files.first.path!),
        progress: (progress) {
          if (progress == 1) {
            ToastUtils.showMsg(msg: "上传成功");
            LoadingDialog.dismiss(context);
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
        state.model.refresh();
      }
    }
  }

  void createSpecies(SettingNavModel item, String typeName,
      [bool isEdit = false]) {
    showCreateGeneralDialog(context, typeName,
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
          state.model.refresh();
          if(item == state.model.value){
            updateNav();
          }
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

          state.model.refresh();
        }
      }
    });
  }

  void rename(SettingNavModel item) {
    showTextInputDialog(
            context: context,
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
            state.model.refresh();
            if(item == state.model.value){
              updateNav();
            }
          }
        });
      }
    });
  }

  void delete(SettingNavModel item) async {
    bool success = await item.source.delete();
    if (success) {
      ToastUtils.showMsg(msg: "删除成功");
      state.model.value!.children.remove(item);
      state.model.refresh();
    }
  }

  void updateInfo(PopupMenuKey key, SettingNavModel item) async {
    switch (item.spaceEnum) {
      case SpaceEnum.directory:
        createDir(item, true);
        break;
      case SpaceEnum.species:
        createSpecies(item, item.source.metadata.typeName, true);
        break;
      case SpaceEnum.property:
        createAttr(item, true);
        break;
      case SpaceEnum.applications:
        createApplication(item, true);
        break;
      case SpaceEnum.form:
        createSpecies(item, '分类', true);
        break;
      case SpaceEnum.user:
      case SpaceEnum.company:
      case SpaceEnum.person:
      case SpaceEnum.departments:
      case SpaceEnum.groups:
      case SpaceEnum.cohorts:
        createTarget(key, item, true);
        break;
    }
  }

  void createTarget(PopupMenuKey key, SettingNavModel model,
      [bool isEdit = false]) {
    List<TargetType> targetType = [];

    switch (key) {
      case PopupMenuKey.createDepartment:
        targetType = [
          TargetType.office,
          TargetType.working,
          TargetType.research,
          TargetType.laboratory
        ];
        break;
      case PopupMenuKey.createStation:
        targetType = [TargetType.station];
        break;
      case PopupMenuKey.createGroup:
        targetType = [TargetType.group];
        break;
      case PopupMenuKey.createCohort:
        targetType = [TargetType.cohort];
        break;
      case PopupMenuKey.createCompany:
        targetType = [
          TargetType.company,
          TargetType.hospital,
          TargetType.university
        ];
        break;
    }
    var item = model.source ?? model.space;
    showCreateOrganizationDialog(context, targetType, callBack: (String name,
            String code,
            String nickName,
            String identify,
            String remark,
            TargetType type) async {
      var target = TargetModel(
        name: nickName,
        code: code,
        typeName: type.label,
        teamName: name,
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
          state.model.refresh();
          if(model == state.model.value){
            updateNav();
          }
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
              spaceEnum: model.spaceEnum);
          if (key == PopupMenuKey.createCompany) {
            state.model.value!.children.add(nav);
          } else {
            model.children.add(nav);
          }
          state.model.refresh();
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

  void createAttr(SettingNavModel item, [bool isEdit = false]) {
    showCreateAttributeDialog(context,
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
          state.model.refresh();
          if(item == state.model.value){
            updateNav();
          }
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
          state.model.refresh();
        }
      }
    },
        name: isEdit ? item.source.metadata.name : '',
        code: isEdit ? item.source.metadata.code : '',
        valueType: isEdit?item.source.metadata.valueType : "",
        info: isEdit?item.source.metadata.info : null,
        unit: isEdit?item.source.metadata.unit:null);
  }

  void createApplication(SettingNavModel item, [bool isEdit = false]) {
    showClassCriteriaDialog(
      context,
      [SpeciesType.application],
      isEdit: isEdit,
      name: isEdit?item.source.metadata.name:null,
      code: isEdit?item.source.metadata.code:null,
      typeName: isEdit?item.source.metadata.typeName:null,
      remark: isEdit?item.source.metadata.remark:null,
      resource: isEdit?item.source.metadata.resource:null,
      callBack: (String name,String code,String typeName,String remark,[String? resource]) async{
        var data = ApplicationModel(name: name,code: code,remark: remark,resource: resource,typeName: typeName);
        if(isEdit){
          var success = await (item.source as IApplication).update(data);
          if (success) {
            item.source.metadata.name = name;
            item.source.metadata.code = code;
            item.source.metadata.typeName = typeName;
            item.source.metadata.resource = resource;
            item.source.metadata.remark = remark;
            ToastUtils.showMsg(msg: "更新成功");
            item.name = name;
            state.model.refresh();
            if(item == state.model.value){
              updateNav();
            }
          }
        }else{
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
            state.model.refresh();
          }
        }
      }
    );
  }

  void operation(PopupMenuKey key, SettingNavModel item) {
    switch (key) {
      case PopupMenuKey.createDir:
        createDir(item);
        break;
      case PopupMenuKey.createApplication:
        createApplication(item);
        break;
      case PopupMenuKey.createSpecies:
        createSpecies(item, '分类');
        break;
      case PopupMenuKey.createDict:
        createSpecies(item, '字典');
        break;
      case PopupMenuKey.createAttr:
        createAttr(item);
        break;
      case PopupMenuKey.createThing:
        createSpecies(item, '实体配置');
        break;
      case PopupMenuKey.createWork:
        createSpecies(item, '事项配置');
        break;
      case PopupMenuKey.createDepartment:
      case PopupMenuKey.createStation:
      case PopupMenuKey.createGroup:
      case PopupMenuKey.createCohort:
      case PopupMenuKey.createCompany:
        createTarget(key, item);
        break;
      case PopupMenuKey.updateInfo:
        updateInfo(key, item);
        break;
      case PopupMenuKey.rename:
        rename(item);
        break;
      case PopupMenuKey.delete:
        delete(item);
        break;
      case PopupMenuKey.upload:
        uploadFile(item);
        break;
      case PopupMenuKey.shareQr:

        var entity;
        if (item.spaceEnum == SpaceEnum.user ||
            item.spaceEnum == SpaceEnum.company) {
          entity = item.space!.metadata;
        }else{
          entity = item.source.metadata;
        }
        Get.toNamed(
          Routers.shareQrCode,
          arguments: {"entity":entity},
        );
        break;
      case PopupMenuKey.openChat:
        if (item.spaceEnum == SpaceEnum.user ||
            item.spaceEnum == SpaceEnum.company) {
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

        break;
    }
  }

  @override
  void onTopPopupMenuSelected(PopupMenuKey key) {
    operation(key,state.model.value!);
  }
}
