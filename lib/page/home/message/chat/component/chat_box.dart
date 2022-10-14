import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../component/voice_painter.dart';

enum RecordStatus {
  stop,
  recoding,
}

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
  inputText,
  inputEmoji,
  clickSendBtn
}

enum MoreFunction {
  photo("相册", Icons.photo),
  camera("拍摄", Icons.camera_alt),
  file("文件", Icons.upload);

  final String name;
  final IconData iconData;

  const MoreFunction(this.name, this.iconData);
}

double defaultBorderRadius = 6.w;
double boxDefaultHeight = 28.h;

class ChatBox extends GetView<ChatBoxController> with WidgetsBindingObserver {
  final Rx<InputStatus> inputStatus = InputStatus.notPopup.obs;
  final Rx<RecordStatus> recordStatus = RecordStatus.stop.obs;
  final RxDouble bottomHeight = 220.h.obs;

  ChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget voiceFunc = Obx(() {
      if (inputStatus.value == InputStatus.voice) {
        return _leftKeyBoardBtn(context);
      } else {
        return _voiceBtn(context);
      }
    });
    Widget otherFunc = Obx(() {
      switch (inputStatus.value) {
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
      if (inputStatus.value == InputStatus.focusing ||
          inputStatus.value == InputStatus.notPopup ||
          inputStatus.value == InputStatus.voice ||
          inputStatus.value == InputStatus.inputtingText) {
        bottomHeight.value = bottom;
      }
    });
    return Container(
      color: CustomColors.easyGrey,
      padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [voiceFunc, _input(context), otherFunc],
          ),
          _bottomPopup(context),
        ],
      ),
    );
  }

  /// 事件触发器
  eventFire(BuildContext context, InputEvent inputEvent) {
    switch (inputEvent) {
      case InputEvent.clickInput:
      case InputEvent.inputText:
      case InputEvent.clickKeyBoard:
        var text = controller.inputController.value.text;
        if (text.isNotEmpty) {
          inputStatus.value = InputStatus.inputtingText;
        } else {
          inputStatus.value = InputStatus.focusing;
        }
        break;
      case InputEvent.clickEmoji:
        FocusScope.of(context).requestFocus(controller.blankNode);
        var text = controller.inputController.value.text;
        if (text.isNotEmpty) {
          inputStatus.value = InputStatus.inputtingEmoji;
        } else {
          inputStatus.value = InputStatus.emoji;
        }
        break;
      case InputEvent.clickMore:
        FocusScope.of(context).requestFocus(controller.blankNode);
        inputStatus.value = InputStatus.more;
        break;
      case InputEvent.inputEmoji:
        inputStatus.value = InputStatus.inputtingEmoji;
        break;
      case InputEvent.clickSendBtn:
        var inputController = controller.inputController;
        controller.sendCallback(inputController.text);
        inputController.clear();
        if (inputStatus.value == InputStatus.inputtingText) {
          inputStatus.value = InputStatus.focusing;
        } else {
          inputStatus.value = InputStatus.emoji;
        }
        break;
      case InputEvent.clickVoice:
        FocusScope.of(context).requestFocus(controller.blankNode);
        inputStatus.value = InputStatus.voice;
        break;
    }
  }

  /// 输入
  Widget _input(BuildContext context) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 8.h, bottom: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        alignment: Alignment.centerLeft,
        child: Obx(() {
          if (inputStatus.value == InputStatus.voice) {
            return GestureDetector(
              onPanDown: (DragDownDetails details) async {
                var voiceWave = OverlayEntry(builder: (BuildContext context) {
                  return _voiceWave();
                });

                Overlay.of(context)!.insert(voiceWave);
                recordStatus.value = RecordStatus.recoding;
                try {
                  await controller.startRecord();
                } on RecordingPermissionException {
                  PermissionUtil.showPermissionDialog(
                      context, Permission.microphone);
                } finally {
                  voiceWave.remove();
                  recordStatus.value = RecordStatus.stop;
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: boxDefaultHeight,
                padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
                child: const Text("按住 说话"),
              ),
            );
          }
          return TextField(
            maxLines: null,
            keyboardType: TextInputType.multiline,
            focusNode: controller.focusNode,
            onChanged: (text) => eventFire(context, InputEvent.clickInput),
            onTap: () => eventFire(context, InputEvent.clickInput),
            style: text16,
            controller: controller.inputController,
            decoration: InputDecoration(
              isCollapsed: true,
              contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
              border: InputBorder.none,
              constraints: BoxConstraints(
                maxHeight: 144.h,
                minHeight: boxDefaultHeight,
              ),
            ),
          );
        }),
      ),
    );
  }

  /// 表情包按钮
  Widget _emojiBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickEmoji),
      child: _rightIcon(Icons.emoji_emotions_outlined),
    );
  }

  /// 更多操作
  Widget _moreBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickMore),
      child: _rightIcon(Icons.add),
    );
  }

  /// 语音按钮
  Widget _voiceBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickVoice),
      child: _leftIcon(Icons.settings_voice_outlined),
    );
  }

  /// 键盘按钮
  Widget _leftKeyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickKeyBoard),
      child: _leftIcon(Icons.keyboard_alt_outlined),
    );
  }

  /// 键盘按钮
  Widget _keyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickKeyBoard),
      child: _rightIcon(Icons.keyboard_alt_outlined),
    );
  }

  // 左侧 Icon
  Widget _leftIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h, right: 8.w),
      child: Icon(
        iconData,
        size: boxDefaultHeight,
      ),
    );
  }

  /// 右侧 Icon
  Widget _rightIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
      child: Icon(
        iconData,
        size: boxDefaultHeight,
      ),
    );
  }

  /// 发送按钮
  Widget _sendBtn(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 8.w),
      child: ElevatedButton(
        onPressed: () => eventFire(context, InputEvent.clickSendBtn),
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
      switch (inputStatus.value) {
        case InputStatus.emoji:
        case InputStatus.inputtingEmoji:
          bottomHeight.value = 220.h;
          body = _emojiPicker(context);
          break;
        case InputStatus.more:
          bottomHeight.value = 220.h;
          body = _more(context);
          break;
        case InputStatus.notPopup:
        case InputStatus.voice:
          return Container();
        case InputStatus.focusing:
        case InputStatus.inputtingText:
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
        eventFire(context, InputEvent.inputEmoji);
      },
    );
  }

  /// 更多功能
  Widget _more(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
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
        controller.execute(moreFunction, context);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5.w)),
            ),
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.only(bottom: 5.h),
            child: Icon(moreFunction.iconData),
          ),
          Text(moreFunction.name, style: text12Bold)
        ],
      ),
    );
  }

  /// 录音波动
  Widget _voiceWave() {
    return CustomPaint(
      size: Size(150.w, 150.w),
      painter: VoicePainter(),
    );
  }
}

