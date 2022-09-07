import 'package:get/get.dart';
import 'package:orginone/api_resp/person_detail_resp.dart';
import 'package:orginone/config/constant.dart';

import '../util/http_util.dart';

class PersonDetailApi {
  static Future<PersonDetailResp> getPersonDetail(String personName) async {
    Map<String, dynamic> resp = await HttpUtil().post("${Constant.personModule}/search/persons",
      data: {
        "filter": personName,
        "limit": 20,
        "offset": 0,
      });
    return PersonDetailResp.fromMap(resp["result"][0]);
  }
  static Future<String> addPerson(String personId) async {
    Map<String, dynamic> resp = await HttpUtil().post("${Constant.personModule}/apply/join",
        data: {
          "id": personId
        });
    return resp['msg'];
  }
}
