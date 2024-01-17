import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:orginone/common/routers/index.dart';
import 'package:orginone/components/modules/general_bread_crumbs/index.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/target/base/target.dart';
import 'package:orginone/dart/core/target/base/team.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';
import 'package:orginone/main_bean.dart';
import 'package:orginone/pages/chat/widgets/avatars.dart';
import 'package:orginone/pages/relation/widgets/dialog.dart';
import 'package:orginone/utils/toast_utils.dart';
import 'package:orginone/components/widgets/gy_scaffold.dart';
import 'package:orginone/components/widgets/choose_item.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/components/widgets/team_avatar.dart';

Size defaultBtnSize = Size(400.w, 70.h);

class MessageSetting extends GetView<IndexController> {
  const MessageSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GyScaffold(
      body: _body(context, Get.arguments),
    );
  }

  Widget _body(BuildContext context, ISession chat) {
    List<Widget> children = [];
    if (chat.share.typeName == TargetType.person.label) {
      children = [
        _avatar(chat),
        Padding(padding: EdgeInsets.only(top: 30.h)),
        // _interruption,
        // _top,
        _file(chat),
        _searchChat(chat),
      ];
    } else {
      children = [
        _avatar(chat),
        Padding(padding: EdgeInsets.only(top: 50.h)),
        // Obx(() {
        //   return
        Avatars(
          showCount: 15,
          persons: chat.members,
          hasAdd: true,
          addCallback: () {
            var target =
                TargetType.getType(chat.share.typeName) == TargetType.group
                    ? TargetType.company
                    : TargetType.person;
            showSearchDialog(context, target, title: "邀请成员", hint: "请输入用户的账号",
                onSelected: (targets) async {
              if (targets.isNotEmpty) {
                var success = await (chat as ITeam).pullMembers(targets);
                if (success) {
                  ToastUtils.showMsg(msg: "邀请成功");
                }
              } else {
                ToastUtils.showMsg(msg: "未选择用户");
              }
            });
          },
        ),
        // }),
        // _interruption,
        // _top,
        _file(chat),
        _searchChat(chat),
      ];
    }

    // 如果是群组,就有退出群组
    // var isPerson = chat.share.typeName != TargetType.person.label;
    // if (isPerson) {
    //   children.add(Padding(padding: EdgeInsets.only(top: 20.h)));
    //   children.add(_exitTarget(context, chat));
    // }
    //
    // // 个人空间的, 有特殊按钮
    // if (chat.belongId == controller.user.metadata.id) {
    //   // 如果是好友, 添加删除好友功能
    //   if (isPerson) {
    //     children.add(Padding(padding: EdgeInsets.only(top: 20.h)));
    //     children.add(_exitTarget(context, chat));
    //   }
    //   // 个人空间可以清空会话
    //   children.add(Padding(padding: EdgeInsets.only(top: 20.h)));
    //   children.add(_clear(context, chat));
    // }
    return Container(
      color: XColors.bgChat,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 30.w, right: 30.w),
              color: Colors.white,
              child: Column(
                children: children,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            _clear(context, chat),
          ],
        ),
      ),
    );
  }

  /// 头像相关
  Widget _avatar(ISession chat) {
    var messageItem = chat.chatdata;
    String name = messageItem.value.chatName ?? "";
    if (messageItem.value.labels.contains(TargetType.person.label) ?? false) {
      name += "(${chat.members.length})";
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TeamAvatar(info: TeamTypeInfo(userId: chat.sessionId)),
        Padding(padding: EdgeInsets.only(left: 10.w)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: XFonts.size22Black3W700),
              Text(
                messageItem.value.chatRemark ?? "",
                style: XFonts.size16Black6,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        )
      ],
    );
  }

  /// 消息免打扰
  get _interruption {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Text(
        "消息免打扰",
        style: XFonts.size20Black3W700,
      ),
      operate: Switch(value: false, onChanged: (value) {}),
    );
  }

  /// 置顶聊天
  get _top {
    return ChooseItem(
      padding: EdgeInsets.zero,
      header: Text(
        "置顶聊天",
        style: XFonts.size20Black3W700,
      ),
      operate: Switch(
        value: false,
        onChanged: (value) {},
      ),
    );
  }

  /// 查找聊天记录
  Widget _searchChat(ISession chat) {
    return ChooseItem(
      func: () {
        Get.toNamed(Routers.messageRecords, arguments: {"chat": chat});
      },
      padding: EdgeInsets.symmetric(vertical: 15.h),
      header: Text(
        "查找聊天记录",
        style: XFonts.size20Black3W700,
      ),
      operate: Icon(
        Icons.keyboard_arrow_right,
        size: 32.w,
      ),
    );
  }

  Widget _file(ISession chat) {
    return ChooseItem(
      func: () async {
        List<GeneralBreadcrumbNav> navs = [];
        IDirectory dir;
        if (chat.share.typeName == TargetType.person.label) {
          dir = relationCtrl.user.directory;
          navs = await _buildNav([dir], relationCtrl.user);
        } else {
          dir = (chat as ITarget).directory;
          navs = await _buildNav([dir], chat.target);
        }
        Get.toNamed(Routers.generalBreadCrumbs,
            arguments: {"data": navs.first});
      },
      padding: EdgeInsets.symmetric(vertical: 15.h),
      header: Text(
        "共享目录",
        style: XFonts.size20Black3W700,
      ),
      operate: Icon(
        Icons.keyboard_arrow_right,
        size: 32.w,
      ),
    );
  }

  /// 清空聊天记录
  Widget _clear(BuildContext context, ISession chat) {
    return GestureDetector(
      onTap: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text("您确定清空与${chat.chatdata.value.chatName}的聊天记录吗?"),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.pop(context);
                    await chat.clearMessage();
                    Fluttertoast.showToast(msg: "清空成功!");
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 150.w),
        decoration: BoxDecoration(
            color: XColors.themeColor,
            borderRadius: BorderRadius.circular(32.w)),
        child: Text(
          "清空聊天记录",
          style: XFonts.size22WhiteW700,
        ),
      ),
    );
  }

  /// 删除好友
  Widget _exitTarget(BuildContext context, ISession chat) {
    String remark = "";
    String btnName = "";
    if (chat.chatdata.value.labels.contains(TargetType.person.label) ?? false) {
      remark = "您确定删除好友${chat.chatdata.value.chatName}吗?";
      btnName = "删除好友";
    } else {
      remark = "您确定退出${chat.chatdata.value.chatName}吗?";
      btnName = "退出群聊";
    }
    return ElevatedButton(
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(defaultBtnSize),
        backgroundColor: MaterialStateProperty.all(XColors.backColor),
      ),
      onPressed: () {
        showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(remark),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('取消'),
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('确定'),
                  onPressed: () async {
                    Navigator.pop(context);
                    Get.until((route) => route.settings.name == Routers.home);
                  },
                ),
              ],
            );
          },
        );
      },
      child: Text(btnName, style: XFonts.size22WhiteW700),
    );
  }

  Future<List<GeneralBreadcrumbNav>> _buildNav(
      List<IDirectory> dirs, ITarget target) async {
    List<GeneralBreadcrumbNav> navs = [];
    for (var dir in dirs) {
      await Future.wait([dir.loadDirectoryResource(), dir.loadFiles()]);
      var nav = GeneralBreadcrumbNav(
        id: dir.metadata.id ?? "",
        name: dir.metadata.name ?? "",
        source: dir,
        spaceEnum: SpaceEnum.directory,
        space: target,
        onNext: (item) async {
          item.children = [
            ...dir.files.map((e) {
              return GeneralBreadcrumbNav(
                id: e.metadata.id ?? "",
                name: e.metadata.name ?? "",
                spaceEnum: SpaceEnum.file,
                image: (e as SysFileInfo).shareInfo().thumbnail,
                space: target,
                source: e,
                children: [],
              );
            }).toList(),
            ...await _buildNav(dir.children, target),
          ];
        },
        children: [
          ...dir.files.map((e) {
            return GeneralBreadcrumbNav(
              id: e.metadata.id ?? "",
              name: e.metadata.name ?? "",
              spaceEnum: SpaceEnum.file,
              space: target,
              source: e,
              children: [],
            );
          }).toList(),
          ...await _buildNav(dir.children, target),
        ],
      );
      navs.add(nav);
    }

    return navs;
  }
}
