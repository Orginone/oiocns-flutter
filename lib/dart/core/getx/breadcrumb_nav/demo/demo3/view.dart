import 'package:flutter/material.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';

import 'logic.dart';
import 'state.dart';

class Demo3Page extends BaseBreadcrumbNavPage<Demo3Controller, Demo3State> {
  const Demo3Page({super.key});

  @override
  Widget body() {
    return Center(
      child: MaterialButton(
        onPressed: () {},
        child: const Text("next"),
      ),
    );
  }
}
