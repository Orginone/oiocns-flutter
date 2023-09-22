import 'package:flutter/material.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/message/msgchat.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/pages/store/state.dart';

class SearchBar<T> extends SearchDelegate {
  final HomeEnum homeEnum;

  final List<T> data;

  SearchBar(
      {required this.homeEnum,
      required this.data,
      super.searchFieldLabel = "请输入关键字"});

  List<T> searchData = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(
      color: Colors.black,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    search();
    return body();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    search();
    return body();
  }

  void search() {
    searchData.clear();
    if (query.isEmpty) {
      return;
    }
    for (var element in data) {
      switch (homeEnum) {
        case HomeEnum.chat:
          if ((element as IMsgChat).chatdata.value.chatName?.contains(query) ??
              false) {
            searchData.add(element);
          }
          break;
        case HomeEnum.work:
          if ((element as IWorkTask).metadata.title!.contains(query)) {
            searchData.add(element);
          }
          break;
        case HomeEnum.store:
          var recent = (element as RecentlyUseModel);
          if (recent.type == StoreEnum.file.label) {
            if (recent.file!.name!.contains(query)) {
              searchData.add(element);
            }
          } else {
            if (recent.thing!.id!.contains(query)) {
              searchData.add(element);
            }
          }
          break;
      }
    }
  }

  Widget body() {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: searchData.length,
        itemBuilder: (BuildContext context, int index) {
          var item = searchData[index];
          switch (homeEnum) {
            case HomeEnum.chat:
              return ListItem(
                adapter: ListAdapter.chat(item as IMsgChat),
              );
            case HomeEnum.work:
              return ListItem(adapter: ListAdapter.work(item as IWorkTask));
            case HomeEnum.store:
              return ListItem(
                  adapter: ListAdapter.store(item as RecentlyUseModel));
          }
          return Container();
        });
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context).copyWith(
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
                elevation: 0.0,
              ),
        );
  }
}
