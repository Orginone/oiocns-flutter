import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orginone/dart/base/schema.dart';

/// recording attributes of rich text segments
class Rule {
  final int startIndex;
  final int endIndex;

  /// extra attribute,you can put like userId and so on
  final XTarget? target;

  Rule(this.startIndex, this.endIndex, this.target);

  Rule copy([startIndex, endIndex, target]) {
    return Rule(startIndex ?? this.startIndex, endIndex ?? this.endIndex,
        target ?? this.target);
  }

  @override
  String toString() {
    return "startIndex : $startIndex , endIndex : $endIndex, target :$target";
  }
}

typedef TriggerAtCallback = Future<List<XTarget>?> Function();

typedef ValueChangedCallback = void Function(List<Rule> rules, String value);

/// it can trigger callback when you input special symbol like @person
class RichTextInputFormatter extends TextInputFormatter {
  TriggerAtCallback _triggerAtCallback;
  ValueChangedCallback? _valueChangedCallback;

  TextEditingController controller;
  List<Rule> _rules;

  /// trigger symbol,when input this ,the [_triggerAtCallback] will be called
  final String triggerSymbol;

  /// compatible with Xiaomi ,because the formatEditUpdate method will be called multiple times on Xiaomi
  bool _flag = false;

  List<Rule> get rules => _rules.map((Rule rule) => rule.copy()).toList();

  RichTextInputFormatter({
    required TriggerAtCallback triggerAtCallback,
    ValueChangedCallback? valueChangedCallback,
    required this.controller,
    this.triggerSymbol = "@",
  })  : assert(triggerAtCallback != null && controller != null),
        _rules = [],
        _triggerAtCallback = triggerAtCallback,
        _valueChangedCallback = valueChangedCallback;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (_flag) {
      /// compatible with Xiaomi
      return oldValue;
    }

