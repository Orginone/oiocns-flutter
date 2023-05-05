import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orginone/dart/base/schema.dart' hide Rule;

import 'rich_text_input_formatter.dart';

/// 绑定软键盘的输入框，可跟随键盘弹出和收起 ，调用KeyboardInputState.popKeyboard即可
///

typedef DoneCallback = Future<bool> Function(List<Rule> rules, String value);

class AtTextFiled extends StatefulWidget {
  final TriggerAtCallback triggerAtCallback;

  final DoneCallback? doneCallback;

  final ValueChanged<String>? onChanged;

  final InputDecoration? decoration;
  final TextStyle? style;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final int? maxLines;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final GestureTapCallback? onTap;

  const AtTextFiled(
      {Key? key,
      required this.triggerAtCallback,
      this.doneCallback,
      this.onChanged,
      this.decoration,
      this.style,
      this.inputFormatters,
      this.controller,
      this.maxLines,
      this.keyboardType,
      this.focusNode,
      this.onTap})
      : super(key: key);

  @override
  AtTextFiledState createState() => AtTextFiledState();
}

class AtTextFiledState extends State<AtTextFiled> {
  late TextEditingController _controller;
  late FocusNode focusNode;
  String? _inputValue;

  List<Rule> _rules = [];

  late RichTextInputFormatter _formatter;

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      controller: _controller,
      focusNode: focusNode,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      decoration: widget.decoration,
      style: widget.style,
      inputFormatters: widget.inputFormatters == null
          ? [_formatter]
          : (widget.inputFormatters!..add(_formatter)),
    );
  }

  void _init() {
    _controller = widget.controller ?? TextEditingController();
    focusNode = widget.focusNode ?? FocusNode();
    _formatter = RichTextInputFormatter(
        triggerAtCallback: () async {
          XTarget? target = await widget.triggerAtCallback();
          return target;
        },
        controller: _controller,
        valueChangedCallback: (List<Rule> rules, String value) {
          _inputValue = value;
          _rules = rules;
        },
    );
    _controller.text = "";
    _inputValue = "";
    _rules.clear();
    _formatter.clear();
  }

  void addTarget(XTarget target){
    _formatter.manualAdd(target);
  }
}
