import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'index.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key}) : super(key: key);

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _DynamicViewGetX();
  }
}

class _DynamicViewGetX extends GetView<DynamicController> {
  const _DynamicViewGetX({Key? key}) : super(key: key);

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
    return GetBuilder<DynamicController>(
      init: DynamicController(),
      id: "dynamic",
      builder: (_) {
        return GyScaffold(
          backgroundColor: Colors.white,
          titleName: '动态',
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