    /// determine whether to add or delete
    bool isAdding = oldValue.text.length < newValue.text.length;
    if (isAdding && oldValue.selection.start == oldValue.selection.end) {
      /// adding
      if (newValue.text.length - oldValue.text.length == 1 &&
          newValue.text.substring(
                  newValue.selection.start - 1, newValue.selection.end) ==
              triggerSymbol) {
        /// the adding char is [triggerSymbol]
        triggerAt(oldValue, newValue);
      }
    } else {
      /// delete or replace content (include directly delete and select some segment to replace)
      /// 删除或替换内容 （含直接delete、选中后输入别的字符替换）
      if (!oldValue.composing.isValid ||
          oldValue.selection.start != oldValue.selection.end) {
        /// 直接delete情况 / 选中一部分替换的情况
        return checkRules(oldValue, newValue);
      }
    }
    _correctRules(
        oldValue.selection.start, oldValue.text.length, newValue.text.length);
    _valueChangedCallback?.call(rules, newValue.text);
    return newValue;
  }

  /// 当长度发生变化需要对旧的受影响的rule修正索引
  void _correctRules(int oldStartIndex, int oldLength, int newLength) {
    /// old startIndex
    int diffLength = newLength - oldLength;
    for (int i = 0; i < _rules.length; i++) {
      if (_rules[i].startIndex >= oldStartIndex) {
        int newStartIndex = _rules[i].startIndex + diffLength;
        int newEndIndex = _rules[i].endIndex + diffLength;
        _rules.replaceRange(
            i, i + 1, <Rule>[_rules[i].copy(newStartIndex, newEndIndex)]);
      }
    }
  }

  /// trigger special callback
  /// 触发[triggerSymbol]操作
  void triggerAt(TextEditingValue oldValue, TextEditingValue newValue,
      {XTarget? t}) async {
    /// 新值的选中光标的开始位置
    int selStart = math.max(newValue.selection.start, 1);

    /// 调用外部选人回调，返回具体参数
    List<XTarget>? target = t != null ? [t] : await _triggerAtCallback();
    if (target != null) {
      List nameArr = target.map((e) => '${e.name} ').toList();
      var atNameStr = nameArr.join('@');
      int startIndex = selStart - 1; // 新值的选中光标的后面一个的字符
      String newString;
      String currentText = t != null ? "${controller.text}@" : controller.text;
      if (selStart < currentText.length) {
        /// 如果光标是在原来字符的中间
        newString =
            "${currentText.substring(0, startIndex + 1)}${atNameStr} ${currentText.substring(startIndex + 1, currentText.length)}";
      } else {
        /// 如果光标是在字符串最后面
        newString = "$currentText${atNameStr} ";
      }
      int endIndex = startIndex + (newString.length - currentText.length);
      controller.text = newString;

      /// 改变光标位置
      controller.selection = controller.selection.copyWith(
        baseOffset: endIndex + 1,
        extentOffset: endIndex + 1,
      );
      _correctRules(
          oldValue.selection.start, currentText.length, newString.length);

      for (var element in target) {
        _rules.add(Rule(startIndex, endIndex, element));
      }

      _valueChangedCallback?.call(rules, controller.text);
    }
  }

  /// 检查被删除/替换的内容是否涉及到rules里的特殊segment并处理，另外作字符的处理替换
  TextEditingValue checkRules(
      TextEditingValue oldValue, TextEditingValue newValue) {
    /// 旧的文本的光标是否选中了部分
    bool isOldSelectedPart = oldValue.selection.start != oldValue.selection.end;

    /// 因为选中删除 和 直接delete删除的开始光标位置不一，故作统一处理
    int startIndex = isOldSelectedPart
        ? oldValue.selection.start
        : oldValue.selection.start - 1;
    int endIndex = oldValue.selection.end;

    /// 用于迭代的时候不能删除的处理
    List<Rule> delRules = [];
    for (int i = 0; i < _rules.length; i++) {
      Rule rule = _rules[i];
      if ((startIndex >= rule.startIndex && startIndex <= rule.endIndex) ||
          (endIndex >= rule.startIndex + 1 && endIndex <= rule.endIndex + 1)) {
        /// 原字符串选中的光标范围 与 rule的范围相交，命中
        delRules.add(rule);

        /// 对命中的rule 的边界与原字符串选中的光标边界比较，对原来的选中要被替换/删除的光标界限 进行扩展
        /// 用来自动覆盖@user 的全部字符
        startIndex = math.min(startIndex, rule.startIndex);
        endIndex = math.max(endIndex, rule.endIndex + 1);
      }
    }

    /// 清除掉不需要的rule
    for (int i = 0; i < delRules.length; i++) {
      _rules.remove(delRules[i]);
    }

    /// 对选中部分原字符串，键盘一次输入字符的替换处理，即找出新旧字符串之间的差异部分
    String newStartSelBeforeStr = newValue.text.substring(
        0, newValue.selection.start < 0 ? 0 : newValue.selection.start);
    String oldStartSelBeforeStr =
        oldValue.text.substring(0, oldValue.selection.start);
    String middleStr = "";
    if (newStartSelBeforeStr.length >= oldStartSelBeforeStr.length &&
        (oldValue.selection.end != oldValue.selection.start) &&
        newStartSelBeforeStr.compareTo(oldStartSelBeforeStr) != 0) {
      /// 此时为选中的删除时 有增加新的字符串的情况
      middleStr = newValue.text
          .substring(oldValue.selection.start, newValue.selection.end);
    } else {
      /// 此时为选中的删除时 没有增加新的字符串的情况
    }

    int leftSubStringEndIndex =
        startIndex > oldValue.text.length ? oldValue.text.length : startIndex;
    String leftValue = startIndex == 0
        ? ""
        : oldValue.text.substring(0, leftSubStringEndIndex);

    String middleValue = middleStr;
    String rightValue = endIndex == oldValue.text.length
        ? ""
        : oldValue.text.substring(endIndex, oldValue.text.length);
    String value = "$leftValue$middleValue$rightValue";

    /// 计算最终光标位置
    final TextSelection newSelection = newValue.selection.copyWith(
      baseOffset: leftValue.length + middleValue.length,
      extentOffset: leftValue.length + middleValue.length,
    );

    _correctRules(
        oldValue.selection.start, oldValue.text.length, newValue.text.length);

    /// 为了解决小米note的兼容问题
    _flag = true;
    Future.delayed(const Duration(milliseconds: 10), () => _flag = false);

    _valueChangedCallback?.call(rules, value);
    return TextEditingValue(
      text: value,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }

  void manualAdd(XTarget target) {
    var textSelection = TextSelection(
      baseOffset: controller.value.selection.baseOffset + 1,
      extentOffset: controller.value.selection.extentOffset + 1,
    );
    triggerAt(
        controller.value,
        TextEditingValue(
            text: "${controller.value.text}@", selection: textSelection),
        t: target);
  }

  void clear() {
    _rules.clear();
  }
}
