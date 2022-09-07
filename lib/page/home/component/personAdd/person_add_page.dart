import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/page/home/component/personAdd/person_add_controller.dart';

class PersonAddPage extends GetView<PersonAddController> {
  const PersonAddPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GFAppBar(
          leading: GFIconButton(
            color: Colors.white,
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
            type: GFButtonType.transparent,
          ),
          title: const Text("好友验证"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Form(
              key: const Key('personAddForm'),
              child: Column(
                children: [
                  TextFormField(
                    autofocus: true,
                    style: const TextStyle(height: 2),
                    cursorHeight: 40,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    controller: controller.validateInfoTextController,
                    decoration: const InputDecoration(
                        hintText: '请输入验证消息',
                        hintStyle: TextStyle(color: Colors.grey),
                        labelText: '验证',
                        contentPadding:
                        EdgeInsets.fromLTRB(0, 30, 0, 15)),
                  ),
                  TextFormField(
                    style: const TextStyle(height: 2),
                    cursorHeight: 40,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    controller: controller.nickNameTextController,
                    decoration: InputDecoration(
                        hintText: controller
                            .personDetailController.personDetail!.team["name"],
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: '备注',
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 30, 0, 15)),
                    // validator: validateTelePhone,
                  ),
                  Expanded(child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GFButton(
                        color: Colors.blue,
                        textColor: Colors.white,
                        onPressed: () async {
                          controller.submitPersonAdd();
                          Get.back();
                        },
                        blockButton: true,
                        text: "发送申请",
                      )
                    ],
                  ))
                ],
              )),
        ));
  }
}
