import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

import 'person_detail_controller.dart';

class PersonDetailPage extends GetView<PersonDetailController> {
  const PersonDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonDetailController>(
      init: PersonDetailController(),
      builder: (item) => UnifiedScaffold(
          appBarTitle: Text("用户详情", style: text16),
          appBarLeading: WidgetUtil.defaultBackBtn,
          bgColor: const Color.fromRGBO(240, 240, 240, 1),
          body: Container(
            margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FormItemType1(
                        title: '昵称',
                        text: item.personDetail != null
                            ? item.personDetail!.name
                            : '',
                        suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                    const Divider(
                      height: 0,
                    ),
                    FormItemType1(
                        title: '姓名',
                        text: item.personDetail != null
                            ? item.personDetail!.team?.name
                            : '',
                        suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                    const Divider(
                      height: 0,
                    ),
                    FormItemType1(
                        title: '电话',
                        text: item.personDetail != null
                            ? item.personDetail!.team?.code
                            : '',
                        suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                    const Divider(
                      height: 0,
                    ),
                  ],
                ),
              ),
            ]),
          ),
          floatingButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: FloatingActionButton(
                    heroTag: 'one',
                    onPressed: () async {
                      if (controller.personDetail == null) {
                        Fluttertoast.showToast(msg: "未获取到人员信息！");
                        return;
                      }
                      // HomeController homeController = Get.find();
                      // MessageController messageController = Get.find();
                      // messageController.currentSpaceId =
                      //     homeController.currentSpace.id;
                      // messageController.currentMessageItemId =
                      //     controller.personDetail!.id;
                      // Get.offNamedUntil(
                      //     Routers.chat,
                      //     (route) =>
                      //         (route as GetPageRoute).settings.name ==
                      //         Routers.home);

                      // MessageController messageController = Get.find();
                      // //循环判断该人员是否在集团里，若有则对话，无则提示
                      // int matchGroupId = -1;
                      // messageController.messageGroupItemsMap.forEach((key, value) {
                      //   List<TargetRelation> matchList = value.where((item) => item.passiveTargetId == int.tryParse(controller.personDetail!.id)).toList();
                      //   if(matchList.isNotEmpty) {
                      //     matchGroupId = key;
                      //   }
                      // });
                      // if(matchGroupId != -1) {
                      //   messageController.currentMessageItemId = int.tryParse(controller.personDetail!.id) ?? -1;
                      //   messageController.currentSpaceId = matchGroupId;
                      //   ChatController chatController = Get.find();
                      //   await chatController.init();
                      //   Get.toNamed(Routers.chat);
                      // } else {
                      //   Fluttertoast.showToast(
                      //       msg: '集团中不存在该人员',
                      //       toastLength: Toast.LENGTH_SHORT,
                      //       gravity: ToastGravity.CENTER,
                      //       timeInSecForIosWeb: 1,
                      //       backgroundColor: Colors.red,
                      //       textColor: Colors.white,
                      //       fontSize: 16.0
                      //   );
                      // }
                    },
                    tooltip: "发送消息",
                    backgroundColor: Colors.blueAccent,
                    splashColor: Colors.white,
                    elevation: 0.0,
                    highlightElevation: 25.0,
                    // Text('添加好友',style:TextStyle(fontSize: 10)),
                    child: const Icon(Icons.message,
                        size: 30, color: Colors.white)),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                child: FloatingActionButton(
                    onPressed: () {
                      Get.toNamed(Routers.personAdd,
                          arguments: item.personDetail!.id);
                    },
                    tooltip: "添加好友",
                    backgroundColor: Colors.blueAccent,
                    splashColor: Colors.white,
                    elevation: 0.0,
                    highlightElevation: 25.0,
                    // Text('添加好友',style:TextStyle(fontSize: 10)),
                    child: const Icon(Icons.person_add,
                        size: 30, color: Colors.white)),
              )
            ],
          )),
    );
  }
}
