import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../common/extension/clip_circle.dart';

abstract class BaseCommonWidget extends StatefulWidget {
  final Color? rippleColor;
  final bool? blackRippleColor;
  final bool? useRipple;
  final GestureTapCallback? onTap;
  final GestureLongPressCallback? onLongPress;
  final GestureTapDownCallback? onTapDown;
  final GestureTapCancelCallback? onTapCancel;
  final double? width;
  final double? height;
  final bool? isCircle;
  final Color? bgColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool? isBlur;
  final Color? blurColor;
  final double? blurSigmaX;
  final double? blurSigmaY;
  final Decoration? decoration;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;
  final InkShowPos? inkShowPos;
  final AlignmentGeometry? alignment;
  final bool? enabled;
  final Gradient? gradient;
  final Widget? customBg;
  final PopupOnEvent? popupOnEvent;
  final BoxConstraints? constraints;
  final HitTestBehavior? behavior;
  const BaseCommonWidget({
    Key? key,
    bool? useRipple,
    this.rippleColor,
    bool? blackRippleColor,
    this.onTap,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.width,
    this.height,
    bool? isCircle,
    this.bgColor,
    this.borderRadius,
    this.padding,
    bool? isBlur,
    Color? blurColor,
    double? blurSigmaX,
    double? blurSigmaY,
    this.decoration,
    this.border,
    this.boxShadow,
    this.margin,
    InkShowPos? inkShowPos,
    AlignmentGeometry? alignment,
    bool? enabled,
    this.gradient,
    this.customBg,
    this.constraints,
    PopupOnEvent? popupOnEvent,
    this.behavior,
  })  : useRipple = useRipple ?? true,
        blackRippleColor = blackRippleColor ?? true,
        isCircle = isCircle ?? false,
        isBlur = isBlur ?? false,
        blurColor = blurColor ?? Colors.transparent,
        blurSigmaX = blurSigmaX ?? 5,
        blurSigmaY = blurSigmaY ?? 5,
        inkShowPos = inkShowPos ?? InkShowPos.topLevel,
        alignment = alignment ?? Alignment.center,
        enabled = enabled ?? true,
        popupOnEvent = popupOnEvent ?? PopupOnEvent.onTap,
        super(key: key);

  bool isContentClip() {
    return true;
  }
}

