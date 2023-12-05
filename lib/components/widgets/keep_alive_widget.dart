import 'package:flutter/material.dart';

class KeepAliveWidget extends StatefulWidget {
  final Widget child;

  const KeepAliveWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  _KeepAliveWidgetState createState() => _KeepAliveWidgetState();
}

class _KeepAliveWidgetState extends State<KeepAliveWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: const Color.fromARGB(255, 240, 240, 240),
      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: widget.child,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
