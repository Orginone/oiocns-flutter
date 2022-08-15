import 'package:flutter/material.dart';
import 'dart:ui';

class TextMessage extends StatelessWidget {
  final String? message;

  const TextMessage(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = window.physicalSize.height;
    double cropWidth = width * 0.6;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        constraints: BoxConstraints(maxWidth: cropWidth),
        child: Text(message ?? ""),
      ),
    );
  }
}
