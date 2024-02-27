import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/components/widgets/infoListPage/infoListPage.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/utils/load_image.dart';

/// 静态组件
abstract class OrginoneStatelessWidget extends StatelessWidget
    with _OrginoneController {
  late dynamic _data;

  dynamic get data => _data;

  OrginoneStatelessWidget({super.key, data}) {
    _data = data ?? RoutePages.getParentRouteParam();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context, _data);
  }
}

/// 动态组件
abstract class OrginoneStatefulWidget extends StatefulWidget {
  late dynamic data;

  OrginoneStatefulWidget({super.key, data}) {
    this.data = data ?? RoutePages.getParentRouteParam();
  }
}

abstract class OrginoneStatefulState<T extends OrginoneStatefulWidget>
    extends State<T> with _OrginoneController {
  dynamic get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return _build(context, data);
  }
}

mixin _OrginoneController {
  Widget _build(BuildContext context, dynamic data) {
    Widget body = buildWidget(context, data);
    bool hasTabs = _hasChildOfType(body, InfoListPage);
    return GyScaffold(
        // backgroundColor: Colors.white,
        // titleName: data.name ?? "详情",
        titleWidget: _title(data),
        centerTitle: false,
        titleSpacing: 0,
        leadingWidth: 35,
        // actions: [XImage.localImage(XImage.user)],
        // leading: XImage.localImage(XImage.user),
        operations: buildButtons(context, data),
        // toolbarHeight: _getToolbarHeight(data),
        body: Container(
          color: const Color(0xFFF0F0F0),
          margin: hasTabs ? null : EdgeInsets.symmetric(vertical: 1.h),
          decoration: hasTabs ? null : const BoxDecoration(color: Colors.white),
          child: body,
        ));
  }

  bool _hasChildOfType<T>(Widget widget, T type) {
    if (widget.runtimeType is T) {
      return true;
    }
    if (widget is Column) {
      if (widget.children.isEmpty) {
        return false;
      }

      for (var child in widget.children) {
        if (_hasChildOfType(child, type)) {
          return true;
        }
      }
    }

    return false;
  }

  double? _getToolbarHeight(dynamic data) {
    var spaceName = "";
    if (data is IEntity) spaceName = data.groupTags.join(" | ");
    if (spaceName.isNotEmpty) {
      return 78.h;
    }
    return null;
  }

  Widget _title(dynamic data) {
    String name = data?.name ?? ""; //RoutePages.getRouteTitle() ??
    // if (state.chat.members.length > 1) {
    //   name += "(${state.chat.members.length})";
    // }
    var spaceName = "";
    if (data is IEntity) {
      spaceName = data.groupTags.reversed.firstWhere(
          (element) => element != "未读"); //data.groupTags.join(" | ");
    }
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: XImage.entityIcon(data, width: 44.w),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                maxLines: 1,
                style: XFonts.size26Black3
                    .merge(const TextStyle(overflow: TextOverflow.ellipsis))),
            // Padding(
            //     padding: const EdgeInsets.only(top: 2),
            //     child: Text(spaceName, style: XFonts.size16Black9)),
          ],
        ))
      ],
    );
  }

  @protected
  List<Widget>? buildButtons(BuildContext context, dynamic data) {
    return null;
  }
  // {
  //   return <Widget>[
  //     GFIconButton(
  //       color: Colors.white.withOpacity(0),
  //       icon: Icon(
  //         Icons.more_vert,
  //         color: XColors.black3,
  //         size: 32.w,
  //       ),
  //       onPressed: showMore(context, data) ? () => onMore(context, data) : null,
  //     ),
  //   ];
  // }

  @protected
  Widget buildWidget(BuildContext context, dynamic data);

  // @protected
  // bool showMore(BuildContext context, dynamic data) {
  //   return false;
  // }

  // @protected
  // void onMore(BuildContext context, dynamic data) {}
}
