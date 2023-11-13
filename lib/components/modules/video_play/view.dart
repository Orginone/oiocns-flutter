import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class VideoPlayPage extends BaseGetView<VideoPlayController, VideoPlayState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.file.name ?? "",
      appBarColor: Colors.black,
      titleStyle: const TextStyle(color: Colors.white),
      backColor: Colors.white,
      backgroundColor: Colors.black,
      body: Obx(() {
        if (!state.isInitialized.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Chewie(controller: state.chewieController);
      }),
    );
  }
}
