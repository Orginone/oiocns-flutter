import 'package:flutter/widgets.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/chat/activity.dart';

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
    return Container();
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
}
