import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/toast_utils.dart';
import 'package:orginone/widget/buttons.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/keep_alive_widget.dart';
import 'package:orginone/widget/sliver_tabbar_delegate.dart';
import 'package:orginone/widget/unified.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'logic.dart';
import 'state.dart';
import 'transaction_records/view.dart';

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
      body: ExtendedNestedScrollView(
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
                                    text: state.coin.type,
                                    style: XFonts.size24Black0,
                                  ),
                                  TextSpan(
                                    text: " (${state.coin.type})",
                                    style: TextStyle(
                                        fontSize: 24.sp, color: Colors.grey),
                                  )
                                ])),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  "账户余额: ￥${state.coin.balance}",
                                  style: const TextStyle(
                                      color: XColors.blueTextColor),
                                ),
                              ],
                            ),
                            const Expanded(child: SizedBox()),
                            // QrImage(
                            //   data: state.coin.address??"",
                            //   version: QrVersions.auto,
                            //   size: 120.w,
                            //   errorCorrectionLevel: QrErrorCorrectLevel.H,
                            // ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              state.coin.address ?? "",
                              style: const TextStyle(color: Colors.grey),
                            ),
                            GestureDetector(
                              onTap: () {
                                ToastUtils.showMsg(msg: "已复制到剪切板");
                                Clipboard.setData(ClipboardData(
                                    text: state.coin.address ?? ""));
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
                          Get.toNamed(Routers.transferAccounts,
                              arguments: {"coin": state.coin});
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
                            fontSize: 18.sp, color: XColors.blueTextColor),
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
          ];
        },
        onlyOneScrollInBody: true,
        pinnedHeaderSliverHeightBuilder: () {
          return 0;
        },
        body: Column(
          children: [
            Container(
              color: Colors.white,
              height: 40,
              child: TabBar(
                tabs: tabs.map((e) => Text(e)).toList(),
                controller: state.tabController,
                labelStyle: TextStyle(
                  fontSize: 24.sp,
                ),
                labelColor: XColors.blueTextColor,
                unselectedLabelStyle: TextStyle(
                  fontSize: 24.sp,
                ),
                unselectedLabelColor: Colors.grey.shade400,
                indicatorSize: TabBarIndicatorSize.label,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: state.tabController,
                children: [
                  KeepAliveWidget(child: TransactionRecordsPage(-1)),
                  KeepAliveWidget(child: TransactionRecordsPage(0)),
                  KeepAliveWidget(child: TransactionRecordsPage(1)),
                ],
              ),
            ),
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
