import 'package:better_player/better_player.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';

import 'state.dart';

class VideoPlayController extends BaseController<VideoPlayState> {
  final VideoPlayState state = VideoPlayState();

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();
    BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network, state.file.shareLink!);
    state.betterPlayerController = BetterPlayerController(
        BetterPlayerConfiguration(),
        betterPlayerDataSource: betterPlayerDataSource);
  }

  @override
  void onClose() {
    // TODO: implement onClose
    state.betterPlayerController.dispose();
    super.onClose();
  }
}
