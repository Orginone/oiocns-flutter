import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/buttons.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/sliver_tabbar_delegate.dart';
import 'package:orginone/widget/unified.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';
import 'state.dart';

class WalletDetailsPage
    extends BaseGetView<WalletDetailsController, WalletDetailsState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: "钱包详情",
      actions: [
        IconButton(
          icon: const Icon(Ionicons.scan_outline),
          onPressed: () {},
          color: Colors.black,
        ),
      ],
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
                child: Card(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            image(),
                            SizedBox(
                              width: 15.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text.rich(TextSpan(children: [
                                  TextSpan(
                                    text: "BTC",
                                    style: XFonts.size24Black0,
                                  ),
                                  TextSpan(
                                    text: " (比特币)",
                                    style: TextStyle(
                                        fontSize: 24.sp, color: Colors.grey),
                                  )
                                ])),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "账户余额: ￥125.30",
                                  style: TextStyle(color: Color(0xFF1890FF)),
                                ),
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            QrImage(
                              data: '12344211',
                              version: QrVersions.auto,
                              size: 120.w,
                              errorCorrectionLevel: QrErrorCorrectLevel.H,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "2sdfdanacoc35dcxsd321cs55d5s23ec",
                              style: TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(
                                    text: "2sdfdanacoc35dcxsd321cs55d5s23ec"));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(0xFF1890FF),
                                    borderRadius: BorderRadius.circular(15.w)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.w, vertical: 4.h),
                                child: Text(
                                  "复制",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14.sp),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: outlinedButton(
                        "转账",
                        onPressed: () {
                          Get.toNamed(Routers.transferAccounts);
                        },
                        height: 70.h,
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(36.w))),
                          side: MaterialStateProperty.all(const BorderSide(
                              color: Color(0xFF1890FF), width: 1)),
                        ),
                        textStyle: TextStyle(
                            fontSize: 18.sp, color: const Color(0xFF1890FF)),
                      ),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      child: outlinedButton("收款", onPressed: () {
                        controller.collection();
                      },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                const Color(0xFF1890FF)),
                            side: MaterialStateProperty.all(BorderSide.none),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36.w))),
                          ),
                          textStyle:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                          height: 70.h),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CommonWidget.commonHeadInfoWidget("交易记录",
                  color: Colors.white),
            ),
            SliverPersistentHeader(
              delegate: SliverTabBarDelegate(
                tabBar: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Colors.grey.shade200, width: 0.5))),
                  child: TabBar(
                    tabs: tabs.map((e) => Text(e)).toList(),
                    controller: state.tabController,
                    labelStyle: TextStyle(
                      fontSize: 24.sp,
                    ),
                    labelColor: const Color(0xFF1890FF),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 24.sp,
                    ),
                    unselectedLabelColor: Colors.grey.shade400,
                    indicatorSize: TabBarIndicatorSize.label,
                  ),
                ),
              ),
              pinned: true,
              floating: true,
            ),
          ];
        },
        body: TabBarView(
          controller: state.tabController,
          children: const [
            SizedBox(),
            SizedBox(),
            SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget image() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: const BoxDecoration(
        color: XColors.themeColor,
        shape: BoxShape.circle,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "B",
          style: XFonts.size28White,
        ),
      ),
    );
  }
}
