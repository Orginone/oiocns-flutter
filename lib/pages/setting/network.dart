import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/app/work/workform.dart';
import 'package:orginone/dart/core/thing/base/form.dart';
import 'package:orginone/dart/core/thing/base/species.dart';
import 'package:orginone/dart/core/thing/dict/dictclass.dart';
import 'package:orginone/dart/core/thing/store/propclass.dart';

import 'config.dart';
import 'home/setting/state.dart';

class SettingNetWork {
  static Future<void> initDepartment(
      SettingNavModel model) async {

    Future<void> loopDepartment(List<IDepartment> department,
        SettingNavModel model) async {
      model.children = [];
      for (var element in department) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            image: element.metadata.avatarThumbnail(),name: element.metadata.name);
        element.children = await element.loadChildren();
        if (element.children.isNotEmpty) {
          await loopDepartment(element.children,child);
        }
        model.children.add(child);
      }
    }

    var list = await (model.space as ICompany).loadDepartments() ?? [];
    if (list.isNotEmpty) {
      await loopDepartment(list, model);
    }
  }

  static Future<void> initGroup(SettingNavModel model) async {
    Future<void> getNextLvOutAgency(List<IGroup> group,SettingNavModel model) async {
      model.children = [];
      for (var value in group) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: value,
            standardEnum: model.standardEnum,
            image: value.metadata.avatarThumbnail(),name: value.metadata.name);
        value.children = await value.loadChildren();
        if (value.children.isNotEmpty) {
          await getNextLvOutAgency(value.children,child);
        }
        model.children.add(child);
      }
    }

    var group = await (model.space as ICompany).loadGroups();
    await getNextLvOutAgency(group,model);
  }

  static Future<void> initStations(SettingNavModel model) async {
    var stations = await (model.space as ICompany).loadStations();
    model.children = [];
    for (var value in stations) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          image: value.metadata.avatarThumbnail(),name: value.metadata.name);
      model.children.add(child);
    }

  }

  static Future<void> initCohorts(SettingNavModel model) async {
    var cohorts = await model.space.loadCohorts();
    model.children = [];
    for (var value in cohorts) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          image: value.metadata.avatarThumbnail(),name: value.metadata.name);
      model.children.add(child);
    }
  }

  static Future<List<IAuthority>> getAuthority(IBelong space) async {
    var authority = await space.loadSuperAuth();

    if (authority != null) {
      return [authority];
    }
    return [];
  }

  static Future<SettingNavModel?> initAuthority(SettingNavModel model) async {
    SettingNavModel? settingNavModel;
    var authority = await model.space.loadSuperAuth();

    void loopAuth(List<IAuthority> auth, List<SettingNavModel> children) {
      for (var element in auth) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            image: element.shareInfo.avatar?.shareLink,
            standardEnum: StandardEnum.permission,
            name: element.metadata.name ?? "");
        child.children = [];
        if (element.children.isNotEmpty) {
          loopAuth(element.children, child.children);
        }
        children.add(child);
      }
    }

    void loadAuth(IAuthority auth) {
      settingNavModel = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: auth,
          image: auth.shareInfo.avatar?.shareLink,
          standardEnum: StandardEnum.permission,
          name: auth.metadata.name ?? "");
      settingNavModel!.children = [];
      if (authority!.children.isNotEmpty) {
        loopAuth(authority.children, settingNavModel!.children);
      }
    }

    if (authority != null) {
      loadAuth(authority);
    }

    return settingNavModel;
  }

  static Future<void> initDict(SettingNavModel model) async{
    var dictArray = await model.space.loadDicts();
    if(dictArray.isNotEmpty){
      model.children = [];
      for (var value in dictArray) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: value,
            standardEnum: model.standardEnum,
            name: value.metadata.name??"");
        model.children.add(child);
      }
    }
  }

  static Future<void> initSpecies(SettingNavModel model) async {
    List<ISpeciesItem> species = await model.space.loadSpecies();
    Future<void> loopSpeciesTree(List<ISpeciesItem> tree, List<SettingNavModel> navs) async{
      for (var element in tree) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            image: element.share.avatar?.shareLink,
            standardEnum: StandardEnum.classCriteria,
            name: element.metadata.name);

        List<SettingNavModel> children = [];
        if (element.metadata.typeName == SpeciesType.workForm.label &&
            element is WorkForm) {
          List<IForm> forms = await element.loadForms();
          if (forms.isNotEmpty) {
            children = forms
                .map((e) => SettingNavModel(
                    space: model.space,
                    standardEnum: model.standardEnum,
                    source: e,
                    spaceEnum: model.spaceEnum,
                    name: e.metadata.name ?? ""))
                .toList();
          }
        }
        if (element.metadata.typeName == SpeciesType.store.label &&
            element is IPropClass) {
          List<XProperty> property = await element.loadPropertys();
          if (property.isNotEmpty) {
            children.add(SettingNavModel(
                space: model.space,
                standardEnum: StandardEnum.propPackage,
                source: element,
                spaceEnum: model.spaceEnum,
                name: StandardEnum.propPackage.label,
                children: property
                    .map((e) => SettingNavModel(
                        space: model.space,
                        standardEnum: StandardEnum.propPackage,
                        source: element,
                        spaceEnum: model.spaceEnum,
                        name: e.name ?? "",
                        id: e.id ?? ""))
                    .toList()));
          }
        }
        if (element.metadata.typeName == SpeciesType.dict.label &&
            element is IDictClass) {
          var dicts = await element.loadDicts();
          children.add(SettingNavModel(
              space: model.space,
              standardEnum: StandardEnum.dictPackage,
              source: element,
              spaceEnum: model.spaceEnum,
              name: StandardEnum.dictPackage.label,
              children: dicts
                  .map((e) => SettingNavModel(
                      space: model.space,
                      standardEnum: model.standardEnum,
                      source: e,
                      spaceEnum: model.spaceEnum,
                      name: e.metadata.name ?? "",
                      id: e.metadata.id ?? ""))
                  .toList()));
        }

        child.children = children;
        if (element.children.isNotEmpty) {
          await loopSpeciesTree(element.children, child.children);
        }
        navs.add(child);
      }
    }
    if(species.isNotEmpty) {
      model.children = [];
      await loopSpeciesTree(species, model.children);
    }
  }
}