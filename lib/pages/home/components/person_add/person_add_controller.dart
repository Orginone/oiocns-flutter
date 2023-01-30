import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/pages/home/component/person_detail/person_detail_controller.dart';

class PersonAddController extends GetxController {
  final Logger log = Logger("PersonAddController");
  PersonDetailController personDetailController =
      Get.find<PersonDetailController>();
  String personId = '';
  TextEditingController validateInfoTextController = TextEditingController();
  TextEditingController nickNameTextController = TextEditingController();

  @override
  void onReady() async {
    personId = Get.arguments;
    super.onReady();
  }

  void submitPersonAdd() async {
    await PersonApi.join(personId);
    Fluttertoast.showToast(msg: "申请成功!");
  }
}
