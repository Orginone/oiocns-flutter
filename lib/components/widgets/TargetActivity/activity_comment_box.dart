// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/common/values/index.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/base/schema.dart' hide Rule;
import 'package:orginone/dart/core/chat/message.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';

import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/text/at_textfield.dart';
import 'package:orginone/pages/chat/widgets/text/rich_text_input_formatter.dart';
import 'package:orginone/utils/bus/event_bus_helper.dart';
import 'package:orginone/utils/permission_util.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

double defaultBorderRadius = 6.w;
double boxDefaultHeight = 40.h;
double defaultBottomHeight = 300.h;

// 动态评论盒子
class ActivityCommentBox extends StatelessWidget with WidgetsBindingObserver {
  final RxDouble bottomHeight = defaultBottomHeight.obs;
  // 组件控制器
  late ActivityCommentBoxController controller;
  // 内容显示组件
  Widget? body;
  // // 文本框输入状态（输入框弹出）事件
  // Function(ShowCommentBoxNotification notification)? onInput;
  // // 文本框输入变动事件
  // Function(RxString content)? onInputChanged;
  // // 点击表情事件
  // Function(RxString content)? onEmoji;
  // // 发送事件
  // Function(RxString content)? onSend;
  // // 键盘按键事件
  // Function(RxString content)? onKeyBoard;
  // // 点击内容显示区域事件
  // Function(RxString content)? onClickBlank;
  // 按钮是否可以点击
  late RxBool isDisabledSend;

