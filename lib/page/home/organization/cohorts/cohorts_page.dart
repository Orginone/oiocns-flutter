import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:orginone/page/home/organization/cohorts/cohorts_controller.dart';

import '../../../../component/text_search.dart';
import '../../../../config/custom_colors.dart';

class CohortsPage extends GetView<CohortsController> {
  const CohortsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GFAppBar(
        leading: GFIconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
          type: GFButtonType.transparent,
        ),
        title: const Text("我的好友"),
      ),
      body: Column(
        children: [
          TextSearch(TextSearchController()),
          Expanded(
              child: Scrollbar(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                            child: Row(children: [
                              Container(
                                  alignment: Alignment.center,
                                  width: 54,
                                  height: 54,
                                  decoration: const BoxDecoration(
                                      color: CustomColors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(54)))),
                              Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0)),
                              const Expanded(
                                  child: Text("姓名",
                                      style: TextStyle(fontSize: 18)))
                            ]));
                      })))
        ],
      ),
    );
  }
}
