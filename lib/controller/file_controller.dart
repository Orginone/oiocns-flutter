import 'package:get/get.dart';
import 'package:orginone/api/hub/any_store.dart';
import 'package:orginone/api/kernelapi.dart';

class FileController extends GetxController {
  Future<void> upload(Map<String, dynamic> value) async {
    var key = SubscriptionKey.userChat.keyWord;
    var domain = Domain.all.name;
    var data = {
      "operation": "replaceAll",
      "data": {"apk": value}
    };
    await Kernel.getInstance.anyStore.set(key, data, domain);
  }
}

class FileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FileController());
  }
}
