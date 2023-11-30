import 'dart:async';
import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/utils/bus/event_bus_helper.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/components/widgets/target_text.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/components/widgets/team_avatar.dart';

import 'chat_box.dart';
import 'detail/file_detail.dart';
import 'detail/image_detail.dart';
import 'detail/text_detail.dart';
import 'detail/voice_detail.dart';

enum Direction { leftStart, rightStart }

enum DetailFunc {
  recall("撤回"),
  remove("删除"),
  forward("转发"),
  copy("复制"),
  reply("回复");
  // multipleChoice("多选");

  const DetailFunc(this.label);

  final String label;
}

double defaultWidth = 10.w;

class DetailItemWidget extends GetView<IndexController> {
  final ISession chat;
  final IMessage msg;
  late CustomPopupMenuController popMenuController;
  DetailItemWidget({
    Key? key,
    required this.chat,
    required this.msg,
  }) : super(key: key) {
    popMenuController = CustomPopupMenuController();
  }

  MessageChatController get chatController => Get.find();

  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  bool get isSelf {
    return msg.metadata.fromId == controller.user.id;
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    late String id;
    ShareIcon? shareIcon;
    XTarget? target;
    if (isSelf) {
      id = settingCtrl.user.id;
      shareIcon = settingCtrl.user.share;
    } else {
      id = msg.metadata.fromId;
      if (chat.share.typeName == TargetType.person.label) {
        shareIcon = chat.share;
      } else if (chat.members.isNotEmpty) {
        target = chat.members.firstWhereOrNull((element) => element.id == id);
        shareIcon = target?.shareIcon() ??
            ShareIcon(name: '请稍候', typeName: TargetType.person.label);
      }
    }

    List<Widget> children = [];
    bool isCenter = false;
    if (msg.msgType == MessageType.recall.label) {
      Widget child;
      if (isSelf) {
        List<InlineSpan> recallMsgs = [
          TextSpan(text: "您撤回了一条消息", style: XFonts.size18Black9)
        ];

        String msgStr = msg.msgSource;
        if (!StringUtil.isJson(msgStr)) {
          recallMsgs.add(TextSpan(
              text: " 重新编辑",
              style: TextStyle(color: Colors.blueAccent, fontSize: 20.sp),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  ChatBoxController controller = Get.find<ChatBoxController>();

                  controller.inputController.text = msgStr;
                  controller.eventFire(context, InputEvent.clickInput, chat);
                }));
        }
        child = Text.rich(TextSpan(children: recallMsgs));
      } else {
        child = Text.rich(TextSpan(children: [
          WidgetSpan(
              child: TargetText(
                style: XFonts.size18Black9,
                userId: msg.metadata.fromId,
                shareIcon: shareIcon,
              ),
              alignment: PlaceholderAlignment.middle),
          TextSpan(text: "撤回了一条消息", style: XFonts.size18Black9),
        ]));
      }
      children.add(child);
      isCenter = true;
    } else if (msg.msgType == MessageType.notify.label) {
      Widget child =
          Text.rich(TextSpan(children: [TextSpan(text: msg.msgBody)]));
      children.add(child);
      isCenter = true;
    } else {
      children.add(_getAvatar(id, shareIcon));
      children.add(_getChat(target?.name ?? ""));
    }
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
      child: Row(
        textDirection: isSelf ? TextDirection.rtl : TextDirection.ltr,
        mainAxisAlignment:
            isCenter ? MainAxisAlignment.center : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// 获取头像
  Widget _getAvatar(String id, [ShareIcon? shareIcon]) {
    return GestureDetector(
      child: TeamAvatar(
        size: 55.w,
        info: TeamTypeInfo(share: shareIcon, userId: id),
        circular: true,
      ),
      onLongPress: () {
        if (chat.share.typeName != TargetType.person.label) {
          var target = chat.members
              .firstWhere((element) => element.id == msg.metadata.fromId);
          EventBusHelper.fire(target);
        }
      },
    );
  }

  /// 获取会话
  Widget _getChat(String name) {
    List<Widget> content = <Widget>[];

    if (!isSelf && chat.share.typeName != TargetType.person.label) {
      content.add(Container(
        margin: EdgeInsets.only(left: 10.w),
        child: Text(name, style: XFonts.size18Black3),
      ));
    }

    var rtl = TextDirection.rtl;
    var ltr = TextDirection.ltr;
    var textDirection = isSelf ? rtl : ltr;

    Widget body = _chatBody(Get.context!, textDirection);

    body = Column(
      crossAxisAlignment:
          isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        body,
        msg.cite == null
            ? const SizedBox()
            : _replyBody(Get.context!, textDirection),
      ],
    );

    String userId = chat.userId;
    List<DetailFunc> func = [
      DetailFunc.forward,
      DetailFunc.reply,
    ];
    if (msg.msgType == MessageType.text.label) {
      func.add(DetailFunc.copy);
    }
    if (userId == controller.user.id) {
      func.add(DetailFunc.remove);
    }
    if (isSelf) {
      var parsedCreateTime = DateTime.parse(msg.createTime);
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                    onTap: () {
                      popMenuController.hideMenu();
                      switch (item) {
                        case DetailFunc.recall:
                          chat.recallMessage(msg.id);
                          break;
                        case DetailFunc.remove:
                          chat.deleteMessage(msg.id);
                          break;
                        case DetailFunc.forward:
                          chatController.forward(msg.msgType, msg);
                          break;
                        case DetailFunc.reply:
                          ChatBoxController controller =
                              Get.find<ChatBoxController>();
                          controller.reply.value = msg;
                          break;
                        case DetailFunc.copy:
                          ////TODO:没有此方法
                          Clipboard.setData(ClipboardData(
                              text: StringUtil.msgConversion(msg, '')));
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
        controller: popMenuController,
        position: PreferredPosition.bottom,
        menuBuilder: _buildLongPressMenu,
        barrierColor: Colors.transparent,
        pressType: PressType.longPress,
        verticalMargin: 0,
        child: body,
      ),
    );

    bool isRead = false;
    List<XTarget> unreadMember = [];
    List<XTarget> readMember = [];
    Widget read = const SizedBox();

    try {
      IMessageLabel? tag;
      if (chat.share.typeName == TargetType.person.label) {
        tag = msg.labels.firstWhere(
            (element) => element.userId == chat.chatdata.value.fullId);
        isRead = tag != null;
      } else {
        for (var member in chat.members) {
          if (member.id != controller.user.id) {
            if (msg.labels
                .where((element) => element.userId == member.id)
                .isEmpty) {
              unreadMember.add(member);
            } else {
              readMember.add(member);
            }
          }
        }
        isRead = readMember.length == (chat.members.length - 1);
      }
    } catch (e) {}

    if (isSelf) {
      if (chat.share.typeName == TargetType.person.label) {
        read = Container(
          margin: EdgeInsets.only(right: 10.w),
          child: Text(
            isRead ? "已读" : "未读",
            style: TextStyle(
                color: isRead ? XColors.black9 : XColors.selectedColor,
                fontSize: 18.sp),
          ),
        );
      } else {
        read = GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Text(
              isRead
                  ? "全部已读"
                  : unreadMember.length == chat.members.length - 1
                      ? "全部未读"
                      : "${unreadMember.length}人未读",
              style: TextStyle(
                  color: isRead ? XColors.black9 : XColors.selectedColor,
                  fontSize: 16.sp),
            ),
          ),
          onTap: () {
            chatController.showReadMessage(
                readMember, unreadMember, msg.labels);
          },
        );
      }
    }

