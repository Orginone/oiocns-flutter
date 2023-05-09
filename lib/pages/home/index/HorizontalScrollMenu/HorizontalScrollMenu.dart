import 'dart:collection';

import 'package:flutter/material.dart';

class HorizontalScrollMenu extends StatelessWidget {
  final LinkedHashMap<String, dynamic> items;

  const HorizontalScrollMenu({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate([
          Row(
            children: items.entries.map((entry) {
              return GestureDetector(
                onTap: entry.value['func'],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 92,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Icon(entry.value['icon']),
                          Text(entry.value['cardName']),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ]))
      ],
      // scrollDirection: Axis.horizontal,
      // padding: EdgeInsets.all(4),
      // primary: true,
      // child: Container(
      //   child: Row(
      //     children: items.entries.map((entry) {
      //       return GestureDetector(
      //         onTap: entry.value['func'],
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.start,
      //           children: [
      //             const SizedBox(
      //               width: 92,
      //             ),
      //             Padding(
      //               padding: EdgeInsets.symmetric(horizontal: 10),
      //               child: Column(
      //                 children: [
      //                   Icon(entry.value['icon']),
      //                   Text(entry.value['cardName']),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       );
      //     }).toList(),
      //   ),
      // ),
    );
  }
}

void main() {
  LinkedHashMap<String, dynamic> testData = LinkedHashMap.from({
    '1': {
      'id': '1',
      'icon': Icons.home,
      'cardName': 'Home',
      'func': () => print('Home pressed')
    },
    '2': {
      'id': '2',
      'icon': Icons.settings,
      'cardName': 'Settings',
      'func': () => print('Settings pressed')
    },
    '3': {
      'id': '3',
      'icon': Icons.person,
      'cardName': 'Profile',
      'func': () => print('Profile pressed')
    },
    '4': {
      'id': '4',
      'icon': Icons.notifications,
      'cardName': 'Notifications',
      'func': () => print('Notifications pressed')
    },
  });

  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Horizontal Scroll Menu Example')),
      body: Center(
        child: HorizontalScrollMenu(items: testData),
      ),
    ),
  ));
}
