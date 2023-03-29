import 'dart:collection';

import 'package:flutter/material.dart';

class HorizontalMenu extends StatelessWidget {
  final LinkedHashMap<String, dynamic> menuItems = LinkedHashMap.from({
    '1': {
      'id': '1',
      'icon': Icons.home,
      'cardName': 'Home',
      'func': () {
        // add functionality for Home menu item
      }
    },
    '2': {
      'id': '2',
      'icon': Icons.search,
      'cardName': 'Search',
      'func': () {
        // add functionality for Search menu item
      }
    },
    '3': {
      'id': '3',
      'icon': Icons.favorite,
      'cardName': 'Favorites',
      'func': () {
        // add functionality for Favorites menu item
      }
    },
    '4': {
      'id': '4',
      'icon': Icons.settings,
      'cardName': 'Settings',
      'func': () {
        // add functionality for Settings menu item
      }
    },
        '5': {
      'id': '5',
      'icon': Icons.search,
      'cardName': 'Search',
      'func': () {
        // add functionality for Search menu item
      }
    },
    '6': {
      'id': '6',
      'icon': Icons.favorite,
      'cardName': 'Favorites',
      'func': () {
        // add functionality for Favorites menu item
      }
    },
    '7': {
      'id': '7',
      'icon': Icons.settings,
      'cardName': 'Settings',
      'func': () {
        // add functionality for Settings menu item
      }
    },
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: menuItems.values
            .map((menuItem) => _buildMenuItem(context, menuItem))
            .toList(),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, dynamic menuItem) {
    return Container(
      width: 100,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: menuItem['func'],
        child: Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(menuItem['icon']),
              SizedBox(height: 5),
              Text(menuItem['cardName']),
            ],
          ),
        ),
      ),
    );
  }
}
