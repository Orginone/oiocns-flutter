

import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/target/authority/authority.dart';
import 'package:orginone/dart/core/target/authority/iauthority.dart';

class PermissionInfoState extends BaseGetState{
 late Authority authority;

 PermissionInfoState(){
   authority = Get.arguments['authority'];
 }
}