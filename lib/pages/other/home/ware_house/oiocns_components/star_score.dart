// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StarScore extends StatefulWidget {
  final double score;

  const StarScore({Key? key, required this.score}) : super(key: key);

  @override
  _StarScoreState createState() => _StarScoreState();
}

class _StarScoreState extends State<StarScore> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 空stra
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            return Icon(
              Icons.star_border_rounded,
              color: const Color.fromARGB(255, 184, 187, 198),
              size: 18.sp,
            );
          }),
        ),
        // 满star
        Row(
          mainAxisSize: MainAxisSize.min,
          children: bulidStar(),
        )
      ],
    );
  }

  List<Widget> bulidStar() {
    List<Widget> stars = [];
    final star = Icon(
      Icons.star_rounded,
      color: const Color.fromARGB(255, 18, 47, 206),
      size: 18.sp,
    );
    // 填满的star
    int entireNum = (widget.score / 2).floor();
    for (var i = 0; i < entireNum; i++) {
      stars.add(star);
    }
    // 未填满star
    double partNum = ((widget.score / 2) - entireNum) * 18.sp;
    final partStar = ClipRect(
      clipper: ClipperStar(partNum),
      child: star,
    );
    stars.add(partStar);
    return stars;
  }
}

class ClipperStar extends CustomClipper<Rect> {
  double width;
  ClipperStar(this.width);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(ClipperStar oldClipper) {
    return width != oldClipper.width;
  }
}
