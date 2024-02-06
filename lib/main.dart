/*
 * @Descripttion:
 * @version:
 * @Author: congsir
 * @Date: 2022-12-07 18:33:34
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 20:50:17
 */
import 'main_base.dart';

import 'env.dart';

Future<void> main() async {
  EnvConfig.env = Env.prod;
  await initApp();
}

// import 'package:flutter/material.dart';

// void main() => runApp(
//       MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: MyApp(),
//       ),
//     );

// class TabInfo {
//   String label;
//   Widget widget;
//   TabInfo(this.label, this.widget);
// }

// class MyApp extends StatelessWidget {
//   final List<TabInfo> _tabs = [
//     TabInfo("SAN CLEMENTE", const Page1()),
//     TabInfo("HUNTINGTON BEACH", const Page1()),
//     TabInfo("SHAKE SHACK", const Page1()),
//     TabInfo("THE HAT", const Page1()),
//   ];

//   MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: _tabs.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Tab Controller'),
//           bottom: PreferredSize(
//             preferredSize: const Size.fromHeight(30.0),
//             child: TabBar(
//               isScrollable: true,
//               tabs: _tabs.map((TabInfo tab) {
//                 return Tab(text: tab.label);
//               }).toList(),
//             ),
//           ),
//         ),
//         body: TabBarView(children: _tabs.map((tab) => tab.widget).toList()),
//       ),
//     );
//   }
// }

// class Page1 extends StatelessWidget {
//   const Page1({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Container(
//           padding: const EdgeInsets.all(10.0),
//           child: Image.asset('assets/san-clemente.jpg'),
//         )
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Tabbed Lazy Loading Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: DefaultTabController(
//         length: 3,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Flutter Tabbed Lazy Loading Demo'),
//             titleTextStyle: const TextStyle(color: Colors.black),
//           ),
//           body: TabBarView(
//             key: PageStorageKey<dynamic>(context), // 使用PageStorageKey来保存滚动位置
//             children: [
//               Container(color: Colors.red), // 第一个页签，只是一个占位符
//               Container(color: Colors.green), // 第二个页签，只是一个占位符
//               Container(color: Colors.blue), // 第三个页签，只是一个占位符
//             ],
//           ),
//           // floatingActionButton: FloatingActionButton(
//           //   onPressed: () {
//           //     // 模拟懒加载数据，这里可以根据实际需求加载数据
//           //     Future.delayed(const Duration(seconds: 2), () {
//           //       print();
//           //       // 加载完成后的操作，例如更新数据或显示加载完成提示等。
//           //     });
//           //   },
//           //   child: const Icon(Icons.refresh), // 刷新按钮图标
//           // ), // Add FloatingActionButton to navigate between tabs.
//         ), // Add Scaffold as the root widget.
//       ), // Close DefaultTabController.
//     ); // Close MaterialApp.
//   } // Close build method for MyApp StatelessWidget.
// }




// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Flutter Router Nested Demo111',
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: Scaffold(
//           appBar: AppBar(
//             title: const Text('Flutter Router Nested Demo222'),
//           ),
//           body: const NestedNavigator(),
//         ),
//         routes: {
//           '/page': (context) => Page(
//                 index: 0,
//               ),
//         });
//   }
// }

// class NestedNavigator extends StatefulWidget {
//   const NestedNavigator({super.key});

//   @override
//   _NestedNavigatorState createState() => _NestedNavigatorState();
// }

// class _NestedNavigatorState extends State<NestedNavigator> {
//   int _currentIndex = 0;
//   final List<Widget> _children = [
//     Container(color: Colors.red), // 第一个页面，红色背景
//     Container(color: Colors.green), // 第二个页面，绿色背景
//     Container(color: Colors.blue), // 第三个页面，蓝色背景
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: <Widget>[
//         const Text("Nested Navigator"),
//         ElevatedButton(
//           onPressed: () {
//             // 导航到第一个页面
//             _navigateToPage(_currentIndex);
//           },
//           child: const Text("Go to First Page"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // 导航到第二个页面
//             _navigateToPage(_currentIndex + 1);
//           },
//           child: const Text("Go to Second Page"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             // 导航到第三个页面，并设置返回参数（用于返回到上一个页面时传递数据）
//             _navigateToPage(_currentIndex + 2, 'Data for the return route');
//           },
//           child: const Text("Go to Third Page"),
//         ),
//       ],
//     );
//   }

//   void _navigateToPage(int index, [String? data]) {
//     // 将当前页面索引加1，以便在下一次导航时跳过当前页面，实现返回功能。
//     setState(() {
//       _currentIndex = index;
//     });
//     // 创建路由参数，传递给下一个页面或返回页面。
//     final Map<String, dynamic> args = {
//       'index': index, // 传递当前页面索引作为参数。可以在下一个页面中使用它来决定如何显示内容。
//       'data': data, // 传递自定义数据作为参数。可以在下一个页面或返回页面中使用它来处理数据。
//     };
//     // 使用 Navigator 将当前页面替换为下一个页面。如果提供了返回参数，则将其添加到返回参数中。这将允许在导航回当前页面时传递数据。
//     Navigator.of(context).pushReplacementNamed('/page', arguments: args);
//   }
// }

// class Page extends StatelessWidget {
//   int index;
//   String? data;
//   Page({Key? key, required this.index, this.data}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     // 在这里使用 index 和 data 参数构建你的页面
//     return Scaffold(body: Text('Page index: $index, Data: $data'));
//   }
// }