    if (!chat.isBelongPerson) {
      content.add(read);
    }

    return Container(
      margin: isSelf ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
      child: Column(
        crossAxisAlignment:
            !isSelf ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        children: content,
      ),
    );
  }

  Widget _chatBody(BuildContext context, TextDirection textDirection) {
    Widget body;

    if (msg.msgType == MessageType.text.label) {
      body = TextDetail(
        isSelf: isSelf,
        message: msg,
      );
    } else if (msg.msgType == MessageType.image.label) {
      body = ImageDetail(
        isSelf: isSelf,
        message: msg,
      );
    } else if (msg.msgType == MessageType.voice.label) {
      body = VoiceDetail(
        isSelf: isSelf,
        message: msg,
      );
    } else if (msg.msgType == MessageType.file.label) {
      body = FileDetail(
        isSelf: isSelf,
        message: msg,
      );
    }
    // TODO 待实现上传中
    /*else if (msg.msgType == MessageType.uploading.label) {
      body = UploadingDetail(
        isSelf: isSelf,
        message: msg.metadata,
      );
    }*/
    else {
      body = Container();
    }

    return body;
  }

  Widget _replyBody(BuildContext context, TextDirection textDirection) {
    Widget? body;
    if (msg.cite?.msgType == MessageType.text.label) {
      body = TextDetail(
        isSelf: isSelf,
        message: msg.cite!,
        bgColor: Colors.black.withOpacity(0.1),
        isReply: true,
        chat: chat,
      );
    } else if (msg.cite?.msgType == MessageType.image.label) {
      body = ImageDetail(
        message: msg.cite!,
        bgColor: Colors.black.withOpacity(0.1),
        isSelf: isSelf,
        chat: chat,
      );
    } else if (msg.cite?.msgType == MessageType.voice.label) {
      body = VoiceDetail(
        message: msg.cite!,
        bgColor: Colors.black.withOpacity(0.1),
        isSelf: isSelf,
        chat: chat,
      );
    } else if (msg.cite?.msgType == MessageType.file.label) {
      body = FileDetail(
        message: msg.cite!,
        bgColor: Colors.black.withOpacity(0.1),
        isSelf: isSelf,
        chat: chat,
      );
    }
    if (body != null) {
      return Container(
        margin: EdgeInsets.only(top: 5.h),
        child: body,
      );
    }

    return const SizedBox();
  }
}

class PreViewUrl extends StatefulWidget {
  final String url;

  const PreViewUrl({Key? key, required this.url}) : super(key: key);

  @override
  State<PreViewUrl> createState() => _PreViewUrlState();
}

class _PreViewUrlState extends State<PreViewUrl> {
  late String url;
  dynamic previewData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    url = widget.url;
  }

  @override
  void didUpdateWidget(covariant PreViewUrl oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.url != oldWidget.url) {
      url = widget.url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LinkPreview(
      onPreviewDataFetched: (data) {
        setState(() {
          previewData = data;
        });
      },
      padding: EdgeInsets.zero,
      previewData: previewData,
      enableAnimation: true,
      openOnPreviewImageTap: true,
      openOnPreviewTitleTap: true,
      text: url,
      width: 400.w,
      onLinkPressed: (url) {
        Get.toNamed(Routers.webView, arguments: {'url': url});
      },
    );
  }
}

enum VoiceStatus { stop, playing }

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
  putPlayerStatusIfAbsent(IMessage msg, MsgBodyModel msgBody) {
    if (!_playStatuses.containsKey(msg.id)) {
      try {
        int milliseconds = msgBody.milliseconds ?? 0;
        List<dynamic> rowBytes = msgBody.bytes ?? [];
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

String getFileSizeString({required int bytes, int decimals = 0}) {
  try {
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  } catch (e) {
    return '0B';
  }
}
