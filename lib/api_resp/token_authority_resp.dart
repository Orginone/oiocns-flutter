import 'package:orginone/api_resp/target.dart';

import 'identity_resp.dart';

class TokenAuthorityResp {
  final String spaceId;
  final String userId;
  final List<IdentityResp> identitys;
  final Target userInfo;
  final Target spaceInfo;

  const TokenAuthorityResp({
    required this.spaceId,
    required this.userId,
    required this.identitys,
    required this.userInfo,
    required this.spaceInfo,
  });

  TokenAuthorityResp.fromMap(Map<String, dynamic> map)
      : spaceId = map["spaceId"],
        userId = map["userId"],
        identitys = IdentityResp.fromList(map["identitys"]),
        userInfo = Target.fromMap(map["userInfo"]),
        spaceInfo = Target.fromMap(map["spaceInfo"]);
}