abstract class BaseCommonWidgetState<T extends BaseCommonWidget>
    extends State<T> {
  @override
  Widget build(BuildContext context) {
    var rootWidget = _buildRootWidget(
      sizeWidget: _buildSizeWidget(),
      bgWidget: _buildBgWidget(),
      contentWidget: buildContentWidget(),
      contentPlaceholderWidget: buildContentPlaceholderWidget(),
      blurWidget: _buildBlurWidget(),
    );
    return widget.margin == null
        ? rootWidget
        : Padding(
            padding: widget.margin!,
            child: rootWidget,
          );
  }

  Widget? _buildSizeWidget() {
    if (widget.width != null || widget.height != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
      );
    }
    return null;
  }

  Widget? _buildBgWidget() {
    if (widget.customBg != null) {
      return widget.customBg;
    }
    if (widget.bgColor == null &&
        widget.decoration == null &&
        widget.border == null &&
        widget.boxShadow == null &&
        widget.gradient == null) {
      return null;
    }
    return Container(
      padding: widget.padding,
      decoration: widget.decoration ??
          BoxDecoration(
            color: widget.bgColor,
            borderRadius: widget.borderRadius,
            border: widget.border,
            boxShadow: widget.boxShadow,
            gradient: widget.gradient,
          ),
      constraints: widget.constraints,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
      ),
    );
  }

  Widget? buildContentWidget();

  Widget? buildContentPlaceholderWidget() {
    return null;
  }

  Widget? _buildBlurWidget() {
    if (widget.isBlur!) {
      Widget blurWidget = BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: widget.blurSigmaX!,
          sigmaY: widget.blurSigmaY!,
        ),
        child: Container(
          color: widget.blurColor,
          // width: widget.width,
          // height: widget.height,
        ),
      );
      if (widget.borderRadius != null) {
        blurWidget = ClipRRect(
          child: blurWidget,
          // borderRadius: widget.borderRadius,
        );
      }
      return blurWidget;
    }
    return null;
  }

  Widget? _buildInkWidget({Widget? child}) {
    GestureTapCallback? onTap;
    GestureLongPressCallback? onLongPress;
    if (widget.onTap != null) {
      onTap = widget.onTap;
    }
    if (widget.onLongPress != null) {
      onLongPress = widget.onLongPress;
    }
    if ((onTap == null && onLongPress == null) || !widget.enabled!) {
      return child;
    }
    if (!kDebugMode) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onTapDown: widget.onTapDown,
        onTapCancel: widget.onTapCancel,
        behavior: widget.behavior,
        child: child,
      );
    }
    if (!widget.useRipple!) {
      return GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        onTapDown: widget.onTapDown,
        onTapCancel: widget.onTapCancel,
        child: child,
      );
    }
    Color? splashColor;
    if (widget.rippleColor == null) {
      splashColor = widget.blackRippleColor! ? Colors.black : Colors.white;
    } else {
      splashColor = widget.rippleColor;
    }

    return Material(
      type: MaterialType.transparency,
      child: InkResponse(
        splashColor: splashColor,
        onTap: onTap,
        onTapDown: widget.onTapDown,
        onTapCancel: widget.onTapCancel,
        onLongPress: onLongPress,
        highlightShape: BoxShape.rectangle,
        borderRadius: widget.borderRadius,
        containedInkWell: true,
        child: child,
      ),
    );
  }

  Widget _buildRootWidget({
    Widget? sizeWidget,
    Widget? bgWidget,
    Widget? contentWidget,
    Widget? contentPlaceholderWidget,
    Widget? blurWidget,
  }) {
    List<Widget> widgets = [];
    List<_WidgetInfo> infoList = [];
    if (sizeWidget != null) {
      infoList.add(_WidgetInfo(
        widget: sizeWidget,
        fillHorizontal: false,
        fillVertical: false,
      ));
    }
    if (bgWidget != null) {
      infoList.add(_WidgetInfo(
        widget: bgWidget,
        fillHorizontal: true,
        fillVertical: true,
      ));
    }

    if (widget.inkShowPos == InkShowPos.underContent) {
      Widget? inkWidget = _buildInkWidget();
      if (inkWidget != null) {
        infoList.add(_WidgetInfo(
          widget: inkWidget,
          fillHorizontal: true,
          fillVertical: true,
        ));
      }
    }

    addContentWidget(contentPlaceholderWidget, infoList);
    addContentWidget(contentWidget, infoList);

    if (blurWidget != null) {
      infoList.add(_WidgetInfo(
        widget: blurWidget,
        fillHorizontal: true,
        fillVertical: true,
      ));
    }
    if (widget.inkShowPos == InkShowPos.topLevel) {
      Widget? inkWidget = _buildInkWidget();
      if (inkWidget != null) {
        infoList.add(_WidgetInfo(
          widget: inkWidget,
          fillHorizontal: true,
          fillVertical: true,
        ));
      }
    }
    if (infoList.length > 1) {
      for (var info in infoList) {
        double? horizontal = info.fillHorizontal ? 0 : null;
        double? vertical = info.fillVertical ? 0 : null;
        widgets.add(
          (info.fillHorizontal || info.fillVertical)
              ? Positioned(
                  left: horizontal,
                  top: vertical,
                  right: horizontal,
                  bottom: vertical,
                  child: info.widget,
                )
              : info.widget,
        );
      }
    } else {
      for (var info in infoList) {
        widgets.add(info.widget);
      }
    }
    if (widgets.isEmpty) {
      return const SizedBox();
    } else if (widgets.length == 1) {
      Widget firstWidget = widgets.first;
      if (widget.isCircle!) {
        if (firstWidget is ClipCircle) {
          return firstWidget;
        }
        return ClipCircle(
          child: firstWidget,
        );
      }
      return firstWidget;
    }
    Widget rootWidget = Stack(
      alignment: widget.alignment!,
      fit: StackFit.loose,
      children: widgets,
    );
    if (widget.isCircle!) {
      return ClipCircle(
        child: rootWidget,
      );
    } else {
      return rootWidget;
    }
  }

  void addContentWidget(Widget? contentWidget, List<_WidgetInfo> infoList) {
    if (contentWidget == null) {
      return;
    }
    if (widget.padding != null) {
      if (widget.isContentClip()) {
        contentWidget = Padding(
          padding: widget.padding!,
          child: widget.isCircle!
              ? ClipCircle(
                  child: contentWidget,
                )
              : widget.borderRadius != null
                  ? ClipRRect(
                      child: contentWidget,
                      // borderRadius: widget.borderRadius,
                    )
                  : contentWidget,
        );
      } else {
        contentWidget = Padding(
          padding: widget.padding!,
          child: contentWidget,
        );
      }
    } else if (widget.borderRadius != null && widget.isContentClip()) {
      contentWidget = ClipRRect(
        child: contentWidget,
        // borderRadius: widget.borderRadius,
      );
    }

    if (widget.inkShowPos == InkShowPos.wrapContent) {
      Widget inkWidget = _buildInkWidget(child: contentWidget)!;
      infoList.add(_WidgetInfo(
        widget: inkWidget,
      ));
    } else {
      infoList.add(_WidgetInfo(
        widget: contentWidget,
      ));
    }
  }
}

class _WidgetInfo {
  final Widget widget;
  final bool fillHorizontal;
  final bool fillVertical;

  _WidgetInfo({
    required this.widget,
    this.fillHorizontal = false,
    this.fillVertical = false,
  });
}

enum InkShowPos {
  /// 置于内容之下，背景层之上
  underContent,

  /// 包裹内容
  wrapContent,

  /// 置于顶层
  topLevel,
}

/// popup window 弹出时机
enum PopupOnEvent {
  onTap,
  onLongPress,
}
