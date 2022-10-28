import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:orginone/public/http/base_controller.dart';

abstract class BaseView<T extends BaseController> extends GetView<T>{

  const BaseView({Key? key}) : super(key: key);

}