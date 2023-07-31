import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:orginone/widget/common_widget.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'package:orginone/widget/unified.dart';

import 'logic.dart';
import 'state.dart';

class SearchCoinPage
    extends BaseGetView<SearchCoinController, SearchCoinState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: CommonWidget.commonSearchBarWidget(hint: "输入Token名称或合约地址"),
      titleSpacing: 0,
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          var item = DEFAULT_COINS[index];
          return Obx(() {
            bool hasItem = state.wallet.value.coins?.firstWhereOrNull((
                element) => element.type == item['type']) != null;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50.w,
                        height: 50.w,
                        decoration: const BoxDecoration(
                          color: XColors.themeColor,
                          shape: BoxShape.circle,
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            (item['type'] ?? "AS").substring(0, 1),
                            style: XFonts.size28White,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Text(item['type'] ?? "",
                          style: TextStyle(fontSize: 20.sp)),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      if (hasItem) {
                        controller.removeCoin(item);
                      } else {
                        controller.addCoin(item);
                      }
                    },
                    icon: Icon(
                        hasItem ? Ionicons.close_circle_outline : Ionicons
                            .add_circle_outline),
                    color: hasItem ? XColors.black6 : XColors.blueHintTextColor,
                  )
                ],
              ),
            );
          });
        },
        itemCount: DEFAULT_COINS.length,
      ),
    );
  }
}
