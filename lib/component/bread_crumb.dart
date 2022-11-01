import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_text_style.dart';

const defaultSplitWidget = Icon(Icons.keyboard_arrow_right);

class BreadCrumb<T> extends StatelessWidget {
  final BreadCrumbController<T> controller;
  final Function? popsCallback;
  final Widget? splitWidget;
  final TextStyle? stackBottomStyle;
  final TextStyle? stackTopStyle;
  final Color? bgColor;

  const BreadCrumb({
    required this.controller,
    this.popsCallback,
    this.splitWidget = defaultSplitWidget,
    this.stackBottomStyle,
    this.stackTopStyle,
    this.bgColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      height: 24.h,
      padding: EdgeInsets.only(left: 10.w, right: 10.w),
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

class Item<T> {
  final T id;
  final String label;
  final Item<T>? innerItem;

  const Item({required this.id, required this.label, this.innerItem});
}

class BreadCrumbController<T> extends GetxController {
  late RxList<Item<T>> items = <Item<T>>[].obs;

  @override
  void onClose() {
    super.onClose();
    items.clear();
  }

  clear() {
    items.clear();
  }

  push(Item<T> item) {
    checkDuplication(item);
    items.add(item);
    while (item.innerItem != null) {
      item = item.innerItem!;
      items.add(item);
    }
  }

  checkDuplication(Item<T> target) {
    for (var item in items) {
      if (item.id == target.id) {
        throw Exception("不允许产生重复的 ID !");
      }
    }
  }

  Item<T>? pop() {
    if (items.isEmpty) {
      return null;
    }
    return items.removeAt(items.length - 1);
  }

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

  popsUntil(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position + 1, items.length);
  }

  pops(T id) {
    var position = getPositionById(id);
    if (position == -1) {
      return;
    }
    items.removeRange(position, items.length);
  }
}
