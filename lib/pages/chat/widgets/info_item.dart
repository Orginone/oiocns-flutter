import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/api/kernelapi.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/chat/message/message.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/images.dart';
import 'package:orginone/pages/chat/message_chat.dart';
import 'package:orginone/pages/chat/text_replace_utils.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/logger.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/widget/widgets/photo_widget.dart';
import 'package:orginone/widget/widgets/team_avatar.dart';

import 'chat_box.dart';

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

class DetailItemWidget extends GetView<SettingController> {
  final IMsgChat chat;
  final IMessage msg;

  DetailItemWidget({
    Key? key,
    required this.chat,
    required this.msg,
  }) : super(key: key);

  CustomPopupMenuController popCtrl = CustomPopupMenuController();

  MessageChatController get chatController => Get.find();
  @override
  Widget build(BuildContext context) {
    return _messageDetail(context);
  }

  bool get isSelf {
    return msg.metadata.fromId == controller.user.metadata.id;
  }

  /// 消息详情
  Widget _messageDetail(BuildContext context) {
    List<Widget> children = [];
    bool isCenter = false;
    if (msg.msgType == MessageType.recall.label) {
      Widget child;
      if (msg.metadata.fromId == controller.user.metadata.id) {
        child = Text("您撤回了一条消息", style: XFonts.size18Black9);
      } else {
        child = Text.rich(TextSpan(children: [
          WidgetSpan(
              child: TargetText(
            style: XFonts.size18Black9,
            userId: msg.metadata.fromId,
          ),alignment: PlaceholderAlignment.middle),
          TextSpan(text: "撤回了一条消息", style: XFonts.size18Black9),
        ]));
      }
      children.add(child);
      isCenter = true;
    } else {
      children.add(_getAvatar());
      children.add(_getChat(context));
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
  Widget _getAvatar() {
    late String id;
    if (isSelf) {
      var settingCtrl = Get.find<SettingController>();
      id = settingCtrl.user.metadata.id;
    } else {
      id = msg.metadata.fromId;
    }
    return GestureDetector(
      child: TeamAvatar(
        size: 55.w,
        info: TeamTypeInfo(userId: id),
        decoration: const BoxDecoration(
          color: XColors.themeColor,
          shape: BoxShape.circle,
        ),
      ),
      onLongPress: () {
         if(chat.share.typeName!=TargetType.person.label){
           var target = chat.members.firstWhere((element) => element.id == msg.metadata.fromId);
           EventBusHelper.fire(target);
         }
      },
    );
  }

  /// 获取会话
  Widget _getChat(BuildContext context) {
    List<Widget> content = <Widget>[];

    if (!isSelf && chat.share.typeName != TargetType.person.label) {
      content.add(Container(
        margin: EdgeInsets.only(left: 10.w),
        child: TargetText(userId: msg.metadata.fromId, style: XFonts.size16Black3),
      ));
    }

    Widget body;
    var rtl = TextDirection.rtl;
    var ltr = TextDirection.ltr;
    var textDirection = isSelf ? rtl : ltr;

    if (msg.msgType == MessageType.text.label) {
      String? reply = TextUtils.isReplyMsg(msg.metadata.showTxt);
      body = Column(
        crossAxisAlignment:
            isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          _text(textDirection: textDirection),
          reply == null
              ? const SizedBox()
              : _detail(
                  textDirection: textDirection,
                  body: Text(
                    reply,
                    style: XFonts.size18Black0,
                  ),
                  bgColor: Colors.black.withOpacity(0.1)),
        ],
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
    if(msg.msgType == MessageType.text.label){
      func.add(DetailFunc.copy);
    }
    if (userId == controller.user.metadata.id) {
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
                      switch (item) {
                        case DetailFunc.recall:
                          chat.recallMessage(msg.id);
                          break;
                        case DetailFunc.remove:
                          chat.deleteMessage(msg.id);
                          break;
                        case DetailFunc.forward:
                          chatController.forward(msg.msgType,msg.metadata.showTxt);
                          break;
                        case DetailFunc.reply:
                          ChatBoxController controller = Get.find<ChatBoxController>();
                          controller.replyText.value = msg.metadata.showTxt;
                          break;
                        case DetailFunc.copy:
                           Clipboard.setData(ClipboardData(text: TextUtils.isReplyMsg(msg.metadata.showTxt)));
                          break;
                      }
                      popCtrl.hideMenu();
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
        controller: popCtrl,
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
    Widget read = SizedBox();

    try {
      IMessageLabel? tag;
      if (chat.share.typeName == TargetType.person.label) {
        tag = msg.labels.firstWhere((element) => element.userId == chat.chatId);
        isRead = tag != null;
      } else {
        for (var member in chat.members) {
          if (member.id != controller.user.metadata.id) {
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
                fontSize: 16.sp),
          ),
        );
      } else {
        read = GestureDetector(
          child: Container(
            margin: EdgeInsets.only(right: 10.w),
            child: Text(
              isRead ? "全部已读" : "${unreadMember.length}人未读",
              style: TextStyle(
                  color: isRead ? XColors.black9 : XColors.selectedColor,
                  fontSize: 16.sp),
            ),
          ),
          onTap: (){
            chatController.showReadMessage(readMember,unreadMember);
          },
        );
      }
    }

    content.add(read);

    return Container(
      margin: isSelf ? EdgeInsets.only(right: 2.w) : EdgeInsets.only(left: 2.w),
      child: Column(
        crossAxisAlignment:
            !isSelf ? CrossAxisAlignment.start : CrossAxisAlignment.end,
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
    Color? bgColor,
  }) {

    Color color = bgColor??(isSelf ? XColors.tinyLightBlue : Colors.white);
    
    return Container(
      constraints: constraints ?? BoxConstraints(maxWidth: 350.w
      ),
      padding: padding ?? EdgeInsets.symmetric(horizontal: 15.w,vertical: 20.h),
      margin: textDirection == TextDirection.ltr
          ? EdgeInsets.only(left: defaultWidth, top: defaultWidth / 2)
          : EdgeInsets.only(right: defaultWidth),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(Radius.circular(defaultWidth)),
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
      msgBody = jsonDecode(msg.metadata.showTxt);
    } catch (error) {
      Log.info("参数解析失败，msg.showTxt:${msg.metadata.showTxt}");
      return Container();
    }
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
    playCtrl.putPlayerStatusIfAbsent(msg.metadata);
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
      msgBody = jsonDecode(msg.metadata.showTxt);
    } catch (error) {
      Log.info("参数解析失败，msg.showTxt:${msg.metadata.showTxt}");
      return Container();
    }

    String extension = msgBody["extension"];
    if (imageExtension.contains(extension.toLowerCase())) {
      return _image(textDirection: textDirection, context: context);
    }

    /// 限制大小
    BoxConstraints boxConstraints = BoxConstraints(minWidth: 200.w,minHeight: 70.h,maxWidth: 250.w,maxHeight: 100.h);

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routers.messageFile, arguments: msgBody);
      },
      child: _detail(
        textDirection: textDirection,
        clipBehavior: Clip.hardEdge,
        padding: EdgeInsets.zero,
        body: Container(
          constraints: boxConstraints,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                        maxLines: 2,
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
              ImageWidget(Images.iconFile,width: 40.w,height: 40.w),
            ],
          ),
        ),
      ),
    );
  }

  Widget _text({required TextDirection textDirection}) {
    List<InlineSpan> _contentList = [];

    RegExp exp = RegExp(
        r'((http|ftp|https):\/\/)?([\w_-]+(?:(?:\.[\w_-]+)+))([\w.,@?^=%&:/~+#-]*[\w@?^=%&/~+#-])?');

    String text = TextUtils.textReplace(msg.metadata.showTxt);
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    if (matches.isNotEmpty) {
      int index = 0;
      for (var match in matches) {
        String url = text.substring(match.start, match.end);
        if (match.start == index) {
          index = match.end;
        }
        if (index < match.start) {
          String a = text.substring(index + 1, match.start);
          index = match.end;
          _contentList.add(
            TextSpan(text: a),
          );
        }
        if (exp.hasMatch(url)) {
          _contentList.add(TextSpan(
              text: url,
              style: TextStyle(color: Colors.blue),
              recognizer: new TapGestureRecognizer()
                ..onTap = () {
                  Get.toNamed(Routers.webView, arguments: {'url': url});
                }));
        } else {
          _contentList.add(
            TextSpan(text: url),
          );
        }
      }
      if (index < text.length) {
        String a = text.substring(index, text.length);
        _contentList.add(
          TextSpan(text: a),
        );
      }
    }

    if (_contentList.isNotEmpty) {
      if (_contentList.length == 1) {
        return _detail(
            textDirection: textDirection,
            body: PreViewUrl(
              url: _contentList.first.toPlainText().replaceAll("www.", ''),
            ));
      } else {
        return _detail(
          textDirection: textDirection,
          body: Text.rich(
            TextSpan(
              children: _contentList,
              style: XFonts.size20Black0,
            ),
          ),
        );
      }
    }

    return _detail(
      textDirection: textDirection,
      body: Text(
        TextUtils.textReplace(msg.metadata.showTxt),
        style: XFonts.size20Black0,
      ),
    );
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
  putPlayerStatusIfAbsent(MsgSaveModel msg) {
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


String getFileSizeString({required int bytes, int decimals = 0}) {
  const suffixes = ["B", "KB", "MB", "GB", "TB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}