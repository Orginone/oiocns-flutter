import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/components/a_font.dart';
import 'package:orginone/components/form_item_type2.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

class UnitDetailPage extends GetView<TargetController> {
  const UnitDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var args = Get.arguments;
    var company = controller.maintainCompany?.target;
    var messageCtrl = Get.find<MessageController>();
    return UnifiedScaffold(
      appBarTitle: Text("单位信息", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
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
                    rightSlot: Text(
                      company?.team?.name ?? "",
                      style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1)),
                    ),
                  ),
                  FormItemType2(
                    text: '单位简称',
                    rightSlot: Text(
                      company?.name ?? '',
                      style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1)),
                    ),
                  ),
                  FormItemType2(
                    text: '设立人',
                    rightSlot: Text(
                      messageCtrl.getName(company?.createUser ?? ''),
                      style: const TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1),
                      ),
                    ),
                  ),
                  FormItemType2(
                    text: '创建时间',
                    rightSlot: Text(
                      company?.createTime.toString() ?? '',
                      style: const TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1),
                      ),
                    ),
                  ),
                  FormItemType2(
                    text: '统一社会信用代码',
                    rightSlot: Text(
                      company?.code ?? '',
                      style: const TextStyle(
                        color: Color.fromRGBO(130, 130, 130, 1),
                      ),
                    ),
                  ),
                  FormItemType2(
                    text: '单位简介',
                    rightSlot: Expanded(
                      child: Text(
                        company?.team?.remark ?? '',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: Color.fromRGBO(130, 130, 130, 1),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            () {
              switch (args) {
                case 1:
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        GFButton(
                          onPressed: () async {
                            var currentPerson = controller.currentPerson;
                            var maintainCompany = controller.maintainCompany!;
                            await currentPerson
                                .exitCompany(maintainCompany.target.id);
                            Get.back();
                          },
                          color: Colors.red,
                          text: "退出单位",
                          blockButton: true,
                        )
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
                            await CompanyApi.joinCompany(company!.id);
                            Get.back();
                          },
                          color: Colors.blueAccent,
                          text: "申请加入",
                          blockButton: true,
                        )
                      ],
                    ),
                  );
                default:
                  return Container();
              }
            }()
          ],
        ),
      ),
    );
  }
}
