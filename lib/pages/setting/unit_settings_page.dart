import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/choose_item.dart';
import 'package:orginone/components/template/originone_scaffold.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/forms.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/other/search_page.dart';
import 'package:orginone/routers.dart';

// 设置-单位设置
class UnitSettingsPage extends GetView<SettingController> {
  const UnitSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrginoneScaffold(
      appBarTitle: Text("单位设置", style: XFonts.size22Black3),
      appBarCenterTitle: true,
      appBarLeading: XWidgets.defaultBackBtn,
      bgColor: const Color.fromRGBO(240, 240, 240, 1),
      floatingButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
              // 操作（三个点），分享、评论
              ),
          Container(
              // 搜索框
              ),
          Container(
              // 当前单位
              // child: Image(image: AssetImage("images/fht.png"), width: 100.0)

              ),
          Container(
              // 个人空间，显示个人设置
              ),
        ],
      ),
    );
  }
}
