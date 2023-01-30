import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';

import 'unified_colors.dart';

const double defaultAppBarPercent = 0.07;
const Color defaultAppBarColor = UnifiedColors.navigatorBgColor;
const Color defaultBgColor = Colors.white;

class UnifiedScaffold extends StatelessWidget {
  final double appBarPercent;
  final double? appBarHeight;
  final Color appBarBgColor;
  final double? appBarElevation;
  final Color bgColor;
  final List<Widget>? appBarActions;
  final Widget? appBarTitle;
  final bool? appBarCenterTitle;
  final Widget? appBarLeading;
  final Widget? body;
  final Widget? bottomNavigationBar;
  final Widget? floatingButton;
  final bool? resizeToAvoidBottomInset;

  const UnifiedScaffold({
    Key? key,
    this.appBarPercent = defaultAppBarPercent,
    this.appBarHeight,
    this.appBarBgColor = defaultAppBarColor,
    this.appBarElevation,
    this.bgColor = defaultBgColor,
    this.appBarActions,
    this.appBarTitle,
    this.appBarCenterTitle,
    this.appBarLeading,
    this.body,
    this.bottomNavigationBar,
    this.floatingButton,
    this.resizeToAvoidBottomInset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height * appBarPercent;
    height = appBarHeight ?? height;
    return Scaffold(
      resizeToAvoidBottomInset: resizeToAvoidBottomInset ?? true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height),
        child: GFAppBar(
          titleSpacing: 0.0,
          actions: appBarActions,
          backgroundColor: appBarBgColor,
          title: appBarTitle,
          centerTitle: appBarCenterTitle,
          leading: appBarLeading,
          elevation: appBarElevation,
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
