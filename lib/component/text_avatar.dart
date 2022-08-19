import 'package:flutter/material.dart';

import '../config/custom_colors.dart';

class TextAvatar extends StatelessWidget {
  final String avatarName;

  const TextAvatar(this.avatarName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
        child: Container(
          alignment: Alignment.center,
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
              color: CustomColors.blue,
              borderRadius: BorderRadius.all(Radius.circular(5))),
          child: Text(avatarName, style: const TextStyle(color: Colors.white)),
        ));
  }
}
