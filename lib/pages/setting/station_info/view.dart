import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/config.dart';
import 'package:orginone/pages/setting/widget.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class StationInfoPage
    extends BaseGetView<StationInfoController, StationInfoState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.station.metadata.name,
      body: SingleChildScrollView(
        child:Column(
          children: [
            Column(
              children: [
                CommonWidget.commonHeadInfoWidget(state.station.metadata.name),
                Obx((){
                  List<List<String>> identityContent = [];
                  for (var identity in state.identitys) {
                    identityContent.add([
                      identity.metadata.id??"",
                      identity.metadata.code??"",
                      identity.metadata.name??"",
                      identity.metadata.name??"",
                      identity.metadata.belongId??"",
                      identity.metadata.remark ?? ""
                    ]);
                  }
                  return CommonWidget.commonDocumentWidget(
                      title: identityTitle,
                      content: identityContent,
                      showOperation: true,
                      popupMenus: [
                        const PopupMenuItem(value: 'out', child: Text("移除")),
                      ],
                      onOperation: (type,data) {
                        controller.removeAdmin(data);
                      });
                }),
              ],
            ),
            SizedBox(height: 10.h,),
            Column(
              children: [
                CommonWidget.commonHeadInfoWidget("岗位人员",action: CommonWidget.commonPopupMenuButton(
                    items: const [
                      PopupMenuItem(
                        value: CompanyFunction.addUser,
                        child: Text("添加人员"),
                      ),
                    ],
                    onSelected: (CompanyFunction function) {
                      controller.companyOperation(function);
                    },color: Colors.transparent
                )),
                Obx(() {
                  return UserDocument(
                    popupMenus: const [
                      PopupMenuItem(value: 'out', child: Text("移除")),
                    ],
                    onOperation: (type, data) {
                      controller.removeMember(data);
                    },
                    unitMember: state.unitMember.value,
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}