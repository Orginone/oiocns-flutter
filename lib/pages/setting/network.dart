import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

import 'home/setting/state.dart';

class SettingNetWork {
  static Future<void> initDepartment(
      SettingNavModel model) async {

    Future<void> loopDepartment(List<ITarget> department,
        SettingNavModel model) async {
      model.children = [];
      for (var element in department) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            image: element.target.avatarThumbnail(),name: element.teamName);
        element.subTeam = await element.loadSubTeam();
        if (element.subTeam.isNotEmpty) {
          await loopDepartment(element.subTeam,child);
        }
        model.children.add(child);
      }
    }

    var list = await model.space.loadSubTeam() ?? [];
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
            image: value.target.avatarThumbnail(),name: value.teamName);
        value.subGroup = await value.getSubGroups();
        if (value.subTeam.isNotEmpty) {
          await getNextLvOutAgency(value.subGroup,child);
        }
        model.children.add(child);
      }
    }

    var group = await (model.space as ICompany).getJoinedGroups();
    await getNextLvOutAgency(group,model);
  }

  static Future<void> initStations(SettingNavModel model) async {
    var stations = await (model.space as ICompany).getStations();
    model.children = [];
    for (var value in stations) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          image: value.target.avatarThumbnail(),name: value.teamName);
      model.children.add(child);
    }

  }

  static Future<void> initCohorts(SettingNavModel model) async {
    var cohorts = await model.space.getCohorts();
    model.children = [];
    for (var value in cohorts) {
      var child = SettingNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          image: value.target.avatarThumbnail(),name: value.teamName);
      model.children.add(child);
    }
  }

  static Future<List<IAuthority>> getAuthority(ITarget space) async {
    var authority = await space.loadAuthorityTree();

    if (authority != null) {
       return [authority];
    }
    return [];
  }

  static Future<void> initAuthority(SettingNavModel model) async {
    var authority = await model.space.loadAuthorityTree();
    void loopAuth(List<IAuthority> auth,SettingNavModel model){
      model.children = [];
      for (var element in auth) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            name: element.name);
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
    var dictArray = await model.space.dict.loadDict(PageRequest(offset: 0, limit: 1000, filter: ''));
    if(dictArray.result!=null && dictArray.result!.isNotEmpty){
      model.children = [];
      for (var value in dictArray.result!) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: value,
            standardEnum: model.standardEnum,
            name: value.name??"");
        model.children.add(child);
      }
    }
  }

  static Future<void> initSpecies(SettingNavModel model) async{
    List<ISpeciesItem> species = await model.space.loadSpeciesTree();
    void loopSpeciesTree(List<ISpeciesItem> tree,SettingNavModel model){
      model.children = [];
      for (var element in tree) {
        var child = SettingNavModel(
            space: model.space,
            spaceEnum: model.spaceEnum,
            source: element,
            standardEnum: model.standardEnum,
            name: element.name);
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