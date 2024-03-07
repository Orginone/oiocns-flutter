import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/common/loading/load_state_widget.dart';
import 'package:orginone/dart/base/model.dart';

class MarkDownPreview extends OrginoneStatelessWidget<FileItemShare> {
  MarkDownPreview({super.key, super.data});

  @override
  Widget buildWidget(BuildContext context, FileItemShare data) {
    return FutureBuilder<String>(
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.hasData) {
          return Container(
            margin: const EdgeInsets.only(top: 1),
            color: Colors.white,
            child: Markdown(
              imageBuilder: (uri, title, alt) =>
                  Image(image: AssetImage(uri.toString())),
              controller: ScrollController(),
              selectable: false,
              data: snapshot.data!,
            ),
          );
        }
        return LoadStateWidget(
          isSuccess: snapshot.hasData,
          isLoading: !snapshot.hasData,
          child: Container(),
        );
      },
      future: loadMarkDownFile(data),
    );

    // GyScaffold(
    //     titleName: '关于奥集能',
    //     backgroundColor: Colors.white,
    //     body: Obx(() {
    //       if (state.mk.isNotEmpty) {
    //         return Column(
    //           children: [
    //             Expanded(
    //               flex: 0,
    //               child: Padding(
    //                 padding: const EdgeInsets.only(bottom: 10),
    //                 child: XImage.localImage(
    //                     fit: BoxFit.contain,
    //                     "assets/markdown/orginone-logo-tou.png",
    //                     height: 60),
    //               ),
    //             ),
    //             Expanded(
    //                 child: Markdown(
    //               imageBuilder: (uri, title, alt) =>
    //                   Image(image: AssetImage(uri.toString())),
    //               controller: ScrollController(),
    //               selectable: false,
    //               data: state.mk.value,
    //             )),
    //           ],
    //         );
    //       } else {
    //         return Container();
    //       }
    //     }));
  }

  Future<String>? loadMarkDownFile(FileItemShare data) async {
    if (null != data.shareLink && data.shareLink!.indexOf("assets") == 0) {
      return await rootBundle.loadString(data.shareLink!);
    }
    return Future<String>.value(null);
  }
}
