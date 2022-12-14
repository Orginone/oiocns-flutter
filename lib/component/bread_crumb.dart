import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_text_style.dart';

const defaultSplitWidget = Icon(Icons.keyboard_arrow_right);

class BreadCrumb<T> extends StatelessWidget {
  final BreadCrumbController<T> controller;
  final double? width;
  final double? height;
  final Function? popsCallback;
  final Widget? splitWidget;
  final TextStyle? stackBottomStyle;
  final TextStyle? stackTopStyle;
  final Color? bgColor;
  final EdgeInsets? padding;

  const BreadCrumb({
    required this.controller,
    this.width,
    this.height,
    this.popsCallback,
    this.splitWidget = defaultSplitWidget,
    this.stackBottomStyle,
    this.stackTopStyle,
    this.bgColor,
    this.padding,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.centerLeft,
      color: bgColor,
      padding: padding ?? EdgeInsets.only(left: 10.w, right: 10.w),
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: controller.items.length,
          itemBuilder: (BuildContext context, int index) {
            Item<T> item = controller.items[index];
            bool topOfStack = index == controller.items.length - 1;

            List<Widget> children = [];
            var style = topOfStack
                ? stackBottomStyle ?? text16GreyBold
                : stackTopStyle ?? text16BlueBold;
            var text = GestureDetector(
              onTap: () {
                if (popsCallback != null) {
                  popsCallback!(item);
                }
              },
              child: Text(item.label, style: style),
            );
            children.add(text);
            if (!topOfStack) {
              children.add(splitWidget!);
            }

            return Row(children: children);
          },
        ),
      ),
    );
  }
}

/// ????????????
Item<String> topPoint = Item(
  id: "top",
  label: "??????",
  children: [chatPoint, centerPoint, workPoint, warehousePoint, settingPoint],
  mustNext: centerPoint,
);

/// ????????????
Item<String> chatPoint = Item(
  id: "chat",
  label: "??????",
  children: [chatRecentPoint, chatMailPoint],
  mustNext: chatRecentPoint,
);
Item<String> workPoint = Item(
  id: "work",
  label: "??????",
  children: [toBePoint, completedPoint, myPoint, sendMyPoint],
  mustNext: toBePoint,
);
Item<String> centerPoint = Item(id: "center", label: "??????");
Item<String> warehousePoint = Item(id: "warehouse", label: "??????");
Item<String> settingPoint = Item(id: "setting", label: "??????");

/// ????????????
Item<String> chatRecentPoint = Item(id: "chatRecent", label: "??????");
Item<String> chatMailPoint = Item(id: "chatMail", label: "?????????");

/// ??????
Item<String> toBePoint = Item(id: "toBe", label: "??????");
Item<String> completedPoint = Item(id: "completed", label: "??????");
Item<String> myPoint = Item(id: "warehouse", label: "????????????");
Item<String> sendMyPoint = Item(id: "sendMy", label: "????????????");

/// ???????????????
class Item<T> {
  final T id;
  final String label;
  Item<T>? parent;
  Item<T>? mustNext;
  final List<Item<T>> children;

  Item({
    required this.id,
    required this.label,
    this.parent,
    this.mustNext,
    this.children = const [],
  });
}

class BreadCrumbController<T> extends GetxController {
  /// ?????????????????????
  final RxList<Item<T>> items = <Item<T>>[].obs;
  final Item<T>? topNode;

  BreadCrumbController({this.topNode}) {
    if (topNode == null) {
      return;
    }
    Queue<Item<T>> queue = Queue.of([topNode!]);
    while (queue.isNotEmpty) {
      Item<T> first = queue.removeFirst();
      for (var child in first.children) {
        child.parent = first;
      }
      queue.addAll(first.children);
    }
  }

  @override
  void onClose() {
    super.onClose();
    items.clear();
  }

  /// ???????????????
  clear() {
    items.clear();
  }

  /// ??????
  push(Item<T> item) {
    checkDuplication(item);
    items.add(item);
  }

  /// ??????????????????
  checkDuplication(Item<T> target) {
    for (var item in items) {
      if (item.id == target.id) {
        throw Exception("???????????????????????? ID !");
      }
    }
  }

  /// ??????
  void redirect(Item<T> item) {
    if (topNode == null || item == topNode) {
      return;
    }
    items.clear();
    Queue<Item<T>> queue = Queue.of([topNode!]);
    Item<T>? matched;
    while (queue.isNotEmpty) {
      Item<T> first = queue.removeFirst();
      if (first == item) {
        matched = item;
        break;
      }
      queue.addAll(first.children);
    }
    if (matched == null) {
      return;
    }
    while (matched!.parent != null) {
      items.insert(0, matched);
      matched = matched.parent!;
    }
    if (item.parent!.mustNext != null) {
      item.parent!.mustNext = item;
    }
    var mustNext = item.mustNext;
    while (mustNext != null) {
      items.add(mustNext);
      mustNext = mustNext.mustNext;
    }
  }

  /// ??????
  Item<T>? pop() {
    if (items.isEmpty) {
      return null;
    }
    return items.removeAt(items.length - 1);
  }

  /// ????????????????????????
  getPositionById(T id) {
    int position = -1;
    var length = items.length;

    for (int i = length - 1; i >= 0; i--) {
      var item = items[i];
      if (item.id == id) {
        return position = i;
      }
    }
    return position;
  }

  /// ??????????????????????????????(?????????)
  popsUntil(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position + 1, items.length);
  }

  /// ?????????????????????
  pops(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position, items.length);
  }
}
