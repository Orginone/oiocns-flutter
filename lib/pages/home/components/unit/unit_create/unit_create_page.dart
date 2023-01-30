import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/api/company_api.dart';
import 'package:orginone/components/unified_scaffold.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/widget_util.dart';

import '../../../../../components/a_font.dart';
import 'unit_create_controller.dart';

class UnitCreatePage extends GetView<UnitCreateController> {
  const UnitCreatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return GetBuilder<UnitCreateController>(
      init: UnitCreateController(),
      builder: (item) => UnifiedScaffold(
        appBarTitle: Text("创建单位", style: AFont.instance.size22Black3),
        appBarCenterTitle: true,
        appBarLeading: WidgetUtil.defaultBackBtn,
        bgColor: const Color.fromRGBO(240, 240, 240, 1),
        body: Container(
          margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
                    child: const Text("完善单位信息", style: TextStyle(fontSize: 24)),
                  ),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.nameController,
                        decoration: const InputDecoration(hintText: '请输入单位名称'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "单位名称不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.codeController,
                        decoration:
                            const InputDecoration(hintText: '请输入社会信用统一代码'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "社会信用统一代码不能为空!";
                          }
                          value = value ?? '';
                          //社会信用统一正则,统一社会信用代码由18位数字或者大写字母组成，但是字母不包括 I、O、Z、S、V
                          RegExp exp = RegExp(
                              r"[0-9A-HJ-NPQRTUWXY]{2}\d{6}[0-9A-HJ-NPQRTUWXY]{10}");
                          if (!exp.hasMatch(value)) {
                            return '统一社会信用代码由18位数字或者大写字母组成，但是字母不包括 I、O、Z、S、V';
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.nickNameController,
                        decoration: const InputDecoration(hintText: '请输入团队简称'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "团队简称不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.teamCodeController,
                        decoration: const InputDecoration(hintText: '请输入团队标识'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "团队标识不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: TextFormField(
                        controller: controller.remarkController,
                        decoration:
                            const InputDecoration(hintText: '请输入团队信息备注'),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (TextUtil.isEmpty(value)) {
                            return "团队信息备注不能为空!";
                          }
                          return null;
                        },
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(40, 30, 40, 0),
                      child: GFButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            //注册
                            var postData = {
                              "code": controller.codeController.text,
                              "name": controller.nameController.text,
                              "teamCode": controller.teamCodeController.text,
                              "teamName": controller.nickNameController.text,
                              "teamRemark": controller.remarkController.text,
                            };
                            await CompanyApi.createCompany(postData);
                            Fluttertoast.showToast(
                                msg: '创建成功',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 16.0);
                            Get.offNamed(Routers.unitDetail);
                          }
                        },
                        text: "创建单位",
                        blockButton: true,
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