  ActivityCommentBox({
    Key? key,
    this.body,
    bool? showCommentBox,
    // this.onInput,
    // this.onInputChanged,
    // this.onEmoji,
    // this.onSend,
    // this.onKeyBoard,
  }) : super(key: key) {
    controller = ActivityCommentBoxController(showCommentBox: showCommentBox);
    isDisabledSend = false.obs;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          controller._hiddenBox(context);
        },
        child: Column(
          children: [
            // body!,
            Expanded(
                child: Container(
                    alignment: Alignment.center,
                    child: NotificationListener<ShowCommentBoxNotification>(
                      onNotification: (notification) {
                        controller._currNotification = notification;
                        controller._showBox(context);
                        return true;
                      },
                      child: body!,
                    ))),
            Offstage(
              offstage: controller.showCommentBox.value,
              child: _box(context),
            )
          ],
        ),
      );
    });
  }

  Widget _box(BuildContext context) {
    // Widget voiceFunc = Obx(() {
    //   if (inputStatus.value == InputStatus.voice) {
    //     return _leftKeyBoardBtn(context);
    //   } else {
    //     return _voiceBtn(context);
    //   }
    // });
    Widget otherFunc = Obx(() {
      switch (controller.inputStatus) {
        case InputStatus.notPopup:
        case InputStatus.focusing:
        case InputStatus.voice:
        //   return Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [_emojiBtn(context), _moreBtn(context)],
        //   );
        case InputStatus.emoji:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_keyBoardBtn(context), _sendBtn(context)],
          );
        case InputStatus.more:
        //   return Row(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [_emojiBtn(context), _moreBtn(context)],
        //   );
        case InputStatus.inputtingText:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _sendBtn(context)],
          );
        case InputStatus.inputtingEmoji:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_keyBoardBtn(context), _sendBtn(context)],
          );
        case InputStatus.at:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _sendBtn(context)],
          );
      }
    });
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      var bottom = MediaQuery.of(context).viewInsets.bottom;
      var inputStatus = controller.inputStatus;
      if (inputStatus == InputStatus.focusing ||
          inputStatus == InputStatus.notPopup ||
          inputStatus == InputStatus.voice ||
          inputStatus == InputStatus.inputtingText ||
          inputStatus == InputStatus.at) {
        bottomHeight.value = bottom;
      }
    });
    return Container(
      color: const Color(0xFFFCFDFF),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [_input(context), otherFunc],
            ),
          ),
          _bottomPopup(context),
        ],
      ),
    );
  }

  /// 输入
  Widget _input(BuildContext context) {
    return Expanded(child: _inputBox(context));
    // return Expanded(child: Obx(() {
    //   if (controller.inputStatus == InputStatus.voice) {
    //       return _voice(context);
    //   }
    //   return _inputBox(context);
    // }));
  }

  /// 输入框
  Widget _inputBox(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        border: Border.all(color: Colors.grey),
      ),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AtTextFiled(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            focusNode: controller.focusNode,
            onChanged: (text) {
              if (text.trim().isNotEmpty) {
                isDisabledSend.value = true;
              } else {
                isDisabledSend.value = false;
              }
              if (text.endsWith('@')) return; //如果是@结尾的话不需要做text的事件通知
              controller.eventFire(context, InputEvent.clickInput);
            },
            onTap: () {
              controller.eventFire(context, InputEvent.clickInput);
            },
            // valueChangedCallback: (rules, value) {
            //   controller.rules = rules;
            // },
            style: XFonts.size22Black3,
            controller: controller.inputController,
            decoration: InputDecoration(
              labelText: controller._currNotification.getTipInfo?.call(),
              isCollapsed: false,
              contentPadding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 16.h),
              border: InputBorder.none,
              constraints: BoxConstraints(
                maxHeight: 144.h,
              ),
            ),
            triggerAtCallback: () async {
              return null;

              //   ///延迟500ms 执行艾特回调 让弹框更丝滑
              //   await Future.delayed(const Duration(milliseconds: 500));
              //   controller.eventFire(context, InputEvent.inputAt, chat);
              //   List<XTarget>? target =
              //       await AtPersonDialog.showDialog(context, chat);
              //   return target;
            },
          ),
          // Obx(() {
          //   if (controller.reply.value == null) {
          //     return const SizedBox();
          //   }
          //   String showTxt = controller.reply.value!.msgBody;
          //   // StringUtil.msgConversion(controller.reply.value!, '');
          //   List<InlineSpan> span = [
          //     TextSpan(
          //       text: showTxt,
          //     ),
          //   ];
          //   if (chat.share.typeName != TargetType.person.label) {
          //     span.insert(
          //       0,
          //       WidgetSpan(
          //           child: TargetText(
          //             userId: controller.reply.value!.metadata.fromId,
          //             text: ": ",
          //           ),
          //           alignment: PlaceholderAlignment.middle),
          //     );
          //   }

          //   return Container(
          //     color: Colors.grey[200],
          //     width: double.infinity,
          //     alignment: Alignment.centerLeft,
          //     padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Text.rich(
          //             TextSpan(
          //               children: span,
          //             ),
          //             maxLines: 2,
          //             overflow: TextOverflow.ellipsis,
          //           ),
          //         ),
          //         GestureDetector(
          //           child: Icon(
          //             Icons.close,
          //             size: 28.w,
          //           ),
          //           onTap: () {
          //             controller.reply.value = null;
          //           },
          //         )
          //       ],
          //     ),
          //   );
          // }),
        ],
      ),
    );
  }

  // /// 录音按钮
  // Widget _voice(BuildContext context) {
  //   var voiceWave = OverlayEntry(builder: (BuildContext context) {
  //     return _voiceWave();
  //   });
  //   return GestureDetector(
  //     behavior: HitTestBehavior.opaque,
  //     onTap: () {},
  //     onLongPressMoveUpdate: (details) async {
  //       var localPosition = details.localPosition;
  //       if (localPosition.dy < 0) {
  //         await controller.pauseRecord();
  //       } else {
  //         await controller.resumeRecord();
  //       }
  //     },
  //     onLongPress: () {
  //       controller.startRecord().then((value) async {
  //         Vibration.hasVibrator()
  //             .then((value) => Vibration.vibrate(duration: 100));
  //         Overlay.of(context).insert(voiceWave);
  //       });
  //     },
  //     onLongPressEnd: (details) async {
  //       voiceWave.remove();

  //       var recordStatus = controller.recordStatus.value;
  //       if (recordStatus == RecordStatus.recoding) {
  //         // 记录
  //         var duration = controller.currentDuration ?? Duration.zero;
  //         await controller.stopRecord();
  //         if (duration.inMilliseconds < 2000) {
  //           Fluttertoast.showToast(msg: '时间太短啦!');
  //           return;
  //         }

  //         var path = controller.currentFile;
  //         var time = duration.inMilliseconds;

  //         if (path?.isNotEmpty ?? false) {
  //           chat.sendMessage(
  //               MessageType.voice,
  //               jsonEncode({
  //                 "milliseconds": time,
  //                 "bytes": File(path!).readAsBytesSync(),
  //               }),
  //               []);
  //         }
  //       } else if (recordStatus == RecordStatus.pausing) {
  //         // 停止记录
  //         await controller.stopRecord();
  //         Fluttertoast.showToast(msg: "取消成功!");
  //       }
  //     },
  //     child: Container(
  //       height: 36.h + 22.sp,
  //       margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
  //         border: Border.all(color: Colors.grey, width: 0.5),
  //       ),
  //       alignment: Alignment.center,
  //       child: Obx(() {
  //         var recordStatus = controller.recordStatus.value;
  //         switch (recordStatus) {
  //           case RecordStatus.stop:
  //             return const Text("按住 说话");
  //           case RecordStatus.recoding:
  //             return const Text("松开 发送");
  //           case RecordStatus.pausing:
  //             return const Text("上移 取消",
  //                 style: TextStyle(color: XColors.backColor));
  //         }
  //       }),
  //     ),
  //   );
  // }

  /// 表情包按钮
  Widget _emojiBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.eventFire(context, InputEvent.clickEmoji),
      child: _rightIcon(AssetsImages.iconEmoji),
    );
  }

  // /// 更多操作
  // Widget _moreBtn(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => controller.eventFire(context, InputEvent.clickMore, chat),
  //     child: _rightIcon(AssetsImages.iconAddAction),
  //   );
  // }

  // /// 语音按钮
  // Widget _voiceBtn(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.eventFire(context, InputEvent.clickVoice, chat);
  //     },
  //     child: _leftIcon(AssetsImages.iconVoice),
  //   );
  // }

  // /// 键盘按钮
  // Widget _leftKeyBoardBtn(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () =>
  //         controller.eventFire(context, InputEvent.clickKeyBoard, chat),
  //     child: _leftIcon(Icons.keyboard_alt_outlined),
  //   );
  // }

  /// 键盘按钮
  Widget _keyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.eventFire(context, InputEvent.inputText),
      child: _rightIcon(Icons.keyboard_alt_outlined),
    );
  }

  // 左侧 Icon
  Widget _leftIcon(dynamic path) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w),
      child: ImageWidget(
        path,
        size: boxDefaultHeight,
      ),
    );
  }

  /// 右侧 Icon
  Widget _rightIcon(dynamic path) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
      child: ImageWidget(
        path,
        size: boxDefaultHeight,
      ),
    );
  }

  /// 发送按钮
  Widget _sendBtn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      child: ElevatedButton(
        onPressed: () async {
          controller.eventFire(context, InputEvent.clickSendBtn);
        },
        style: isDisabledSend.value
            ? ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                minimumSize:
                    MaterialStateProperty.all(Size(10.w, boxDefaultHeight)),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all(XColors.black9),
                minimumSize:
                    MaterialStateProperty.all(Size(10.w, boxDefaultHeight)),
              ),
        child: const Text("发送"),
      ),
    );
  }

  /// 下面的弹出框
  Widget _bottomPopup(BuildContext context) {
    return Obx(() {
      late Widget body;
      switch (controller.inputStatus) {
        case InputStatus.emoji:
        case InputStatus.inputtingEmoji:
          bottomHeight.value = defaultBottomHeight;
          body = _emojiPicker(context);
          break;
        case InputStatus.more:
        //   bottomHeight.value = defaultBottomHeight;
        //   body = _more(context);
        //   break;
        case InputStatus.notPopup:
        case InputStatus.voice:
          bottomHeight.value = 0;
          return Container();
        case InputStatus.focusing:
        case InputStatus.inputtingText:
          bottomHeight.value = 0;
          body = Container();
          FocusScope.of(context).requestFocus(controller.focusNode);
          break;
        case InputStatus.at:
          bottomHeight.value = 0;
          body = Container();
          break;
      }
      return Offstage(
        offstage: false,
        child: Obx(() => SizedBox(height: bottomHeight.value, child: body)),
      );
    });
  }

  /// 表情包选择
  Widget _emojiPicker(BuildContext context) {
    var inputController = controller.inputController;
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        isDisabledSend.value = true;
        inputController
          ..text += emoji.emoji
          ..selection = TextSelection.fromPosition(
            TextPosition(
              offset: inputController.text.length,
            ),
          );
        // controller.eventFire(context, InputEvent.inputEmoji);
      },
    );
  }

  // /// 更多功能
  // Widget _more(BuildContext context) {
  //   return Container(
  //     padding: EdgeInsets.only(top: 20.h),
  //     decoration: BoxDecoration(
  //       border:
  //           Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
  //     ),
  //     child: GridView.count(
  //       shrinkWrap: true,
  //       mainAxisSpacing: 10.w,
  //       scrollDirection: Axis.vertical,
  //       crossAxisCount: 4,
  //       children: MoreFunction.values
  //           .map((item) => _funcIcon(item, context))
  //           .toList(),
  //     ),
  //   );
  // }

  // /// 功能点
  // Widget _funcIcon(MoreFunction moreFunction, BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       controller.execute(moreFunction, context, chat);
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         Container(
  //           width: 80.w,
  //           height: 80.w,
  //           decoration: BoxDecoration(
  //             color: Colors.grey.shade200,
  //             borderRadius: BorderRadius.all(Radius.circular(5.w)),
  //           ),
  //           margin: EdgeInsets.only(bottom: 10.h),
  //           child: Icon(moreFunction.iconData),
  //         ),
  //         Text(moreFunction.label, style: XFonts.size16Black3W700)
  //       ],
  //     ),
  //   );
  // }

  // /// 录音波动
  // Widget _voiceWave() {
  //   Random random = Random();
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: Alignment.topCenter - const Alignment(0.0, -0.5),
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: const BorderRadius.all(Radius.circular(5)),
  //             color: Colors.black.withOpacity(0.5),
  //           ),
  //           child: Obx(() {
  //             var recordStatus = controller.recordStatus.value;
  //             if (recordStatus == RecordStatus.recoding) {
  //               // 处于录音状态
  //               double value = controller.level?.value ?? 0;
  //               double maxValue = controller.maxLevel ?? 0;

  //               double randomPercent = 0.3;
  //               double percent = maxValue == 0 ? 1 : value / maxValue;
  //               percent = percent - randomPercent;
  //               Color color = XColors.white;

  //               // 坡数量，波浪数量
  //               int peakCount = 8;
  //               int waveCount = 32;
  //               int averagePeakCount = waveCount ~/ peakCount;
  //               double average = peakCount / waveCount;

  //               List<AudioWaveBar> bars = [];
  //               for (int i = 0; i <= waveCount; i++) {
  //                 bool isEven = ((i ~/ averagePeakCount) % 2) == 0;
  //                 int heightCount = i % averagePeakCount;
  //                 double randomHeight = random.nextDouble() * randomPercent;
  //                 if (isEven) {
  //                   var height = heightCount * average * percent + randomHeight;
  //                   height = height < 0 ? 0 : height;
  //                   bars.add(AudioWaveBar(heightFactor: height, color: color));
  //                 } else {
  //                   var remainder = averagePeakCount - heightCount;
  //                   var height = remainder * average * percent + randomHeight;
  //                   height = height < 0 ? 0 : height;
  //                   bars.add(AudioWaveBar(heightFactor: height, color: color));
  //                 }
  //               }
  //               return AudioWave(
  //                 animation: false,
  //                 bars: bars,
  //               );
  //             } else if (recordStatus == RecordStatus.pausing) {
  //               return Container(
  //                 alignment: Alignment.center,
  //                 decoration: BoxDecoration(
  //                   color: XColors.backColor,
  //                   borderRadius: BorderRadius.all(Radius.circular(10.w)),
  //                 ),
  //                 width: 100,
  //                 height: 100,
  //                 child: Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(
  //                       Icons.keyboard_return,
  //                       color: Colors.white,
  //                       size: 50.w,
  //                     ),
  //                     Padding(padding: EdgeInsets.only(top: 10.h)),
  //                     Text("取消发送", style: XFonts.size22WhiteW700)
  //                   ],
  //                 ),
  //               );
  //             } else {
  //               return Container();
  //             }
  //           }),
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

enum RecordStatus { stop, recoding, pausing }

enum InputStatus {
  notPopup,
  focusing,
  emoji,
  more,
  voice,
  inputtingText,
  inputtingEmoji,
  at, //@
}

enum InputEvent {
  clickInput,
  clickEmoji,
  clickKeyBoard,
  clickVoice,
  clickMore,
  clickBlank,
  inputText,
  inputEmoji,
  inputAt,
  clickSendBtn
}

enum MoreFunction {
  photo("相册", Icons.photo),
  camera("拍摄", Icons.camera_alt),
  file("文件", Icons.upload);

  final String label;
  final IconData iconData;

  const MoreFunction(this.label, this.iconData);
}

class ActivityCommentBoxController with WidgetsBindingObserver {
  final Rx<InputStatus> _inputStatus = InputStatus.notPopup.obs;
  // 文本框
  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode blankNode = FocusNode();

  final ImagePicker picker = ImagePicker();

  final Rx<RecordStatus> _recordStatus = RecordStatus.stop.obs;
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  StreamSubscription? _mt;
  String? _currentFile;
  String? _currentFileName;
  Duration? _currentDuration;
  RxDouble? _level;
  double? _maxLevel;

  InputStatus get inputStatus => _inputStatus.value;

  Rx<RecordStatus> get recordStatus => _recordStatus;

  String? get currentFile => _currentFile;

  String? get currentFileName => _currentFileName;

  RxDouble? get level => _level;

  double? get maxLevel => _maxLevel;

  Duration? get currentDuration => _currentDuration;

  late GlobalKey<AtTextFiledState> atKey;

  List<Rule> rules = [];

  Rxn<IMessage> reply = Rxn();
  // 当前操作对象
  late ShowCommentBoxNotification _currNotification;
  // 显示数据采集box
  late RxBool showCommentBox;
  // 发送文本框提示信息
  late RxString tipInfo;

  ActivityCommentBoxController({bool? showCommentBox}) {
    EventBusHelper.register(this, (event) {
      if (event is XTarget) {
        atKey.currentState!.addTarget(event);
      }
    });
    atKey = GlobalKey();
    Permission.microphone.request();
    this.showCommentBox = (showCommentBox ?? true).obs;
    tipInfo = "".obs;
    _currNotification = ShowCommentBoxNotification((text) async => true);
  }

  dispose() {
    EventBusHelper.unregister(this);
    _recorder.dispositionStream();
    inputController.dispose();
    focusNode.dispose();
    blankNode.dispose();
    stopRecord();
  }

  _showBox(BuildContext context) {
    showCommentBox.value = false;
    _inputStatus.value = InputStatus.inputtingText;
    // FocusScope.of(context).requestFocus(controller.focusNode);
    // controller.focusNode.requestFocus();
  }

  _hiddenBox(BuildContext context) {
    showCommentBox.value = true;
    _inputStatus.value = InputStatus.notPopup;
    FocusScope.of(context).requestFocus(blankNode);
    // onClickBlank?.call(controller.content);
  }

  /// 事件触发器
  eventFire(BuildContext context, InputEvent inputEvent) async {
    switch (inputEvent) {
      case InputEvent.clickInput:
      case InputEvent.inputText:
        // var text = inputController.value.text;
        // if (text.isNotEmpty) {
        _inputStatus.value = InputStatus.inputtingText;
        // } else {
        //   _inputStatus.value = InputStatus.focusing;
        // }
        break;
      case InputEvent.clickKeyBoard:
        _inputStatus.value = InputStatus.notPopup;
        break;
      case InputEvent.inputEmoji:
        _inputStatus.value = InputStatus.at;
        break;
      case InputEvent.clickEmoji:
        FocusScope.of(context).requestFocus(blankNode);
        var text = inputController.value.text;
        if (text.isNotEmpty) {
          _inputStatus.value = InputStatus.inputtingEmoji;
        } else {
          _inputStatus.value = InputStatus.emoji;
        }
        break;
      case InputEvent.clickMore:
        FocusScope.of(context).requestFocus(blankNode);
        if (_inputStatus.value != InputStatus.more) {
          _inputStatus.value = InputStatus.more;
        } else {
          _inputStatus.value = InputStatus.notPopup;
        }
        break;
      case InputEvent.inputAt:
        _inputStatus.value = InputStatus.at;
        FocusScope.of(context).unfocus();
        break;
      case InputEvent.clickSendBtn:
        String message = inputController.text;
        bool success = await _currNotification.onSend(message);
        if (success) {
          inputController.clear();
          atKey.currentState?.clearRules();
          reply.value = null;
          rules.clear();
          if (_inputStatus.value == InputStatus.inputtingText) {
            _inputStatus.value = InputStatus.focusing;
          } else {
            _inputStatus.value = InputStatus.emoji;
          }
          _hiddenBox(context);
        }
        break;
      case InputEvent.clickVoice:
        FocusScope.of(context).requestFocus(blankNode);
        _inputStatus.value = InputStatus.voice;
        break;
      case InputEvent.clickBlank:
        if (_inputStatus.value != InputStatus.voice) {
          _inputStatus.value = InputStatus.notPopup;
        }
        break;
    }
  }

  void imagePicked(XFile pickedImage, ISession chat) async {
    var docDir = settingCtrl.user.directory;
    String ext = pickedImage.name.split('.').last;

    var save = ChatMessageType.fromFileUpload(
        settingCtrl.user.id,
        chat.sessionId,
        chat.sessionId,
        pickedImage.name,
        pickedImage.path,
        ext);
    var msg = Message(save, chat);
    chat.messages.insert(0, msg);
    //chat.chatdata.value.lastMessage!

    var item = await docDir.createFile(
      File(pickedImage.path),
      p: (progress) {
        // var msg = chat.messages
        //     .firstWhere((element) => element.metadata.id == pickedImage.name);
        // //TODO:无此方法
        // msg.metadata.body!.progress = progress;
        msg.progress = progress;
        chat.messages.refresh();
      },
    );
    if (item != null) {
      chat.messages.remove(msg);
      chat.messages.refresh();
      chat.sendMessage(
          MessageType.image, jsonEncode(item.shareInfo().toJson()), []);
    }
  }

  Future<void> filePicked(PlatformFile file, ISession chat) async {
    var docDir = settingCtrl.user.directory;

    String ext = file.name.split('.').last;

    // var file1 = File(file.path!);
    // var save = MsgSaveModel.fromFileUpload(
    //     settingCtrl.user.id, file.name, file.path!, ext, file1.lengthSync());
    // chat.messages.insert(0, Message(chat.chatdata.value.lastMessage!, chat));

    var file1 = File(file.path!);
    var save = ChatMessageType.fromFileUpload(
        settingCtrl.user.id,
        chat.sessionId,
        chat.sessionId,
        file.name,
        file.path!,
        ext,
        file1.lengthSync());
    var msg = Message(save, chat);
    chat.messages.insert(0, msg);

    var item = await docDir.createFile(
      file1,
      p: (progress) {
        //TODO:无此方法
        // msg.metadata.body!.progress = progress;
        msg.progress = progress;
        chat.messages.refresh();
      },
    );
    if (item != null) {
      chat.messages.remove(msg);
      chat.messages.refresh();
      chat.sendMessage(MessageType.file, jsonEncode(item.shareInfo().toJson()),
          msg.mentions);
    }
  }

  execute(
      MoreFunction moreFunction, BuildContext context, ISession chat) async {
    switch (moreFunction) {
      case MoreFunction.photo:
        var gallery = ImageSource.gallery;
        XFile? pickedImage = await picker.pickImage(source: gallery);
        if (pickedImage != null) {
          imagePicked(pickedImage, chat);
        }
        break;
      case MoreFunction.camera:
        var camera = ImageSource.camera;
        try {
          XFile? pickedImage = await picker.pickImage(source: camera);
          if (pickedImage != null) {
            imagePicked(pickedImage, chat);
          }
        } on PlatformException catch (error) {
          if (error.code == "camera_access_denied") {
            PermissionUtil.showPermissionDialog(context, Permission.camera);
          }
        } catch (error) {
          error.printError();
          Fluttertoast.showToast(msg: "打开相机时发生异常!");
        }
        break;
      case MoreFunction.file:
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.any);
        if (result != null) {
          for (var file in result.files) {
            await filePicked(file, chat);
          }
        }

        break;
    }
  }

  openRecorder() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
          AVAudioSessionCategoryOptions.allowBluetooth |
              AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
          AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
    await _recorder.isEncoderSupported(Codec.aacMP4);
  }

  /// 开始录音
  Future<void> startRecord() async {
    try {
      await openRecorder();
      // 状态变化
      _recordStatus.value = RecordStatus.recoding;
      // 监听音浪
      _level ??= 0.0.obs;
      _maxLevel ??= 60.0;
      // 创建临时文件
      var tempDir = await getTemporaryDirectory();
      _currentFile = '${tempDir.path}/orginone${ext[Codec.aacMP4.index]}';
      print("voiceFile--------------$_currentFile");
      // 开启监听

      await _recorder.startRecorder(
        toFile: _currentFile,
        codec: Codec.aacMP4,
        bitRate: 48000,
        sampleRate: 48000,
      );
      _mt = _recorder.onProgress?.listen((e) {
        _level!.value = e.decibels ?? 0;
        _maxLevel = max(_maxLevel!, _level!.value);
        _currentDuration = e.duration;
      });
    } catch (error) {
      await stopRecord();
      rethrow;
    }
  }

  /// 停止录音
  stopRecord() async {
    await _recorder.stopRecorder();
    await _recorder.closeRecorder();
    if (_mt != null) {
      _mt!.cancel();
      _mt = null;
    }
    _level = null;
    _recordStatus.value = RecordStatus.stop;
  }

  /// 暂停录音
  pauseRecord() async {
    if (_recorder.isRecording) {
      await _recorder.pauseRecorder();
      recordStatus.value = RecordStatus.pausing;
    }
  }

  /// 继续录音
  resumeRecord() async {
    if (_recorder.isPaused) {
      await _recorder.resumeRecorder();
      recordStatus.value = RecordStatus.recoding;
    }
  }
}

class ActivityCommentBoxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActivityCommentBoxController());
  }
}

// 显示消息窗口通知
class ShowCommentBoxNotification extends Notification {
  // 获得发送文本框提示信息
  String Function()? getTipInfo;
  // 发送操作
  Future<bool> Function(String text) onSend;
  ShowCommentBoxNotification(this.onSend, {this.getTipInfo});
}
