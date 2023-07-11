import 'package:better_player/better_player.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

class VideoPlayState extends BaseGetState {
  late FileItemShare file;
  var isInitialized = true.obs;

  late BetterPlayerController betterPlayerController;
  VideoPlayState() {
    file = Get.arguments['file'];
    print(Uri.parse(file.shareLink!));
  }
}
