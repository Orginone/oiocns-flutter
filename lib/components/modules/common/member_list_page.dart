import 'package:flutter/material.dart';
import 'package:orginone/common/index.dart';
import 'package:orginone/components/base/action_container.dart';
import 'package:orginone/components/base/orginone_stateful_widget.dart';
import 'package:orginone/components/widgets/list_widget/index.dart';
import 'package:orginone/config/unified.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/chat/session.dart';
import 'package:orginone/dart/core/target/innerTeam/department.dart';
import 'package:orginone/dart/core/target/outTeam/cohort.dart';
import 'package:orginone/dart/core/target/outTeam/group.dart';
import 'package:orginone/dart/core/target/person.dart';
import 'package:orginone/dart/core/target/team/company.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/log/log_util.dart';

/// 好友/成员列表页面
class MemberListPage extends OrginoneStatelessWidget {
  MemberListPage({super.key, super.data});

  @override
  Widget buildWidget(BuildContext context, dynamic data) {
    List<XTarget> members = [];
    if (data is IPerson) {
      members = loadMembers(data);
    } else if (data is ICompany) {
      members = loadMembers(data);
    } else if (data is IDepartment) {
      members = loadMembers(data);
    } else if (data is ICohort) {
      members = loadMembers(data);
    } else if (data is IGroup) {
      members = loadMembers(data);
    } else if (data is ISession) {
      members = loadMembers(data);
    }
    Widget content = Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        decoration: const BoxDecoration(color: Colors.white),
        child: _buildList(context, members));
    if (data is ISession &&
        data.target.hasRelationAuth() &&
        data.target.id != data.target.userId) {
      content = ActionContainer(
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            mini: true,
            tooltip: "邀请成员",
            child: const Icon(Icons.add),
          ),
          child: content);
    }

    return content;
  }

  // List<XTarget> loadFriends(IPerson user) {
  //   return user.members;
  // }

  List<XTarget> loadMembers(dynamic company) {
    return company.members;
  }

  _buildList(BuildContext context, List<XTarget> datas) {
    return ListWidget(
      initDatas: datas,
      getDatas: ([dynamic parentData]) {
        if (null == parentData) {
          return datas;
        }
        return [];
      },
      // getTitle: (dynamic data) => Text(data.name),
      // getAvatar: (dynamic data) => data is XEntity && null != data.shareIcon()
      //     ? TeamAvatar(size: 35, info: TeamTypeInfo(share: data.shareIcon()))
      //     : XImageWidget.asset(
      //         width: 35,
      //         height: 35,
      //         IconsUtils.workDefaultAvatar(data.typeName)),
      // getLabels: (dynamic data) => data is IEntity ? data.groupTags : null,
      // getDesc: (dynamic data) => "" != data.remark ? Text(data.remark) : null,
      getAction: (dynamic data) {
        return GestureDetector(
          onTap: () {
            LogUtil.d('>>>>>>======点击了感叹号');
            RoutePages.jumpRelationInfo(data: data);
          },
          child: const IconWidget(
            color: XColors.black666,
            iconData: Icons.info_outlined,
          ),
        );
      },
      onTap: (dynamic data, List children) {
        LogUtil.d('>>>>>>======点击了列表项 ${data.name}');
        if (children.isNotEmpty) {
          RoutePages.jumpRelation(parentData: data, listDatas: children);
        } else if (data is XTarget) {
          ISession? session = relationCtrl.user?.findMemberChat(data.id);
          if (null != session) {
            RoutePages.jumpRelationInfo(data: session);
          } else {
            // 待完善新建的会话
            RoutePages.jumpRelationInfo(data: data);
          }
        } else {
          RoutePages.jumpRelationInfo(data: data);
        }
      },
    );
  }
}
