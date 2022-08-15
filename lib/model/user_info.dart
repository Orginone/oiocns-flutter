import 'package:hive/hive.dart';

import '../config/hive_object_id.dart';

part 'user_info.g.dart';

@HiveType(typeId: HiveObjectId.userInfo)
class UserInfo {
  @HiveField(0)
  String id;

  UserInfo(this.id);

  UserInfo.fromJson(Map<String, dynamic> map) : id = map["id"];

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json['id'] = id;
    return json;
  }
}
