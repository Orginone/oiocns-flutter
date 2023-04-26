import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBarController extends GetxController {
  var searchText = ''.obs;
  void onTextChanged(String text) => searchText.value = text;

  void add() {
// 添加按钮的点击逻辑
  }
}

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBarController>(
      builder: (controller) => Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              onChanged: controller.onTextChanged,
              decoration: InputDecoration(
                hintText: 'Search',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 6.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 34,
            ),
            onPressed: () {
              print('Search button clicked');
            },
          ),
          IconButton(
            icon: Icon(Icons.add, size: 34),
            onPressed: controller.add,
          ),
          VerticalDivider(),
        ],
      ),
    );
  }
}

class CustomSearchBar extends StatelessWidget {
  CustomSearchBar({required this.onAddClicked});

  final Function onAddClicked;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchBarController>(
      builder: (controller) => Row(
        children: <Widget>[
          Container(
            width: 20,
          ),
          Expanded(
            child: TextField(
              onChanged: controller.onTextChanged,
              decoration: InputDecoration(
                // hintText: 'Search',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 6.0),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              size: 34,
            ),
            onPressed: () {
              print('Search button clicked');
            },
          ),
          IconButton(
            icon: Icon(Icons.add_circle_outline, size: 34),
            onPressed: onAddClicked as void Function(),
          ),
          VerticalDivider(),
        ],
      ),
    );
  }
}

void main() {
// 所有 GetX 的功能都需要在 main 方法中进行初始化
  runApp(GetMaterialApp(
    home: Scaffold(
      appBar: AppBar(),
      body: CustomSearchBar(
        onAddClicked: () {
// 添加按钮的点击逻辑
        },
      ),
    ),
    initialBinding: BindingsBuilder(
      () {
        Get.put(SearchBarController());
      },
    ),
  ));
}
