import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/public/consts.dart';
import 'package:orginone/components/widgets/common/image/image_widget.dart';
import 'package:orginone/main_base.dart';
import 'package:orginone/utils/load_image.dart';

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

  final bool circular;

  TeamAvatar({
    super.key,
    required this.info,
    double? size,
    this.circular = false,
  }) : size = size ?? 66.w;

  @override
  State<TeamAvatar> createState() => _TeamAvatarState();
}

class _TeamAvatarState extends State<TeamAvatar> {
  ShareIcon? cache;

  late TeamTypeInfo info;

  late double size;
  Widget? child;
  List<Widget>? children;
  late BoxDecoration decoration;

  late bool circular;

  @override
  void initState() {
    //
    super.initState();
    info = widget.info;
    size = widget.size;
    circular = widget.circular;
  }

  @override
  void didUpdateWidget(covariant TeamAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.info != oldWidget.info) {
      info = widget.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (info.share != null) {
      return avatar(info.share!);
    }

    if (ShareIdSet.containsKey(info.userId ?? "")) {
      return avatar(ShareIdSet[info.userId!]!);
    }

    return FutureBuilder<ShareIcon>(
      builder: (context, shot) {
        if (shot.hasData && shot.connectionState == ConnectionState.done) {
          cache = shot.data!;
          return avatar(shot.data!);
        }
        return cache != null ? avatar(cache!) : const SizedBox();
      },
      future: Future(() =>
          relationCtrl.user?.findShareById(info.userId!) ??
          ShareIcon(name: "", typeName: "未知类型")),
    );
  }

  Widget avatar(ShareIcon share) {
    var avatar = share.avatar;
    dynamic image = avatar?.thumbnailUint8List ?? avatar?.defaultAvatar;
    return null == image
        ? XImage.entityIcon(
            share,
            width: size,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            circular: circular,
          )
        : ImageWidget(
            image,
            size: size,
            fit: BoxFit.cover,
            gaplessPlayback: true,
            circular: circular,
          );
  }
}
