



import 'package:get/get.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/store/filesys.dart';
import 'package:orginone/dart/core/store/ifilesys.dart';
import 'package:orginone/dart/core/target/itarget.dart';

class SettingManagement{
  static final SettingManagement _instance = SettingManagement._();

  factory SettingManagement() => _instance;

  SettingManagement._();

  SettingController get settingController => Get.find<SettingController>();

  var  outAgencyGroup = <IGroup>[].obs;

  var stations = <IStation>[].obs;

  var cohorts = <ICohort>[].obs;

  Future<void>  initSetting() async{
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


}