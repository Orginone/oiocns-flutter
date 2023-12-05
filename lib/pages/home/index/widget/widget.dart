import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:getwidget/getwidget.dart';
import 'package:orginone/common/values/index.dart';

import 'package:orginone/components/widgets/image_widget.dart';
import 'package:orginone/config/unified.dart';

class TextArrow extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const TextArrow({Key? key, required this.title, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text.rich(TextSpan(children: [
        TextSpan(text: title, style: TextStyle(fontSize: 18.sp)),
        WidgetSpan(
            child: Container(
                margin: EdgeInsets.only(left: 10.w),
                child: const ImageWidget(AssetsImages.toMore)),
            alignment: PlaceholderAlignment.middle)
      ])),
    );
  }
}

class CardItem extends StatelessWidget {
  const CardItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: XColors.cardShadowColor,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200.w,
              height: 160.h,
              child: ImageWidget(
                "https://lmg.jj20.com/up/allimg/tp05/1Z9291S23R619-0-lp.jpg",
                radius: 12.w,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "标题",
                  style: XFonts.size22Black0,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 5.h,
                  children: [
                    tag("我是标签"),
                    tag("我是标签11111"),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要",
                  style: TextStyle(
                      color: XColors.blueHintTextColor, fontSize: 16.sp),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.w),
                          border: Border.all(
                              color: XColors.blueHintTextColor, width: 0.5)),
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Text(
                        "查看详情",
                        style: TextStyle(
                            color: XColors.blueHintTextColor, fontSize: 14.sp),
                      ),
                    ),
                    Text(
                      "xxxxxx",
                      style: XFonts.size16Black9,
                    ),
                  ],
                )
              ],
            ))
          ],
        ),
      ),
    );
  }

  Widget tag(String tag) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: XColors.blueTextColor,
        borderRadius: BorderRadius.circular(14.w),
      ),
      child: Text(
        tag,
        style: TextStyle(color: XColors.white, fontSize: 16.sp),
      ),
    );
  }
}

class ColumnItem extends StatelessWidget {
  const ColumnItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageWidget(
          "https://t7.baidu.com/it/u=4162611394,4275913936&fm=193&f=GIF",
          circular: true,
          size: 60.w,
        ),
        const Text("名字"),
      ],
    );
  }
}

class NewsPage extends StatelessWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFCarousel(
      hasPagination: true,
      activeIndicator: GFColors.WHITE,
      height: 200.h,
      autoPlay: true,
      items: [
        'https://lmg.jj20.com/up/allimg/tp05/1Z9291S23R619-0-lp.jpg',
        'https://lmg.jj20.com/up/allimg/1112/031319114916/1Z313114916-3-1200.jpg'
      ].map(
        (img) {
          return Container(
            margin: EdgeInsets.only(left: 8.w),
            width: double.infinity,
            child: ImageWidget(
              img,
              radius: 5.w,
              fit: BoxFit.fill,
            ),
          );
        },
      ).toList(),
    );
  }
}

class PopularItem extends StatelessWidget {
  const PopularItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageWidget(
          'https://lmg.jj20.com/up/allimg/tp05/1Z9291S23R619-0-lp.jpg',
          fit: BoxFit.fill,
          size: double.infinity,
          radius: 8.w,
        ),
        Positioned(
          bottom: 10.w,
          left: 10.w,
          child: Row(
            children: [
              ImageWidget(
                'https://lmg.jj20.com/up/allimg/1112/031319114916/1Z313114916-3-1200.jpg',
                size: 50.w,
                fit: BoxFit.fill,
                radius: 8.w,
              ),
              SizedBox(
                width: 5.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "名称",
                    style: TextStyle(fontSize: 18.sp),
                    maxLines: 1,
                  ),
                  Text(
                    "介绍",
                    maxLines: 2,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
