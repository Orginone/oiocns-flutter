

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PageViewScrollUtils {
  final PageController pageController;
  final TabController tabController;
  PageViewScrollUtils({required this.pageController, required this.tabController});

  Drag? _drag;

  bool handleNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      if ((notification.direction == ScrollDirection.reverse && tabController.index == tabController.length - 1) || (notification.direction == ScrollDirection.forward && tabController.index ==  0)) {
        _drag = pageController.position.drag(DragStartDetails(), () {
          _drag = null;
        });
      }
    }
    if (notification is OverscrollNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag!.update(notification.dragDetails!);
      }
    }
    if (notification is ScrollEndNotification) {
      if (notification.dragDetails != null && _drag != null) {
        _drag!.end(notification.dragDetails!);
      }
    }
    return true;
  }
}