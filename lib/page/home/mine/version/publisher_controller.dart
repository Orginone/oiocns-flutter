
import 'package:get/get.dart';

class PublisherController extends GetxController{

}

class PublisherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PublisherController());
  }
}