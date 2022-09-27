import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:orginone/config/custom_colors.dart';

import '../../../../../component/unified_edge_insets.dart';

double defaultHeight = 35.h;
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
      color: CustomColors.lightGrey,
      padding: EdgeInsets.fromLTRB(10.w, 5.h, 10.w, 5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _input(controller),
          Container(margin: EdgeInsets.only(left: 10.w)),
          _emoji(),
          Container(margin: EdgeInsets.only(left: 10.w)),
          _sendBtn(controller)
        ],
      ),
    );
  }

  Widget _input(TextEditingController controller) {
    return Expanded(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: defaultHeight,
          minHeight: defaultHeight,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(defaultBorderRadius)),
        ),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: left10,
            border: OutlineInputBorder(
              borderSide: const BorderSide(style: BorderStyle.none, width: 5),
              borderRadius: BorderRadius.all(
                Radius.circular(defaultBorderRadius),
              ),
            ),
            hintText: "请输入聊天信息",
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
      size: defaultHeight,
      onPressed: () {
        callback();
        controller.clear();
      },
      text: "发送",
    );
  }
}
