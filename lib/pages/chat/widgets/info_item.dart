import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/target/chat/ichat.dart';
import 'package:orginone/dart/core/target/targetMap.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/logger.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/photo_widget.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除"),
  forward("转发"),
  reply("回复");
  // multipleChoice("多选");

  const DetailFunc(this.label);

  final String label;
}

double defaultWidth = 10.w;

class DetailItemWidget extends GetView<SettingController> {
  final IChat chat;
  final XImMsg msg;

  const DetailItemWidget({Key? key, required this.chat, required this.msg})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  bool get isSelf {
    return msg.fromId == controller.user.id;
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];
    bool isCenter = false;
    if (msg.msgType == MessageType.recall.label) {
      String msgBody = StringUtil.getDetailRecallBody(
        fromId: msg.fromId,
        userId: controller.user.id,
        name: getName(),
      );
      children.add(Text(msgBody, style: XFonts.size18Black9));
      isCenter = true;
    } else {
      children.add(_getAvatar());
      children.add(_getChat(context));
    }
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Row(
        textDirection: isSelf
            ? TextDirection.rtl
            : TextDirection.ltr,
        mainAxisAlignment:
        isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 目标名称
  String getName() {
    return controller.provider.findNameById(msg.fromId);
  }

  /// 获取头像
  Widget _getAvatar() {
    late TargetShare shareInfo;
    if (isSelf) {
      var settingCtrl = Get.find<SettingController>();
      shareInfo = settingCtrl.user.shareInfo;
    } else {
      shareInfo = findTargetShare(msg.fromId);
    }
    return GestureDetector(
        child: TeamAvatar(info: TeamTypeInfo(share: shareInfo),),onLongPress: (){
          EventBusHelper.fire(chat.persons[0]);
    },);
  }

  /// 获取会话
  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (!isSelf) {
      content.add(Container(
        margin: EdgeInsets.only(left: 10.w),
        child: Text(getName(), style: XFonts.size16Black3),
      ));
    }

    Widget body;
    var rtl = TextDirection.rtl;
    var ltr = TextDirection.ltr;
    var textDirection = isSelf ? rtl : ltr;

    if (msg.msgType == MessageType.text.label) {
      body = _detail(
        textDirection: textDirection,
        body: Text(
          msg.showTxt,
          style: XFonts.size22Black3W700,
        ),
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 10.w,
          bottom: 10.w,
        ),
      );
    } else if (msg.msgType == MessageType.image.label) {
      body = _image(textDirection: textDirection, context: context);
    } else if (msg.msgType == MessageType.voice.label) {
      body = _voice(textDirection: textDirection);
    } else if (msg.msgType == MessageType.file.label) {
      body = _file(textDirection: textDirection, context: context);
    } else {
      body = Container();
    }

    String userId = chat.userId;
    List<DetailFunc> func = [
      DetailFunc.forward,
      DetailFunc.reply,
    ];
    if (userId == controller.user.id) {
      func.add(DetailFunc.remove);
    }
    if (isSelf && msg.createTime != null) {
      var parsedCreateTime = DateTime.parse(msg.createTime!);
      var diff = parsedCreateTime.difference(DateTime.now());
      if (diff.inSeconds.abs() < 2 * 60) {
        func.add(DetailFunc.recall);
      }
    }

