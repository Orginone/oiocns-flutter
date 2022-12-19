// 控制器
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/controller/message/message_controller.dart';
import 'package:orginone/enumeration/message_type.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  camera("拍摄", Icons.camera_alt);
  // file("文件", Icons.upload);

  final String label;
  final IconData iconData;

  const MoreFunction(this.label, this.iconData);
}

class ChatBoxController extends FullLifeCycleController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Logger log = Logger("ChatBoxController");

  final Rx<InputStatus> _inputStatus = InputStatus.notPopup.obs;
  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode blankNode = FocusNode();

  final ImagePicker picker = ImagePicker();

  final Rx<RecordStatus> _recordStatus = RecordStatus.stop.obs;
  FlutterSoundRecorder? _recorder;
  StreamSubscription? _mt;
  String? _currentFile;
  String? _currentFileName;
  Duration? _currentDuration;
  RxDouble? _level;
  double? _maxLevel;

  ChatBoxController();

  InputStatus get inputStatus => _inputStatus.value;

  Rx<RecordStatus> get recordStatus => _recordStatus;

  String? get currentFile => _currentFile;

  String? get currentFileName => _currentFileName;

  RxDouble? get level => _level;

  double? get maxLevel => _maxLevel;

  Duration? get currentDuration => _currentDuration;

  @override
  onClose() {
    super.onClose();
    inputController.dispose();
    focusNode.dispose();
    blankNode.dispose();
    stopRecord();
  }

  /// 事件触发器
  eventFire(BuildContext context, InputEvent inputEvent) async {
    switch (inputEvent) {
      case InputEvent.clickInput:
      case InputEvent.inputText:
      case InputEvent.clickKeyBoard:
        var text = inputController.value.text;
        if (text.isNotEmpty) {
          _inputStatus.value = InputStatus.inputtingText;
        } else {
          _inputStatus.value = InputStatus.focusing;
        }
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
        _inputStatus.value = InputStatus.more;
        break;
      case InputEvent.inputEmoji:
        _inputStatus.value = InputStatus.inputtingEmoji;
        break;
      case InputEvent.clickSendBtn:
        var messageCtrl = Get.find<MessageController>();
        var currentChat = messageCtrl.getCurrentChat;
        await currentChat!.sendMsg(
          msgBody: inputController.text,
          msgType: MsgType.text,
        );
        inputController.clear();
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

  execute(MoreFunction moreFunction, BuildContext context) async {
    var messageCtrl = Get.find<MessageController>();
    switch (moreFunction) {
      case MoreFunction.photo:
        var gallery = ImageSource.gallery;
        XFile? pickedImage = await picker.pickImage(source: gallery);
        if (pickedImage != null) {
          messageCtrl.imagePicked(pickedImage);
        }
        break;
      case MoreFunction.camera:
        var camera = ImageSource.camera;
        try {
          XFile? pickedImage = await picker.pickImage(source: camera);
          if (pickedImage != null) {
            messageCtrl.imagePicked(pickedImage);
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
    }
  }

  openRecorder() async {
    _recorder ??= await FlutterSoundRecorder().openRecorder();
  }

  /// 开始录音
  Future<void> startRecord() async {
    if (_recorder == null) {
      return;
    }
    try {
      // 状态变化
      _recordStatus.value = RecordStatus.recoding;

      // 监听音浪
      _level ??= 0.0.obs;
      _maxLevel ??= 60.0;
      _recorder!.setSubscriptionDuration(const Duration(milliseconds: 50));
      _mt = _recorder?.onProgress?.listen((e) {
        _level!.value = e.decibels ?? 0;
        _maxLevel = max(_maxLevel!, _level!.value);
        log.info("duration:${e.duration}");
        _currentDuration = e.duration;
      });

      // 创建临时文件
      var tempDir = await getTemporaryDirectory();
      var key = DateTime.now().millisecondsSinceEpoch;
      _currentFileName = "$key${ext[Codec.aacADTS.index]}";
      _currentFile = "${tempDir.path}/$_currentFileName";

      // 开启监听
      await _recorder!.startRecorder(
        toFile: _currentFile,
        codec: Codec.aacADTS,
        bitRate: 8000,
        sampleRate: 8000,
      );
    } catch (error) {
      await stopRecord();
      rethrow;
    }
  }

  /// 停止录音
  stopRecord() async {
    if (_recorder == null) {
      return;
    }
    await _recorder!.stopRecorder();
    _mt?.cancel();
    _mt = null;
    _level = null;

    _recordStatus.value = RecordStatus.stop;
  }

  /// 暂停录音
  pauseRecord() async {
    if (_recorder == null) {
      return;
    }
    if (_recorder!.isRecording) {
      await _recorder!.pauseRecorder();
      recordStatus.value = RecordStatus.pausing;
    }
  }

  /// 继续录音
  resumeRecord() async {
    if (_recorder == null) {
      return;
    }
    if (_recorder!.isPaused) {
      await _recorder!.resumeRecorder();
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
