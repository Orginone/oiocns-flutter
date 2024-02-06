import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/public/entity.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/systemfile.dart';

/// 文件列表页面
class FileListPage extends OrginoneStatefulWidget {
  FileListPage({super.key, super.data});
  @override
  State<StatefulWidget> createState() => _FileListPageState();
}

class _FileListPageState extends OrginoneStatefulState<FileListPage> {
  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    List<IEntity> directorys = [];
    if (data is IPerson) {
      directorys = loadAll<IDirectory>(data.directory);
    } else if (data is ICompany) {
      directorys = loadAll<IDirectory>(data.directory);
    } else if (data is IDepartment) {
      directorys = loadAll<IDirectory>(data.directory);
    } else if (data is ICohort) {
      directorys = loadAll<IDirectory>(data.directory);
    } else if (data is IGroup) {
      directorys = loadAll<IDirectory>(data.directory);
    } else if (data is IDirectory) {
      directorys = loadAll<IDirectory>(data);
    } else if (data is ISession) {
      directorys = loadAll<IDirectory>(data.target.directory);
    }

    return Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: const BoxDecoration(color: Colors.white),
        child: _buildList(context, directorys));
  }

  List<IEntity> loadAll<T extends IDirectory>(T targtet) {
    List<IEntity> directorys = [];
    directorys.addAll(loadDirectorys<T>(targtet));
    directorys.addAll(loadFiels<T>(targtet));
    directorys = _filterDeleteed(directorys);

    return directorys;
  }

  ///过滤已删除的目录
  List<IEntity> _filterDeleteed(List<IEntity> directorys) {
    return directorys
        .where((element) => !element.groupTags.contains("已删除"))
        .toList();
  }

  List<IDirectory> loadDirectorys<T extends IDirectory>(T target) {
    List<IDirectory> directorys = target.children;
    print('>>>>>>======directorys ${directorys.length}');
    if (directorys.isEmpty) {
      target.loadContent().then((value) {
        if (value && target.children.isNotEmpty) {
          setState(() {});
        }
      });
    }
    return directorys;
  }

  List<ISysFileInfo> loadFiels<T extends IDirectory>(T target) {
    List<ISysFileInfo> files = target.files;
    print('>>>>>>======files ${files.length}');
    if (files.isEmpty) {
      target.loadContent().then((value) {
        if (value && target.files.isNotEmpty) {
          setState(() {});
        }
      });
    }
    return files;
  }

  _buildList(BuildContext context, List datas) {
    return ListWidget(
      initDatas: datas,
      getDatas: ([dynamic parentData]) {
        if (null == parentData) {
          return datas;
        }
        print('>>>>>>======${parentData.runtimeType}');
        return [];
      },
      getAction: (dynamic data) {
        return GestureDetector(
          onTap: () {
            print('>>>>>>======点击了感叹号');
            RoutePages.jumpEneityInfo(data: data);
          },
          child: const XImageWidget.asset(width: 35, height: 35, ''),
        );
      },
      onTap: (dynamic item, List children) {
        print('>>>>>>======点击了列表项 ${item.name} ${item.id} ${children.length}');
        if (item is IDirectory) {
          RoutePages.jumpFileList(data: item);
        } else {
          RoutePages.jumpRelationInfo(data: item);
        }
      },
    );
  }
}