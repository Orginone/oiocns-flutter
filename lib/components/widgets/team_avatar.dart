import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/consts.dart';
import 'package:orginone/main.dart';
import 'package:orginone/components/widgets/image_widget.dart';

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
    // TODO: implement initState
    super.initState();
    info = widget.info;
    size = widget.size;
    circular = widget.circular;
  }

  @override
  void didUpdateWidget(covariant TeamAvatar oldWidget) {
    // TODO: implement didUpdateWidget
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
      future: Future(() => settingCtrl.user.findShareById(info.userId!)),
    );
  }

  Widget avatar(ShareIcon share) {
    var avatar = share.avatar;
    dynamic image = avatar?.thumbnailUint8List ?? avatar?.defaultAvatar;
    return ImageWidget(
      image,
      size: size,
      fit: BoxFit.cover,
      gaplessPlayback: true,
      circular: circular,
    );
  }
}
