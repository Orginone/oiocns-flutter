import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class RefreshBody extends StatelessWidget {
  final RefreshController refreshCtrl;
  final ListView body;
  final Function? onRefresh;
  final Function? onLoading;

  const RefreshBody({
    Key? key,
    required this.refreshCtrl,
    required this.body,
    this.onRefresh,
    this.onLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshCtrl,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: () async {
        if (onLoading != null) {
          await onLoading!();
        }
        refreshCtrl.refreshCompleted();
      },
      onLoading: () async {
        if (onLoading != null) {
          await onLoading!();
        }
        refreshCtrl.loadComplete();
      },
      child: body,
    );
  }
}
