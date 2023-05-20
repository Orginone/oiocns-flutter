import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/widget/gy_scaffold.dart';
import 'index.dart';

class CardbagPage extends StatefulWidget {
  const CardbagPage({Key? key}) : super(key: key);

  @override
  State<CardbagPage> createState() => _CardbagPageState();
}

class _CardbagPageState extends State<CardbagPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return const _CardbagViewGetX();
  }
}

class _CardbagViewGetX extends GetView<CardbagController> {
  const _CardbagViewGetX({Key? key}) : super(key: key);

  // 主视图
  Widget _buildView() {
    var settingCtrl = Get.find<SettingController>();
    var avatar = settingCtrl.user!.share.avatar;
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        card,
        butn,
        ICard(
          asset: 180.0,
          cnName: '比特币',
          name: 'BTC',
          avatar: avatar,
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardbagController>(
      init: CardbagController(),
      id: "cardbag",
      builder: (_) {
        return GyScaffold(
          titleName: '卡包',
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: _buildView(),
            ),
          ),
        );
      },
    );
  }

  Widget get butn {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // RaisedButton(),
          Container(
              height: 50,
              width: 160,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: const Center(
                child: Text(
                  '创建',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )),
          Container(
              height: 50,
              width: 160,
              decoration: const BoxDecoration(
                color: XColors.themeColor,
                borderRadius: BorderRadius.all(Radius.circular(50.0)),
              ),
              child: const Center(
                child: Text(
                  '添加',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )),
        ],
      ),
    );
  }

  Widget get card {
    var settingCtrl = Get.find<SettingController>();
    var name = settingCtrl.user.metadata.name.substring(0, 1);
    if (settingCtrl.user.share.avatar == null) {
      return Container(
          height: 150,
          decoration: const BoxDecoration(
              color: XColors.designBlue,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 58, 95, 227),
                Color.fromARGB(255, 5, 40, 136),
              ])),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 30, 30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50.0,
                              height: 50.0,
                              decoration: const BoxDecoration(
                                  color: XColors.themeColor,
                                  shape: BoxShape.circle),
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  name,
                                  style: XFonts.size28White,
                                ),
                              ),
                            ),
                            Container(
                              width: 20,
                            ),
                            Text(settingCtrl.user!.share.name,
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
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('账户余额：￥180.00',
                            style:
                                TextStyle(color: Colors.white60, fontSize: 15)),
                        Icon(Icons.add_circle_outline_rounded,
                            color: Colors.white60, size: 30)
                      ]),
                ]),
          ));
    }
    var avatar = settingCtrl.user!.share.avatar;
    var thumbnail = avatar!.thumbnail!.split(",")[1];
    thumbnail = thumbnail.replaceAll('\r', '').replaceAll('\n', '');
    return Container(
        height: 150,
        decoration: const BoxDecoration(
            color: XColors.designBlue,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            gradient: LinearGradient(colors: [
              Color.fromARGB(255, 58, 95, 227),
              Color.fromARGB(255, 5, 40, 136),
            ])),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 50.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                                color: XColors.themeColor,
                                image: DecorationImage(
                                  image: MemoryImage(base64Decode(thumbnail)),
                                  fit: BoxFit.fill,
                                ),
                                shape: BoxShape.circle),
                          ),
                          Container(
                            width: 20,
                          ),
                          Text(settingCtrl.user!.share.name,
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
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
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
  final String? cnName;
  final double? asset;
  final FileItemShare? avatar;
  final VoidCallback? onTap;

  const ICard({
    super.key,
    this.name,
    this.cnName,
    this.asset,
    this.avatar,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 90,
        decoration: const BoxDecoration(
          color: XColors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  image,
                  Container(
                    width: 20,
                  ),
                  Text('$name', style: const TextStyle(fontSize: 18)),
                  Container(
                    width: 20,
                  ),
                  Text('($cnName)',
                      style: const TextStyle(fontSize: 15, color: Colors.grey)),
                ],
              ),
              Text(
                '￥ $asset',
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ));
  }

  Widget get image {
    return Container(
      width: 50.0,
      height: 50.0,
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
