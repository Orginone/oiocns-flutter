import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';

import 'home/setting/state.dart';

class SettingNetWork {
  static Future<void> initDepartment(
      SettingFunctionBreadcrumbNavModel model) async {

    Future<void> loopDepartment(List<ITarget> department,
        SettingFunctionBreadcrumbNavModel model) async {
      model.children = [];
      for (var element in department) {
        var child = SettingFunctionBreadcrumbNavModel(
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

  static Future<void> initGroup(SettingFunctionBreadcrumbNavModel model) async {
    Future<void> getNextLvOutAgency(List<IGroup> group,SettingFunctionBreadcrumbNavModel model) async {
      model.children = [];
      for (var value in group) {
        var child = SettingFunctionBreadcrumbNavModel(
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

    var group = await (model.space as ICompany).getJoinedGroups(reload: true);
    await getNextLvOutAgency(group,model);
  }

  static Future<void> initStations(SettingFunctionBreadcrumbNavModel model) async {
    var stations = await (model.space as ICompany).getStations();
    model.children = [];
    for (var value in stations) {
      var child = SettingFunctionBreadcrumbNavModel(
          space: model.space,
          spaceEnum: model.spaceEnum,
          source: value,
          standardEnum: model.standardEnum,
          image: value.target.avatarThumbnail(),name: value.teamName);
      model.children.add(child);
    }

  }

  static Future<void> initCohorts(SettingFunctionBreadcrumbNavModel model) async {
    var cohorts = await model.space.getCohorts();
    model.children = [];
    for (var value in cohorts) {
      var child = SettingFunctionBreadcrumbNavModel(
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

  static Future<void> initAuthority(SettingFunctionBreadcrumbNavModel model) async {
    var authority = await model.space.loadAuthorityTree();

    void loopAuth(List<IAuthority> auth,SettingFunctionBreadcrumbNavModel model){
      model.children = [];
      for (var element in auth) {
        var child = SettingFunctionBreadcrumbNavModel(
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
}