// 控制下面的动画
class ChatBoxController extends FullLifeCycleController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Logger log = Logger("ChatBoxController");

  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode blankNode = FocusNode();

  final ImagePicker picker = ImagePicker();
  final Function sendCallback;
  final Function imageCallback;

  FlutterSoundRecorder? recorder;

  ChatBoxController({required this.sendCallback, required this.imageCallback});

  @override
  onClose() {
    super.onClose();
    inputController.dispose();
    focusNode.dispose();
    blankNode.dispose();
    if (recorder != null) {
      recorder!.closeRecorder();
      recorder = null;
    }
  }

  execute(MoreFunction moreFunction, BuildContext context) async {
    switch (moreFunction) {
      case MoreFunction.photo:
        var gallery = ImageSource.gallery;
        XFile? pickedImage = await picker.pickImage(source: gallery);
        if (pickedImage != null) {
          imageCallback(pickedImage);
        }
        break;
      case MoreFunction.camera:
        var camera = ImageSource.camera;
        try {
          XFile? pickedImage = await picker.pickImage(source: camera);
          if (pickedImage != null) {
            imageCallback(pickedImage);
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
        break;
    }
  }

  startRecord() async {
    recorder ??= await FlutterSoundRecorder().openRecorder();
    if (recorder == null) {
      return;
    }

    // 鉴权
    PermissionStatus permissionStatus = await Permission.microphone.request();
    if (permissionStatus != PermissionStatus.granted) {
      throw RecordingPermissionException("Microphone permission not granted");
    }

    await recorder!.startRecorder(toFile: "temp.mp4", codec: Codec.aacMP4);
    var directory = await getTemporaryDirectory();
    var file = File("${directory.path}/temp.mp4");
    log.info(file);
  }
}
