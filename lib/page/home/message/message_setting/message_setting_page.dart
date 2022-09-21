import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/routers.dart';
import '../../../../util/widget_util.dart';
import 'message_setting_controller.dart';

class MessageSettingPage extends GetView<MessageSettingController> {
  const MessageSettingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
        appBarLeading: WidgetUtil.defaultBackBtn,
        appBarTitle: const Text("会话设置"),
        body: Obx(() {
          List<Widget> widgetList = [
            Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.all(Radius.circular(2))),
                  margin: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    controller.name.value.isNotEmpty
                        ? controller.name.value.substring(
                            0, controller.name.value.length >= 2 ? 2 : 1)
                        : '',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  )),
              Container(
                  margin: const EdgeInsets.all(10),
                  child: Text(controller.name.value,
                      style: const TextStyle(fontSize: 24))),
            ]),
            const Divider(
              height: 0,
            )
          ];
          if (controller.label.value == '公司') {
            widgetList.addAll([
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
                    itemCount: controller.filterPersonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Get.toNamed(Routers.personDetail,
                              arguments:
                                  controller.filterPersonList[index].name);
                        },
                        child: Container(
                          width: 50,
                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              FadeInImage.assetNetwork(
                                placeholder: 'images/person-empty.png',
                                image:
                                    'https://www.vcg.com/creative/1382429598',
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
                              Text(controller.filterPersonList[index].name,
                                  style: const TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
              const Divider(
                height: 0,
              )
            ]);
          } else if (controller.label.value == '群组') {
            widgetList.addAll([
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
                    itemCount: 2 + controller.filterPersonList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
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
                      } else if (index == 1) {
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
                          onTap: () {},
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
                                    controller.filterPersonList[index - 2].name,
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
                height: 0,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("我在本群昵称",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(controller.userInfo.name)
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("群组备注",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(controller.remark.value)
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
            ]);
          } else {}

          widgetList.addAll([
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: controller.textField1.value,
                  onChanged: (a) {
                    controller.test1(a);
                  },
                ),
                const Text("设置群消息免打扰")
              ],
            ),
            Row(
              children: [
                Radio(
                  value: 2,
                  groupValue: controller.textField2.value,
                  onChanged: (a) {
                    controller.test1(a);
                  },
                ),
                const Text("置顶该群")
              ],
            ),
          ]);

          if (controller.label.value == '公司') {
            widgetList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 130,
                  child: GFButton(
                    color: const Color.fromRGBO(254, 240, 240, 1),
                    textColor: const Color.fromRGBO(255, 0, 0, 1),
                    onPressed: () async {},
                    text: "清空聊天记录",
                  ),
                ),
              ],
            ));
          } else if (controller.label.value == '群组') {
            widgetList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 110,
                  child: GFButton(
                    color: const Color.fromRGBO(254, 240, 240, 1),
                    textColor: const Color.fromRGBO(255, 0, 0, 1),
                    onPressed: () async {},
                    text: "退出该群",
                  ),
                ),
                SizedBox(
                  width: 110,
                  child: GFButton(
                    color: const Color.fromRGBO(255, 0, 0, 1),
                    textColor: const Color.fromRGBO(254, 240, 240, 1),
                    onPressed: () async {},
                    text: "解散该群",
                  ),
                ),
                SizedBox(
                  width: 130,
                  child: GFButton(
                    color: const Color.fromRGBO(254, 240, 240, 1),
                    textColor: const Color.fromRGBO(255, 0, 0, 1),
                    onPressed: () async {},
                    text: "清空聊天记录",
                  ),
                ),
              ],
            ));
          } else {
            widgetList.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 130,
                  child: GFButton(
                    color: const Color.fromRGBO(254, 240, 240, 1),
                    textColor: const Color.fromRGBO(255, 0, 0, 1),
                    onPressed: () async {},
                    text: "删除好友",
                  ),
                ),
              ],
            ));
          }
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widgetList);
        }));
  }
}
