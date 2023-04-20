import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/template/originone_scaffold.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/event/home_data.dart';
import 'package:orginone/pages/other/home/widgets/space_item_widget.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/asset_management.dart';
import 'package:orginone/util/event_bus_helper.dart';

class SpacesPage extends GetView<SettingController> {
  const SpacesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarLeading: XWidgets.defaultBackBtn,
      appBarTitle: Text("工作空间", style: XFonts.size22Black3),
      appBarCenterTitle: true,
      body: _body,
    );
  }

  get _body {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.user?.getJoinedCompanys(reload: true);
      },
      child: Obx(() {
        var joinedCompanies = controller.user!.joinedCompany;
        var spaces = <ISpace>[...joinedCompanies, controller.user!];
        spaces.removeWhere((element) => controller.space.id == element.target.id);
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: spaces.length,
          itemBuilder: (BuildContext context, int index) {
            return _item(spaces[index]);
          },
        );
      }),
    );
  }

  Widget _item(ISpace space) {
    return SpaceItemWidget(
      space: space,
      isCurrent: controller.space.id == space.target.id,
      onTap: (company) async {
        await controller.setCurSpace(company.target.id);
        Get.back(result: true);
      },
    );
  }
}
