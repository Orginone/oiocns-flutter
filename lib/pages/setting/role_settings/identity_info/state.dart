import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class IdentityInfoState extends BaseGetState {
  var unitMember = <XTarget>[].obs;
}

List<String> docTitle = [
  "账号",
  "昵称",
  "姓名",
  "备注",
  "手机号",
];


enum IdentityFunction{
  edit,
  delete,
  addMember,
}