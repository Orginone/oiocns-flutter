import 'package:orginone/model/user.dart';

class LoginResp {
  final String accessToken;
  final User user;

  LoginResp.fromJson(Map<String, dynamic> map)
      : accessToken = map["accessToken"],
        user = User.fromJson(map);

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['assessToken'] = accessToken;
    json['user'] = user;
    return json;
  }


}