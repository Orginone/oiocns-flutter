import 'package:flutter/material.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';

import '../config/custom_colors.dart';

const double defaultAppBarPercent = 0.07;
const Color defaultAppBarColor = CustomColors.lightGrey;

class UnifiedScaffold extends StatelessWidget {
  final double appBarPercent;
  final Color appBarBgColor;
  final List<Widget>? appBarActions;
  final Widget? appBarTitle;
  final Widget? appBarLeading;
  final Widget? body;
  final Widget? bottomNavigationBar;

  const UnifiedScaffold(
      {Key? key,
      this.appBarPercent = defaultAppBarPercent,
      this.appBarBgColor = defaultAppBarColor,
      this.appBarActions,
      this.appBarTitle,
      this.appBarLeading,
      this.body,
      this.bottomNavigationBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * appBarPercent),
        child: GFAppBar(
          actions: appBarActions,
          backgroundColor: appBarBgColor,
          title: appBarTitle,
          leading: appBarLeading,
        ),
      ),
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
