import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:audio_wave/audio_wave.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart' hide Rule;
import 'package:orginone/dart/core/chat/message/message.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/images.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/text/rich_text_input_formatter.dart';
import 'package:orginone/util/event_bus_helper.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/target_text.dart';
import 'package:orginone/widget/unified.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';

import 'dialog/at_person_dialog.dart';
import 'text/at_textfield.dart';

double defaultBorderRadius = 6.w;
double boxDefaultHeight = 40.h;
double defaultBottomHeight = 300.h;

class ChatBox extends StatelessWidget with WidgetsBindingObserver {
  final RxDouble bottomHeight = defaultBottomHeight.obs;
  final IMsgChat chat;
  final ChatBoxController controller;

  ChatBox({
    Key? key,
    required this.chat,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget voiceFunc = Obx(() {
      if (controller.inputStatus == InputStatus.voice) {
        return _leftKeyBoardBtn(context);
      } else {
        return _voiceBtn(context);
      }
    });
    Widget otherFunc = Obx(() {
      switch (controller.inputStatus) {
        case InputStatus.notPopup:
        case InputStatus.focusing:
        case InputStatus.voice:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _moreBtn(context)],
          );
        case InputStatus.emoji:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_keyBoardBtn(context), _moreBtn(context)],
          );
        case InputStatus.more:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _moreBtn(context)],
          );
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
      }
    });
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      var bottom = MediaQuery.of(context).viewInsets.bottom;
      var inputStatus = controller.inputStatus;
      if (inputStatus == InputStatus.focusing ||
          inputStatus == InputStatus.notPopup ||
          inputStatus == InputStatus.voice ||
          inputStatus == InputStatus.inputtingText) {
        bottomHeight.value = bottom;
      }
    });
    return Container(
      color: Color(0xFFFCFDFF),
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [voiceFunc, _input(context), otherFunc],
            ),
          ),
          _bottomPopup(context),
        ],
      ),
    );
  }

  /// 输入
  Widget _input(BuildContext context) {
    return Expanded(child: Obx(() {
      if (controller.inputStatus == InputStatus.voice) {
        return _voice(context);
      }
      return _inputBox(context);
    }));
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
            key: controller.atKey,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            focusNode: controller.focusNode,
            onChanged: (text) {
              controller.eventFire(context, InputEvent.clickInput, chat);
            },
            onTap: () {
              controller.eventFire(context, InputEvent.clickInput, chat);
            },
            valueChangedCallback: (rules, value) {
              controller.rules = rules;
            },
            style: XFonts.size20Black3,
            controller: controller.inputController,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(10.w, 16.h, 10.w, 16.h),
              border: InputBorder.none,
              constraints: BoxConstraints(
                maxHeight: 144.h,
              ),
            ),
            triggerAtCallback: () async {
              var target = await AtPersonDialog.showDialog(context, chat);
              return target;
            },
          ),
          Obx(() {
            if (controller.reply.value == null) {
              return SizedBox();
            }
            String showTxt = StringUtil.msgConversion(controller.reply.value!,'');
            List<InlineSpan> span  = [TextSpan(text:  showTxt,),];
            if(chat.share.typeName!=TargetType.person.label){
              span.insert(0,  WidgetSpan(child: TargetText(userId: controller.reply.value!.fromId,text: ": ",),alignment: PlaceholderAlignment.middle),);
            }

            return Container(
              color: Colors.grey[200],
              width: double.infinity,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 15.w),
              child: Row(
                children: [
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: span,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.close,
                      size: 28.w,
                    ),
                    onTap: () {
                      controller.reply.value = null;
                    },
                  )
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  /// 录音按钮
  Widget _voice(BuildContext context) {
    var voiceWave = OverlayEntry(builder: (BuildContext context) {
      return _voiceWave();
    });
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {},
      onLongPressMoveUpdate: (details) async {
        var localPosition = details.localPosition;
        if (localPosition.dy < 0) {
          await controller.pauseRecord();
        } else {
          await controller.resumeRecord();
        }
      },
      onLongPress: () {
        controller.startRecord().then((value) async {
          Vibration.hasVibrator()
              .then((value) => Vibration.vibrate(duration: 100));
          Overlay.of(context).insert(voiceWave);
        });
      },
      onLongPressEnd: (details) async {
        voiceWave.remove();

        var recordStatus = controller.recordStatus.value;
        if (recordStatus == RecordStatus.recoding) {
          // 记录
          var duration = controller.currentDuration ?? Duration.zero;
          await controller.stopRecord();
          if (duration.inMilliseconds < 2000) {
            Fluttertoast.showToast(msg: '时间太短啦!');
            return;
          }

          var path = controller.currentFile;
          var time = duration.inMilliseconds;

          if (path?.isNotEmpty ?? false) {
            chat.sendMessage(
              MessageType.voice,
              jsonEncode({
                "milliseconds": time,
                "bytes": File(path!).readAsBytesSync(),
              }),
            );
          }
        } else if (recordStatus == RecordStatus.pausing) {
          // 停止记录
          await controller.stopRecord();
          Fluttertoast.showToast(msg: "取消成功!");
        }
      },
      child: Container(
        height: 36.h + 22.sp,
        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        alignment: Alignment.center,
        child: Obx(() {
          var recordStatus = controller.recordStatus.value;
          switch (recordStatus) {
            case RecordStatus.stop:
              return const Text("按住 说话");
            case RecordStatus.recoding:
              return const Text("松开 发送");
            case RecordStatus.pausing:
              return const Text("上移 取消",
                  style: TextStyle(color: XColors.backColor));
          }
        }),
      ),
    );
  }

  /// 表情包按钮
  Widget _emojiBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.eventFire(context, InputEvent.clickEmoji, chat),
      child: _rightIcon(Images.iconEmoji),
    );
  }

  /// 更多操作
  Widget _moreBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.eventFire(context, InputEvent.clickMore, chat),
      child: _rightIcon(Images.iconAddAction),
    );
  }

  /// 语音按钮
  Widget _voiceBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.eventFire(context, InputEvent.clickVoice, chat);
      },
      child: _leftIcon(Images.iconVoice),
    );
  }

  /// 键盘按钮
  Widget _leftKeyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          controller.eventFire(context, InputEvent.clickKeyBoard, chat),
      child: _leftIcon(Icons.keyboard_alt_outlined),
    );
  }

  /// 键盘按钮
  Widget _keyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          controller.eventFire(context, InputEvent.clickKeyBoard, chat),
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
        onPressed: () {
          controller.eventFire(context, InputEvent.clickSendBtn, chat);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
          minimumSize: MaterialStateProperty.all(Size(10.w, boxDefaultHeight)),
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
          bottomHeight.value = defaultBottomHeight;
          body = _more(context);
          break;
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
        inputController
          ..text += emoji.emoji
          ..selection = TextSelection.fromPosition(
            TextPosition(
              offset: inputController.text.length,
            ),
          );
        controller.eventFire(context, InputEvent.inputEmoji, chat);
      },
    );
  }

  /// 更多功能
  Widget _more(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      decoration: BoxDecoration(
        border:
            Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
      ),
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 10.w,
        scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        children: MoreFunction.values
            .map((item) => _funcIcon(item, context))
            .toList(),
      ),
    );
  }

  /// 功能点
  Widget _funcIcon(MoreFunction moreFunction, BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.execute(moreFunction, context, chat);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            margin: EdgeInsets.only(bottom: 10.h),
            child: Icon(moreFunction.iconData),
          ),
          Text(moreFunction.label, style: XFonts.size16Black3W700)
        ],
      ),
    );
  }

  /// 录音波动
  Widget _voiceWave() {
    Random random = Random();
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter - const Alignment(0.0, -0.5),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Obx(() {
              var recordStatus = controller.recordStatus.value;
              if (recordStatus == RecordStatus.recoding) {
                // 处于录音状态
                double value = controller.level?.value ?? 0;
                double maxValue = controller.maxLevel ?? 0;

                double randomPercent = 0.3;
                double percent = maxValue == 0 ? 1 : value / maxValue;
                percent = percent - randomPercent;
                Color color = XColors.white;

                // 坡数量，波浪数量
                int peakCount = 8;
                int waveCount = 32;
                int averagePeakCount = waveCount ~/ peakCount;
                double average = peakCount / waveCount;

                List<AudioWaveBar> bars = [];
                for (int i = 0; i <= waveCount; i++) {
                  bool isEven = ((i ~/ averagePeakCount) % 2) == 0;
                  int heightCount = i % averagePeakCount;
                  double randomHeight = random.nextDouble() * randomPercent;
                  if (isEven) {
                    var height = heightCount * average * percent + randomHeight;
                    height = height < 0 ? 0 : height;
                    bars.add(AudioWaveBar(heightFactor: height, color: color));
                  } else {
                    var remainder = averagePeakCount - heightCount;
                    var height = remainder * average * percent + randomHeight;
                    height = height < 0 ? 0 : height;
                    bars.add(AudioWaveBar(heightFactor: height, color: color));
                  }
                }
                return AudioWave(
                  animation: false,
                  bars: bars,
                );
              } else if (recordStatus == RecordStatus.pausing) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: XColors.backColor,
                    borderRadius: BorderRadius.all(Radius.circular(10.w)),
                  ),
                  width: 100,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.keyboard_return,
                        color: Colors.white,
                        size: 50.w,
                      ),
                      Padding(padding: EdgeInsets.only(top: 10.h)),
                      Text("取消发送", style: XFonts.size22WhiteW700)
                    ],
                  ),
                );
              } else {
                return Container();
              }
            }),
          ),
        ),
      ],
    );
  }
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

