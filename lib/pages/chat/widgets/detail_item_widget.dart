import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/photo_widget.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/index.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/util/string_util.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除");

  const DetailFunc(this.label);

  final String label;
}

double defaultWidth = 10.w;

class DetailItemWidget extends GetView<ChatController> {
  final XImMsg msg;

  const DetailItemWidget({Key? key, required this.msg}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];
    bool isCenter = false;
    if (msg.msgType == MessageType.recall.label) {
      String msgBody = StringUtil.getDetailRecallBody(
        fromId: msg.fromId,
        userId: controller.userId,
        name: controller.getName(msg.fromId),
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
        textDirection: msg.fromId == controller.userId
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
    return controller.getName(msg.fromId);
  }

  /// 获取头像
  Widget _getAvatar() {
    return TextAvatar(
      avatarName: getName().substring(0, 2),
      textStyle: XFonts.size16WhiteW700,
      radius: 9999,
    );
  }

  /// 获取会话
  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (msg.fromId != controller.userId) {
      content.add(Container(
        margin: EdgeInsets.only(left: 10.w),
        child: Text(getName(), style: XFonts.size16Black3),
      ));
    }

    Widget body;
    var mySend = msg.fromId == controller.userId;
    var rtl = TextDirection.rtl;
    var ltr = TextDirection.ltr;
    var textDirection = mySend ? rtl : ltr;

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
    } else {
      body = Container();
    }

    // 添加长按手势
    double x = 0, y = 0;
    var currentChat = controller.chat!;
    String spaceId = currentChat.spaceId;
    var chat = GestureDetector(
      onPanDown: (position) {
        x = position.globalPosition.dx;
        y = position.globalPosition.dy;
      },
      onLongPress: () async {
        List<DetailFunc> items = [];
        if (msg.fromId == controller.userId && msg.createTime != null) {
          var parsedCreateTime = DateTime.parse(msg.createTime!);
          var diff = parsedCreateTime.difference(DateTime.now());
          if (diff.inSeconds.abs() < 2 * 60) {
            items.add(DetailFunc.recall);
          }
        }
        if (spaceId == controller.userId) {
          items.add(DetailFunc.remove);
        }
        if (items.isEmpty) {
          return;
        }
        var top = y - 50;
        var right = MediaQuery.of(context).size.width - x;
        final result = await showMenu<DetailFunc>(
          context: context,
          position: RelativeRect.fromLTRB(x, top, right, 0),
          items: items.map((item) {
            return PopupMenuItem(
              value: item,
              child: Text(item.label),
            );
          }).toList(),
        );
        if (result != null) {
          switch (result) {
            case DetailFunc.recall:
              break;
            case DetailFunc.remove:
              controller.chat?.deleteMessage(msg.id);
              break;
          }
        }
      },
      child: body,
    );
    content.add(chat);

    return Container(
      margin: msg.fromId == controller.userId
          ? EdgeInsets.only(right: 2.w)
          : EdgeInsets.only(left: 2.w),
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
        color: msg.fromId == controller.userId
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
    Map<String, dynamic> msgBody = jsonDecode(msg.showTxt);
    String link = msgBody["shareLink"] ?? "";

    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(maxWidth: 200.w);

    Map<String, String> headers = {
      "Authorization": KernelApi.getInstance().anystore.accessToken,
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
}

enum VoiceStatus { stop, playing }

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
    _soundPlayer ??= await FlutterSoundPlayer().openPlayer();
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
