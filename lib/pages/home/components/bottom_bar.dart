


import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {

  final TabController? controller;

  final List<Widget> tabs;

  final ValueChanged<int>? onTap;

  const BottomBar({Key? key, this.controller, required this.tabs, this.onTap}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> with SingleTickerProviderStateMixin{


  late TabController controller;

  late List<Widget> tabs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabs = widget.tabs;
    controller = widget.controller??TabController(length: tabs.length, vsync: this);
    controller.addListener(() {

    });
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.tabs!=oldWidget.tabs){
      tabs = widget.tabs;
      controller = widget.controller??TabController(length: tabs.length, vsync: this);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: tabs,
      onTap: (index) {
         if(widget.onTap!=null){
           widget.onTap!(index);
         }
      },
    );
  }
}
