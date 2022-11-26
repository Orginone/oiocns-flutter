import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/login_resp.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/target/person.dart';

class TargetController extends GetxController {
  late Person _currentPerson;

  Person get currentPerson => _currentPerson;

  Company get currentCompany => _currentPerson.currentCompany;

  @override
  void onInit() {
    super.onInit();
    _currentPerson = Person(auth.userInfo);
    _currentPerson.loadJoinedCompanies();
  }

  Future<void> switchSpaces(String spaceId) async {
    if (auth.spaceId == spaceId) {
      return;
    }

    LoginResp loginResp = await PersonApi.changeWorkspace(spaceId);
    setAccessToken = loginResp.accessToken;
    _currentPerson.setCurrentCompany(spaceId);

    await loadAuth();
    if (auth.isCompanySpace()) {
      await currentCompany.loadTree();
    }

    if (Get.isRegistered<MessageController>()) {
      var messageCtrl = Get.find<MessageController>();
      messageCtrl.setGroupTop(spaceId);
    }
  }
}

class TargetBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TargetController());
  }
}