    Widget _buildLongPressMenu() {
      return ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          height: 50.h,
          width: 50.w * func.length,
          color: const Color(0xFF4C4C4C),
          child: Row(
            children: func
                .map(
                  (item) => GestureDetector(
                    child: Container(
                      width: 40.w,
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      alignment: Alignment.center,
                      child: Text(
                        item.label,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    onTap: (){
                       switch(item){

                         case DetailFunc.recall:
                           chat.recallMessage(msg.id);
                           break;
                         case DetailFunc.remove:
                           chat.deleteMessage(msg.id);
                           break;
                         case DetailFunc.forward:
                           // TODO: Handle this case.
                           break;
                         case DetailFunc.reply:
                           // TODO: Handle this case.
                           break;
                       }
                    },
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    content.add(
      CustomPopupMenu(
        position: PreferredPosition.bottom,
        menuBuilder: _buildLongPressMenu,
        barrierColor: Colors.transparent,
        pressType: PressType.longPress,
        verticalMargin: 0,
        child: body,
      ),
    );

    return Container(
      margin: isSelf ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: content,
      ),
    );
  }

  /// 会话详情
  Widget _detail({
    required TextDirection textDirection,
    required Widget body,
    BoxConstraints? constraints,
    Clip? clipBehavior,
    EdgeInsets? padding,
  }) {
    return Container(
      constraints: constraints ?? BoxConstraints(maxWidth: 350.w),
      padding: padding ?? EdgeInsets.all(defaultWidth),
      margin: textDirection == TextDirection.ltr
          ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
          : EdgeInsets.only(right: defaultWidth),
      decoration: BoxDecoration(
        color: isSelf
            ? XColors.tinyLightBlue
            : Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
        boxShadow: const [
          //阴影效果
          BoxShadow(
            offset: Offset(0, 2), //阴影在X轴和Y轴上的偏移
            color: Colors.black12, //阴影颜色
            blurRadius: 3.0, //阴影程度
            spreadRadius: 0, //阴影扩散的程度 取值可以正数,也可以是负数
          ),
        ],
      ),
      clipBehavior: clipBehavior ?? Clip.none,
      child: body,
    );
  }

  /// 图片详情
  Widget _image({
    required TextDirection textDirection,
    required BuildContext context,
  }) {
    /// 解析参数
    Map<String, dynamic> msgBody = {};
    try {
      msgBody = jsonDecode(msg.showTxt);
    } catch (error) {
      Log.info("参数解析失败，msg.showTxt:${msg.showTxt}");
      return Container();
    }
    String link = msgBody["shareLink"] ?? "";

    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(maxWidth: 200.w);

    Map<String, String> headers = {
      "Authorization": KernelApi
          .getInstance()
          .anystore
          .accessToken,
    };

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(DialogRoute(
            context: context,
            builder: (BuildContext context) {
              return PhotoWidget(
                imageProvider: CachedNetworkImageProvider(link),
              );
            }));
      },
      child: _detail(
        constraints: boxConstraints,
        textDirection: textDirection,
        body: CachedNetworkImage(imageUrl: link, httpHeaders: headers),
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.zero,
      ),
    );
  }

  /// 语音详情
  Widget _voice({required TextDirection textDirection}) {
    // 初始化语音输入

    Map<String, dynamic> msgBody = {};
    try {
      msgBody = jsonDecode(msg.showTxt);
    } catch (error) {
      Log.info("参数解析失败，msg.showTxt:${msg.showTxt}");
      return Container();
    }
    String link = msgBody["shareLink"] ?? "";

    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(maxWidth: 200.w);

    Map<String, String> headers = {
      "Authorization": KernelApi
          .getInstance()
          .anystore
          .accessToken,
    };

    var playCtrl = Get.find<PlayController>();
    playCtrl.putPlayerStatusIfAbsent(msg);
    var voicePlay = playCtrl.getPlayerStatus(msg.id)!;
    var seconds = voicePlay.initProgress ~/ 1000;
    seconds = seconds > 60 ? 60 : seconds;

    return _detail(
      textDirection: textDirection,
      body: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              if (voicePlay.bytes.isEmpty) {
                Fluttertoast.showToast(msg: "未获取到语音，播放失败！");
                return;
              }
              if (voicePlay.status.value == VoiceStatus.stop) {
                playCtrl.startPlayVoice(msg.id, voicePlay.bytes);
              } else {
                playCtrl.stopPrePlayVoice();
              }
            },
            child: Obx(() {
              var status = voicePlay.status;
              return status.value == VoiceStatus.stop
                  ? const Icon(Icons.play_arrow, color: Colors.black)
                  : const Icon(Icons.stop, color: Colors.black);
            }),
          ),
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
      ),
    );
  }

  Widget _file({
    required TextDirection textDirection,
    required BuildContext context,
  }) {
    /// 解析参数
    Map<String, dynamic> msgBody = {};
    try {
      msgBody = jsonDecode(msg.showTxt);
    } catch (error) {
      Log.info("参数解析失败，msg.showTxt:${msg.showTxt}");
      return Container();
    }

    String extension = msgBody["extension"];
    if (imageExtension.contains(extension.toLowerCase())) {
      return _image(textDirection: textDirection, context: context);
    }

    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(maxWidth: 200.w);

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.messageFile,arguments: msgBody);
      },
      child: _detail(
        constraints: boxConstraints,
        textDirection: textDirection,
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.zero,
        body: Container(
          width: 250.w,
          height: 70.h,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        msgBody['name'],
                        style: XFonts.size20Black0,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      getFileSizeString(bytes: msgBody['size']),
                      style: XFonts.size16Black9,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.file_copy),
            ],
          ),
        ),
      ),
    );
  }
}

