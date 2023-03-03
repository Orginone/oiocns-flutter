import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/model/asset_use.dart';
import 'package:orginone/util/common_tree_management.dart';

class CreateClaimState extends BaseGetState {
  late bool isEdit;

  TextEditingController reasonController = TextEditingController();

  var orderNum = ''.obs;

  var detailedData = <ClaimDetailed>[].obs;

  late AssetUse assetUse;

  CreateClaimState() {
    isEdit = Get.arguments?['isEdit'] ?? false;
    if (isEdit) {
      assetUse = Get.arguments?['assetUse'];
      orderNum.value = assetUse.billCode ?? "";
      reasonController.text = assetUse.applyRemark ?? "";
      if (assetUse.approvalDocument?.detail?.isNotEmpty ?? false) {
        var assets = assetUse.approvalDocument!.detail!;
        for (var value in assets) {
          detailedData.add(ClaimDetailed(location: value.location,
              brand: value.brand ?? "",
              model: value.specMod ?? "",
              quantity:"${value.numOrArea??0}",
              assetName:value.assetName??"",
              isDistribution: value.isDistribution??false,
              assetType: CommonTreeManagement().findTree(value.assetType??""),
          ));
        }
      }
    } else {
      detailedData.add(ClaimDetailed());
    }
  }
}


class ClaimDetailed {

  TextEditingController assetNameController = TextEditingController();

  TextEditingController quantityController = TextEditingController();

  TextEditingController modelController = TextEditingController();

  TextEditingController brandController = TextEditingController();

  XDictItem? assetType;

  bool? isDistribution;

  String? location;

  ClaimDetailed(
      {String assetName = "",
      String quantity = "",
      String model = "",
      String brand = "",
      this.assetType,
      this.isDistribution = false,
      this.location = ""}) {
    assetNameController.text = assetName;
    quantityController.text = quantity;
    modelController.text = model;
    brandController.text = brand;
  }

  bool hasData() {
    return assetNameController.text.trim().isNotEmpty ||
        quantityController.text.trim().isNotEmpty ||
        modelController.text.trim().isNotEmpty ||
        brandController.text.trim().isNotEmpty ||
        assetType != null ||
        isDistribution != null;
  }
}