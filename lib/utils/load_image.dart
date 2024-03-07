import 'package:flutter/material.dart' hide SearchBar;
import 'dart:math';

import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/common/extension/ex_widget.dart';
import 'package:orginone/components/widgets/common/image/image_widget.dart';
import 'package:orginone/components/widgets/common/image/team_avatar.dart';
import 'package:orginone/config/space.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/model.dart' hide Column;
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';
import 'package:orginone/dart/core/work/index.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/pages/home/components/search_bar.dart';

import 'icons.dart';

///系统图片图标访问类
class XImage {
  // XImage._();

  ///操作图标
  static final Map<String, Widget> _operationsIconWidgets = {
    XImage.search: _searchWidget,
    XImage.scan: _qrScanWidget,
    XImage.add: _moreWidget,
    XImage.startWork: _startWorkWidget,
    XImage.joinGroup: _joinGroupWidget,
    XImage.addStorage: _addStorageWidget,
  };

  ///头像随机背景色
  static final List<List<Color>> colors = [
    [const Color(0xFF0060FF), const Color(0xFF0091FB)],
    [const Color(0xFF2BA471), const Color(0xFF00CD77)],
    [const Color(0xFFD54941), const Color(0xFFFF2A1E)],
    [const Color(0xFFE36118), const Color(0xFFFF7200)]
  ];

  ///系统logo
  static const String logo = "assets/images/logo.png";
  static const String scanLogin = "assets/images/scanLogin.png";
  static const String emptyPage = "";
  static const String emptyChat = "assets/images/empty/empty_chat.png";
  static const String emptyFile = "assets/images/empty/empty_file.png";
  static const String emptyActivity = "assets/images/empty/empty_activity.png";
  //================================================================== navbar
  ///沟通
  static const String chat = "chat";

  ///办事
  static const String work = "work";

  ///门户
  static const String home = "home";

  ///数据（存储）
  static const String store = "store";

  ///关系
  static const String relation = "relation";

  //================================================================== topbar
  ///沟通线条
  static const String chatOutline = "chatOutline";

  ///成员线条
  static const String memberOutline = "memberOutline";

  // ///关系线条
  // static const String relationOutline = "relationOutline";

  ///动态线条
  static const String dynamicOutline = "dynamicOutline";

  ///文件线条
  static const String fileOutline = "fileOutline";

  ///设置线条
  static const String settingOutline = "settingOutline";
  //================================================================== toolbar

  ///搜索
  static const String search = "search";

  ///扫码
  static const String scan = "scan";

  ///新增
  static const String add = "add";

  ///发起办事
  static const String startWork = "startWork";

  ///添加存储
  static const String addStorage = "addStorage";

  //================================================================== operate

  ///动态-操作按钮
  ///
  ///点赞线条
  static const String likeOutline = "likeOutLine";

  ///点赞填充
  static const String likeFill = "likeFill";

  ///删除
  static const String deleteOutline = "deleteOutline";

  ///评论线条
  static const String commentOutline = "commentOutline";

  ///沟通-操作按钮
  ///
  ///转发
  static const String forward = "forward";

  ///复制
  static const String copyOutline = "copyOutline";

  ///引用
  static const String quote = "quote";

  ///撤回
  static const String recall = "recall";

  ///事项提醒-工作台
  ///
  ///办事
  static const String homeWork = "homeWork";

  ///任务
  static const String homeTask = "homeTask";

  ///提醒
  static const String homeRemind = "homeRemind";

  ///未读消息
  static const String homeChat = "homeChat";

  ///快捷操作-工作台
  ///
  ///添加好友
  static const String addFriend = "addFriend";

  ///创建群组
  static const String createGroup = "createGroup";

  ///加入群组
  static const String joinGroup = "joinGroup";

  ///申请存储
  static const String applyStorage = "applyStorage";

  ///设立单位
  static const String establishmentUnit = "establishmentUnit";

  ///加入单位
  static const String joinUnit = "joinUnit";

  ///工作台
  static const String more = "more";

  // ///设置
  // static const String settings = "settings";

  //================================================================== types/folders
  ///属性
  static const String folderProperties = "folderProperties";

  ///分类
  static const String folderClassification = "folderClassification";

  ///字典
  static const String folderDictionary = "folderDictionary";

  ///表单
  static const String folderForm = "folderForm";

  ///业务模型
  static const String folderModel = "folderModel";

  ///应用
  static const String folderApplication = "folderApplication";

  ///文件
  static const String folderStore = "folderStore";

  ///代码
  static const String folderCode = "folderCode";

  ///镜像
  static const String folderImage = "folderImage";
  // ///资源
  // static const String folderStore = "folderStore";

  ///目录
  static const String folder = "folder";

  //================================================================== types/files

  ///pdf
  static const String pdf = "pdf";

  ///word
  static const String word = "word";

  ///excel
  static const String excel = "excel";

  ///ppt
  static const String ppt = "ppt";

  ///音频
  static const String music = "music";

  ///视频
  static const String video = "video";

  ///图片
  static const String image = "image";

