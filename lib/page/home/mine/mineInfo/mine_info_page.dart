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
            title: const Text(
                '我的信息',
                style: TextStyle(fontSize: 24)),
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
                  children: const [
                    FormItemType2(text:'测试',suffixIcon: Icon(Icons.access_time_filled_sharp)),
                    Divider(
                      height: 0,
                    ),
                    FormItemType2(text:'测试',rightSlot: Text('data12121'),suffixIcon: Icon(Icons.access_time_filled_sharp)),
                  ],
                ),
              ),
            ]),
          ),
    )
    );
        }
}
