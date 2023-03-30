import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class StationInfoPage extends BaseGetView<StationInfoController,StationInfoState>{
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.station.teamName,
      body: SingleChildScrollView(
        child:Column(
          children: [
            Column(
              children: [
                CommonWidget.commonHeadInfoWidget(state.station.target.name),
                Obx((){
                  List<List<String>> identityContent = [];
                  for (var identity in state.identitys) {
                    identityContent.add([
                      identity.id??"",
                      identity.code??"",
                      identity.name??"",
                      identity.name??"",
                      identity.belongId??"",
                      identity.remark ?? ""
                    ]);
                  }
                  return CommonWidget.commonDocumentWidget(
                      title: identityTitle,
                      content: identityContent,
                      showOperation: true,
                      popupMenus: [
                        const PopupMenuItem(value: 'out', child: Text("移除")),
                      ],
                      onOperation: (type,data) {});
                }),
              ],
            ),
            SizedBox(height: 10.h,),
            Column(
              children: [
                CommonWidget.commonHeadInfoWidget("岗位人员"),
                Obx((){
                  List<List<String>> memberContent = [];
                  for (var user in state.unitMember) {
                    memberContent.add([
                      user.code,
                      user.name,
                      user.team?.name ?? "",
                      user.team?.code ?? "",
                      user.team?.remark ?? ""
                    ]);
                  }
                  return CommonWidget.commonDocumentWidget(
                      title: memberTitle,
                      content: memberContent,
                      showOperation: true,
                      popupMenus: [
                        const PopupMenuItem(value: 'out', child: Text("移除")),
                      ],
                      onOperation: (type,data) {});
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}