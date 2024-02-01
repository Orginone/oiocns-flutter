import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/components/widgets/common/image/image_widget.dart';
import 'package:orginone/components/widgets/dialog/popup_widget.dart';
import 'package:orginone/utils/string_util.dart';
import 'package:orginone/main_bean.dart';

class BaseBreadcrumbNavItem<T extends BaseBreadcrumbNavModel>
    extends StatelessWidget {
  final T item;

  final VoidCallback? onNext;

  final VoidCallback? onTap;
  final bool useTip;

  const BaseBreadcrumbNavItem({
    Key? key,
    required this.item,
    this.onNext,
    this.useTip = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: PopupWidget(
        itemBuilder: (BuildContext context) {
          return popupItems();
        },
        onSelected: (key) {
          onSelectPopupItem(key);
        },
        onTap: () async {
          if (item.onNext != null) {
            await item.onNext!(item);
          }
          if (onNext != null) {
            onNext!();
          } else if (onTap != null) {
            onTap!();
          }
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 0.5))),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 7.h),
          child: Row(
            children: [
              AdvancedAvatar(
                size: 60.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.w)),
                ),
                child: _imageWidget(),
              ),
              Expanded(
                child: title(),
              ),
              more(),
            ],
          ),
        ),
      ),
    );
  }

  _imageWidget() {
    if (item.image == null) {
      return _Icon(
        spaceEnum: item.spaceEnum,
      );
    }
    dynamic link = '';
    dynamic thumbnail = item.image;
    // TODO 待处理小的预览图
    if (thumbnail != null) {
      link = thumbnail;
    } else if (!link.startsWith('/orginone/kernel/load/')) {
      link = File(link);
    } else {
      link = '${Constant.host}$link';
    }
    // link =
    // '${Constant.host}/orginone/kernel/load/8ww8g2gjdatorvyezuenfyge8lhme1yk53nnj1xo1jsowux2mlzm66dk6lhnzzyql1vgq3uan11ge1dcnjugm3dmojug53c91n8w3sl9ipfuo9opcmhl51damruge1daojrgqzdkmr1f1wha1d';
    Map<String, String> headers = {
      "Authorization": kernel.accessToken,
    };
    LogUtil.d('_imageWidget');
    LogUtil.d(link);
    Widget child = ImageWidget(
      link,
      httpHeaders: headers,
      fit: BoxFit.fill,
    );

    return child;
  }

  Widget title() {
    Widget tips = const SizedBox();
    String? size;
    if (item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.property ||
        item.spaceEnum == SpaceEnum.applications ||
        item.spaceEnum == SpaceEnum.module ||
        item.spaceEnum == SpaceEnum.work ||
        item.spaceEnum == SpaceEnum.form ||
        item.spaceEnum == SpaceEnum.file) {
      tips = Text(
        item.source.metadata.typeName,
        style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
      );

      // size = item.source.metadata.icon.size; //~/ 1024
    }
    if (item.spaceEnum == SpaceEnum.file) {
      size = StringUtil.formatFileSize(item.source.filedata.size ?? 0);
      size = ' ($size)';
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name + (size ?? ''),
            style: TextStyle(fontSize: 24.sp, color: Colors.black),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          useTip ? tips : const SizedBox(),
        ],
      ),
    );
  }

  Widget more() {
    if (item.spaceEnum == SpaceEnum.file ||
        item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.work ||
        item.spaceEnum == SpaceEnum.form ||
        item.spaceEnum == SpaceEnum.property) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.navigate_next,
        size: 32.w,
      ),
    );
  }

  List<PopupMenuItem> popupItems() {
    return [];
  }

  void onSelectPopupItem(dynamic key) {}
}

class _Icon extends StatelessWidget {
  final SpaceEnum? spaceEnum;

  const _Icon({Key? key, this.spaceEnum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late IoniconsData icon;

    if (spaceEnum == null) {
      icon = Ionicons.book_sharp;
    } else {
      switch (spaceEnum) {
        case SpaceEnum.directory:
          icon = Ionicons.folder_sharp;
          break;
        case SpaceEnum.species:
          icon = Ionicons.pricetag_sharp;
          break;
        case SpaceEnum.property:
          icon = Ionicons.snow_sharp;
          break;
        case SpaceEnum.work:
        case SpaceEnum.module:
        case SpaceEnum.applications:
          icon = Ionicons.apps_sharp;
          break;
        case SpaceEnum.form:
          icon = Ionicons.clipboard_sharp;
          break;
        case SpaceEnum.user:
          icon = Ionicons.person_sharp;
          break;
        case SpaceEnum.company:
          icon = Ionicons.business_sharp;
          break;
        case SpaceEnum.person:
          icon = Ionicons.person_sharp;
          break;
        case SpaceEnum.departments:
          icon = Ionicons.library_sharp;
          break;
        case SpaceEnum.groups:
          icon = Ionicons.git_network_sharp;
          break;
        case SpaceEnum.cohorts:
          icon = Ionicons.chatbubble_sharp;
          break;
        default:
          icon = Ionicons.book_sharp;
          break;
      }
    }

    return Icon(
      icon,
      color: const Color(0xFF9498df),
      size: 50.w,
    );
  }
}
