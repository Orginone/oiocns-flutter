import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/home/index/HorizontalScrollMenu/QuickEntry.dart';
import 'package:orginone/pages/index/state.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

import 'application_widget.dart';
import 'logic.dart';

class IndexPage extends BaseGetPageView<IndexController,IndexState>{
  @override
  Widget buildView() {
    return RefreshIndicator(
      onRefresh: () async{
        await controller.loadApps(true);
      },
      child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            ImageWidget(state.imageList.first),
            Container(
                decoration: BoxDecoration(
                    color: XColors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  height: 12.h,
                )),
            Container(
              color: XColors.white,
              child: SizedBox(
                height: 12.h,
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: XColors.white,
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.fromLTRB(11.0, 0, 0, 0),
                alignment: Alignment.topLeft,
                child: Text(
                  "常用",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
                )),
            Container(
              color: XColors.white,
              child: SizedBox(
                height: 12.h,
              ),
            ),
            const MyHorizontalMenu(),
            Container(
                decoration: BoxDecoration(
                    color: XColors.white, borderRadius: BorderRadius.circular(10)),
                child: SizedBox(
                  height: 12.h,
                )),
            Container(
              color: XColors.white,
              padding: EdgeInsets.only(left: 12.w, right: 12.w),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Obx(() {
                    return ApplicationWidget('应用', settingCtrl.provider.myApps.value);
                  }),
                ],
              ),
            ),
          ]),
    );
  }

  @override
  IndexController getController() {
   return IndexController();
  }

  @override
  String tag() {
    // TODO: implement tag
    return 'index';
  }
}