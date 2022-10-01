import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';

double defaultBorderRadius = 6.w;

class ChatBox extends StatelessWidget {
  final Function callback;
  final RxBool showEmoji = false.obs;
  final RxBool showSendBtn = false.obs;

  ChatBox(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      color: CustomColors.easyGrey,
      padding: EdgeInsets.fromLTRB(10.w, 2.h, 10.w, 2.h),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _input(controller),
              _emoji(context),
              Obx(() => showSendBtn.value ? _sendBtn(controller) : Container()),
            ],
          ),
          _emojiPicker(controller)
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          onChanged: (text) {
            showSendBtn.value = text.isNotEmpty;
          },
          onTap: () {
            showEmoji.value = false;
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

  Widget _emoji(BuildContext context) {
    return IconButton(
      onPressed: () {
        bool target = !showEmoji.value;
        if (target) {
          FocusScope.of(context).requestFocus(FocusNode());
          Future.delayed(const Duration(milliseconds: 200), () {
            showEmoji.value = target;
          });
        }
      },
      icon: Icon(
        Icons.emoji_emotions_outlined,
        size: 28.w,
      ),
    );
  }

  Widget _emojiPicker(TextEditingController controller) {
    return Obx(
      () => Offstage(
        offstage: !showEmoji.value,
        child: SizedBox(
          height: 250.h,
          child: EmojiPicker(
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
          ),
        ),
      ),
    );
  }

  Widget _sendBtn(TextEditingController controller) {
    return ElevatedButton(
      onPressed: () {
        callback(controller.text);
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
}
