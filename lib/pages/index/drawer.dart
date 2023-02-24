import 'package:flutter/material.dart';
// 在这个示例中，我们使用 Scaffold widget 来设置页面的布局，其中包含了一个 AppBar widget 作为页面的标题栏，以及一个 Drawer widget 作为抽屉菜单。Drawer widget 中包含了一个 ListView widget，用于显示抽屉菜单的列表项，其中包含了一个 DrawerHeader widget 作为列表的标题，以及两个 ListTile widget 作为列表的选项。通过点击 ListTile widget，我们可以触发 Navigator.pop 方法来关闭抽屉菜单。
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawer Menu Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawer Menu Demo'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorite'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Welcome to Drawer Menu Demo'),
      ),
    );
  }
}
