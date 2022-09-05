import 'package:orginone/api_resp/person_detail_resp.dart';
import 'package:orginone/config/constant.dart';

import '../util/http_util.dart';

class PersonDetailApi {
  static Future<PersonDetailResp> getPersonDetail(int personId) async {
    Map<String, dynamic> resp = await HttpUtil().post("${Constant.personModule}/query/info");
    return PersonDetailResp.fromMap(resp);
  }
}
