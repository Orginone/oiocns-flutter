import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/utils/date_util.dart';
import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/components/widgets/popup_widget.dart';
import 'package:orginone/components/widgets/target_text.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/components/widgets/text_tag.dart';

import 'list_adapter.dart';

class GridItem extends StatelessWidget {
  final ListAdapter adapter;

  const GridItem({
    Key? key,
    required this.adapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupWidget(
      onTap: () {
        adapter.callback?.call();
      },
      itemBuilder: (BuildContext context) {
        return adapter.popupMenuItems;
      },
      onSelected: (key) {
        adapter.onSelected?.call(key);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _avatarContainer,
          SizedBox(
            width: 10.w,
          ),
          Expanded(child: _content),
        ],
      ),
    );
  }

  Widget get _avatarContainer {
    var noRead = adapter.noReadCount;
    Widget child = ImageWidget(
      adapter.image,
      size: 50.w,
      iconColor: const Color(0xFF9498df),
      circular: adapter.circularAvatar,
    );
    if (noRead.isNotEmpty) {
      child = badges.Badge(
        ignorePointer: false,
        position: badges.BadgePosition.topEnd(top: -2),
        badgeContent: Text(
          noRead.value,
          // "${noRead > 99 ? "99+" : noRead}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 1,
            wordSpacing: 2,
            height: 1,
          ),
        ),
        child: child,
      );
    }
    return child;
  }

  Widget get _content {
    Widget label;

    var text = adapter.typeName ?? adapter.labels.first;

    var style = TextStyle(
      color: XColors.designBlue,
      fontSize: 14.sp,
    );

    if (adapter.isUserLabel) {
      label = Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(color: XColors.tinyBlue),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
        child: TargetText(userId: text, style: style),
      );
    } else {
      label = TextTag(
        text,
        bgColor: Colors.white,
        textStyle: style,
        borderColor: XColors.tinyBlue,
        maxLines: 1,
      );
    }
    return Column(
      children: [
        Text(
          adapter.title,
          style: TextStyle(
            color: XColors.chatTitleColor,
            fontWeight: FontWeight.w500,
            fontSize: 20.sp,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        ),
        SizedBox(
          height: 10.h,
        ),
        label,
      ],
    );
  }
}

class ListItem extends StatelessWidget {
  final ListAdapter adapter;

  const ListItem({
    Key? key,
    required this.adapter,
  }) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _ListItemState();
//   }
// }

// class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PopupWidget(
        itemBuilder: (BuildContext context) {
          return adapter.popupMenuItems;
        },
        onTap: () {
          adapter.callback?.call();
        },
        onSelected: (key) {
          adapter.onSelected?.call(key);
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 7.h),
            decoration: BoxDecoration(
                border: Border(
                    bottom:
                        BorderSide(color: Colors.grey.shade300, width: 0.4))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _avatarContainer,
                SizedBox(
                  width: 10.w,
                ),
                Expanded(child: _content),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget get _avatarContainer {
    var noRead = adapter.noReadCount;
    Widget child = ImageWidget(
      adapter.image,
      size: 65.w,
      iconColor: const Color(0xFF9498df),
      circular: adapter.circularAvatar,
    );
    if (noRead.isNotEmpty) {
      child = badges.Badge(
        ignorePointer: false,
        position: badges.BadgePosition.topEnd(top: -6, end: -8),
        badgeContent: Text(
          noRead.value,
          // "${noRead > 99 ? "99+" : noRead}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 10,
            letterSpacing: 1,
            wordSpacing: 2,
            height: 1,
          ),
        ),
        child: child,
      );
    }
    return child;
  }

  Widget get _content {
    var labels = <Widget>[];
    for (var item in adapter.labels) {
      if (item.isNotEmpty) {
        bool isTop = item == "置顶";

        Widget label;

        var style = TextStyle(
          color: isTop ? XColors.fontErrorColor : XColors.designBlue,
          fontSize: 14.sp,
        );
        if (adapter.isUserLabel) {
          label = Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: XColors.tinyBlue),
            ),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 5),
            child: TargetText(userId: item, style: style),
          );
        } else {
          label = TextTag(
            item,
            bgColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
            textStyle: style,
            borderColor: isTop ? XColors.fontErrorColor : XColors.tinyBlue,
          );
        }

        labels.add(label);
        labels.add(Padding(padding: EdgeInsets.only(left: 4.w)));
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                adapter.title,
                style: TextStyle(
                  color: XColors.chatTitleColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 24.sp,
                  overflow: TextOverflow.ellipsis,
                ),
                maxLines: 1,
              ),
            ),
            Text(
              CustomDateUtil.getSessionTime(adapter.dateTime),
              style: XFonts.chatSMTimeTip,
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(
          height: 3.h,
        ),
        Row(
          children: labels,
        ),
        SizedBox(
          height: 3.h,
        ),
        _showTxt(),
      ],
    );
  }

  Widget _showTxt() {
    return Text(
      adapter.content,
      style: TextStyle(
        color: XColors.chatHintColors,
        fontSize: 18.sp,
      ),
      textAlign: TextAlign.left,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
