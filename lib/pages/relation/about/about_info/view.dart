import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:orginone/components/widgets/system/gy_scaffold.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/pages/relation/about/about_info/logic.dart';
import 'package:orginone/pages/relation/about/about_info/state.dart';
import 'package:orginone/utils/load_image.dart';

class VersionInfoPage
    extends BaseGetView<VersionInfoController, VersionInfoState> {
  const VersionInfoPage({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
        titleName: '关于奥集能',
        backgroundColor: Colors.white,
        body: Obx(() {
          if (state.mk.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: XImage.localImage(
                        fit: BoxFit.contain,
                        "assets/markdown/orginone-logo-tou.png",
                        height: 60),
                  ),
                ),
                Expanded(
                    child: Markdown(
                  imageBuilder: (uri, title, alt) =>
                      Image(image: AssetImage(uri.toString())),
                  controller: ScrollController(),
                  selectable: false,
                  data: state.mk.value,
                )),
              ],
            );
          } else {
            return Container();
          }
        }));
  }
}
