import 'package:flutter/material.dart';
import 'package:orginone/common/models/index.dart';
import 'package:orginone/common/routers/pages.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/controller/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/getx/submenu_list/item.dart';
import 'package:orginone/dart/core/getx/submenu_list/list_adapter.dart';
import 'package:orginone/dart/core/work/task.dart';
import 'package:orginone/utils/date_util.dart';

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
    print(buildActions);
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
    print('>>>>>>>>>>>>>buildActions');
    return BackButton(
      color: Colors.black,
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    print('>>>>>>>>>>>>>buildResults');
    search();
    return _body();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print('>>>>>>>>>>>>>buildSuggestions');
    search();
    return _body();
  }

  void search() {
    searchData.clear();
    if (query.isEmpty) {
      searchData.addAll(data);
      return;
    }

    for (var element in data) {
      switch (homeEnum) {
        case HomeEnum.chat:
          if ((element as ISession).chatdata.value.chatName.contains(query) ??
              false) {
            searchData.add(element);
          }
          break;
        case HomeEnum.work:
          if ((element as IWorkTask).taskdata.title!.contains(query)) {
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

  Widget _body() {
    return ListWidget<T>(
      initDatas: searchData,
      getDatas: ([dynamic data]) {
        if (null == data) {
          return searchData ?? [];
        }
        return [];
      },
      getAction: (dynamic data) {
        return Text(
          CustomDateUtil.getSessionTime(data.updateTime),
          style: XFonts.chatSMTimeTip,
          textAlign: TextAlign.right,
        );
      },
      onTap: (dynamic data, List children) {
        print('>>>>>>======点击了列表项 ${data.name}');
        if (data is ISession) {
          RoutePages.jumpChatSession(data: data);
        } else if (data is IWorkTask) {
          RoutePages.jumpWorkInfo(work: data);
        }
      },
    );
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
                adapter: ListAdapter.chat(item as ISession),
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
    print('>>>>>>>>>>>>>appBarTheme');
    return super.appBarTheme(context).copyWith(
          appBarTheme: super.appBarTheme(context).appBarTheme.copyWith(
                elevation: 0.0,
              ),
        );
  }
}
