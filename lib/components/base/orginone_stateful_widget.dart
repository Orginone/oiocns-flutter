import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/index.dart';
import 'package:orginone/components/widgets/infoListPage/infoListPage.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';

/// 静态组件
abstract class OrginoneStatelessWidget<P> extends StatelessWidget
    with _OrginoneController<P> {
  late P _data;

  P get data => _data;

  OrginoneStatelessWidget({super.key, data}) {
    _data =
        data ?? RoutePages.getParentRouteParam() ?? RoutePages.getRouteParams();
  }

  @override
  Widget build(BuildContext context) {
    return _build(context, _data);
  }
}

/// 动态组件
abstract class OrginoneStatefulWidget<P> extends StatefulWidget {
  late P data;

  OrginoneStatefulWidget({super.key, data}) {
    this.data = data ?? RoutePages.getParentRouteParam();
  }
}

abstract class OrginoneStatefulState<T extends OrginoneStatefulWidget<P>, P>
    extends State<T> with _OrginoneController<P> {
  P get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return _build(context, data);
  }
}

mixin _OrginoneController<P> {
  Widget _build(BuildContext context, P data) {
    Widget body = buildWidget(context, data);
    bool hasTabs = _hasChildOfType(body, InfoListPage);
    return GyScaffold(
        // backgroundColor: Colors.white,
        // titleName: data.name ?? "详情",
        titleWidget: Obx(() => _title(relationCtrl.homeEnum.value, data)),
        isHomePage: isHomePage(),
        parentRouteParam:
            isHomePage() ? null : RoutePages.getParentRouteParam(),
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

  bool isHomePage() {
    return RoutePages.getRouteLevel() == 0;
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

  double? _getToolbarHeight(P data) {
    var spaceName = "";
    if (data is IEntity) spaceName = data.groupTags.join(" | ");
    if (spaceName.isNotEmpty) {
      return 78.h;
    }
    return null;
  }

  Widget _title(HomeEnum homeEnum, dynamic data) {
    String name = data?.name ?? ""; //RoutePages.getRouteTitle() ??
    // if (state.chat.members.length > 1) {
    //   name += "(${state.chat.members.length})";
    // }
    String spaceName = "";
    if (data is IEntity) {
      spaceName = data.groupTags.reversed.firstWhere(
          (element) => element != "未读"); //data.groupTags.join(" | ");
    }
    return null != data
        ? Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: XImage.entityIcon(data, width: 40.w),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      maxLines: 1,
                      style: XFonts.size26Black3.merge(
                          const TextStyle(overflow: TextOverflow.ellipsis))),
                  // Padding(
                  //     padding: const EdgeInsets.only(top: 2),
                  //     child: Text(spaceName, style: XFonts.size16Black9)),
                ],
              )
            ],
          )
        : Container();
  }

  @protected
  List<Widget>? buildButtons(BuildContext context, P data) {
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
  Widget buildWidget(BuildContext context, P data);

  // @protected
  // bool showMore(BuildContext context, dynamic data) {
  //   return false;
  // }

  // @protected
  // void onMore(BuildContext context, dynamic data) {}
}

///有背景的静态组件
abstract class BeautifulBGStatelessWidget extends StatelessWidget
    with _BeautifulBGController {
  BeautifulBGStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}

/// 有背景的动态组件
abstract class BeautifulBGStatefulWidget extends StatefulWidget {
  const BeautifulBGStatefulWidget({super.key});
}

abstract class BeautifulBGStatefulState<T extends BeautifulBGStatefulWidget>
    extends State<T> with _BeautifulBGController {
  @override
  Widget build(BuildContext context) {
    return _build(context);
  }
}

mixin _BeautifulBGController {
  @protected
  Widget buildWidget(BuildContext context);

  Widget _build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          //背景图模块
          _background(),
          buildWidget(context)
        ],
      ),
    );
  }

  ///上下对其布局
  Widget topAndBottomLayout({required Widget top, required Widget bottom}) {
    return Stack(
      children: [
        Positioned(top: 0, left: 0, right: 0, child: top),
        Positioned(bottom: 0, left: 0, right: 0, child: bottom),
      ],
    );
  }

  //背景图
  Widget _background() {
    return Stack(
      children: [
        Positioned(
          left: -200,
          child: Container(
            width: 900,
            height: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AssetsImages.logoBackground),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          left: -200,
          child: Container(
            width: 900,
            height: 500,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(249, 249, 249, 0),
                  Color.fromRGBO(255, 255, 255, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
