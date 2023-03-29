import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/components/template/choose_item.dart';
import 'package:orginone/components/template/tabs.dart';
import 'package:orginone/components/unified.dart';
import 'package:orginone/components/widgets/team_avatar.dart';
import 'package:orginone/components/widgets/text_avatar.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/chat/chat_controller.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/pages/chat/widgets/message_item_widget.dart';
import 'package:orginone/routers.dart';

class MessagePage extends GetView<MessageController> {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tabs(
      tabCtrl: controller.tabController,
      top: TabBar(
        controller: controller.tabController,
        tabs: controller.tabs.map((item) => item.toTab()).toList(),
      ),
      views: controller.tabs.map((item) => item.toTabView()).toList(),
    );
  }
}

class MessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MessageController());
  }
}

class MessageController extends TabsController {
  var chatCtrl = Get.find<ChatController>();

  @override
  initTabs() {
    registerTab(XTab(
      view: const Recent(),
      body: Container(
        alignment: Alignment.center,
        width: 100.w,
        child: Text("会话", style: XFonts.size22Black3),
      ),
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: Obx(() => chatCtrl.hasNoRead()
              ? Icon(Icons.circle, color: Colors.redAccent, size: 10.w)
              : Container()),
        )
      ],
    ));
    registerTab(XTab(
      view: const Relation(),
      body: Text("通讯录", style: XFonts.size22Black3),
    ));
  }
}

class Recent extends GetView<ChatController> {
  const Recent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int chatSize = controller.getChatSize();
      return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: chatSize + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < chatSize) {
            var chat = controller.chats[index];
            return MessageItemWidget(chat: chat, remove: controller.removeChat);
          }
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routers.moreMessage);
            },
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 30.h)),
                Text("更多会话", style: XFonts.size18Theme),
                Padding(padding: EdgeInsets.only(top: 30.h)),
              ],
            ),
          );
        },
      );
    });
  }
}

