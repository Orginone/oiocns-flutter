import 'package:flutter/material.dart';

class PopupWidget<T> extends StatefulWidget {
  final PopupMenuItemBuilder<T> itemBuilder;

  final Widget child;

  final VoidCallback? onTap;

  final bool enabled;

  final EdgeInsetsGeometry padding;

  final PopupMenuPosition? position;

  final Offset offset;

  final double? elevation;

  final Color? shadowColor;

  final Color? surfaceTintColor;

  final T? initialValue;

  final ShapeBorder? shape;

  final Color? color;

  final BoxConstraints? constraints;

  final Clip clipBehavior;

  final PopupMenuItemSelected<T>? onSelected;

  final PopupMenuCanceled? onCanceled;

  const PopupWidget(
      {Key? key,
      required this.itemBuilder,
      required this.child,
      this.onTap,
      this.enabled = true,
      this.padding = const EdgeInsets.all(8.0),
      this.position,
      this.offset = Offset.zero,
      this.elevation,
      this.shadowColor,
      this.surfaceTintColor,
      this.initialValue,
      this.shape,
      this.color,
      this.constraints,
      this.clipBehavior = Clip.none,
      this.onSelected,
      this.onCanceled})
      : super(key: key);

  @override
  State<PopupWidget<T>> createState() => _PopupWidgetState<T>();
}

class _PopupWidgetState<T> extends State<PopupWidget<T>> {
  bool get _canRequestFocus {
    final NavigationMode mode = MediaQuery.maybeOf(context)?.navigationMode ??
        NavigationMode.traditional;
    switch (mode) {
      case NavigationMode.traditional:
        return widget.enabled;
      case NavigationMode.directional:
        return true;
    }
  }

  void showButtonMenu() {
    final PopupMenuThemeData popupMenuTheme = PopupMenuTheme.of(context);
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final PopupMenuPosition popupMenuPosition =
        widget.position ?? popupMenuTheme.position ?? PopupMenuPosition.over;
    final Offset  offset =
        Offset(0.0, button.size.height - (widget.padding.vertical / 2)) +
            widget.offset;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(button.size.width,button.size.height/2), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
            ancestor: overlay),
      ),
      Offset(button.size.width/3,0) & overlay.size,
    );
    final List<PopupMenuEntry<T>> items = widget.itemBuilder(context);
    if (items.isNotEmpty) {
      showMenu<T?>(
        context: context,
        elevation: widget.elevation ?? popupMenuTheme.elevation,
        shadowColor: widget.shadowColor ?? popupMenuTheme.shadowColor,
        surfaceTintColor:
            widget.surfaceTintColor ?? popupMenuTheme.surfaceTintColor,
        items: items,
        initialValue: widget.initialValue,
        position: position,
        shape: widget.shape ?? popupMenuTheme.shape,
        color: widget.color ?? popupMenuTheme.color,
        constraints: widget.constraints,
        clipBehavior: widget.clipBehavior,
      ).then<void>((T? newValue) {
        if (!mounted) {
          return null;
        }
        if (newValue == null) {
          widget.onCanceled?.call();
          return null;
        }
        widget.onSelected?.call(newValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: widget.enabled ? showButtonMenu : null,
      onTap: widget.onTap,
      canRequestFocus: _canRequestFocus,
      child: widget.child,
    );
  }
}
