import 'package:get/get.dart';

class FormWidgetController extends GetxController {
  FormWidgetController();

  _initData() async {
    //加载数据

    update(["form_widget"]);
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
}
