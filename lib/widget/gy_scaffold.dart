import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/config/color.dart';

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

  final Widget? leading;

  final double elevation;

  final Color? backColor;

  final double? leadingWidth;

  final Widget? bottomNavigationBar;

  final double? toolbarHeight;

  const GyScaffold({Key? key,
    this.body,
    this.supportSafeArea = true,
    this.backgroundColor,
    this.appBarColor,
    this.titleName,
    this.titleWidget,
    this.titleStyle,
    this.centerTitle = true,
    this.actions,
    this.leading,
    this.elevation = 0,
    this.backColor,
    this.leadingWidth,
    this.bottomNavigationBar,
    this.toolbarHeight})
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

  Widget? leading;

  late double elevation;

  late Color backColor;

  late double leadingWidth;

  double? toolbarHeight;

  Widget? bottomNavigationBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() {
    body = widget.body ?? Container();
    supportSafeArea = widget.supportSafeArea;
    backgroundColor = widget.backgroundColor ?? GYColors.backgroundColor;
    appBarColor = widget.appBarColor ?? Colors.white;
    titleName = widget.titleName ?? "";
    titleWidget = widget.titleWidget;
    titleStyle = widget.titleStyle;
    centerTitle = widget.centerTitle;
    actions = widget.actions;
    leading = widget.leading;
    elevation = widget.elevation;
    backColor = widget.backColor ?? Colors.black;
    leadingWidth = widget.leadingWidth ?? kToolbarHeight;
    bottomNavigationBar = widget.bottomNavigationBar;
    toolbarHeight = widget.toolbarHeight;
  }

  @override
  void didUpdateWidget(covariant GyScaffold oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.body != widget.body){
      body = widget.body ?? Container();
    }
    if(oldWidget.supportSafeArea != widget.supportSafeArea){
      supportSafeArea = widget.supportSafeArea;
    }
    if(oldWidget.backgroundColor != widget.backgroundColor){
      backgroundColor = widget.backgroundColor ?? GYColors.backgroundColor;
    }
    if(oldWidget.appBarColor != widget.appBarColor){
      appBarColor = widget.appBarColor ?? XColors.themeColor;
    }
    if(oldWidget.titleName != widget.titleName){
      titleName = widget.titleName ?? "";
    }
    if(oldWidget.titleWidget != widget.titleWidget){
      titleWidget = widget.titleWidget;
    }
    if(oldWidget.titleStyle != widget.titleStyle){
      titleStyle = widget.titleStyle;
    }
    if(oldWidget.centerTitle != widget.centerTitle){
      centerTitle = widget.centerTitle;
    }
    if(oldWidget.actions != widget.actions){
      actions = widget.actions;
    }
    if(oldWidget.leading != widget.leading){
      leading = widget.leading;
    }
    if(oldWidget.elevation != widget.elevation){
      elevation = widget.elevation;
    }
    if(oldWidget.backColor != widget.backColor){
      backColor = widget.backColor??Colors.black;
    }
    if(oldWidget.leadingWidth != widget.leadingWidth){
      leadingWidth = widget.leadingWidth??kToolbarHeight;
    }
    if(oldWidget.bottomNavigationBar != widget.bottomNavigationBar){
      bottomNavigationBar = widget.bottomNavigationBar;
    }
    if(oldWidget.toolbarHeight != widget.toolbarHeight){
      toolbarHeight = widget.toolbarHeight;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (supportSafeArea) {
      body = SafeArea(
        child: body,
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: titleWidget ??
              Text(
                titleName,
                style: titleStyle ??
                    TextStyle(color: Colors.black, fontSize: 24.sp),
              ),
          centerTitle: centerTitle,
          elevation: elevation,
          backgroundColor: appBarColor,
          actions: actions,
          leading: leading ?? BackButton(color: backColor),
          leadingWidth: leadingWidth,
          toolbarHeight:toolbarHeight,
        ),
        backgroundColor: backgroundColor,
        body: body,bottomNavigationBar: bottomNavigationBar,);
  }
}
