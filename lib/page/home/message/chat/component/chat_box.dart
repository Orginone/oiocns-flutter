import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';
import 'package:orginone/util/permission_util.dart';
import 'package:permission_handler/permission_handler.dart';

double defaultBorderRadius = 6.w;

enum BottomPopupType { emoji, more, inputting, notPopup }

enum MoreFunction {
  photo("相册", Icons.photo),
  camera("拍摄", Icons.camera_alt),
  voice("语音", Icons.keyboard_voice);

  final String name;
  final IconData iconData;

  const MoreFunction(this.name, this.iconData);
}

class ChatBox extends GetView<ChatBoxController> {
  final RxBool showSendBtn = false.obs;
  final Rx<BottomPopupType> bottomPopupType = BottomPopupType.notPopup.obs;

  ChatBox({Key? key}) : super(key: key);

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
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context), _moreBtn(context)],
          );
        case BottomPopupType.inputting:
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [_emojiBtn(context)],
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
              Obx(() => showSendBtn.value
                  ? Container(
                      margin: EdgeInsets.only(left: 8.w),
                      child: _sendBtn(inputController),
                    )
                  : Container()),
            ],
          ),
          _bottomPopup(inputController, context),
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
            var isEmpty = text.isEmpty;
            if (isEmpty) {
              showSendBtn.value = false;
              bottomPopupType.value = BottomPopupType.notPopup;
            } else {
              showSendBtn.value = true;
              bottomPopupType.value = BottomPopupType.inputting;
            }
          },
          onTap: () {
            bottomPopupType.value = BottomPopupType.inputting;
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
        bottomPopupType.value = BottomPopupType.inputting;
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
        size: 28.h,
      ),
    );
  }

  /// 发送按钮
  Widget _sendBtn(TextEditingController inputController) {
    return ElevatedButton(
      onPressed: () {
        controller.sendCallback(inputController.text);
        inputController.clear();
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
  Widget _bottomPopup(
      TextEditingController inputController, BuildContext context) {
    return Obx(() {
      late Widget body;
      switch (bottomPopupType.value) {
        case BottomPopupType.emoji:
          body = _emojiPicker(inputController);
          break;
        case BottomPopupType.more:
          body = _more(context);
          break;
        case BottomPopupType.notPopup:
          return Container();
        case BottomPopupType.inputting:
          body = Container();
          break;
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
    with GetSingleTickerProviderStateMixin {
  late AnimationController animationController;
  late CurvedAnimation curvedAnimation;
  late Animation<Offset> slideTransition;
  final ImagePicker picker = ImagePicker();

  final Function sendCallback;
  final Function imageCallback;

  ChatBoxController({required this.sendCallback, required this.imageCallback});

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
