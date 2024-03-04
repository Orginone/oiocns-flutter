import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';

class FormController extends GetxController {
  FormController();
  String title = '';
  List<XForm> mainForm = [];
  List<XForm> subForm = [];
  _initData() {
    mainForm = Get.arguments['mainForm'].cast<XForm>();
    subForm = Get.arguments['subForm'].cast<XForm>();
    title = Get.arguments['title'];
    update(["form"]);
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
