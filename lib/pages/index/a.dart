import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('My Drawer'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // 处理Item 1的单击事件
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // 处理Item 2的单击事件
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          print('11111111111111111111111111111111111111111');
          // 打开抽屉
          Scaffold.of(context).openDrawer();
        },
        child: Center(
          child: Text('Tap to open drawer!111'),
        ),
      ),
    );
  }
}
