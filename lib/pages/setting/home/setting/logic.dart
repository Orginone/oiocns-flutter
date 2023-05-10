import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_controller.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/dialog.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'state.dart';

class SettingFunctionController extends BaseBreadcrumbNavController<SettingFunctionState> {
 final SettingFunctionState state = SettingFunctionState();


 void nextLvForSpaceEnum(SettingNavModel model) {

   if(model.spaceEnum!=null){
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
       case SpaceEnum.standardSettings:
         List<SettingNavModel> data = [];
         for (var element in StandardEnum.values) {
           data.add(SettingNavModel(name: element.label,standardEnum: element, space: state.space));
         }
         model.children = data;
         Get.toNamed(Routers.settingFunction,arguments: {'data': model},preventDuplicates: false);
         break;
       default:
         Get.toNamed(Routers.relationGroup, arguments: {
           "data":model,
         });
         break;
     }
   } else if(model.standardEnum!=null){
     switch(model.standardEnum){

       case StandardEnum.permission:
       case StandardEnum.dict:
       case StandardEnum.classCriteria:
          Get.toNamed(Routers.relationGroup, arguments: {
         "data":model,
       });
         break;
       case StandardEnum.attribute:
         Get.toNamed(Routers.attributeInfo, arguments: {
           "data":model,
         });
         break;
     }
   }


  }

  void createOrganization(SettingNavModel model) {
    showCreateOrganizationDialog(
        context,
        getTargetType(model),
        callBack: (String name, String code, String nickName, String identify,
            String remark, TargetType type) async {
          var model = TargetModel(
              name: nickName,
              code: code,
              typeName: type.label,
              teamName: name,
          teamCode: code,
          remark: remark,
          icon: '',
          belongId: '');

      var data = await state.space.createTarget(model);
      if (data != null) {
        ToastUtils.showMsg(msg: "创建成功");
      } else {
        ToastUtils.showMsg(msg: "创建失败");
      }
    });
 }

 void editOrganization(SettingNavModel model) {
   showCreateOrganizationDialog(
       context, getTargetType(model),
       name: state.space.metadata.name,
       nickName: state.space.metadata.name,
       code: state.space.metadata.code,
       remark: state.space.metadata.remark ?? "",
       identify: state.space.metadata.code,
       type: TargetType.getType(state.space.metadata.typeName),
       callBack: (String name,
           String code,
           String nickName,
            String identify,
            String remark,
            TargetType type) async {
      await state.space.update(TargetModel(
          id: state.space.metadata.id,
          name: nickName,
          code: code,
          typeName: type.label,
          icon: state.space.metadata.icon,
          belongId: state.space.metadata.belongId,
          teamName: name,
          teamCode: code,
          remark: remark));
      ToastUtils.showMsg(msg: "修改成功");
    });
 }

 List<TargetType> getTargetType(SettingNavModel model) {
   List<TargetType> targetType = [];
   switch (model.spaceEnum) {
     case SpaceEnum.innerAgency:
       targetType.addAll(model.space.memberTypes);
       break;
     case SpaceEnum.outAgency:
       targetType.add(TargetType.group);
       break;
     case SpaceEnum.stationSetting:
       targetType.add(TargetType.station);
       break;
     case SpaceEnum.externalCohort:
       targetType.add(TargetType.cohort);
       break;
     case SpaceEnum.personGroup:
       targetType.add(TargetType.cohort);
       break;
   }
   return targetType;
 }

 void createDict(SettingNavModel item) {
   showCreateDictDialog(context,onCreate: (name,code,remark){
     var dict = item.space.createDict(DictModel(name: name, public: true, code: code, remark: remark));
     if(dict!=null){
       ToastUtils.showMsg(msg: "新建成功");
     }
   });
 }

 void createAttribute(SettingNavModel item) async {
   var dictArray = await item.space.loadDicts();
   showCreateAttributeDialog(
       context, onCreate: (name, code, type, remark, unit, dict) {
     var property = item.source.createProperty(PropertyModel(name: name,code: code,valueType: type,dictId: dict?.metadata.id,unit: unit,remark: remark));
     if(property!=null){
       ToastUtils.showMsg(msg: "新建成功");
     }
   }, dictList: dictArray);
 }

}
