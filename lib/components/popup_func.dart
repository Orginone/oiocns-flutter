import 'package:flutter/material.dart';

class PopupFunc<T> extends PopupMenuEntry<T> {
  final T? value;
  final Widget func;

  @override
  final double height;

  const PopupFunc({
    this.value,
    required this.height,
    required this.func,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PopupFuncState();

  @override
  bool represents(value) => value == this.value;
}

class _PopupFuncState<T> extends State<PopupFunc<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.func;
  }
}
