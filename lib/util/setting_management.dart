



import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/store/filesys.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SettingManagement{
  static final SettingManagement _instance = SettingManagement._();

  factory SettingManagement() => _instance;

  SettingManagement._();

  SettingController get settingController => Get.find<SettingController>();

  var outAgencyGroup = <IGroup>[].obs;

  var stations = <IStation>[].obs;

  var cohorts = <ICohort>[].obs;

  var authority = <IAuthority>[].obs;

  Future<void>  initSetting() async{
     this.outAgencyGroup.clear();
     this.stations.clear();
     this.cohorts.clear();
     this.authority.clear();
     Future<void> getNextLvOutAgency(List<IGroup> group) async {
       for (var value in group) {
         value.subGroup = await value.getSubGroups(reload: true);
         if(value.subTeam.isNotEmpty){
           await getNextLvOutAgency(value.subGroup);
         }
       }
     }
     var group = await settingController.company?.getJoinedGroups(reload: true);
     if(group!=null){
       await getNextLvOutAgency(group);
       outAgencyGroup.addAll(group);
     }
     var stations  = await settingController.company?.getStations(reload: true);
     if(stations!=null){
       this.stations.addAll(stations);
     }
     var cohorts = await settingController.company?.getCohorts(reload: true);
     if(cohorts!=null){
       this.cohorts.addAll(cohorts);
     }
     var authority = await settingController.space.loadAuthorityTree(reload: true);
     if(authority!=null){
       this.authority.add(authority);
     }
  }

  List<IGroup> getAllOutAgency(List<IGroup> outAgencyGroup) {
    List<IGroup> list = [];
    for (var element in outAgencyGroup) {
      list.add(element);
      if (element.subGroup.isNotEmpty) {
        list.addAll(getAllOutAgency(element.subGroup));
      }
    }

    return list;
  }

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


}