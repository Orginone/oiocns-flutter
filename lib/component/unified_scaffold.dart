import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';

import '../config/custom_colors.dart';

const double defaultAppBarPercent = 0.07;
const Color defaultAppBarColor = CustomColors.lightGrey;
const Color defaultBgColor = Colors.white;

class UnifiedScaffold extends StatelessWidget {
  final double appBarPercent;
  final Color appBarBgColor;
  final Color bgColor;
  final List<Widget>? appBarActions;
  final Widget? appBarTitle;
  final bool? appBarCenterTitle;
  final Widget? appBarLeading;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingButton;

  const UnifiedScaffold(
      {Key? key,
      this.appBarPercent = defaultAppBarPercent,
      this.appBarBgColor = defaultAppBarColor,
      this.bgColor = defaultBgColor,
      this.appBarActions,
      this.appBarTitle,
      this.appBarCenterTitle,
      this.appBarLeading,
      this.body,
      this.bottomNavigationBar,
      this.floatingButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * appBarPercent),
        child: GFAppBar(
          titleSpacing: 0.0,
          actions: appBarActions,
          backgroundColor: appBarBgColor,
          title: appBarTitle,
          centerTitle: appBarCenterTitle,
          leading: appBarLeading,
        ),
      ),
      backgroundColor: bgColor,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
