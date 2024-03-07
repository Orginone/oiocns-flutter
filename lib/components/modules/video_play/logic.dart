import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

import 'state.dart';

class VideoPlayController extends BaseController<VideoPlayState> {
  @override
  final VideoPlayState state = VideoPlayState();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    await state.videoPlayerController.initialize();
    state.chewieController = ChewieController(
        // aspectRatio: 16 / 9,
        videoPlayerController: state.videoPlayerController,
        autoPlay: true,
        looping: true);
    state.isInitialized.value =
        state.chewieController.videoPlayerController.value.isInitialized;
    state.chewieController.addListener(() {
      if (!state.chewieController.isFullScreen) {
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      }
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    try {
      state.videoPlayerController.dispose();
      state.chewieController.dispose();
    } catch (e) {}
  }
}
