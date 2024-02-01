import 'dart:ui';

import 'package:get/get.dart';
import 'package:orginone/config/index.dart';

class AppColors {
  static Color backgroundColor = const Color(0xFFF0F2F7);
  static Color formBackgroundColor = const Color(0xFFD9E3F5);
  static Color formTitleBackgroundColor = const Color(0xFFF5F6FC);

  static const Color defaultAppBarColor = XColors.navigatorBgColor;
  static const Color defaultBgColor = XColors.lightBlue;
  /// 自定义 颜色
  /// *******************************************
  static const orange = Color(0xffff6634);
  static const yellow = Color(0xffF1E300);
  static const green = Color(0xFF12B523);
  static const red = Color(0xffEB3838);
  static const blueGrey = Color(0xff607D8B);
  static const darkGray = Color(0xff4A4A4A);
  static const gray = Color(0xff9b9b9b);
  static const gray_33 = Color(0xFF333333); //51
  static const gray_66 = Color(0xFF666666); //51
  static const gray_99 = Color(0xFF999999); //51
  static const lightGray = Color(0xffF5F5F5);
  static const eee = Color(0xffeeeeee);
  static const blue = Color(0xFF056DE3);
  static const deepPrimary = Color(0xff1d7eb3);

  static const Color black_333 = Color(0xFF333333); //51
  static const Color black_666 = Color(0xFF666666); //102
  static const Color black_999 = Color(0xFF999999); //153

  static const black = Color(0xff000000);
  static const white = Color(0xffffffff);
  static const clear = Color(0x00000000);
  // 深色背景
  static const back1 = Color(0xff1D1F22);
  static const transparent_80 = Color(0x80000000);
  // 比深色背景略深一点
  static const back2 = Color(0xff121314);

  /// 强调
  static Color get highlight =>
      Get.isDarkMode ? const Color(0xFFFFB4A9) : const Color(0xFFF77866);

  /// Success
  /// Warning
  /// Danger
  /// Info

  /// *******************************************
  /// Material System
  /// *******************************************

  static Color get background => Get.theme.colorScheme.background;

  static Brightness get brightness => Get.theme.colorScheme.brightness;

  static Color get error => Get.theme.colorScheme.error;

  static Color get errorContainer => Get.theme.colorScheme.errorContainer;

  static Color get inversePrimary => Get.theme.colorScheme.inversePrimary;

  static Color get inverseSurface => Get.theme.colorScheme.inverseSurface;

  static Color get onBackground => Get.theme.colorScheme.onBackground;

  static Color get onError => Get.theme.colorScheme.onError;

  static Color get onErrorContainer => Get.theme.colorScheme.onErrorContainer;

  static Color get onInverseSurface => Get.theme.colorScheme.onInverseSurface;

  static Color get onPrimary => Get.theme.colorScheme.onPrimary;

  static Color get onPrimaryContainer =>
      Get.theme.colorScheme.onPrimaryContainer;

  static Color get onSecondary => Get.theme.colorScheme.onSecondary;

  static Color get onSecondaryContainer =>
      Get.theme.colorScheme.onSecondaryContainer;

  static Color get onSurface => Get.theme.colorScheme.onSurface;

  static Color get onSurfaceVariant => Get.theme.colorScheme.onSurfaceVariant;

  static Color get onTertiary => Get.theme.colorScheme.onTertiary;

  static Color get onTertiaryContainer =>
      Get.theme.colorScheme.onTertiaryContainer;

  static Color get outline => Get.theme.colorScheme.outline;

  static Color get primary => Get.theme.colorScheme.primary;

  static Color get primaryContainer => Get.theme.colorScheme.primaryContainer;

  static Color get secondary => Get.theme.colorScheme.secondary;

  static Color get secondaryContainer =>
      Get.theme.colorScheme.secondaryContainer;

  static Color get shadow => Get.theme.colorScheme.shadow;

  static Color get surface => Get.theme.colorScheme.surface;

  static Color get surfaceVariant => Get.theme.colorScheme.surfaceVariant;

  static Color get tertiary => Get.theme.colorScheme.tertiary;

  static Color get tertiaryContainer => Get.theme.colorScheme.tertiaryContainer;
}
