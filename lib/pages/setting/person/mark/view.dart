import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/images.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'index.dart';

class MarkPage extends GetView<MarkController> {
  const MarkPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return Center(
      child: Column(children: [
        Image.asset(
          Images.star,
          width: 280.w,
          height: 280.w,
        ),
        const Text.rich(TextSpan(text: '收藏夹空空如也'))
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkController>(
      builder: (_) {
        return GyScaffold(
          backgroundColor: Colors.white,
          titleName: '收藏',
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
