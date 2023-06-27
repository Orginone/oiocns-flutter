import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ionicons/ionicons.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_get_breadcrumb_nav_state.dart';
import 'package:orginone/widget/image_widget.dart';

class BaseBreadcrumbNavItem<T extends BaseBreadcrumbNavModel>
    extends StatelessWidget {
  final T item;

  final VoidCallback? onNext;

  final VoidCallback? onTap;

  const BaseBreadcrumbNavItem({
    Key? key,
    required this.item,
    this.onNext,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onNext != null) {
          onNext!();
        } else if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.shade300,width: 0.5))
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w,vertical: 12.h),
        child: Row(
          children: [
            AdvancedAvatar(
              size: 60.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.w)),
              ),
              child: item.image != null
                  ? ImageWidget(
                      item.image,
                    )
                  : _Icon(
                      spaceEnum: item.spaceEnum,
                    ),
            ),
            Expanded(
              child: title(),
            ),
            action(),
            more(),
          ],
        ),
      ),
    );
  }

  Widget title() {
    Widget tips = const SizedBox();
    if (item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.property ||
        item.spaceEnum == SpaceEnum.applications ||
        item.spaceEnum == SpaceEnum.form ||
        item.spaceEnum == SpaceEnum.file) {
      tips = Text(
        item.source.metadata.typeName,
        style: TextStyle(fontSize: 16.sp, color: Colors.grey.shade500),
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      width: double.infinity,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.name,
            style: TextStyle(fontSize: 20.sp, color: Colors.black),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          tips,
        ],
      ),
    );
  }

  Widget more() {
    if (item.spaceEnum == SpaceEnum.file ||
        item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.applications ||
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

  Widget action() {
    return SizedBox();
  }
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
        case SpaceEnum.cardbag:
          icon = Ionicons.card_sharp;
          break;
        case SpaceEnum.security:
          icon = Ionicons.key_sharp;
          break;
        case SpaceEnum.gateway:
          icon = Ionicons.home_sharp;
          break;
        case SpaceEnum.theme:
          icon = Ionicons.color_palette_sharp;
          break;
        case SpaceEnum.directory:
          icon = Ionicons.folder_sharp;
          break;
        case SpaceEnum.species:
          icon = Ionicons.pricetag_sharp;
          break;
        case SpaceEnum.property:
          icon = Ionicons.snow_sharp;
          break;
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
      color: Color(0xFF9498df),
      size: 50.w,
    );
  }
}
