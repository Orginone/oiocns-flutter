import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:getwidget/components/button/gf_icon_button.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/getx/base_bindings.dart';
import 'package:orginone/dart/core/getx/base_controller.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/getx/base_get_view.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'target_activity_list.dart';

/// 动态
// class TargetActivity extends StatelessWidget {
//   late IActivity activity;

//   TargetActivity({super.key}) {
//     activity = Get.arguments;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: Column(
//       children: [
//         Row(
//           children: [
//             const Flexible(child: Text("全部动态")),
//             Flexible(
//                 child: Offstage(
//               offstage: activity.allPublish,
//               child: TextButton(
//                   onPressed: () {
//                     //pubActivity
//                     // Get.toNamed(Routers.importWallet);
//                   },
//                   child: const Text("发布动态")),
//             ))
//           ],
//         ),
//         ActivityBody(
//           activity: activity,
//         ),
//       ],
//     ));
//   }
// }

// class TargetActivity extends StatefulWidget {
//   late IActivity activity;
//   TargetActivity({super.key}) {
//     activity = Get.arguments;
//   }
//   @override
//   _ActivityBodyState createState() => _ActivityBodyState();
// }

// class _ActivityBodyState extends State<TargetActivity> {
//   bool _isRefreshing = false;
//   List<int> _items = [];
//   final ScrollController _scrollController = ScrollController();

//   @override
//   Widget build(BuildContext context) {
//     setState(() {
//       _isRefreshing = false;
//       // 在这里执行加载更多数据的操作。
//       // 这里简单地将列表中的数据增加一些。
//       _items = List<int>.generate(100, (d) => d);
//     });
//     return Container(
//       child: RefreshIndicator(
//         onRefresh: () async {
//           if (_isRefreshing) return;
//           _isRefreshing = true;
//           // 在这里执行刷新操作，比如重新获取数据等。
//           // 假设这里是一些简单的延迟操作来模拟刷新。
//           await Future.delayed(const Duration(seconds: 3));
//           // 刷新完成后，重置状态。
//           setState(() {
//             _isRefreshing = false;
//             // 在这里执行加载更多数据的操作。
//             // 这里简单地将列表中的数据增加一些。
//             _items = List<int>.generate(100, (d) => d);
//           });
//         },
//         child: ListView.builder(
//           controller: _scrollController,
//           itemCount: _items.length,
//           itemBuilder: (context, index) {
//             return Text('Item ${_items[index]}');
//           },
//           // physics: const ClampingScrollPhysics(),
//         ),
//       ),
//     );
//   }
// }

class TargetActivityView
    extends BaseGetView<TargetActivityViewController, TargetActivityViewState> {
  const TargetActivityView({super.key});

  @override
  Widget buildView() {
    return GyScaffold(
      titleWidget: _title(),
      actions: _actions(),
      body: GestureDetector(
        onTap: () {},
        child: const Column(
          children: [
            Expanded(child: TargetActivityList()),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    // String name = state.chat.chatdata.value.chatName ?? "";
    // if (state.chat.memberChats.length > 1) {
    //   name += "(${state.chat.memberChats.length})";
    // }
    // var spaceName = state.chat.chatdata.value.labels.join(" | ");
    return Column(
      children: [
        Text(state.activity.name, style: XFonts.size24Black3),
        // Text(spaceName, style: XFonts.size16Black9),
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
