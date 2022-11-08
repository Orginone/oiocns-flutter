import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';

import '../../../../component/a_font.dart';
import 'person_detail_controller.dart';

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
                      if (controller.personDetail == null) {
                        Fluttertoast.showToast(msg: "未获取到人员信息！");
                        return;
                      }
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
              // Container(
              //   margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
              //   child: FloatingActionButton(
              //       onPressed: () {
              //         Get.toNamed(Routers.personAdd,
              //             arguments: item.personDetail!.id);
              //       },
              //       tooltip: "添加好友",
              //       backgroundColor: Colors.blueAccent,
              //       splashColor: Colors.white,
              //       elevation: 0.0,
              //       highlightElevation: 25.0,
              //       // Text('添加好友',style:TextStyle(fontSize: 10)),
              //       child: const Icon(Icons.person_add,
              //           size: 30, color: Colors.white)),
              // )
            ],
          )),
    );
  }
}
