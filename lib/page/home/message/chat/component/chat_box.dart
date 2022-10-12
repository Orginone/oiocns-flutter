import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';

double defaultBorderRadius = 6.w;

enum BottomPopupType { emoji, more, keyboard, notPopup }

enum MoreFunction {
  photo("相册", Icons.photo),
  camera("拍摄", Icons.camera_alt),
  voice("语音", Icons.keyboard_voice);

  final String name;
  final IconData iconData;

  const MoreFunction(this.name, this.iconData);
}

class ChatBox extends GetView<ChatBoxController> {
  final Function sendCallback;
  final RxBool showSendBtn = false.obs;
  final Rx<BottomPopupType> bottomPopupType = BottomPopupType.notPopup.obs;

  ChatBox(this.sendCallback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var inputController = TextEditingController();
    var focusNode = FocusNode();
    Widget func = Obx(() {
      switch (bottomPopupType.value) {
        case BottomPopupType.emoji:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_keyBoardBtn(context, focusNode), _moreBtn(context)],
          );
        case BottomPopupType.more:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _moreBtn(context)],
          );
        case BottomPopupType.notPopup:
        case BottomPopupType.keyboard:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _moreBtn(context)],
          );
      }
    });

    return Container(
      color: CustomColors.easyGrey,
      padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _input(inputController, focusNode),
              func,
              Obx(() =>
                  showSendBtn.value ? _sendBtn(inputController) : Container()),
            ],
          ),
          _bottomPopup(inputController),
        ],
      ),
    );
  }

  /// 输入
  Widget _input(TextEditingController controller, FocusNode focusNode) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          focusNode: focusNode,
          onChanged: (text) {
            showSendBtn.value = text.isNotEmpty;
          },
          onTap: () {
            bottomPopupType.value = BottomPopupType.notPopup;
          },
          style: text18,
          controller: controller,
          decoration: InputDecoration(
            isCollapsed: true,
            contentPadding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  /// 表情包按钮
  Widget _emojiBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        bottomPopupType.value = BottomPopupType.emoji;
      },
      child: _defaultIcon(Icons.emoji_emotions_outlined),
    );
  }

  /// 键盘按钮
  Widget _keyBoardBtn(BuildContext context, FocusNode focusNode) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(focusNode);
        bottomPopupType.value = BottomPopupType.keyboard;
      },
      child: _defaultIcon(Icons.keyboard_alt_outlined),
    );
  }

  /// 更多操作
  Widget _moreBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
        bottomPopupType.value = BottomPopupType.more;
      },
      child: _defaultIcon(Icons.add),
    );
  }

  Widget _defaultIcon(IconData iconData) {
    return Container(
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 8.h),
      child: Icon(
        iconData,
        size: 28.w,
      ),
    );
  }

  /// 发送按钮
  Widget _sendBtn(TextEditingController controller) {
    return ElevatedButton(
      onPressed: () {
        sendCallback(controller.text);
        controller.clear();
        showSendBtn.value = false;
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
        minimumSize: MaterialStateProperty.all(Size(10, 28.h)),
      ),
      child: const Text("发送"),
    );
  }

  /// 下面的弹出框
  Widget _bottomPopup(TextEditingController inputController) {
    return Obx(() {
      late Widget body;
      switch (bottomPopupType.value) {
        case BottomPopupType.emoji:
          body = _emojiPicker(inputController);
          break;
        case BottomPopupType.more:
          body = _more();
          break;
        case BottomPopupType.notPopup:
        case BottomPopupType.keyboard:
          return Container();
      }
      return Offstage(
        offstage: false,
        child: SizedBox(height: 220.h, child: body),
      );
    });
  }

  /// 表情包选择
  Widget _emojiPicker(TextEditingController controller) {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {
        controller
          ..text += emoji.emoji
          ..selection = TextSelection.fromPosition(
            TextPosition(
              offset: controller.text.length,
            ),
          );
        showSendBtn.value = true;
      },
    );
  }

  /// 更多功能
  Widget _more() {
    return Container(
      padding: EdgeInsets.only(top: 20.h),
      child: GridView.count(
        shrinkWrap: true,
        mainAxisSpacing: 10.w,
        scrollDirection: Axis.vertical,
        crossAxisCount: 4,
        children: MoreFunction.values.map((item) => _funcIcon(item)).toList(),
      ),
    );
  }

  /// 功能点
  Widget _funcIcon(MoreFunction moreFunction) {
    return GestureDetector(
      onTap: () {
        controller.execute(moreFunction);
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
class ChatBoxController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;
  late Animation<Offset> slideTransition;
  final ImagePicker picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    slideTransition = Tween(
      begin: const Offset(0, 1),
      end: const Offset(0, 0),
    ).animate(curvedAnimation);
  }

  execute(MoreFunction moreFunction) async {
    switch (moreFunction) {
      case MoreFunction.photo:
        var gallery = ImageSource.gallery;
        await picker.pickImage(source: gallery);
        break;
      case MoreFunction.camera:
        var camera = ImageSource.camera;
        await picker.pickImage(source: camera);
        break;
      case MoreFunction.voice:
        break;
    }
  }
}
