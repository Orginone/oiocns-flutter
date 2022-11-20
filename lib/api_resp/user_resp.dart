class UserResp {
  final String account;
  final String authority;
  final int expiresIn;
  final String license;
  final String motto;
  final String tokenType;
  final String userName;
  final String workspaceId;
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