enum VoiceStatus { stop, playing }

String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}

List<String> imageExtension = [
  '.jpg',
  '.png',
  '.bmp',
  '.tif',
  '.webp',
];

class PlayerStatus {
  final Rx<VoiceStatus> status;
  final int initProgress;
  final RxInt progress;
  final Uint8List bytes;

  const PlayerStatus({
    required this.status,
    required this.initProgress,
    required this.progress,
    required this.bytes,
  });
}

class PlayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PlayController());
  }
}

class PlayController extends GetxController with GetTickerProviderStateMixin {
  // 语音相关
  final Map<String, PlayerStatus> _playStatuses = {};
  FlutterSoundPlayer? _soundPlayer;
  StreamSubscription? _mt;
  AnimationController? _animationController;
  Animation<AlignmentGeometry>? _animation;
  PlayerStatus? _currentVoicePlay;

  get animation => _animation;

  /// 获取一个播放状态
  PlayerStatus? getPlayerStatus(String id) {
    return _playStatuses[id];
  }

  /// 不存在就推入状态
  putPlayerStatusIfAbsent(XImMsg msg) {
    if (!_playStatuses.containsKey(msg.id)) {
      try {
        Map<String, dynamic> data = jsonDecode(msg.showTxt);
        int milliseconds = data["milliseconds"] ?? 0;
        List<dynamic> rowBytes = data["bytes"] ?? [];
        List<int> tempBytes = rowBytes.map((byte) => byte as int).toList();
        _playStatuses[msg.id] = PlayerStatus(
          status: VoiceStatus.stop.obs,
          initProgress: milliseconds,
          progress: milliseconds.obs,
          bytes: Uint8List.fromList(tempBytes),
        );
      } catch (error) {
        _playStatuses[msg.id] = PlayerStatus(
          status: VoiceStatus.stop.obs,
          initProgress: 0,
          progress: 0.obs,
          bytes: Uint8List.fromList([]),
        );
      }
    }
  }

  @override
  onClose() {
    _soundPlayer?.stopPlayer();
    _mt?.cancel();
    _animationController?.dispose();
    _animation = null;
    _playStatuses.clear();
    _currentVoicePlay = null;
    super.onClose();
  }

  /// 开始播放
  startPlayVoice(String id, Uint8List bytes) async {
    await stopPrePlayVoice();

    // 动画效果
    _currentVoicePlay = _playStatuses[id];
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: _currentVoicePlay!.initProgress),
    );
    _animation = Tween<AlignmentGeometry>(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    ).animate(CurvedAnimation(
      parent: _animationController!,
      curve: Curves.linear,
    ));
    _animationController!.forward();

    // 监听进度
    _soundPlayer ??= await FlutterSoundPlayer().openAudioSession();
    _soundPlayer!.setSubscriptionDuration(const Duration(milliseconds: 50));
    _mt = _soundPlayer!.onProgress!.listen((event) {
      _currentVoicePlay!.progress.value = event.position.inMilliseconds;
    });
    _soundPlayer!
        .startPlayer(
      fromDataBuffer: bytes,
      whenFinished: () => stopPrePlayVoice(),
    )
        .catchError((error) => stopPrePlayVoice());

    // 重新开始播放
    _currentVoicePlay!.status.value = VoiceStatus.playing;
  }

  /// 停止播放
  stopPrePlayVoice() async {
    if (_currentVoicePlay != null) {
      // 改状态
      _currentVoicePlay!.status.value = VoiceStatus.stop;
      _currentVoicePlay!.progress.value = _currentVoicePlay!.initProgress;

      // 关闭播放
      await _soundPlayer?.stopPlayer();
      _mt?.cancel();
      _mt = null;
      _soundPlayer = null;

      // 关闭动画
      _animation = null;
      _animationController?.stop();
      _animationController?.dispose();
      _animationController = null;

      // 空引用
      _currentVoicePlay = null;
    }
  }
}
