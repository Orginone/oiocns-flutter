import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/component/unified_text_style.dart';
import 'package:orginone/config/custom_colors.dart';

double defaultBorderRadius = 6.w;

class CustomView extends EmojiPickerBuilder {
  CustomView(super.config, super.state, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CustomViewState();
}

class _CustomViewState extends State<CustomView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ChatBox extends StatelessWidget {
  final Function callback;

  const ChatBox(this.callback, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Container(
      color: CustomColors.easyGrey,
      padding: EdgeInsets.fromLTRB(10.w, 0.h, 10.w, 0.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _input(controller),
          Container(margin: EdgeInsets.only(left: 10.w)),
          _sendBtn(controller)
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
          style: text16,
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

  Widget _emoji() {
    return EmojiPicker(
      onEmojiSelected: (category, emoji) {},
    );
  }

  Widget _sendBtn(TextEditingController controller) {
    return GFButton(
      constraints: BoxConstraints(maxWidth: 10.w, minWidth: 10.w),
      size: 25.h,
      onPressed: () {
        callback(controller.text);
        controller.clear();
      },
      text: "发送",
    );
  }
}