class ChatBoxController with WidgetsBindingObserver {
  final Rx<InputStatus> _inputStatus = InputStatus.notPopup.obs;
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

  Rxn<MsgSaveModel> reply = Rxn();

  ChatBoxController() {
    EventBusHelper.register(this, (event) {
      if (event is XTarget) {
        atKey.currentState!.addTarget(event);
      }
    });
    atKey = GlobalKey();
    Permission.microphone.request();
  }

  dispose() {
    EventBusHelper.unregister(this);
    _recorder.dispositionStream();
    inputController.dispose();
    focusNode.dispose();
    blankNode.dispose();
    stopRecord();
  }


  /// 事件触发器
  eventFire(BuildContext context, InputEvent inputEvent, IMsgChat chat) async {
    switch (inputEvent) {
      case InputEvent.clickInput:
      case InputEvent.inputText:
        var text = inputController.value.text;
        if (text.isNotEmpty) {
          _inputStatus.value = InputStatus.inputtingText;
        } else {
          _inputStatus.value = InputStatus.focusing;
        }
        break;
      case InputEvent.clickKeyBoard:
        _inputStatus.value = InputStatus.notPopup;
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
      case InputEvent.inputEmoji:
        if (_inputStatus.value != InputStatus.inputtingEmoji) {
          _inputStatus.value = InputStatus.inputtingEmoji;
        }
        break;
      case InputEvent.clickSendBtn:
        String message = inputController.text;
        await chat.sendMessage(MessageType.text, message,
            rules.map((e) => e.target?.id ?? "").toList(), reply.value);
        inputController.clear();
        atKey.currentState?.clearRules();
        reply.value = null;
        rules.clear();
        if (_inputStatus.value == InputStatus.inputtingText) {
          _inputStatus.value = InputStatus.focusing;
        } else {
          _inputStatus.value = InputStatus.emoji;
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

  void imagePicked(XFile pickedImage, IMsgChat chat) async {
    var docDir = settingCtrl.user.directory;
    String ext = pickedImage.name.split('.').last;

    var save = MsgSaveModel.fromFileUpload(
        settingCtrl.user.id, pickedImage.name, pickedImage.path, ext);
    chat.messages.insert(0, Message(chat, save));

    var item = await docDir.createFile(
      File(pickedImage.path),
      progress: (progress) {
        var msg = chat.messages
            .firstWhere((element) => element.metadata.id == pickedImage.name);
        msg.metadata.body!.progress = progress;
        chat.messages.refresh();
      },
    );
    if (item != null) {
      chat.sendMessage(
          MessageType.image, jsonEncode(item.shareInfo().toJson()));
    }
  }

  Future<void> filePicked(PlatformFile file, IMsgChat chat) async {
    var docDir =  settingCtrl.user.directory;

    String ext = file.name.split('.').last;

    var file1 = File(file.path!);
    var save = MsgSaveModel.fromFileUpload(
        settingCtrl.user.id, file.name, file.path!, ext, file1.lengthSync());
    chat.messages.insert(0, Message(chat, save));

    var item = await docDir.createFile(
      file1,
      progress: (progress) {
        var msg = chat.messages
            .firstWhere((element) => element.metadata.id == file.name);
        msg.metadata.body!.progress = progress;
        chat.messages.refresh();
      },
    );
    if (item != null) {
      var msg = chat.messages.firstWhere((element) => element.body?.name == save.body?.name);
      msg.body!.name = item.shareInfo().name;
      chat.sendMessage(MessageType.file, jsonEncode(item.shareInfo().toJson()));
    }
  }

  execute(
      MoreFunction moreFunction, BuildContext context, IMsgChat chat) async {
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
        print('e------------------${e.duration}');
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

class ChatBoxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatBoxController());
  }
}
