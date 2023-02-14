import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/dart/ts/controller/setting/index.dart';
import 'package:orginone/pages/other/home/widgets/space_item_widget.dart';

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
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: spaces.length + 1,
          itemBuilder: (BuildContext context, int index) {
            return _item(spaces[index - 1]);
          },
        );
      }),
    );
  }

  Widget _item(ISpace space) {
    return SpaceItemWidget(
      space: space,
      isCurrent: controller.user!.target.id == space.target.id,
      onTap: (company) async {
        await controller.setCurSpace(company.target.id);
        Get.back();
      },
    );
  }
}
