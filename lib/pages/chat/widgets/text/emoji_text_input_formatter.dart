import 'package:flutter/services.dart';

class EmojiTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue,
      TextEditingValue newValue) {
    List<int> utf16Codes = [];
    TextEditingValue? editing;
    for (var element in newValue.text.runes) {
      if (_isUtf16Surrogate(element)) {
        utf16Codes.add(element);
      }
    }
    if (utf16Codes.isNotEmpty) {
      List<int> codes = newValue.text.runes.toList();
      codes.removeWhere((element) => utf16Codes.contains(element));
      TextSelection selection = TextSelection(
          baseOffset: newValue.selection.baseOffset,
          extentOffset: newValue.selection.extentOffset - utf16Codes.length);
      editing = newValue.copyWith(text: String.fromCharCodes(codes),
          selection: selection,
          composing: TextRange(start: newValue.composing.start,
              end: newValue.composing.end - utf16Codes.length));
    }
    return editing ?? newValue;
  }


  bool _isUtf16Surrogate(int value) {
    return value & 0xF800 == 0xD800;
  }
}