


import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class AddMembersState extends BaseGetState{
  TextEditingController searchController = TextEditingController();

  late String title;

  var unitMember = <XTarget>[].obs;

  var selectAll = false.obs;

  var showSearch = false.obs;

  var searchMember = <XTarget>[].obs;

  var selectedMember = <XTarget>[].obs;

  AddMembersState(){
    title = Get.arguments['title'];
  }
}