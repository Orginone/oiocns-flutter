import 'dart:math';

import 'package:flutter/material.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/base/action_container.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/components/widgets/common/empty/empty_activity.dart';
import 'package:orginone/config/index.dart';
import 'package:orginone/dart/core/chat/activity.dart';

//渲染动态列表
class ActivityListWidget extends StatefulWidget {
  late final ScrollController _scrollController;
  late final IActivity? _activity;
  late final int? showCount;

  ActivityListWidget({
    super.key,
    this.showCount,
    scrollController,
    activity,
  }) {
    _scrollController = scrollController ?? ScrollController();
    _activity = activity ?? RoutePages.getParentRouteParam();
  }
  @override
  State<StatefulWidget> createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityListWidget> {
  ScrollController get _scrollController => widget._scrollController;
  IActivity? get _activity => widget._activity;
  int? get showCount => widget.showCount;

  late final String? _key;

  @override
  void initState() {
    super.initState();
    //订阅数据变更
    // _activity?.unsubscribe();
    _key = _activity?.subscribe((key, args) {
      if (mounted) {
        setState(() {});
      }
    }, false);
  }

  @override
  void dispose() {
    super.dispose();
    _activity?.unsubscribe(_key);
  }

  @override
  void didUpdateWidget(covariant ActivityListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return null != _activity
        ? null != showCount
            ? _buildActivity(activity: _activity!)
            : _buildActivityList(activity: _activity!)
        : const EmptyActivity();
  }

  Widget _buildActivity({required IActivity activity}) {
    return Container(
        child: Column(
      children: activity.activityList
          .sublist(0, min(2, activity.activityList.length))
          .map((item) {
        return ActivityMessageWidget(
          item: item,
          activity: item.activity,
          hideResource: true,
        );
      }).toList(),
    ));
  }

  Widget _buildActivityList({required IActivity activity}) {
    Widget content = Container(
      color: XColors.bgListBody,
      child: ListView(
          controller: _scrollController,
          children: _buildActivityItem(activity: _activity!)),
    );
    if (activity.allPublish) {
      content = _actionWidget(
        buttonTooltip: "发表动态",
        onPressed: () {
          RoutePages.jumpActivityRelease(activity: activity);
        },
        child: content,
      );
    }
    return content;
  }

  Widget _actionWidget(
      {required String buttonTooltip,
      Function()? onPressed,
      required Widget child}) {
    return ActionContainer(
      floatingActionButton: FloatingActionButton(
        onPressed: onPressed,
        mini: true,
        tooltip: buttonTooltip,
        child: const Icon(Icons.add),
      ),
      child: child,
    );
  }

  //渲染动态列表
  List<Widget> _buildActivityItem({required IActivity activity}) {
    return activity.activityList.map((item) {
      return ActivityMessageWidget(
        item: item,
        activity: item.activity,
        hideResource: true,
      );
    }).toList();
  }
}
