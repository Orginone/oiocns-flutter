import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';

class FormDetailController extends GetxController {
  FormDetailController();

  XForm? form;
  int? infoIndex;
  _initData() {
    form = Get.arguments?['form'];
    infoIndex = Get.arguments?['infoIndex'];
    update(["form_detail"]);
  }

  void onTap() {}

  // @override
  // void onInit() {
  //   super.onInit();
  // }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  // @override
  // void onClose() {
  //   super.onClose();
  // }
}
