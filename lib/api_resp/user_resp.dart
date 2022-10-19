import 'package:hive/hive.dart';

import '../config/hive_object_id.dart';

part 'user_resp.g.dart';

@HiveType(typeId: HiveObjectId.userId)
class UserResp {
  @HiveField(0)
  final String account;
  @HiveField(1)
  final String authority;
  @HiveField(2)
  final int expiresIn;
  @HiveField(3)
  final String license;
  @HiveField(4)
  final String motto;
  @HiveField(5)
  final String tokenType;
  @HiveField(6)
  final String userName;
  @HiveField(7)
  final String workspaceId;
  @HiveField(8)
  final String workspaceName;

  UserResp(
      this.account,
      this.authority,
      this.expiresIn,
      this.license,
      this.motto,
      this.tokenType,
      this.userName,
      this.workspaceId,
      this.workspaceName);

  UserResp.fromMap(Map<String, dynamic> map)
      : account = map["account"],
        authority = map["authority"],
        expiresIn = map["expiresIn"],
        license = map["license"],
        motto = map["motto"],
        tokenType = map["tokenType"],
        userName = map["userName"],
        workspaceId = map["workspaceId"],
        workspaceName = map["workspaceName"];

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['account'] = account;
    data['authority'] = authority;
    data['expiresIn'] = expiresIn;
    data['license'] = license;
    data['motto'] = motto;
    data['tokenType'] = tokenType;
    data['userName'] = userName;
    data['workspaceId'] = workspaceId;
    data['workspaceName'] = workspaceName;
    return data;
  }
}
