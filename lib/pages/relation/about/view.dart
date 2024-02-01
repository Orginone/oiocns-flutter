import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/names.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/relation/about/logic.dart';
import 'package:orginone/pages/relation/about/state.dart';
import 'package:orginone/utils/system/update_utils.dart';
import 'package:orginone/utils/toast_utils.dart';

class AboutPage extends BaseGetView<AboutController, AboutState> {
  final AboutController versionController = Get.find<AboutController>();

  AboutPage({super.key});

  @override
  Widget buildView() {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(color: Colors.white),
          child: Stack(
            children: [
              CommonWidget.imageBackground(),
              CommonWidget.logoUD(),
              backToHome(),
              Positioned(
                top: 200,
                left: 24,
                right: 24,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      Obx(() => Text(
                            versionController.version.value,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                              fontFamily: 'PingFang SC',
                            ),
                          ))
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 300,
                left: 24,
                right: 24,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routers.originone);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            top: BorderSide(width: 0.5, color: Colors.grey),
                            bottom: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '关于奥集能',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black54)
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(Routers.versionList);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '版本信息',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.chevron_right,
                                color: Color.fromRGBO(0, 0, 0, 0.541))
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        bool update = await AppUpdate.checkUpdate();
                        if (!update) {
                          ToastUtils.showMsg(msg: "已是最新版本");
                        } else {
                          AppUpdate.instance.update();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.5, color: Colors.grey),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '版本更新',
                              style: TextStyle(fontSize: 16),
                            ),
                            Icon(Icons.chevron_right, color: Colors.black54)
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 100,
                left: 24,
                right: 24,
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      'Powered by Orginone',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                    // const SizedBox(
                    //   height: 5,
                    // ),
                    // Text(
                    //   '主办单位：浙江省财政厅',
                    //   style: TextStyle(
                    //     fontSize: 15,
                    //     color: Colors.grey.shade600,
                    //     fontFamily: 'PingFang SC',
                    //   ),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '技术支持：资产云开放协同创新中心',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontFamily: 'PingFang SC',
                      ),
                    )
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget backToHome() {
    return Positioned(
        top: 60,
        left: 20,
        child: GestureDetector(
          onTap: (() {
            controller.backToHome();
          }),
          child: XIcons.arrowBack32,
        ));
  }
}
