import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/form_item_type1.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/dart/controller/message/message_controller.dart';
import 'package:orginone/dart/core/authority.dart';
import 'package:orginone/pages/setting/person_detail/person_detail_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

class PersonDetailPage extends GetView<PersonDetailController> {
  const PersonDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonDetailController>(
      init: PersonDetailController(),
      builder: (item) => UnifiedScaffold(
        appBarTitle: Text("用户详情", style: AFont.instance.size22Black3),
        appBarCenterTitle: true,
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
                  if (Get.isRegistered<MessageController>()) {
                    var messageCtrl = Get.find<MessageController>();
                    await messageCtrl.setCurrent(
                      auth.userId,
                      controller.personDetail?.id ?? "",
                    );
                    Get.toNamed(Routers.chat);
                  }
                },
                tooltip: "发送消息",
                backgroundColor: Colors.blueAccent,
                splashColor: Colors.white,
                elevation: 0.0,
                highlightElevation: 25.0,
                // Text('添加好友',style:TextStyle(fontSize: 10)),
                child: const Icon(Icons.message, size: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
