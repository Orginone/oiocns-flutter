import 'package:flutter/material.dart';

class TextHighlight extends StatelessWidget {
  final TextStyle? normalStyle;
  final TextStyle? highlightStyle;
  final String? content;
  final String? keyWord;
  final int maxLines;
  const TextHighlight(
      {super.key,
      this.content,
      this.keyWord,
      this.normalStyle,
      this.highlightStyle,
      this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    if (keyWord == null || keyWord == "") {
      return Text(
        content!,
        style: normalStyle,
      );
    }
    List<TextSpan> spans = [];
    int start = 0;
    int end;
    while ((end = content!.indexOf(keyWord!, start)) != -1) {
      spans.add(
          TextSpan(text: content!.substring(start, end), style: normalStyle));
      spans.add(TextSpan(text: keyWord, style: highlightStyle));
      start = end + keyWord!.length;
    }
    spans.add(TextSpan(
        text: content!.substring(start, content!.length), style: normalStyle));
    return RichText(
      text: TextSpan(children: spans),
      maxLines: maxLines,
    );
  }
}
