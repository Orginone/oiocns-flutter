import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'activity_comment_box.dart';
import 'target_activity_list.dart';

class TargetActivityView
    extends BaseGetView<TargetActivityViewController, TargetActivityViewState> {
  const TargetActivityView({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: _title(),
      actions: _actions(),
      body: ActivityCommentBox(
        body: const Expanded(child: TargetActivityList()),
      ),
    );
  }

  Widget _title() {
    return Column(
      children: [
        Text(state.activity.name, style: XFonts.size24Black3),
      ],
    );
  }

  List<Widget> _actions() {
    return <Widget>[
      GFIconButton(
        color: Colors.white.withOpacity(0),
        icon: Icon(
          Icons.more_vert,
          color: XColors.black3,
          size: 32.w,
        ),
        onPressed: () async {
          print(">>>===");
          // Get.toNamed(Routers.messageSetting, arguments: state.chat);
        },
      ),
    ];
  }
}

class TargetActivityViewController
    extends BaseController<TargetActivityViewState> {
  @override
  final TargetActivityViewState state = TargetActivityViewState();

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    Future.delayed(const Duration(milliseconds: 100), () {
      // markVisibleMessagesAsRead();
    });
  }

  @override
  void onClose() {
    // settingCtrl.chat.currentChat = null;
    super.onClose();
  }

  @override
  void onReceivedEvent(event) {
    super.onReceivedEvent(event);
    print(">>>");
    // if (event is JumpSpecifyMessage) {
    //   int index = state.chat.messages.indexOf(event.message);
    //   state.itemScrollController.jumpTo(index: index);
    // }
  }
}

class TargetActivityViewState extends BaseGetState {
  late IActivity activity;

  late GlobalKey scrollKey;

  final ItemScrollController itemScrollController = ItemScrollController();
  RxBool showCommentBox = false.obs;

  TargetActivityViewState() {
    activity = Get.arguments;
    scrollKey = GlobalKey();
  }

  refresh() async {}
}

class TargetActivityViewBinding
    extends BaseBindings<TargetActivityViewController> {
  @override
  TargetActivityViewController getController() {
    return TargetActivityViewController();
  }
}
