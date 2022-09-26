import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:logging/logging.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/api_resp/target_resp.dart';
import 'package:orginone/util/hive_util.dart';

class MineCardController extends GetxController {
  final Logger log = Logger("MineCardController");
  TargetResp userInfo = HiveUtil().getValue(Keys.userInfo);
  @override
  void onReady() async {
    super.onReady();
  }
}
