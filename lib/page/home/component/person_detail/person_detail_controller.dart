import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';

class PersonDetailController extends GetxController {
  final Logger log = Logger("PersonDetailController");
  Target? personDetail;

  @override
  void onReady() async {
    await getPersonDetail(Get.arguments);
    update();
    super.onReady();
  }

  getPersonDetail(personPhone) async {
    var pageResp = await PersonApi.searchPersons(
      keyword: personPhone,
      limit: 20,
      offset: 0,
    );
    personDetail = pageResp.result[0];
  }
}
