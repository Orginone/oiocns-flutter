import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/base/belong.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/out_team/group.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/base/species.dart';

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

    var list = await model.source.loadSubTeam() ?? [];
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

  static Future<void> initAuthority(SettingNavModel model) async {
    var authority = await model.space.loadSuperAuth();
    void loopAuth(List<IAuthority> auth,SettingNavModel model){
      model.children = [];
      for (var element in auth) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            name: element.metadata.name??"");
        if(element.children.isNotEmpty){
          loopAuth(element.children,child);
        }
        model.children.add(child);
      }

    }

    if (authority != null) {
      loopAuth([authority],model);
    }

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

  static Future<void> initSpecies(SettingNavModel model) async{
    List<ISpeciesItem> species = await model.space.loadSpecies();
    void loopSpeciesTree(List<ISpeciesItem> tree,SettingNavModel model){
      model.children = [];
      for (var element in tree) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            name: element.metadata.name);
        if(element.children.isNotEmpty){
          loopSpeciesTree(element.children,child);
        }
        model.children.add(child);
      }
    }
    if(species.isNotEmpty){
      loopSpeciesTree(species,model);
    }
  }
}