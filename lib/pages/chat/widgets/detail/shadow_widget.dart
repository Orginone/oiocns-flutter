

import 'package:flutter/material.dart';

class ShadowWidget extends StatelessWidget {

  final Widget child;

  const ShadowWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      foregroundDecoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          // Add one stop for each color. Stops should increase from 0 to 1
          stops: [0.2, 0.7],
          colors: [
            Color.fromARGB(100, 0, 0, 0),
            Color.fromARGB(100, 0, 0, 0),
          ],
        ),
      ),
      child: child,
    );
  }
}
