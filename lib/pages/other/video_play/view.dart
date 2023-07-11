import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:orginone/widget/gy_scaffold.dart';

import 'logic.dart';
import 'state.dart';

class VideoPlayPage extends BaseGetView<VideoPlayController, VideoPlayState> {
  @override
  Widget buildView() {
    return GyScaffold(
      titleName: state.file.name??"",
      appBarColor: Colors.black,
      titleStyle: const TextStyle(color: Colors.white),
      backColor: Colors.white,
      backgroundColor: Colors.black,
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: BetterPlayer(
            controller: state.betterPlayerController,
          ),
        ),
      ),
    );
  }
}
