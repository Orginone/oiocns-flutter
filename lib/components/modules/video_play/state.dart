import 'package:chewie/chewie.dart';
import 'package:get/get.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:video_player/video_player.dart';

class VideoPlayState extends BaseGetState {
  late FileItemShare file;
  late ChewieController chewieController;
  late VideoPlayerController videoPlayerController;

  var isInitialized = false.obs;

  VideoPlayState() {
    file = Get.arguments['file'];
    var link = Uri.parse('${Constant.host}${file.shareLink!}');
    videoPlayerController = VideoPlayerController.networkUrl(link,
        httpHeaders: {"content-type": "video/mp4"});
  }
}
