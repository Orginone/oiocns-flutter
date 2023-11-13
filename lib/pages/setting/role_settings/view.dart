import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/role_settings/state.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'identity_info/view.dart';
import 'logic.dart';

class RoleSettingsPage
    extends BaseGetView<RoleSettingsController, RoleSettingsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "角色设置",
      actions: [
        IconButton(
            onPressed: () {
              controller.createIdentity();
            },
            icon: Icon(
              Icons.add,
              color: Colors.black,
              size: 36.w,
            ))
      ],
      body: Column(
        children: [
          Obx(() {
            if (state.identitys.isEmpty) {
              return Container();
            }
            return Container(
              width: double.infinity,
              color: Colors.white,
              child: TabBar(
                controller: state.tabController,
                tabs: state.identitys
                    .map((item) => Tab(
                          text: item.metadata.name,
                        ))
                    .toList(),
                isScrollable: true,
                unselectedLabelColor: Colors.black,
                indicatorColor: XColors.themeColor,
                labelColor: XColors.themeColor,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (state.identitys.isEmpty) {
                return Container();
              }
              return TabBarView(
                controller: state.tabController,
                children: state.identitys.map((element) {
                  return IdentityInfoPage(element);
                }).toList(),
              );
            }),
          )
        ],
      ),
    );
  }
}
