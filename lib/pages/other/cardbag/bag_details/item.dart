import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/model/wallet_model.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/widget/unified.dart';

class Item extends StatelessWidget {
  final Coin coin;

  const Item({
    super.key,
    required this.coin,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(Routers.walletDetails,arguments: {"coin":coin});
      },
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    image,
                    Container(
                      width: 20.w,
                    ),
                    Text(coin.type??"", style:  TextStyle(fontSize: 20.sp)),
                    Container(
                      width: 10.w,
                    ),
                    Text('(${coin.type??""})',
                        style:
                             TextStyle(fontSize: 18.sp, color: Colors.grey)),
                  ],
                ),
                Text(coin.balance??"0"),
              ],
            ),
          )),
    );
  }

  Widget get image {
    return Container(
      width: 50.w,
      height: 50.w,
      decoration: const BoxDecoration(
        color: XColors.themeColor,
        shape: BoxShape.circle,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          (coin.type??"AS").substring(0, 1),
          style: XFonts.size28White,
        ),
      ),
    );
  }
}
