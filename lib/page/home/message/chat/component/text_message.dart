import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../config/custom_colors.dart';

class TextMessage extends StatelessWidget {
  final String? message;

  const TextMessage(this.message, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
          color: CustomColors.seaBlue,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 160),
        child: Text(message ?? ""),
      ),
    );
  }
}
