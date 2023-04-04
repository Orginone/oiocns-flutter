import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'index.dart';

class CardbagPage extends StatefulWidget {
  const CardbagPage({Key? key}) : super(key: key);

  @override
  State<CardbagPage> createState() => _CardbagPageState();
}

class _CardbagPageState extends State<CardbagPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _CardbagViewGetX();
  }
}

class _CardbagViewGetX extends GetView<CardbagController> {
  const _CardbagViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Center(
      child: Column(children: [
        Image.asset(
          Images.empty,
          width: 280.w,
          height: 280.w,
        ),
        const Text.rich(TextSpan(text: '暂无内容'))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardbagController>(
      init: CardbagController(),
      id: "cardbag",
      builder: (_) {
        return GyScaffold(
          backgroundColor: Colors.white,
          titleName: '卡包',
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
