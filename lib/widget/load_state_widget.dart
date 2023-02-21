import 'package:flutter/material.dart';

import 'text_widget.dart';

typedef ChildBuilder = Widget Function();
typedef ParentBuilder = Widget Function(Widget child);

class LoadStateWidget extends StatefulWidget {
  final bool? isLoading;
  final bool? isSuccess;
  final bool? isEmpty;
  final Widget? child;
  final ChildBuilder? builder;
  final GestureTapCallback? onRetry;
  final bool? loginOnly;
  final bool? hasData;
  final bool antiColor;
  final ParentBuilder? parentBuilder;

  // final Color bgColor;

  LoadStateWidget({
    Key? key,
    this.isSuccess,
    this.isEmpty,
    this.child,
    this.builder,
    this.isLoading,
    this.onRetry,
    this.loginOnly,
    this.hasData,
    this.antiColor = false,
    this.parentBuilder,
    // this.bgColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _LoadStateWidgetState();
  }
}

class _LoadStateWidgetState extends State<LoadStateWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant LoadStateWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading ||
        oldWidget.isSuccess != widget.isSuccess) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading ?? false) {
      return _buildLoadingWidget();
    }
    if (widget.hasData ?? false) {
      return _buildSuccessWidget();
    }
    if (widget.isSuccess ?? false) {
      if (widget.isEmpty ?? false) {
        return _buildEmptyWidget();
      } else {
        return _buildSuccessWidget();
      }
    }
    return _buildErrorWidget();
  }

  Widget _buildLoadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      // color: widget.bgColor,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.antiColor
              ? CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : CircularProgressIndicator(color:Theme.of(context).accentColor,),
        ],
      ),
    );
  }

  Widget _buildSuccessWidget() {
    if (widget.builder != null) {
      return widget.builder!();
    }
    return widget.child!;
  }

  Widget _buildEmptyWidget() {
    return SizedBox();
  }

  Widget _buildErrorWidget() {
    return _buildCommonWidget(showRetryButton: true,buttonText: "重新请求",onTap: widget.onRetry);
  }

  Widget _buildCommonWidget({
    String? msg,
    bool showRetryButton = false,
    double iconWidth = 180,
    double iconHeight = 180,
    String? buttonText,
    GestureTapCallback? onTap,
  }) {
    List<Widget> children = [];

    children.add(TextWidget(
      width: double.infinity,
      text: msg,
      padding: const EdgeInsets.only(
        left: 30,
        top: 20,
        right: 30,
      ),
      style: TextStyle(
        color: widget.antiColor ? Colors.white : Colors.grey,
        fontSize: 15,
      ),
    ));
    if (showRetryButton) {
      children.add(TextWidget(
        text: buttonText,
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 5,
        ),
        onTap: onTap,
        bgColor: widget.antiColor ? Colors.white : Theme.of(context).accentColor,
        style: TextStyle(
          color: widget.antiColor ? Theme.of(context).accentColor: Color(0xFFFFFFFF),
          fontSize: 16,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        margin: EdgeInsets.only(top: 30),
      ));
    }
    var column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
    if (widget.parentBuilder != null) {
      return widget.parentBuilder!(column);
    } else {
      return column;
    }
  }
}
