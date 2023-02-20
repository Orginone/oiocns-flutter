import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/base_controller.dart';

class TodoDetail extends StatefulWidget {
  const TodoDetail({Key? key}) : super(key: key);

  @override
  State<TodoDetail> createState() => _TodoDetailState();
}

class _TodoDetailState extends State<TodoDetail> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TodoDetailController extends BaseController{

}

class TodoDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TodoDetailController());
  }
}