class Relation extends GetView<ChatController> {
  const Relation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _relation();
  }

  Widget _relation() {
    List<Widget> children = [];
    children.addAll(_recent());
    children.add(Padding(padding: EdgeInsets.only(top: 10.h)));
    children.add(Divider(height: 1.h));
    children.add(Padding(padding: EdgeInsets.only(top: 10.h)));
    // children.add(_tree());
    children.add(_links());
    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 25.w),
      child: Column(children: children),
    );
  }

  // Widget _tree() {
  //   var settingCtrl = Get.find<SettingController>();
  //   return Obx(() {
  //     double leftWidth = 60.w;
  //     // 选择项
  //     List<Widget> body = [];
  //     body.add(ChooseItem(
  //       padding: EdgeInsets.zero,
  //       header: Container(
  //         alignment: Alignment.center,
  //         width: leftWidth,
  //         child: TextTag(
  //           settingCtrl.isCompanySpace() ? "单位" : "个人",
  //           padding: EdgeInsets.all(4.w),
  //           textStyle: XFonts.size12Theme,
  //           borderColor: XColors.themeColor,
  //           bgColor: Colors.white,
  //         ),
  //       ),
  //       body: Container(
  //         margin: EdgeInsets.only(left: 15.w),
  //         child: Text(
  //           settingCtrl.space.name,
  //           style: XFonts.size22Black3W700,
  //         ),
  //       ),
  //       func: () {
  //         if (settingCtrl.isUserSpace()) {
  //           Get.toNamed(Routers.friends);
  //         } else {
  //           Get.toNamed(Routers.dept, arguments: auth.spaceId);
  //         }
  //       },
  //     ));
  //
  //     if (settingCtrl.isCompanySpace()) {
  //       NodeCombine? nodeCombine = settingCtrl.company.tree;
  //       if (nodeCombine != null) {
  //         TreeNode topNode = nodeCombine.topNode;
  //         var children = topNode.children;
  //         double top = 16.h;
  //         if (children.isNotEmpty) {
  //           body.add(Padding(padding: EdgeInsets.only(top: top)));
  //           body.add(_deptItem(children[0], leftWidth));
  //           if (children.length > 1) {
  //             body.add(Padding(padding: EdgeInsets.only(top: top)));
  //             body.add(_deptItem(children[1], leftWidth));
  //             if (children.length > 2) {
  //               body.add(Padding(padding: EdgeInsets.only(top: top)));
  //               body.add(_more(leftWidth));
  //             }
  //           }
  //         }
  //       }
  //     }
  //     return Column(children: body);
  //   });
  // }

  Widget _links() {
    double top = 12.h;
    return Column(
      children: [
        Padding(padding: EdgeInsets.only(top: top)),
        _otherUnits,
        Padding(padding: EdgeInsets.only(top: top)),
        // _chats,
        // Padding(padding: EdgeInsets.only(top: top)),
        Divider(height: 1.h),
        Padding(padding: EdgeInsets.only(top: top)),
        _newFriends,
        // Padding(padding: EdgeInsets.only(top: top)),
        // _specialFocus,
        Padding(padding: EdgeInsets.only(top: top)),
        _myRelation,
        Padding(padding: EdgeInsets.only(top: top)),
        _myCohort,
      ],
    );
  }

  List<Widget> _recent() {
    double avatarWidth = 60.w;
    return [
      Container(margin: EdgeInsets.only(top: 4.h)),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("最近联系", style: XFonts.size20Black3W700),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routers.moreMessage);
            },
            child: Text("更多会话", style: XFonts.size18ThemeW700),
          )
        ],
      ),
      Container(
        margin: EdgeInsets.only(top: 10.h),
        height: avatarWidth,
        child: Obx(
          () => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.getChatSize(),
            itemBuilder: (context, index) {
              var chat = controller.chats[index];
              return GestureDetector(
                onTap: () async {
                  await controller.setCurrent(chat.spaceId, chat.chatId);
                  if (controller.chat == null) {
                    Fluttertoast.showToast(msg: "未获取到会话信息！");
                    return;
                  }
                  Get.toNamed(Routers.chat);
                },
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(6.w)),
                  ),
                  margin: EdgeInsets.only(right: 15.w),
                  child: TeamAvatar(
                    size: avatarWidth,
                    info: TeamTypeInfo(share: chat.shareInfo),
                    child: Text(
                      chat.target.name.substring(0, 1),
                      style: XFonts.size16WhiteW700,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      )
    ];
  }

  // Widget _deptItem(TreeNode treeNode, double leftWidth) {
  //   return ChooseItem(
  //     padding: EdgeInsets.zero,
  //     header: Container(
  //       alignment: Alignment.centerRight,
  //       width: leftWidth,
  //       child: const Icon(Icons.arrow_right),
  //     ),
  //     body: Container(
  //       margin: EdgeInsets.only(left: 10.w),
  //       child: Text(treeNode.label, style: XFonts.size18Black3),
  //     ),
  //     func: () {
  //       Get.toNamed(Routers.dept, arguments: treeNode.id);
  //     },
  //   );
  // }
  //
  // Widget _more(double leftWidth) {
  //   return ChooseItem(
  //     padding: EdgeInsets.zero,
  //     header: Container(width: leftWidth),
  //     body: Container(
  //       margin: EdgeInsets.only(left: 10.w),
  //       child: Text("更多", style: XFonts.size16Black0),
  //     ),
  //     func: () {
  //       Get.toNamed(Routers.dept);
  //     },
  //   );
  // }

  Widget _header(IconData icon) {
    return AdvancedAvatar(
      size: 60.w,
      decoration: BoxDecoration(
        color: XColors.themeColor,
        borderRadius: BorderRadius.all(Radius.circular(8.w)),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  get _otherUnits => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("其他单位", style: XFonts.size22Black3W700),
        ),
        func: () {
          Get.toNamed(Routers.mineUnit);
        },
      );

  get _chats => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("奥集能通讯录", style: XFonts.size22Black3W700),
        ),
        func: () {},
      );

  get _newFriends => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("新朋友", style: XFonts.size22Black3W700),
        ),
        func: () {
          Get.toNamed(Routers.newFriends);
        },
      );

  get _specialFocus => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("特别关注", style: XFonts.size22Black3W700),
        ),
        func: () {},
      );

  get _myRelation => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("我的联系人", style: XFonts.size22Black3W700),
        ),
        func: () {
          Get.toNamed(Routers.contact);
        },
      );

  get _myCohort => ChooseItem(
        padding: EdgeInsets.zero,
        header: _header(Icons.group),
        body: Container(
          margin: EdgeInsets.only(left: 15.w),
          child: Text("我的群组", style: XFonts.size22Black3W700),
        ),
        func: () {
          if (Get.isRegistered<SettingController>()) {
            var settingCtrl = Get.find<SettingController>();
            settingCtrl.user?.getCohorts();
          }
          Get.toNamed(Routers.cohorts);
        },
      );
}

class TreeNode {
  String id;
  String label;
  bool hasNodes;
  XTarget data;
  List<TreeNode> children;

  TreeNode.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        label = map["label"],
        hasNodes = map["hasNodes"],
        data = XTarget.fromJson(map["data"]),
        children = <TreeNode>[];

  static TreeNode fromNode(
    Map<String, dynamic> node,
    Map<String, TreeNode> index,
  ) {
    TreeNode treeNode = TreeNode.fromMap(node);
    index.putIfAbsent(treeNode.id, () => treeNode);
    List<dynamic> mapChildren = node["children"] ?? [];
    if (mapChildren.isNotEmpty) {
      var nodes = mapChildren.map((item) => fromNode(item, index)).toList();
      treeNode.children.addAll(nodes);
    }
    return treeNode;
  }
}

class NodeCombine {
  final TreeNode topNode;
  final Map<String, TreeNode> index;

  const NodeCombine(this.topNode, this.index);
}
