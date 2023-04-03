import 'package:get/get.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/routers.dart';

import '../../../../dart/core/getx/base_controller.dart';
import 'state.dart';

class RelationController extends BaseController<RelationState> {
 final RelationState state = RelationState();


 void nextLvForEnum(CompanySpaceEnum companySpaceEnum) {
   if (companySpaceEnum != CompanySpaceEnum.company) {
     Get.toNamed(Routers.relationGroup,arguments: {"companySpaceEnum":companySpaceEnum,"head":"关系"});
   }else{
     Get.toNamed(Routers.companyInfo);
   }
 }
}
