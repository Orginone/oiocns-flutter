import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/config/colors.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/pages/home/components/user_bar.dart';

class GyScaffold extends StatefulWidget {
  final Widget? body;

  final bool supportSafeArea;

  final Color? backgroundColor;

  final Color? appBarColor;

  final String? titleName;

  final TextStyle? titleStyle;

  final bool centerTitle;

  final Widget? titleWidget;

  final List<Widget>? actions;

  final List<Widget>? operations;

  final Widget? leading;

  final double elevation;

  final Color? backColor;

  final double? leadingWidth;

  final Widget? bottomNavigationBar;

  final double? toolbarHeight;

  final double? titleSpacing;

  final Widget? floatingActionButton;
  final bool isHomePage;
  final dynamic parentRouteParam;

  const GyScaffold(
      {Key? key,
      this.body,
      this.supportSafeArea = true,
      this.backgroundColor,
      this.appBarColor,
      this.titleName,
      this.titleWidget,
      this.titleStyle,
      this.centerTitle = true,
      this.actions,
      this.operations,
      this.leading,
      this.elevation = 0,
      this.backColor,
      this.leadingWidth,
      this.bottomNavigationBar,
      this.toolbarHeight,
      this.titleSpacing,
      this.floatingActionButton,
      this.isHomePage = false,
      this.parentRouteParam})
      : super(key: key);

  @override
  State<GyScaffold> createState() => _GyScaffoldState();
}

class _GyScaffoldState extends State<GyScaffold> {
  late Widget body;

  late bool supportSafeArea;

  late Color backgroundColor;

  late Color appBarColor;

  Widget? titleWidget;

  late String titleName;

  TextStyle? titleStyle;

  late bool centerTitle;

  List<Widget>? actions;
  List<Widget>? operations;

  Widget? leading;

  late double elevation;

  late Color backColor;

  late double leadingWidth;

  double? toolbarHeight;

  Widget? bottomNavigationBar;

  double? titleSpacing;

  Widget? floatingActionButton;
  late bool isHomePage;
  late dynamic parentRouteParam;
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    body = widget.body ?? Container();
    supportSafeArea = widget.supportSafeArea;
    backgroundColor = widget.backgroundColor ?? Colors.white;
    appBarColor = widget.appBarColor ?? Colors.white;
    titleName = widget.titleName ?? "";
    titleWidget = widget.titleWidget;
    titleStyle = widget.titleStyle;
    centerTitle = widget.centerTitle;
    actions = widget.actions;
    operations = widget.operations;
    leading = widget.leading;
    elevation = widget.elevation;
    backColor = widget.backColor ?? Colors.black;
    leadingWidth = widget.leadingWidth ?? 15; //kToolbarHeight;
    bottomNavigationBar = widget.bottomNavigationBar;
    toolbarHeight = widget.toolbarHeight;
    titleSpacing = widget.titleSpacing;
    floatingActionButton = widget.floatingActionButton;
    isHomePage = widget.isHomePage;
    parentRouteParam = widget.parentRouteParam;

