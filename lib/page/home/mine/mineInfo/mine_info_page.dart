import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/api/person_api.dart';
import 'package:orginone/component/form_item_type2.dart';
import 'package:getwidget/getwidget.dart';
import 'mine_info_controller.dart';

class MineInfoPage extends GetView<MineInfoController> {
  const MineInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineInfoController>(
        init: MineInfoController(),
        builder: (item) => Scaffold(
              appBar: GFAppBar(
                leading: GFIconButton(
                  color: Colors.white,
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Get.back(),
                  type: GFButtonType.transparent,
                ),
                title: const Text('我的信息', style: TextStyle(fontSize: 24)),
              ),
              backgroundColor: const Color.fromRGBO(240, 240, 240, 1),
              body: ListView(children: [
                Container(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FormItemType2(
                              text: '头像',
                              rightSlot: CircleAvatar(
                                foregroundImage: const NetworkImage(
                                    'https://www.vcg.com/creative/1382429598'),
                                backgroundImage:
                                const AssetImage('images/person-empty.png'),
                                onForegroundImageError: (error, stackTrace) {},
                                radius: 15,
                              ),
                              suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                          const Divider(
                            height: 0,
                          ),
                          FormItemType2(
                            text: '昵称',
                            rightSlot: Text(controller.userInfo.name,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                            suffixIcon: const Icon(Icons.keyboard_arrow_right),
                            callback1: () async {
                              controller.showFormDialogWidget(context, controller.nickNameTextController, title: '昵称修改', text: controller.userInfo.name, validator: (value) {
                                value = value ?? '';
                                if (value.isEmpty) {
                                  return '请输入昵称';
                                }
                                return null;
                              },callback: () {
                                controller.updateUser({
                                  "code": controller
                                      .userInfo.code,
                                  "id": controller.userInfo.id,
                                  "name":
                                  controller
                                      .nickNameTextController.text,
                                  "teamAuthId":
                                  controller.userInfo.team.id,
                                  "teamCode": controller
                                      .userInfo.team.code,
                                  "teamName": controller
                                      .userInfo.team.name,
                                  "teamRemark": controller
                                      .userInfo.team.remark,
                                  "thingId":
                                  controller.userInfo.thingId,
                                });
                                controller.nickNameTextController
                                    .clear();
                                Get.back();

                              });
                            },
                          ),
                          const Divider(
                            height: 0,
                          ),
                          FormItemType2(
                            text: '账号',
                            rightSlot: Text(controller.userInfo.code,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                            suffixIcon: const Icon(Icons.keyboard_arrow_right),
                            callback1: () async {
                              controller.showFormDialogWidget(context, controller.accountTextController, title: '账号修改', text: controller.userInfo.code, validator: (value) {
                                value = value ?? '';
                                if (value.isEmpty) {
                                  return '请输入账号';
                                }
                                //用户名正则，4到16位（字母，数字，下划线，减号）
                                RegExp exp =
                                RegExp(r"^[a-zA-Z0-9_-]{4,16}$");
                                if (!exp.hasMatch(value)) {
                                  return '账号格式错误';
                                }
                                return null;
                              },callback: () {
                                controller.updateUser({
                                  "code": controller
                                      .accountTextController.text,
                                  "id": controller.userInfo.id,
                                  "name":
                                  controller.userInfo.name,
                                  "teamAuthId":
                                  controller.userInfo.team.id,
                                  "teamCode": controller
                                      .userInfo.team.code,
                                  "teamName": controller
                                      .userInfo.team.name,
                                  "teamRemark": controller
                                      .userInfo.team.remark,
                                  "thingId":
                                  controller.userInfo.thingId,
                                });
                                controller.accountTextController
                                    .clear();
                                Get.back();

                              });
                            },
                          ),
                          const Divider(
                            height: 0,
                          ),
                          FormItemType2(
                            text: '真实姓名',
                            rightSlot: Text(controller.userInfo.team.name,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1),
                                    overflow: TextOverflow.ellipsis)),
                            suffixIcon: const Icon(Icons.keyboard_arrow_right),
                            callback1: () async {
                              controller.showFormDialogWidget(context, controller.nameTextController, title: '真实姓名修改', text: controller.userInfo.team.name, validator: (value) {
                                value = value ?? '';
                                if (value.isEmpty) {
                                  return '请输入真实姓名';
                                }
                                return null;
                              },callback: () {
                                controller.updateUser({
                                  "code": controller
                                      .userInfo.code,
                                  "id": controller.userInfo.id,
                                  "name":
                                  controller.userInfo.name,
                                  "teamAuthId":
                                  controller.userInfo.team.id,
                                  "teamCode": controller
                                      .userInfo.team.code,
                                  "teamName": controller.nameTextController.text,
                                  "teamRemark": controller
                                      .userInfo.team.remark,
                                  "thingId":
                                  controller.userInfo.thingId,
                                });
                                controller.nameTextController
                                    .clear();
                                Get.back();
                              });
                            },
                          ),
                          const Divider(
                            height: 0,
                          ),
                          FormItemType2(
                              text: '手机号',
                              rightSlot: Text(controller.userInfo.team.code,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(130, 130, 130, 1),
                                      overflow: TextOverflow.ellipsis)),
                              suffixIcon: const Icon(Icons.keyboard_arrow_right),
                              callback1: () async {
                                controller.showFormDialogWidget(context, controller.phoneTextController, keyboardType: TextInputType.number,title: '手机号修改', text: controller.userInfo.team.code, validator: (value) {
                                  value = value ?? '';
                                  if (value.isEmpty) {
                                    return '请输入手机号';
                                  }
                                  //用户名正则，4到16位（字母，数字，下划线，减号）
                                  RegExp exp =
                                  RegExp(r"^((13[0-9])|(14[5|7])|(15([0-3]|[5-9]))|(18[0,5-9]))\d{8}$");
                                  if (!exp.hasMatch(value)) {
                                    return '手机号格式错误';
                                  }
                                  return null;
                                },callback: () {
                                  controller.updateUser({
                                    "code": controller.phoneTextController.text,
                                    "id": controller.userInfo.id,
                                    "name":
                                    controller.userInfo.name,
                                    "teamAuthId":
                                    controller.userInfo.team.id,
                                    "teamCode": controller
                                        .userInfo.team.code,
                                    "teamName": controller.userInfo.team.name,
                                    "teamRemark": controller
                                        .userInfo.team.remark,
                                    "thingId":
                                    controller.userInfo.thingId,
                                  });
                                  controller.phoneTextController
                                      .clear();
                                  Get.back();
                                });
                              }),
                          const Divider(
                            height: 0,
                          ),
                          FormItemType2(
                              text: '座右铭',
                              rightSlot: Expanded(
                                child: Text(controller.userInfo.team.remark,
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                        color: Color.fromRGBO(130, 130, 130, 1),
                                        overflow: TextOverflow.ellipsis)),
                              ),
                              suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                          const Divider(
                            height: 0,
                          ),
                        ],
                      ),
                    ),
                  ]),
                )
              ]),
            ));
  }

  void showFormItemDialog() {}
}
