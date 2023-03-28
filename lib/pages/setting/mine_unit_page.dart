import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/choose_item.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/forms.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/routers.dart';

class MineUnitPage extends GetView<SettingController> {
  const MineUnitPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarTitle: Text("我的单位", style: XFonts.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: XWidgets.defaultBackBtn,
      bgColor: const Color.fromRGBO(240, 240, 240, 1),
      floatingButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: FloatingActionButton(
              heroTag: 'one',
              onPressed: () async {
                Get.toNamed(
                  Routers.form,
                  arguments: CreateCompany((value) {
                    // if (Get.isRegistered<SettingController>()) {
                    //   var targetCtrl = Get.find<SettingController>();
                    //   targetCtrl.user?.create(value)
                    //       .then((value) => Get.back());
                    // }
                  }),
                );
              },
              tooltip: "创建单位",
              backgroundColor: Colors.blueAccent,
              splashColor: Colors.white,
              elevation: 0.0,
              highlightElevation: 25.0,
              child: const Icon(Icons.add, size: 30, color: Colors.white),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(10, 0, 5, 0),
            child: FloatingActionButton(
              onPressed: () {
                Map<String, dynamic> params = {
                  "items": [SearchItem.units],
                  "point": FunctionPoint.applyCompanies,
                };
                Get.toNamed(Routers.search, arguments: params);
              },
              tooltip: "加入单位",
              backgroundColor: Colors.blueAccent,
              splashColor: Colors.white,
              elevation: 0.0,
              highlightElevation: 25.0,
              child: const Icon(
                Icons.search,
                size: 30,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Obx(() {
          var companies = controller.user?.joinedCompany ?? [];
          return ListView.builder(
            itemCount: companies.length,
            itemBuilder: (BuildContext context, int index) {
              var company = companies[index];
              return ChooseItem(
                  header: CircleAvatar(
                  foregroundImage: const NetworkImage(
                      'https://www.vcg.com/creative/1382429598'),
                  backgroundImage: const AssetImage('images/person_empty.png'),
                  onForegroundImageError: (error, stackTrace) {},
                  radius: 15,
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(company.target.code),
                  Text(company.target.name)
                ]),
                func: () {
                  // controller.setCurrentMaintain(company);
                  // Get.toNamed(Routers.unitDetail, arguments: 1);
                },
              );
            },
          );
        }),
      ),
    );
  }
}
