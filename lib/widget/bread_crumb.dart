import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/widget/a_font.dart';

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
                ? stackBottomStyle ?? AFont.instance.size16Black9W500
                : stackTopStyle ?? AFont.instance.size24themeColorW500;
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

/// 顶部菜单
Item<String> topPoint = Item(
  id: "top",
  label: "顶部",
  children: [chatPoint, centerPoint, workPoint, warehousePoint, settingPoint],
  mustNext: centerPoint,
);

/// 首页菜单
Item<String> chatPoint = Item(
  id: "chat",
  label: "沟通",
  children: [chatRecentPoint, chatMailPoint],
  mustNext: chatRecentPoint,
);
Item<String> workPoint = Item(
  id: "work",
  label: "办事",
  children: [toBePoint, completedPoint, myPoint, sendMyPoint],
  mustNext: toBePoint,
);
Item<String> centerPoint = Item(id: "center", label: "首页");
Item<String> warehousePoint = Item(id: "warehouse", label: "仓库");
Item<String> settingPoint = Item(id: "setting", label: "设置");

/// 会话相关
Item<String> chatRecentPoint = Item(id: "chatRecent", label: "会话");
Item<String> chatMailPoint = Item(id: "chatMail", label: "通讯录");

/// 办事
Item<String> toBePoint = Item(id: "toBe", label: "待办");
Item<String> completedPoint = Item(id: "completed", label: "已办");
Item<String> myPoint = Item(id: "warehouse", label: "我的发起");
Item<String> sendMyPoint = Item(id: "sendMy", label: "抄送我的");

/// 单个面包屑
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
  /// 当前面包屑个数
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

  /// 清空面包屑
  clear() {
    items.clear();
  }

  /// 入栈
  push(Item<T> item) {
    checkDuplication(item);
    items.add(item);
  }

  /// 校验重复问题
  checkDuplication(Item<T> target) {
    for (var item in items) {
      if (item.id == target.id) {
        throw Exception("不允许产生重复的 ID !");
      }
    }
  }

  /// 组装
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

  /// 出栈
  Item<T>? pop() {
    if (items.isEmpty) {
      return null;
    }
    return items.removeAt(items.length - 1);
  }

  /// 获取当前节点位置
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

  /// 出栈直到某个节点停止(不包括)
  popsUntil(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position + 1, items.length);
  }

  /// 出栈到某个节点
  pops(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position, items.length);
  }
}
