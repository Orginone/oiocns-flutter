import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_page.dart';

import 'logic.dart';
import 'state.dart';

class Demo3Page extends BaseBreadcrumbNavPage<Demo3Controller,Demo3State>{

  @override
  Widget body() {
    return Center(
      child: MaterialButton(onPressed: () {
      },child: Text("next"),),
    );
  }
}