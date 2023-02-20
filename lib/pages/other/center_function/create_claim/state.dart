import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class CreateClaimState extends BaseGetState {
  late bool isEdit;

  TextEditingController reasonController = TextEditingController();

  var detailedData = RxList<DetailedData>();

  CreateClaimState() {
    isEdit = Get.arguments?['isEdit'] ?? false;
  }

}


class DetailedData {

  TextEditingController assetNameController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController modelController = TextEditingController();

  TextEditingController brandController = TextEditingController();

  bool newCreate = false;

  String place = "";

  String assetClassification = "";

}