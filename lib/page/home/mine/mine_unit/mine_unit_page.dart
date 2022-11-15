import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

import '../../../../component/a_font.dart';
import 'mine_unit_controller.dart';

class MineUnitPage extends GetView<MineUnitController> {
  const MineUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineUnitController>(
        init: MineUnitController(),
        builder: (item) => UnifiedScaffold(
            appBarTitle: Text("我的单位", style: AFont.instance.size22Black3),
            appBarCenterTitle: true,
            appBarLeading: WidgetUtil.defaultBackBtn,
            bgColor: const Color.fromRGBO(240, 240, 240, 1),
            floatingButton: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: FloatingActionButton(
                      heroTag: 'one',
                      onPressed: () async {
                        Get.toNamed(Routers.unitCreate);
                      },
                      tooltip: "创建单位",
                      backgroundColor: Colors.blueAccent,
                      splashColor: Colors.white,
                      elevation: 0.0,
                      highlightElevation: 25.0,
                      child:
                          const Icon(Icons.add, size: 30, color: Colors.white)),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                  child: FloatingActionButton(
                      onPressed: () {
                        List<SearchItem> units = [SearchItem.units];
                        Get.toNamed(Routers.search, arguments: units);
                      },
                      tooltip: "加入单位",
                      backgroundColor: Colors.blueAccent,
                      splashColor: Colors.white,
                      elevation: 0.0,
                      highlightElevation: 25.0,
                      // Text('添加好友',style:TextStyle(fontSize: 10)),
                      child: const Icon(Icons.person_add,
                          size: 30, color: Colors.white)),
                )
              ],
            ),
            body: Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.units.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FormItemType1(
                      leftSlot: CircleAvatar(
                        foregroundImage: const NetworkImage(
                            'https://www.vcg.com/creative/1382429598'),
                        backgroundImage:
                            const AssetImage('images/person_empty.png'),
                        onForegroundImageError: (error, stackTrace) {},
                        radius: 15,
                      ),
                      title: controller.units[index].code,
                      text: controller.units[index].name,
                      suffixIcon: const Icon(Icons.keyboard_arrow_right),
                      callback1: () {
                        Get.toNamed(Routers.unitDetail, arguments: {
                          'code': controller.units[index].code,
                          'type': 1
                        });
                      },
                    );
                  }),
            )));
  }
}
