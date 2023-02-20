

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/other/assets_config.dart';

import '../../../../../dart/core/getx/base_get_state.dart';

class ApproveDocumentsState extends BaseGetState{

  late TextEditingController textEditingController;

  late DocumentsType type;

  var showMore = false.obs;

  late bool edit;


  ApproveDocumentsState(){
    textEditingController = TextEditingController();
    type = Get.arguments?['type']??DocumentsType.transfer;
    edit = Get.arguments?['edit']??true;
  }
}


