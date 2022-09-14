import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              body: Container(
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
                            await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("温馨提示"),
                                  //title 的内边距，默认 left: 24.0,top: 24.0, right 24.0
                                  //默认底部边距 如果 content 不为null 则底部内边距为0
                                  //            如果 content 为 null 则底部内边距为20
                                  titlePadding: EdgeInsets.all(10),
                                  //标题文本样式
                                  titleTextStyle: TextStyle(
                                      color: Colors.black87, fontSize: 16),
                                  //中间显示的内容
                                  content: Text("您确定要删除吗?"),
                                  //中间显示的内容边距
                                  //默认 EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0)
                                  contentPadding: EdgeInsets.all(10),
                                  //中间显示内容的文本样式
                                  contentTextStyle: TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                  //底部按钮区域
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text("确认"),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                TextButton(
                                child: const Text("取消"),
                                onPressed: () {
                                  Get.back();
                                },
                                ),
                                  ],
                                );
                              },
                            );
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
                            suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                        const Divider(
                          height: 0,
                        ),
                        FormItemType2(
                            text: '真实姓名',
                            rightSlot: Text(controller.userInfo.team.name,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1),
                                    overflow: TextOverflow.ellipsis)),
                            suffixIcon: const Icon(Icons.keyboard_arrow_right)),
                        const Divider(
                          height: 0,
                        ),
                        FormItemType2(
                            text: '手机号',
                            rightSlot: Text(controller.userInfo.team.code,
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1),
                                    overflow: TextOverflow.ellipsis)),
                            suffixIcon: const Icon(Icons.keyboard_arrow_right)),
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
              ),
            ));
  }
}
