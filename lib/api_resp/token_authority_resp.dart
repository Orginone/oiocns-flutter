import 'package:orginone/api_resp/target_resp.dart';

import 'identity_resp.dart';

class TokenAuthorityResp {
  final String spaceId;
  final String userId;
  final List<IdentityResp> identitys;
  final TargetResp userInfo;
  final TargetResp spaceInfo;

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
        userInfo = TargetResp.fromMap(map["userInfo"]),
        spaceInfo = TargetResp.fromMap(map["spaceInfo"]);
}
