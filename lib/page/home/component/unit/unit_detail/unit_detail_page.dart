import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/component/form_item_type2.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

import 'unit_detail_controller.dart';

class UnitDetailPage extends GetView<UnitDetailController> {
  const UnitDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UnitDetailController>(
        init: UnitDetailController(),
        builder: (item) => UnifiedScaffold(
            appBarTitle: Text("单位信息", style: text16),
            appBarLeading: WidgetUtil.defaultBackBtn,
            bgColor: const Color.fromRGBO(240, 240, 240, 1),
            body: Container(
                margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: ListView(
                  children: [
                    Container(
                      color: const Color.fromRGBO(255, 255, 255, 1),
                      child: Column(
                        children: [
                          FormItemType2(
                            text: '单位名称',
                            rightSlot: Text(controller.unit?.team.name ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                          ),
                          FormItemType2(
                            text: '单位简称',
                            rightSlot: Text(controller.unit?.name ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                          ),
                          FormItemType2(
                            text: '设立人',
                            rightSlot: Text(controller.unit?.createUser ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                          ),
                          FormItemType2(
                            text: '创建时间',
                            rightSlot: Text(
                                controller.unit?.createTime.toString() ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                          ),
                          FormItemType2(
                            text: '统一社会信用代码',
                            rightSlot: Text(controller.unit?.code ?? '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(130, 130, 130, 1))),
                          ),
                          FormItemType2(
                            text: '单位简介',
                            rightSlot: Expanded(
                              child: Text(controller.unit?.team.remark ?? '',
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                      color: Color.fromRGBO(130, 130, 130, 1),
                                      overflow: TextOverflow.ellipsis)),
                            ),
                          )
                        ],
                      ),
                    ),
                    (){
                      switch(controller.type) {
                        case 1:
                          return Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                GFButton(
                                    onPressed: () async {
                                      await CompanyApi.quitCompany(
                                          controller.unit!.id);
                                      Get.offNamed(Routers.unitDetail);
                                    },
                                    color: Colors.red,
                                    text: "退出单位",
                                    blockButton: true)
                              ],
                            ),
                          );
                        case 2:
                          return Container(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                GFButton(
                                    onPressed: () async {
                                      await CompanyApi.joinCompany(
                                          controller.unit!.id);
                                      Get.back();
                                    },
                                    color: Colors.blueAccent,
                                    text: "申请加入",
                                    blockButton: true)
                              ],
                            ),
                          );
                        default:
                          return Container();
                      }
                    }()
                  ],
                ))));
  }
}
