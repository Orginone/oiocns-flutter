import 'package:flutter/material.dart';
import 'package:orginone/component/form_item_type1.dart';
import 'package:orginone/page/home/search/search_controller.dart';
import 'package:get/get.dart';
import 'package:orginone/routers.dart';

const Color defaultBgColor = Colors.white;

class UnitResultPage extends GetView<SearchController> {
  const UnitResultPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
        init: SearchController(),
        builder: (item) => Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: ListView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.searchResults.length,
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
                      title: controller.searchResults[index]["code"],
                      text: controller.searchResults[index]["name"],
                      suffixIcon: const Icon(Icons.keyboard_arrow_right),
                      callback1: () {
                        Get.toNamed(Routers.unitDetail, arguments: {
                          'code': controller.searchResults[index]["code"],
                          'type': 2
                        });
                      },
                    );
                  }),
            ));
  }
}
