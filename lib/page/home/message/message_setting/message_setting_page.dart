import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/form_item_type2.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/hub_util.dart';

import '../../../../component/unified_text_style.dart';
import '../../../../util/widget_util.dart';
import 'message_setting_controller.dart';

class MessageSettingPage extends GetView<MessageSettingController> {
  const MessageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
        appBarLeading: WidgetUtil.defaultBackBtn,
        appBarTitle: Text("会话设置", style: text20),
        bgColor: const Color.fromRGBO(240, 240, 240, 1),
        body: Obx(() {
          //拼接消息设置的界面,根据会话的标签分为个人,好友,单位,群组的概念
          List<Widget> widgetList = [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: FormItemType1(
                leftSlot: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.all(Radius.circular(2))),
                    margin: const EdgeInsets.all(10),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(6),
                    child: Text(
                      controller.messageItem != null &&
                              controller.messageItem!.value.name.isNotEmpty
                          ? controller.messageItem!.value.name.substring(
                              0,
                              controller.messageItem!.value.name.length >= 2
                                  ? 2
                                  : 1)
                          : '',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    )),
                title: '群聊名称',
                text: controller.messageItem?.value.name,
              ),
            ),
          ];
          widgetList
              .add(personListWidget(controller.messageItem?.value.label ?? ''));
          if (controller.messageItem?.value.label == '群组') {
            widgetList.add(Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Column(
                children: [
                  FormItemType2(
                    text: "我在本群昵称",
                    rightSlot: Text(
                      controller.userInfo.name,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                  FormItemType2(
                    text: "备注",
                    rightSlot: Text(
                      controller.messageItem?.value.remark ?? '',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ));
          }

          widgetList.addAll([
            FormItemType2(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              text: '设置群消息免打扰',
              rightSlot: Switch(
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  value: controller.textField1.value,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xff025EFF),
                  inactiveTrackColor: const Color(0xffF2F2F2),
                  onChanged: (value) {
                    controller.textField1.value = value;
                  }),
            ),
            FormItemType2(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              height: 50,
              text: '置顶该群',
              rightSlot: Switch(
                  value: controller.textField2.value,
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xff025EFF),
                  inactiveTrackColor: const Color(0xffF2F2F2),
                  onChanged: (value) {
                    controller.textField2.value = value;
                  }),
            ),
          ]);
          widgetList
              .add(btnListWidget(controller.messageItem?.value.label ?? ''));
          return ListView(
            children: [
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widgetList)
            ],
          );
        }));
  }

  //群组的widget
  Widget personListWidget(String type) {
    switch (type) {
      case '本人':
      case '好友':
        return Container();
      case '群组':
      case '单位':
        return Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: Column(
            children: [
              Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: Text(
                            "组成员 ${controller.originPersonList.length} 人",
                            style: const TextStyle(fontSize: 16))),
                    Container(
                      constraints: const BoxConstraints(
                          maxHeight: 40,
                          minHeight: 40,
                          minWidth: 50,
                          maxWidth: 150),
                      margin: const EdgeInsets.all(10),
                      child: TextField(
                          controller: controller.searchGroupTextController,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                  icon: const Icon(Icons.search),
                                  onPressed: () {
                                    controller.searchPerson();
                                  }),
                              contentPadding:
                                  const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFDCDFE6)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF409EFF)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4.0)),
                              ),
                              hintText: "搜索成员")),
                    )
                  ]),
              Container(
                height: 70,
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: type == '群组'
                        ? 2 + controller.filterPersonList.length
                        : controller.filterPersonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0 && type == '群组') {
                        return GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {},
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.fromLTRB(10, 1, 10, 20),
                              child: DottedBorder(
                                dashPattern: const [4, 4],
                                strokeWidth: 1,
                                padding: const EdgeInsets.all(0),
                                child: Container(
                                  alignment: Alignment.center,
                                  width: 50,
                                  child: const Text("+",
                                      style: TextStyle(fontSize: 40)),
                                  // color: Colors.black26,
                                ),
                              ),
                            ));
                      } else if (index == 1 && type == '群组') {
                        return Container(
                          width: 50,
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: const Color.fromRGBO(255, 0, 0, 1)),
                          ),
                          child: const Text("-",
                              style:
                                  TextStyle(fontSize: 40, color: Colors.red)),
                        );
                      } else {
                        return GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            Get.toNamed(Routers.personDetail,arguments:
                              controller.filterPersonList[index].team?.code
                            );
                          },
                          child: Container(
                            width: 50,
                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FadeInImage.assetNetwork(
                                  placeholder: 'images/person-empty.png',
                                  image: 'qqqqqq',
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  'images/person-empty.png'),
                                              fit: BoxFit.cover)),
                                    );
                                  },
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                    controller
                                        .filterPersonList[
                                            type == '群组' ? index - 2 : index]
                                        .name,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }
                    }),
              ),
              const Divider(
                height: 1,
              )
            ],
          ),
        );
    }
    return Container();
  }

  //按钮组的widget
  Widget btnListWidget(String type) {
    switch (type) {
      case '本人':
        return GFButton(
          size: 50,
          color: Colors.white,
          textStyle: const TextStyle(
              fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
          fullWidthButton: true,
          onPressed: () async {
            HubUtil().clearHistoryMsg(controller.spaceId?.value,
                controller.messageItemId?.value ?? '');
          },
          text: "清空聊天记录",
        );
      case '好友':
        return Column(
          children: [
            GFButton(
              size: 50,
              color: Colors.white,
              textStyle: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
              fullWidthButton: true,
              onPressed: () async {
              },
              text: "删除好友",
            ),
            const Divider(
              height: 1,
            ),
            GFButton(
              size: 50,
              color: Colors.white,
              textStyle: const TextStyle(
                  fontSize: 16, color: Color.fromRGBO(255, 0, 0, 1)),
              fullWidthButton: true,
              onPressed: () async {
                HubUtil().clearHistoryMsg(controller.spaceId?.value,
                    controller.messageItemId?.value ?? '');
              },
              text: "清空聊天记录",
            ),
          ],
        );
      case '群组':
        return Container();
      case '单位':
        return Container();
    }
    return Container();
  }
}
