import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class CreateClaimState extends BaseGetState {
  late bool isEdit;

  TextEditingController reasonController = TextEditingController();

  var orderNum = ''.obs;

  var detailedData = RxList<ClaimDetailed>();

  CreateClaimState() {
    isEdit = Get.arguments?['isEdit'] ?? false;
  }

}


class ClaimDetailed {

  TextEditingController assetNameController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController modelController = TextEditingController();

  TextEditingController brandController = TextEditingController();

  XDictItem? assetType;

  bool newCreate = false;

  String place = "";

  String assetClassification = "";

}