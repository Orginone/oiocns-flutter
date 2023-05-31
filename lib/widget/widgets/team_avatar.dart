import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/controller/setting/setting_controller.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class TeamTypeInfo {
  final bool? preview;
  final int? number;
  final double fontSize;
  final String? userId;
  final ShareIcon? share;
  final bool? notAvatar;

  TeamTypeInfo({
    this.preview,
    this.number,
    double? fontSize,
    this.userId,
    this.share,
    this.notAvatar,
  }) : fontSize = fontSize ?? 32.w;
}

class TeamAvatar extends StatefulWidget {
  final TeamTypeInfo info;
  final double size;
  final Widget? child;
  final List<Widget>? children;
  final BoxDecoration decoration;

  TeamAvatar({
    super.key,
    required this.info,
    double? size,
    this.child,
    this.children,
    BoxDecoration? decoration,
  })  : size = size ?? 66.w,
        decoration = decoration ??
            BoxDecoration(
              color: XColors.themeColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(6.w)),
            );

  @override
  State<TeamAvatar> createState() => _TeamAvatarState();
}

class _TeamAvatarState extends State<TeamAvatar> {
  SettingController get setting => Get.find();

  ShareIcon? cache;

  late TeamTypeInfo info;

  late double size;
  Widget? child;
  List<Widget>? children;
  late BoxDecoration decoration;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    info = widget.info;
    size = widget.size;
    child = widget.child;
    children = widget.children;
    decoration = widget.decoration;
  }

  @override
  Widget build(BuildContext context) {
    if (info.share != null) {
      return avatar(info.share!);
    }

    if(ShareIdSet.containsKey(info.userId!)){
      return avatar(ShareIdSet[info.userId!]!);
    }

    return FutureBuilder<ShareIcon>(
      builder: (context, shot) {
        if (shot.hasData && shot.connectionState == ConnectionState.done) {
          cache = shot.data!;
          return avatar(shot.data!);
        }
      return cache != null ? avatar(cache!) : const SizedBox();
      },future: setting.user.findShareById(info.userId!),);
  }


  Widget avatar(ShareIcon share){
    var avatar = share.avatar;
    if (avatar?.thumbnail != null) {
      var image;
      if(avatar!.thumbnail!.contains('default')??false){
        image = avatar.thumbnail!;
      }else{
        image = avatar.thumbnailUint8List;
      }
      return AdvancedAvatar(
        size: size,
        decoration: decoration,
        child: ImageWidget(image,width: size,
          height: size,
          color: (image is String) && (!image.contains('http'))?Colors.white:null,
          fit: BoxFit.cover,
          gaplessPlayback: true,),
        children: children ?? [],
      );
    }
    var typeName = share.typeName;
    Widget? child;
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
        child = Icon(Icons.group, size: info.fontSize, color: Colors.white);
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
