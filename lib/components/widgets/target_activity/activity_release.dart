import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/pages/chat/widgets/text/at_textfield.dart';

///发布动态
class ActivityRelease extends OrginoneStatefulWidget<IActivity> {
  ActivityRelease({super.key});
  @override
  State<StatefulWidget> createState() => _ActivityReleaseState();
}

class _ActivityReleaseState
    extends OrginoneStatefulState<ActivityRelease, IActivity> {
  @override
  Widget buildWidget(BuildContext context, IActivity data) {
    return Column(
      children: [
        _buildInputBox(context, data),
      ],
    );
  }

  @override
  List<Widget>? buildButtons(BuildContext context, IActivity data) {
    return [
      GestureDetector(
        onTap: () {},
        child: Text(
          "发送",
          style: TextStyle(color: XColors.themeColor, fontSize: 20.sp),
        ),
      )
    ];
  }

  ///构建文本输入框
  Widget _buildInputBox(BuildContext context, IActivity data) {
    return const TextField();
  }
}