    // relationCtrl.homeEnum.listen(_listenHomeEnum);
  }

  // void _listenHomeEnum(HomeEnum value) {
  //   print('>>>topbar listen mounted $value isHomePage $isHomePage');
  //   if (mounted && !isHomePage) {
  //     // setState(() {
  //     isHomePage = true;
  //     parentRouteParam = null;
  //     // });
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant GyScaffold oldWidget) {
    //
    super.didUpdateWidget(oldWidget);
    if (oldWidget.body != widget.body) {
      body = widget.body ?? Container();
    }
    if (oldWidget.supportSafeArea != widget.supportSafeArea) {
      supportSafeArea = widget.supportSafeArea;
    }
    if (oldWidget.backgroundColor != widget.backgroundColor) {
      backgroundColor = widget.backgroundColor ?? AppColors.backgroundColor;
    }
    if (oldWidget.appBarColor != widget.appBarColor) {
      appBarColor = widget.appBarColor ?? XColors.themeColor;
    }
    if (oldWidget.titleName != widget.titleName) {
      titleName = widget.titleName ?? "";
    }
    if (oldWidget.titleWidget != widget.titleWidget) {
      titleWidget = widget.titleWidget;
    }
    if (oldWidget.titleStyle != widget.titleStyle) {
      titleStyle = widget.titleStyle;
    }
    if (oldWidget.centerTitle != widget.centerTitle) {
      centerTitle = widget.centerTitle;
    }
    if (oldWidget.actions != widget.actions) {
      actions = widget.actions;
    }
    if (oldWidget.operations != widget.operations) {
      operations = widget.operations;
    }
    if (oldWidget.leading != widget.leading) {
      leading = widget.leading;
    }
    if (oldWidget.elevation != widget.elevation) {
      elevation = widget.elevation;
    }
    if (oldWidget.backColor != widget.backColor) {
      backColor = widget.backColor ?? Colors.black;
    }
    if (oldWidget.leadingWidth != widget.leadingWidth) {
      leadingWidth = widget.leadingWidth ?? kToolbarHeight;
    }
    if (oldWidget.bottomNavigationBar != widget.bottomNavigationBar) {
      bottomNavigationBar = widget.bottomNavigationBar;
    }
    if (oldWidget.toolbarHeight != widget.toolbarHeight) {
      toolbarHeight = widget.toolbarHeight;
    }
    if (oldWidget.titleSpacing != widget.titleSpacing) {
      titleSpacing = widget.titleSpacing;
    }
    if (oldWidget.floatingActionButton != widget.floatingActionButton) {
      floatingActionButton = widget.floatingActionButton;
    }
    isHomePage = widget.isHomePage;
    parentRouteParam = widget.parentRouteParam;
  }

  @override
  Widget build(BuildContext context) {
    final hasGyScaffold = context.findAncestorWidgetOfExactType<GyScaffold>();
    print('>>>topbar build hasGyScaffold: $hasGyScaffold ');
    if (null != hasGyScaffold) {
      return body;
    }
    // _listenHomeEnum(relationCtrl.homeEnum.value);
    // if (RoutePages.getRouteLevel() == 0) {
    //   return body;
    // }

    if (supportSafeArea) {
      body = SafeArea(
        child: body,
      );
    }
    return Scaffold(
      appBar: _buildTitle(isHomePage),
      backgroundColor: backgroundColor,
      body: _buildBody(isHomePage),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      resizeToAvoidBottomInset: true,
    );
  }

  // 构建主体
  Widget _buildBody(bool isHomePage) {
    Widget pageW = body;
    if (isHomePage) {
      // pageW = Column(
      //   children: [const UserBar(), body],
      // );
    }

    return pageW;
  }

  /// 构建二级页面头部
  PreferredSizeWidget _buildTitle(bool isHomePage) {
    print('>>>topbar isHomePage: $isHomePage titleName: $titleName');
    return AppBar(
      title: isHomePage
          ? UserBar(
              title: titleName,
              data: parentRouteParam,
              actions: operations,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                titleWidget ??
                    Text(
                      titleName,
                      style: titleStyle ??
                          TextStyle(color: Colors.black, fontSize: 24.sp),
                    ),
                if (null != operations)
                  Padding(
                    padding: EdgeInsets.only(right: 10.w),
                    child: Row(
                      children: operations!,
                    ),
                  ),
              ],
            ),
      centerTitle: centerTitle,
      elevation: elevation,
      toolbarOpacity: isHomePage ? 0 : 1.0,
      backgroundColor: appBarColor,
      shadowColor: appBarColor,
      surfaceTintColor: appBarColor,
      actions: isHomePage ? null : actions,
      leading: isHomePage ? null : leading ?? BackButton(color: backColor),
      leadingWidth: isHomePage ? 0 : leadingWidth,
      titleSpacing: isHomePage ? 0 : titleSpacing,
      // toolbarHeight: isHomePage ? null : toolbarHeight ?? 74.h,
    );
  }
}
