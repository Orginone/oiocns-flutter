import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/component/a_font.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/controller/target/target_controller.dart';
import 'package:orginone/core/authority.dart';
import 'package:orginone/core/target/company.dart';
import 'package:orginone/core/ui/target/space_item_widget.dart';
import 'package:orginone/util/widget_util.dart';

class SpaceChoosePage extends GetView<TargetController> {
  const SpaceChoosePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnifiedScaffold(
      appBarLeading: WidgetUtil.defaultBackBtn,
      appBarTitle: Text("工作空间切换", style: AFont.instance.size22Black3),
      appBarCenterTitle: true,
      body: _body,
    );
  }

  get _body => RefreshIndicator(
      onRefresh: () => controller.currentPerson.refreshJoinedCompanies(),
      child: Obx(() {
        var currentPerson = controller.currentPerson;
        var joinedCompanies = currentPerson.joinedCompanies;
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: joinedCompanies.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return _item(currentPerson.selfCompany);
            }
            return _item(joinedCompanies[index - 1]);
          },
        );
      }));

  Widget _item(Company company) {
    return SpaceItemWidget(
        company: company,
        isCurrent: auth.spaceId == company.target.id,
        onTap: (company) async {
          await controller.currentPerson.changeSpaces(company);
          Get.back();
        });
  }
}