  ///app应用
  static const String app = "app";

  ///文件
  static const String file = "file";
  //================================================================== types
  ///动态
  static const String dynamicIcon = "dynamic";

  ///属性
  static const String property = "property";

  ///用户
  static const String user = "user";

  ///群组
  static const String communicationGroup = "communicationGroup";

  ///单位
  static const String unit = "unit";

  ///内设机构
  static const String unitInstitution = "unitInstitution";

  ///集群
  static const String cluster = "cluster";

  ///表单办事
  static const String formWork = "formWork";

  ///办事-申请加入人员
  static const String workApplyAddPerson = "workApplyAddPerson";

  ///办事-申请加入单位
  static const String workApplyAddUnit = "workApplyAddUnit";

  ///办事-申请加入群组
  static const String workApplyAddGroup = "workApplyAddGroup";

  ///办事-申请加入存储资源
  static const String workApplyAddStorage = "workApplyAddStorage";

  ///办事-申请加入群
  static const String workApplyAddCohort = "workApplyAddCohort";

  ///办事-子流程
  static const String workSend = "workSend";

  ///应用
  static const String application = "application";

  ///动态
  static const String activity = "activity";

  ///字典
  static const String dictionary = "dictionary";

  ///分类
  static const String species = "species";

  ///表单
  static const String form = "form";

  ///页面模版
  static const String pageTemplate = "pageTemplate";
  //================================================================== other
  //==================================================================

