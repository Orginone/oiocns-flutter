import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/other/work/initiate/initiate_business/state.dart';
import 'package:orginone/pages/todo/config.dart';

import 'logic.dart';

class InitiateBusinessPage extends BaseGetPageView<InitiateBusinessController,InitiateBusinessState>{
  @override
  Widget buildView() {
    return Scaffold(
      body:ListView(
        shrinkWrap: true,
        children: _getItems(),
      ),
      floatingActionButton: SizedBox(
        height: 50.w,
        width: 50.w,
        child: GFButton(
          text: "+",
          textStyle: TextStyle(
            color: XColors.white,
            fontSize: 40.sp,
          ),
          onPressed: () {
            controller.createInstance();
          },
          borderShape: const CircleBorder(),
        ),
      ),
    );
  }

  List<Widget> _getItems() {
    List<Widget> children = [];
    getCards().forEach((key, value) {
      children.add(CardChildWidget(key, value));
    });
    return children;
  }

  @override
  InitiateBusinessController getController() {
     return InitiateBusinessController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return "InitiateBusiness";
  }
}