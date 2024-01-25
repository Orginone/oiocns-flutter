import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/widgets/text_tag.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/getx/breadcrumb_nav/base_breadcrumb_nav_item.dart';
import 'package:orginone/dart/core/public/enums.dart';
import 'package:orginone/pages/store/models/index.dart';

class StoreNavItem extends BaseBreadcrumbNavItem<StoreTreeNavModel> {
  final void Function(PopupMenuKey value, StoreTreeNavModel model)? onSelected;
  const StoreNavItem(
      {super.key,
      required super.item,
      super.onTap,
      super.onNext,
      this.onSelected});

  @override
  List<PopupMenuItem> popupItems() {
    return [
      // PopupMenuItem(
      //   value: PopupMenuKey.shareQr,
      //   child: Text(PopupMenuKey.shareQr.label),
      // )
    ];
  }

  @override
  void onSelectPopupItem(key) {
    onSelected?.call(key, item);
  }

  @override
  Widget title() {
    return <Widget>[
      super.title(),
      <Widget>[...tagsLabel()].toRow().marginSymmetric(horizontal: 10),
      remarkView(),
    ].toColumn(
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }

  remarkView() {
    String? content;
    if (item.source != null) {
      content = item.source?.remark ?? [];
    } else {
      content = item.space?.remark ?? '';
    }
    return content == null
        ? const SizedBox()
        : TextWidget(
                text: content,
                color: AppColors.gray,
                overflow: TextOverflow.ellipsis)
            .paddingTop(5)
            .marginSymmetric(horizontal: 10);
  }

  ///获取tags视图
  List<Widget> tagsLabel() {
    // LogUtil.d("tagsLabel ---");
    // LogUtil.d(item.space);
    // LogUtil.d(item.space?.groupTags);
    // LogUtil.d(item.space?.directory);
    // LogUtil.d(item.source.metadata.typeName);
    // LogUtil.d(item.source?.groupTags);
    // LogUtil.d(item.space?.groupTags);
    List<String> tags = [];
    if (item.source != null) {
      tags = item.source?.groupTags ?? [];
    } else {
      tags = item.space?.groupTags ?? [];
    }
    return tags
        .map((element) => TextTag(
              element,
              bgColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 3),
              textStyle: TextStyle(
                color: XColors.designBlue,
                fontSize: 14.sp,
              ),
              borderColor: XColors.tinyBlue,
            ).paddingRight(5))
        .toList();
  }

  @override
  Widget more() {
    if (item.spaceEnum == SpaceEnum.file ||
        item.spaceEnum == SpaceEnum.species ||
        item.spaceEnum == SpaceEnum.work ||
        item.spaceEnum == SpaceEnum.property) {
      return const SizedBox();
    }
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        Icons.info_outline_rounded,
        size: 28.w,
        // color: Colors.blueGrey,
      ),
    );
  }
}
