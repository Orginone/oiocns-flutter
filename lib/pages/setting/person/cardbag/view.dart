import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    return const Center(
      child: Text("CardbagPage"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardbagController>(
      init: CardbagController(),
      id: "cardbag",
      builder: (_) {
        return Scaffold(
          appBar: AppBar(title: const Text("cardbag")),
          body: SafeArea(
            child: _buildView(),
          ),
        );
      },
    );
  }
}
