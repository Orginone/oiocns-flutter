import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'index.dart';
import 'widgets/widgets.dart';

class MarkPage extends GetView<MarkController> {
  const MarkPage({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    return const HelloWidget();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarkController>(
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("mark")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
