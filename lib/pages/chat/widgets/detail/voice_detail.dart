import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/config/unified.dart';

class VoiceDetail extends BaseDetail {
  VoiceDetail({
    required super.isSelf,
    required super.message,
    super.clipBehavior = Clip.hardEdge,
    super.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    super.bgColor,
    super.constraints,
    super.isReply = false,
    super.chat,
  });

  PlayController get playCtrl => Get.find<PlayController>();

  PlayerStatus get voicePlay => playCtrl.getPlayerStatus(message.id)!;

  @override
  Widget body(BuildContext context) {
    playCtrl.putPlayerStatusIfAbsent(message);
    var seconds = voicePlay.initProgress ~/ 1000;
    seconds = seconds > 60 ? 60 : seconds;
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Obx(() {
          var status = voicePlay.status;
          return status.value == VoiceStatus.stop
              ? const Icon(Icons.play_arrow, color: Colors.black)
              : const Icon(Icons.stop, color: Colors.black);
        }),
        Padding(padding: EdgeInsets.only(left: 5.w)),
        SizedBox(
          height: 12.h,
          width: 60.w + seconds * 2.w,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 16.h,
                  decoration: BoxDecoration(
                    color: XColors.lineLight,
                    borderRadius: BorderRadius.all(
                      Radius.circular(2.w),
                    ),
                  ),
                ),
              ),
              Obx(() {
                var status = voicePlay.status;
                if (status.value == VoiceStatus.stop) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(Icons.circle, size: 12.h),
                  );
                } else {
                  return AlignTransition(
                    alignment: playCtrl.animation!,
                    child: Icon(Icons.circle, size: 12.h),
                  );
                }
              }),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 10.w)),
        Obx(() {
          var progress = voicePlay.progress;
          return Text(
            StringUtil.getMinusShow(progress.value ~/ 1000),
            style: XFonts.size22Black3,
          );
        })
      ],
    );
  }

  @override
  void onTap(BuildContext context) {
    if (voicePlay.bytes.isEmpty) {
      Fluttertoast.showToast(msg: "未获取到语音，播放失败！");
      return;
    }
    if (voicePlay.status.value == VoiceStatus.stop) {
      playCtrl.startPlayVoice(message.id, voicePlay.bytes);
    } else {
      playCtrl.stopPrePlayVoice();
    }
  }
}
