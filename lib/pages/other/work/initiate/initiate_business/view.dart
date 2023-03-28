import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/config/color.dart';
import 'package:orginone/dart/core/getx/base_get_page_view.dart';
import 'package:orginone/pages/index/index_page.dart';
import 'package:orginone/pages/other/ware_house/ware_house_management/item.dart';
import 'package:orginone/pages/other/work/initiate/initiate_business/state.dart';
import 'package:orginone/pages/todo/config.dart';
import 'package:orginone/util/common_tree_management.dart';
import 'package:orginone/widget/common_widget.dart';

import 'logic.dart';

class InitiateBusinessPage
    extends BaseGetPageView<InitiateBusinessController, InitiateBusinessState> {
  @override
  Widget buildView() {
    return Scaffold(
      backgroundColor: GYColors.backgroundColor,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
              color: XColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "常用应用",
                    ),
                  ),
                  Container(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.only(top: 10.h, bottom: 20.h),
                      shrinkWrap: true,
                      itemCount: 4,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: XColors.navigatorBgColor,
                                ),
                                width: 64.w,
                                height: 64.w,
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text(
                                "具体业务",
                                style: XFonts.size18Black6,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Obx(() {
                    return CommonWidget.commonBreadcrumbNavWidget(
                        firstTitle: "全部业务",
                        allTitle: state.selectedSpecies
                            .map((element) => element.name)
                            .toList(),
                        onTapFirst: () {
                          controller.clearSpecies();
                        },
                        onTapTitle: (index) {
                          controller.removeSpecies(index);
                        });
                  }),
                  Obx(() {
                    var list = [];
                    if (state.selectedSpecies.isNotEmpty) {
                      list = state.selectedSpecies.last.children;
                    }else{
                      CommonTreeManagement().species?.children.forEach((element) {
                        if(element.name == "事项"){
                          list.addAll(element.children);
                        }
                      });
                    }
                    return Column(
                      children: list.map(
                        (e) {
                          return GbItem(
                            item: e,
                            showPopupMenu: false,
                            next: () {
                              controller.selectSpecies(e);
                            },
                            onTap: () {
                              controller.createInstance(e);
                            },
                          );
                        },
                      ).toList(),
                    );
                  })
                ],
              )),
        ],
      ),
      // floatingActionButton: SizedBox(
      //   height: 50.w,
      //   width: 50.w,
      //   child: GFButton(
      //     text: "+",
      //     textStyle: TextStyle(
      //       color: XColors.white,
      //       fontSize: 40.sp,
      //     ),
      //     onPressed: () {
      //       controller.createInstance();
      //     },
      //     borderShape: const CircleBorder(),
      //   ),
      // ),
    );
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
