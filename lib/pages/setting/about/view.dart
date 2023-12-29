import 'package:flutter/material.dart';
import 'package:orginone/components/widgets/common_widget.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/setting/about/logic.dart';
import 'package:orginone/pages/setting/about/state.dart';

class AboutPage extends BaseGetView<AboutController, AboutState> {
  const AboutPage({super.key});

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
              CommonWidget.logo(),
              backToHome(),
              Positioned(
                top: 200,
                left: 24,
                right: 24,
                child: Center(
                    child: Column(
                  children: [
                    Text(
                      '关于奥集能',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey.shade800,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'v1.0.0',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade600,
                        fontFamily: 'PingFang SC',
                      ),
                    )
                  ],
                )),
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
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '主办单位：浙江省财政厅',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        fontFamily: 'PingFang SC',
                      ),
                    ),
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
