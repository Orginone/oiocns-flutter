import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/component/unified_text_style.dart';

class BreadCrumb<T> extends StatelessWidget {
  final BreadCrumbController<T> controller;
  final Function? popsCallback;

  const BreadCrumb({
    required this.controller,
    this.popsCallback,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
            var style = topOfStack ? text16GreyBold : text16BlueBold;
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
              children.add(const Icon(Icons.keyboard_arrow_right));
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

  const Item({required this.id, required this.label});
}

class BreadCrumbController<T> extends GetxController {
  late RxList<Item<T>> items = <Item<T>>[].obs;
  late Map<T, Item<T>> index = {};

  @override
  void onClose() {
    super.onClose();
    items.clear();
    index.clear();
  }

  push(Item<T> item) {
    if (index.containsKey(item.id)) {
      throw Exception("不允许产生重复的 ID");
    }
    items.add(item);
    index[item.id] = item;
  }

  pop() {
    if (items.isEmpty) {
      return;
    }
    var target = items.removeAt(items.length - 1);
    index.remove(target.id);
  }

  popsUntil(T id) {
    int position = -1;
    var length = items.length;
    List<T> ids = [];

    for (int i = length - 1; i >= 0; i--) {
      var item = items[i];
      ids.add(item.id);
      if (item.id == id) {
        position = i;
        break;
      }
    }
    if (position == -1) {
      return;
    }

    items.removeRange(position + 1, items.length);
    for (var id in ids) {
      index.remove(id);
    }
  }
}
