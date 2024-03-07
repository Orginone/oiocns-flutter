import 'package:flutter/material.dart';

class ActionContainer extends StatelessWidget {
  final Widget child;
  final Widget? floatingActionButton;

  const ActionContainer({
    super.key,
    required this.child,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return null != floatingActionButton
        ? _floatingActionButtonWidget(context)
        : _bottomActionButtonWidget(context);
    // Stack(children: <Widget>[
    //   child,
    //   Positioned(
    //     bottom: 16.0,
    //     right: 16.0,
    //     child: floatingActionButton,
    //   )
    // ]);
  }

  _bottomActionButtonWidget(BuildContext context) {}

  _floatingActionButtonWidget(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.white),
      child: Stack(
        children: [
          child,
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: floatingActionButton!,
          )
        ],
      ),
    );
  }
}
