import 'package:flutter/material.dart';

class NNPopupRoute<T> extends PopupRoute<T> {
  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => false;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => const Duration(seconds: 0);

  final Color? backgroundViewColor;
  final Alignment alignment;
  final Widget child;
  final Function onClick;

  NNPopupRoute(
      {this.backgroundViewColor,
      this.alignment = Alignment.center,
      required this.onClick,
      required this.child});

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final screenSize = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            SafeArea(
              child: Align(
                alignment: alignment,
                child: child,
              ),
            ),
            SizedBox(
              width: screenSize.width,
              height: screenSize.height,
            ),
          ],
        ),
        onTap: () {
          onClick();
        },
      ),
    );
  }
}
