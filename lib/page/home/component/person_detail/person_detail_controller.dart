
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

class PersonDetailController extends GetxController {
  final Logger log = Logger("PersonDetailController");
  TargetResp? personDetail;
  @override
  void onReady() async{
    await getPersonDetail(Get.arguments);
    update();
    super.onReady();
  }
  getPersonDetail(personPhone) async {
    personDetail = await PersonApi.getPersonDetail(personPhone);
  }
}