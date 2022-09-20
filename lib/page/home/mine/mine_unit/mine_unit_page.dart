import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/text_search.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/page/home/mine/mine_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

import 'mine_unit_controller.dart';

class MineUnitPage extends GetView<MineUnitController> {
  const MineUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineUnitController>(
        init: MineUnitController(),
        builder: (item) => UnifiedScaffold(
            appBarTitle: Text("我的单位", style: text16),
            appBarLeading: WidgetUtil.defaultBackBtn,
            bgColor: const Color.fromRGBO(240, 240, 240, 1),
            body: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (BuildContext context, int index) {
                    return FormItemType1(
                      leftSlot: CircleAvatar(
                        foregroundImage: const NetworkImage(
                            'https://www.vcg.com/creative/1382429598'),
                        backgroundImage:
                            const AssetImage('images/person-empty.png'),
                        onForegroundImageError: (error, stackTrace) {},
                        radius: 15,
                      ),
                      title: '测试标题',
                      text: '测试文本',
                      suffixIcon: const Icon(Icons.keyboard_arrow_right),
                    );
                  }),
            )));
  }
}
