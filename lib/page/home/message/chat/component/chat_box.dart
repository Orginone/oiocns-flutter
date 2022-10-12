import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logging/logging.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:permission_handler/permission_handler.dart';

double defaultBorderRadius = 6.w;

enum InputStatus {
  notPopup,
  focusing,
  emoji,
  more,
  inputtingText,
  inputtingEmoji
}

enum InputEvent {
  clickInput,
  clickEmoji,
  clickKeyBoard,
  clickMore,
  inputText,
  inputEmoji,
  clickSendBtn
}

enum MoreFunction {
  photo("相册", Icons.photo),
  camera("拍摄", Icons.camera_alt),
  voice("语音", Icons.keyboard_voice);

  final String name;
  final IconData iconData;

  const MoreFunction(this.name, this.iconData);
}

class ChatBox extends GetView<ChatBoxController> with WidgetsBindingObserver {
  final Rx<InputStatus> inputStatus = InputStatus.notPopup.obs;
  final RxDouble bottomHeight = 220.h.obs;

  ChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget func = Obx(() {
      switch (inputStatus.value) {
        case InputStatus.notPopup:
        case InputStatus.focusing:
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
            children: [_input(context), func],
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
        if (inputEvent == InputEvent.clickKeyBoard) {
          FocusScope.of(context).requestFocus(controller.focusNode);
        }
        break;
      case InputEvent.clickEmoji:
        FocusScope.of(context).requestFocus(FocusNode());
        var text = controller.inputController.value.text;
        if (text.isNotEmpty) {
          inputStatus.value = InputStatus.inputtingEmoji;
        } else {
          inputStatus.value = InputStatus.emoji;
        }
        break;
      case InputEvent.clickMore:
        FocusScope.of(context).requestFocus(FocusNode());
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
        child: TextField(
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
            constraints: BoxConstraints(maxHeight: 144.h, minHeight: 28.h),
          ),
        ),
      ),
    );
  }

  /// 表情包按钮
  Widget _emojiBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickEmoji),
      child: _defaultIcon(Icons.emoji_emotions_outlined),
    );
  }

  /// 更多操作
  Widget _moreBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickMore),
      child: _defaultIcon(Icons.add),
    );
  }

  /// 键盘按钮
  Widget _keyBoardBtn(BuildContext context) {
    return GestureDetector(
      onTap: () => eventFire(context, InputEvent.clickKeyBoard),
      child: _defaultIcon(Icons.keyboard_alt_outlined),
    );
  }

  /// 默认 Icon
  Widget _defaultIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
      child: Icon(
        iconData,
        size: 28.h,
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
          minimumSize: MaterialStateProperty.all(Size(10, 28.h)),
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
          return Container();
        case InputStatus.focusing:
        case InputStatus.inputtingText:
          body = Container();
          break;
      }
      return Offstage(
        offstage: false,
        child: Obx(() => SizedBox(
              height: bottomHeight.value,
              child: body,
            )),
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
}

// 控制下面的动画
class ChatBoxController extends FullLifeCycleController
    with GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  final Logger log = Logger("ChatBoxController");

  final TextEditingController inputController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  final ImagePicker picker = ImagePicker();
  final Function sendCallback;
  final Function imageCallback;

  ChatBoxController({required this.sendCallback, required this.imageCallback});

  @override
  onClose() {
    super.onClose();
    inputController.dispose();
    focusNode.dispose();
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
      case MoreFunction.voice:
        break;
    }
  }
}
