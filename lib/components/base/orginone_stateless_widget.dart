// import 'package:flutter/material.dart';
// import 'package:getwidget/getwidget.dart';
// import 'package:orginone/common/index.dart';
// import 'package:orginone/components/index.dart';
// import 'package:orginone/components/widgets/infoListPage/infoListPage.dart';
// import 'package:orginone/config/unified.dart';
// import 'package:orginone/dart/core/public/entity.dart';


// /// 静态组件
// abstract class OrginoneStatelessWidget extends StatelessWidget {
//   late dynamic data;

//   OrginoneStatelessWidget({super.key, data}) {
//     this.data = data ?? RoutePages.getParentRouteParam();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Widget body = buildWidget(context, data);
//     bool hasTabs = _hasChildOfType(body, InfoListPage);
//     return GyScaffold(
//         backgroundColor: Colors.grey.shade200,
//         titleWidget: _title(),
//         actions: _actions(context),
//         toolbarHeight: _getToolbarHeight(),
//         body: Container(
//           margin: hasTabs ? null : EdgeInsets.symmetric(vertical: 1.h),
//           decoration: hasTabs ? null : const BoxDecoration(color: Colors.white),
//           child: body,
//         ));
//   }

//   bool _hasChildOfType<T>(Widget widget, T type) {
//     if (widget.runtimeType is T) {
//       return true;
//     }
//     if (widget is Column) {
//       if (widget.children.isEmpty) {
//         return false;
//       }

//       for (var child in widget.children) {
//         if (_hasChildOfType(child, type)) {
//           return true;
//         }
//       }
//     }

//     return false;
//   }

//   double? _getToolbarHeight() {
//     var spaceName = "";
//     if (data is IEntity) spaceName = data.groupTags.join(" | ");
//     if (spaceName.isNotEmpty) {
//       return 80.h;
//     }
//     return null;
//   }

//   Widget _title() {
//     String name = data.name ?? "详情";
//     // if (state.chat.members.length > 1) {
//     //   name += "(${state.chat.members.length})";
//     // }
//     var spaceName = "";
//     if (data is IEntity) spaceName = data.groupTags.join(" | ");
//     return Column(
//       children: [
//         Text(name, style: XFonts.size24Black3),
//         Text(spaceName, style: XFonts.size16Black9),
//       ],
//     );
//   }

//   List<Widget> _actions(BuildContext context) {
//     return <Widget>[
//       GFIconButton(
//         color: Colors.white.withOpacity(0),
//         icon: Icon(
//           Icons.more_vert,
//           color: XColors.black3,
//           size: 32.w,
//         ),
//         onPressed: showMore(context, data) ? () => onMore(context, data) : null,
//       ),
//     ];
//   }

//   @protected
//   Widget buildWidget(BuildContext context, dynamic data);

//   @protected
//   bool showMore(BuildContext context, dynamic data) {
//     return false;
//   }

//   @protected
//   void onMore(BuildContext context, dynamic data) {}
// }