import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/component/person_add/person_add_controller.dart';
import 'package:orginone/util/widget_util.dart';

class PersonAddPage extends GetView<PersonAddController> {
  const PersonAddPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
        appBarTitle: Text("好友添加", style: text16),
        appBarLeading: WidgetUtil.defaultBackBtn,
        bgColor: const Color.fromRGBO(240, 240, 240, 1),
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
                        contentPadding: EdgeInsets.fromLTRB(0, 30, 0, 15)),
                  ),
                  TextFormField(
                    style: const TextStyle(height: 2),
                    cursorHeight: 40,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    controller: controller.nickNameTextController,
                    decoration: InputDecoration(
                        hintText: controller.personDetailController
                                .personDetail!.team?.name ??
                            "",
                        hintStyle: const TextStyle(color: Colors.grey),
                        labelText: '备注',
                        contentPadding:
                            const EdgeInsets.fromLTRB(0, 30, 0, 15)),
                    // validator: validateTelePhone,
                  ),
                  Expanded(
                      child: Column(
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
