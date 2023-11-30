import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/values/index.dart';

import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/main.dart';

import 'index.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key? key}) : super(key: key);

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _SecurityViewGetX();
  }
}

class _SecurityViewGetX extends GetView<SecurityController> {
  const _SecurityViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    List<Widget> widgetList = [
      Row(
        children: [
          Text("单位数据：成功加载${settingCtrl.provider.user?.companys.length}个"),
        ],
      ),
      Row(
        children: [
          Text("群数据：成功加载${settingCtrl.provider.user?.cohorts.length}个"),
        ],
      ),
      Row(
        children: [
          Text("群会话数据：成功加载${settingCtrl.provider.user?.cohortChats.length}个")
        ],
      )
    ];
    if (settingCtrl.provider.errInfo != "" && widgetList.isNotEmpty) {
      return Container(
          child: Column(children: [
        ...widgetList,
        Row(children: [
          Scrollbar(
              child: SingleChildScrollView(
            child: Text(settingCtrl.provider.errInfo),
          )),
        ])
      ])); //_buildView(),
    } else {
      return Center(
        child: Column(children: [
          Image.asset(
            AssetsImages.empty,
            width: 280.w,
            height: 280.w,
          ),
          const Text.rich(TextSpan(text: '暂无内容'))
        ]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SecurityController>(
      init: SecurityController(),
      id: "security",
      builder: (_) {
        return GyScaffold(
            backgroundColor: Colors.white,
            titleName: '安全',
            body: SafeArea(
              child: _buildView(),
            ));
      },
    );
  }
}
