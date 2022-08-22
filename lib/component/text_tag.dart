import 'package:flutter/material.dart';

import '../config/custom_colors.dart';

class TextTag extends StatelessWidget {
  final String label;

  const TextTag(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(1),
        decoration: const BoxDecoration(
            color: CustomColors.lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        padding: const EdgeInsets.all(2),
        child: Text(
          label,
          style: const TextStyle(fontSize: 10, color: CustomColors.blue),
        ));
  }
}
