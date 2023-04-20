


import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SettingNetWork{
  static Future<List<IGroup>> initGroup(ICompany space) async {
    Future<void> getNextLvOutAgency(List<IGroup> group) async {
      for (var value in group) {
        value.subGroup = await value.getSubGroups(reload: true);
        if (value.subTeam.isNotEmpty) {
          await getNextLvOutAgency(value.subGroup);
        }
      }
    }

    var group = await space.getJoinedGroups(reload: true);
    await getNextLvOutAgency(group);
    return group;
  }

  static Future<List<IStation>> initStations(ICompany space) async {
    var stations = await space.getStations(reload: true);
    return stations;
  }

  static Future<List<ICohort>> initCohorts(ISpace space) async {
    var cohorts = await space.getCohorts(reload: true);
    return cohorts;
  }

  static Future<List<IAuthority>> initAuthority(ITarget space) async {
    var authority =
    await space.loadAuthorityTree(reload: true);
    if (authority != null) {
      return [authority];
    }
    return [];
  }
}