import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'state.dart';

class WalletDetailsController extends BaseController<WalletDetailsState>
    with GetTickerProviderStateMixin {
  final WalletDetailsState state = WalletDetailsState();

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    state.tabController = TabController(length: tabs.length, vsync: this);
  }

  void collection() {
    showModalBottomSheet<int?>(
        context: context,
        backgroundColor: Colors.grey,
        constraints: BoxConstraints(maxHeight: 600.h, minHeight: 600.h),
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.w),
                topRight: Radius.circular(15.w))),
        builder: (context) {
          return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15.w)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "收款",
                  style: TextStyle(fontSize: 24.sp),
                ),
                SizedBox(
                  height: 50.h,
                ),
                QrImage(
                  data: '12344211',
                  version: QrVersions.auto,
                  size: 300.w,
                  errorCorrectionLevel: QrErrorCorrectLevel.H,
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  "扫描地址以接收付款",
                  style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h,horizontal: 20.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(36.w),
                      border: Border.all(color: Color(0xFF1890FF), width: 1),),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text("2sandman35dcxsd321cs55d5s23ec",style: TextStyle(color: Color(0xFF1890FF)),),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(const ClipboardData(
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
                  ),
                ),
              ],
            ),
          );
        });
  }
}
