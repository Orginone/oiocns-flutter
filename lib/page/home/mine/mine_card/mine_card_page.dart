import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/click_item_type1.dart';
import 'package:orginone/component/unified_scaffold.dart';
import 'package:orginone/util/widget_util.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../../component/a_font.dart';
import 'mine_card_controller.dart';

class MineCardPage extends GetView<MineCardController> {
  const MineCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MineCardController>(
        init: MineCardController(),
        builder: (item) => UnifiedScaffold(
              appBarTitle: Text("我的名片", style: AFont.instance.size22Black3),
              appBarCenterTitle: true,
              appBarLeading: WidgetUtil.defaultBackBtn,
              bgColor: const Color.fromRGBO(240, 240, 240, 1),
              body: Container(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  margin: EdgeInsets.fromLTRB(0, 20.h, 0, 0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      //截图层
                      RepaintBoundary(
                          key: controller.globalKey1,
                          child: Column(
                            children: [
                              //名片层
                              Container(
                                height: 195.h,
                                margin:
                                    EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 35.w),
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('images/person-card-bg.png'),
                                )),
                                child: Stack(
                                  children: [
                                    //头像
                                    Positioned(
                                      top: 20.h,
                                      right: 20.w,
                                      child: CircleAvatar(
                                        foregroundImage: const NetworkImage(
                                            'https://www.vcg.com/creative/1382429598'),
                                        backgroundImage: const AssetImage(
                                            'images/person-empty.png'),
                                        onForegroundImageError:
                                            (error, stackTrace) {},
                                        radius: 25.w,
                                      ),
                                    ),
                                    //左侧上信息
                                    Positioned(
                                        top: 20.h,
                                        left: 20.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5.w),
                                                child: Text(
                                                  controller.userInfo.name,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 24),
                                                )),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5.w),
                                                child: Text(
                                                  controller.userInfo.team
                                                          ?.name ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                )),
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5.w),
                                                child: Text(
                                                  controller.userInfo.team
                                                          ?.remark ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                )),
                                          ],
                                        )),
                                    //左侧下信息
                                    Positioned(
                                        bottom: 10.h,
                                        left: 20.w,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5.w),
                                                child: Text(
                                                  controller.userInfo.team
                                                          ?.code ??
                                                      "",
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                )),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              //二维码层
                              Container(
                                margin:
                                    EdgeInsets.fromLTRB(50.w, 0, 50.w, 35.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(3.w),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1.3,
                                              color: const Color.fromRGBO(
                                                  0, 0, 0, 1))),
                                      child: QrImage(
                                        data:
                                            '{"type":"person","data":"13362799531"}',
                                        version: QrVersions.auto,
                                        size: 150.0,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )),
                      //功能层
                      Container(
                        margin: EdgeInsets.fromLTRB(50.w, 0, 50.w, 40.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(255, 235, 221, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: const EdgeInsets.all(0),
                              text: '保存到相册',
                              icon: const Icon(Icons.image,
                                  color: Color.fromRGBO(238, 95, 0, 1),
                                  size: 32),
                              callback: () {
                                // controller.captureImage();
                              },
                            ),
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(239, 251, 254, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: const EdgeInsets.all(0),
                              text: '奥集能分享',
                              icon: const Icon(Icons.electric_bolt,
                                  color: Color.fromRGBO(75, 214, 249, 1),
                                  size: 32),
                            ),
                            ClickItemType1(
                              bgColor: const Color.fromRGBO(238, 255, 238, 1),
                              height: 50.w,
                              width: 50.w,
                              padding: EdgeInsets.all(10.w),
                              text: '微信分享',
                              icon: const Icon(Icons.message,
                                  color: Color.fromRGBO(102, 255, 102, 1),
                                  size: 28),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
            ));
  }
}
