import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Item extends StatelessWidget {
  final String name;

  const Item({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: 5,
      ),
      Container(
          height: 80.h,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 20, 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(TextSpan(text: name)),
                  const Icon(
                    Icons.navigate_next,
                    // size: 32,
                  )
                ]),
          ))
    ]);
  }
}

enum PersonCenter {
  carBag('carBag', "卡包"),
  security('security', "安全"),
  dynamic('dynamic', "动态"),
  mark('mark', "收藏");

  final String key;
  final String name;
  const PersonCenter(this.key, this.name);
}