  static Widget localImage(String name,
      {Key? key,
      double? width,
      double? height,
      double? size,
      BoxFit? fit,
      Color? color,
      Color? bgColor,
      bool circular = false,
      double? radius}) {
    ///常规图标
    String path = (IconsUtils.icons['x']?[name]) ?? name;
    if (path.isEmpty) path = XImage.user;

    return null == bgColor
        ? ImageWidget(
            path,
            key: key,
            fit: fit ?? BoxFit.cover,
            width: width,
            height: height,
            size: size,
            color: color,
            circular: circular,
            radius: radius,
          )
        : Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
            ),
            padding: const EdgeInsets.all(10),
            child: ImageWidget(
              path,
              key: key,
              fit: fit ?? BoxFit.cover,
              width: width,
              height: height,
              size: size,
              color: color,
              circular: circular,
              radius: radius,
            ),
          );
  }

  /// 获得实体图标
  static Widget entityIcon(
    dynamic data, {
    double? width,
    double? height,
    Size? size,
    bool circular = false,
    double? radius,
    BoxFit fit = BoxFit.contain,
    bool gaplessPlayback = false,
  }) {
    Widget iconW;
    if (null == data || (data is String && data.isEmpty)) {
      return XImage.localImage(XImage.user);
    }
    if (null != width && null != height) {
      size = Size(width, height);
    } else if (null != width) {
      size = Size(width, width);
    } else if (null != height) {
      size = Size(height, height);
    }

    if (data is XEntity && null != data.shareIcon()) {
      iconW = TeamAvatar(
        key: ValueKey(data.shareIcon()),
        size: size?.width,
        circular: circular,
        info: TeamTypeInfo(share: data.shareIcon()),
      );
    } else if (data is FixedDirectory &&
        null != DirectoryType.getType(data.name)) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        DirectoryType.getType(data.name)?.icon ?? DirectoryType.def.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is IDirectory && null != SpaceEnum.getType(data.typeName)) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        SpaceEnum.getType(data.typeName)!.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if ((data is IEntity || data is IActivityMessage) &&
        null != data.share.avatar &&
        null != data.share.avatar?.thumbnailUint8List) {
      // iconW = TeamAvatar(
      //     size: size?.width,
      //     circular: circular,
      //     info: TeamTypeInfo(share: data.share));
      iconW = ImageWidget(
        key: ValueKey(data.id),
        data.share.avatar?.thumbnailUint8List,
        fit: fit,
        size: size?.width,
        circular: circular,
        radius: radius ?? 7,
      );
    } else if ((data is ShareIcon ||
            data is XTarget ||
            data is IEntity ||
            data is ActivityMessage) &&
        data.typeName == TargetType.person.label &&
        data.name.isNotEmpty) {
      iconW = _defaultPersonIcon(data.name, size: size, circular: circular);
    } else if (data is IEntity && null != SpaceEnum.getType(data.typeName)) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        SpaceEnum.getType(data.typeName)!.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is IEntity &&
        data.typeName != TargetType.person.label &&
        null != TargetType.getType(data.typeName)) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        TargetType.getType(data.typeName)!.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is ISysFileInfo) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        StorageFileType.getType(data.typeName)?.icon ??
            StorageFileType.getTypeByFileName(data.name).icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is WorkTask &&
        null != data.taskdata.taskType &&
        data.taskdata.taskType!.isNotEmpty) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        WorkType.getType(data.taskdata.taskType!)?.icon ?? WorkType.thing.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is Work && data.typeName.isNotEmpty) {
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        WorkType.getType(data.typeName)?.icon ?? WorkType.thing.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if ((data is XTarget || data is IActivityMessage) &&
        null != TargetType.getType(data.typeName ?? "")) {
      //会影响用户头像
      iconW = XImage.localImage(
        key: ValueKey(data.id),
        TargetType.getType(data.typeName!)!.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is XForm &&
        null != SpaceEnum.getType(data.typeName ?? "")) {
      //会影响用户头像
      iconW = XImage.localImage(
        SpaceEnum.getType(data.typeName!)!.icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else if (data is FileItemShare) {
      iconW = XImage.localImage(
        key: ValueKey(data.name ?? data.contentType),
        StorageFileType.getType(data.contentType ?? "")?.icon ??
            StorageFileType.getTypeByFileName(data.name ?? "").icon,
        width: size?.width,
        circular: circular,
        radius: radius,
      );
    } else {
      iconW = localImage(
        key: const ValueKey(user),
        user,
        width: size?.width,
        color: XColors.doorDesGrey,
        circular: circular,
        radius: radius,
      );
    }
    return iconW;
  }

  static Widget _defaultPersonIcon(String name,
      {Size? size, bool circular = false}) {
    return _defaultIcon(name, size: size, circular: circular);
  }

  static Widget _defaultIcon(String? data,
      {Size? size, bool circular = false}) {
    String name = data ?? "--";
    return Container(
      width: size?.width,
      height: size?.height,
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 7.82),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0.71, -0.71),
          end: const Alignment(-0.71, 0.71),
          colors: colors[data.hashCode % colors.length],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(circular ? 50 : 4)),
      ),
      child: Center(
          child: Text(name.substring(max(0, name.length - 2), name.length),
              style: TextStyle(
                  fontSize: (size?.width ?? 0) > 33 ? 14 : 12,
                  color: XColors.white,
                  fontWeight: FontWeight.bold))),
    );
  }

  ///获得操作图标
  static List<Widget> operationIcons(List<String> icons) {
    return icons.map((icon) {
      return _operationsIconWidgets[icon] ?? Container();
    }).toList();
  }

  ///搜索
  static Widget get _searchWidget {
    return IconButton(
      icon: XImage.localImage(XImage.search),
      onPressed: () {
        SearchBar? search;
        switch (relationCtrl.homeEnum.value) {
          case HomeEnum.chat:
            search = SearchBar<ISession>(
                homeEnum: HomeEnum.chat, data: relationCtrl.chats);
            break;
          case HomeEnum.work:
            search = SearchBar<IWorkTask>(
                homeEnum: HomeEnum.work, data: relationCtrl.work.todos);
            break;
          // case HomeEnum.store:
          //   search = SearchBar<RecentlyUseModel>(
          //       homeEnum: HomeEnum.store, data: controller.storage.recent);
          // break;
          case HomeEnum.relation:
            search = SearchBar<int>(
                homeEnum: relationCtrl.homeEnum.value, data: const []);
            break;
          case HomeEnum.door:
            break;
        }
        if (search != null) {
          showSearch(context: Get.context!, delegate: search);
        }
      },
      // constraints: const BoxConstraints(maxWidth: 50),
    );
  }

  ///扫描
  static Widget get _qrScanWidget {
    return IconButton(
      icon: XImage.localImage(XImage.scan), //const Icon(Ionicons.scan_outline),
      onPressed: () {
        relationCtrl.qrScan();
      },
    );
  }

  ///更多新增
  static Widget get _moreWidget {
    return _createCustomPopupMenu(
      children: relationCtrl.menuItems
          .map(
            (item) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                relationCtrl.settingMenuController.hideMenu();
                relationCtrl.showAddFeatures(item);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.grey.shade300, width: 0.5))),
                child: Row(
                  children: <Widget>[
                    Icon(
                      item.shortcut.icon,
                      size: 24.w,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 10.w),
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        child: Text(
                          item.shortcut.label,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
      controller: relationCtrl.settingMenuController,
      child: XImage.localImage(XImage.add), //const Icon(
      //   Ionicons.add_sharp,
      // ),
    );
  }

  ///发起办事
  static Widget get _startWorkWidget {
    return IconButton(
      icon: XImage.localImage(XImage.startWork),
      onPressed: () {
        // relationCtrl.qrScan();
      },
    );
  }

  ///添加群组
  static Widget get _joinGroupWidget {
    return IconButton(
      icon: XImage.localImage(XImage.joinGroup),
      onPressed: () {
        // relationCtrl.qrScan();
      },
    );
  }

  ///添加存储
  static Widget get _addStorageWidget {
    return IconButton(
      icon: XImage.localImage(XImage.addStorage),
      onPressed: () {
        // relationCtrl.qrScan();
      },
    );
  }

  ///公用构建方法
  ///弹出菜单构建
  static Widget _createCustomPopupMenu({
    CustomPopupMenuController? controller,
    required Widget child,
    required List<Widget> children,
  }) {
    return CustomPopupMenu(
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ).paddingAll(AppSpace.listView),
      ),
      controller: controller,
      pressType: PressType.singleClick,
      showArrow: false,
      child: child.clipRRect(all: AppSpace.button),
    );
  }
}
