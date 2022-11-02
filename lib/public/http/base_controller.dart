import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../loading/load_status.dart';

abstract class BaseController extends GetxController {
  final Rx<LoadStatusX> loadStatus = LoadStatusX.loading.obs;

  updateLoadStatus(LoadStatusX status) {
    debugPrint("---->1$status");
    if (status != loadStatus.value) {
      loadStatus.value = status;
    }
  }
}
