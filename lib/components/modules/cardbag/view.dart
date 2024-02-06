import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/modules/cardbag/index.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/icons.dart';
import 'package:orginone/components/widgets/system/buttons.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';
import 'package:orginone/config/unified.dart';

class CardbagPage extends BaseGetView<CardbagController, CardbagState> {
  const CardbagPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleName: '卡包',
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.w),
        child: _buildView(),
      ),
    );
  }

  // 主视图
  Widget _buildView() {
    return Center(
      child: ListView(
        children: [
          card,
          butn,
          Obx(() {
            return Column(
                children: walletCtrl.wallet.map((element) {
              return ICard(
                asset: 180.0,
                name: element.account,
                onTap: () {
                  Get.toNamed(Routers.bagDetails,
                      arguments: {"wallet": element});
                },
              );
            }).toList());
          }),
        ],
      ),
    );
  }

  Widget get butn {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: outlinedButton(
              "创建",
              onPressed: () {
                RoutePages.jumpCreateBag();
              },
              height: 70.h,
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(36.w))),
                side: MaterialStateProperty.all(
                    const BorderSide(color: XColors.blueTextColor, width: 1)),
              ),
              textStyle:
                  TextStyle(fontSize: 18.sp, color: const Color(0xFF1890FF)),
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          Expanded(
            child: outlinedButton("添加", onPressed: () {
              RoutePages.jumpImportWallet();
            },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(XColors.blueTextColor),
                  side: MaterialStateProperty.all(BorderSide.none),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(36.w))),
                ),
                textStyle: TextStyle(fontSize: 18.sp, color: Colors.white),
                height: 70.h),
          ),
        ],
      ),
    );
  }

  Widget get card {
    var avatar = relationCtrl.user.metadata.avatarThumbnail();
    var defalut = IconsUtils.icons['x']!['defalutAvatar'].toString();

    ImageProvider provider;

    if (avatar != null) {
      provider = MemoryImage(avatar);
    } else {
      provider = AssetImage(defalut);
    }
    return Container(
        margin: EdgeInsets.only(top: 10.h),
        decoration: const BoxDecoration(
            color: XColors.designBlue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            gradient: LinearGradient(colors: [
              Color(0xFf2A55EA),
              Color(0xFF1D40BD),
              Color(0xFF1890FF),
            ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                                color: XColors.themeColor,
                                image: DecorationImage(
                                  image: provider,
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            width: 20,
                          ),
                          Text(relationCtrl.user.share.name,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 15)),
                        ],
                      ),
                      const Icon(
                        Icons.more_horiz_sharp,
                        color: Colors.white60,
                        size: 30,
                      )
                    ]),
                SizedBox(
                  height: 40.h,
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('账户余额：￥180.00',
                          style:
                              TextStyle(color: Colors.white60, fontSize: 15)),
                      Icon(Icons.add_circle_outline_rounded,
                          color: Colors.white60, size: 30)
                    ]),
              ]),
        ));
  }
}

class ICard extends StatelessWidget {
  final String? name;
  final double? asset;
  final VoidCallback? onTap;

  const ICard({
    super.key,
    this.name,
    this.asset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          shadowColor: XColors.blueTextColor,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    image,
                    Container(
                      width: 20.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$name', style: TextStyle(fontSize: 20.sp)),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text('助记词钱包', style: TextStyle(fontSize: 18.sp)),
                      ],
                    ),
                  ],
                ),
                Text(
                  '￥ $asset',
                  style: TextStyle(fontSize: 18.sp),
                )
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
          name!.substring(0, 1),
          style: XFonts.size28White,
        ),
      ),
    );
  }
}
