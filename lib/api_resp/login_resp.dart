import 'package:orginone/api_resp/user_resp.dart';

class LoginResp {
  final String accessToken;
  final UserResp user;

  LoginResp.fromMap(Map<String, dynamic> map)
      : accessToken = map["accessToken"],
        user = UserResp.fromMap(map);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['assessToken'] = accessToken;
    json['user'] = user;
    return json;
  }
}
