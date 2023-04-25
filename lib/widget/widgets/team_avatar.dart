import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/widget/unified.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/enum.dart';

class TeamTypeInfo {
  final bool? preview;
  final int? number;
  final double fontSize;
  final TargetShare share;
  final bool? notAvatar;

  TeamTypeInfo({
    this.preview,
    this.number,
    double? fontSize,
    required this.share,
    this.notAvatar,
  }) : fontSize = fontSize ?? 32.w;
}

class TeamAvatar extends StatelessWidget {
  final TeamTypeInfo info;
  final double size;
  final Widget? child;
  final List<Widget>? children;
  final BoxDecoration? decoration;

  TeamAvatar({
    super.key,
    required this.info,
    double? size,
    this.child,
    this.children,
  })  : size = size ?? 66.w,
        decoration = BoxDecoration(
          color: XColors.themeColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(6.w)),
        );

  @override
  Widget build(BuildContext context) {
    var avatar = info.share.avatar;
    if (avatar?.thumbnail != null) {
      var thumbnail = avatar!.thumbnail!.split(",")[1];
      thumbnail = thumbnail.replaceAll('\r', '').replaceAll('\n', '');
      return AdvancedAvatar(
        size: size,
        children: children ?? [],
        decoration: decoration,
        child: Image(
          width: size,
          height: size,
          image: MemoryImage(base64Decode(thumbnail)),
          fit: BoxFit.cover,
          gaplessPlayback: true,
        ),
      );
    }
    var typeName = info.share.typeName;
    late Widget child;
    if (this.child == null) {
      if (typeName == TargetType.group.label) {
        child = Icon(Icons.groups, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.company.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.section.label) {
        child = Icon(Icons.person, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.department.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.college.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.laboratory.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.office.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.research.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.working.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.station.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.cohort.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else if (typeName == TargetType.person.label) {
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
      } else {
        child = Icon(Icons.group, size: info.fontSize);
      }
    } else {
      child = this.child!;
    }
    return AdvancedAvatar(
      size: size,
      children: children ?? [],
      decoration: decoration,
      child: child,
    );
  }
}
