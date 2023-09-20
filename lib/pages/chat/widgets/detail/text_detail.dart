import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orginone/config/constant.dart';
import 'package:orginone/dart/base/api/kernelapi_old.dart';
import 'package:orginone/main.dart';
import 'package:orginone/pages/chat/widgets/detail/base_detail.dart';
import 'package:orginone/pages/chat/widgets/info_item.dart';
import 'package:orginone/routers.dart';
import 'package:orginone/util/string_util.dart';
import 'package:orginone/widget/image_widget.dart';
import 'package:orginone/widget/unified.dart';

class TextDetail extends BaseDetail {
  TextDetail(
      {required super.isSelf,
      required super.message,
      super.bgColor,
      super.clipBehavior = Clip.hardEdge,
      super.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      super.constraints,  super.isReply = false,super.chat});

  @override
  Widget body(BuildContext context) {
    Widget? child = _getUrlSpan(message.body?.text ?? "") ??
        _getImageSpan(message.body?.text ?? "");
    return child ??
        Text(
          message.body?.text ?? "",
          style: XFonts.size24Black0,
        );
  }

  Widget? _getUrlSpan(String text) {
    List<InlineSpan> span = [];

    List<RegExpMatch> urlMatch = StringUtil.urlReg.allMatches(text).toList();

    if (urlMatch.isEmpty) {
      return null;
    }

    InlineSpan getSpan(String text) {
      dynamic imageUrl = StringUtil.getImageUrl(text);
      if (imageUrl != null) {
        return WidgetSpan(child: imageWidget(imageUrl));
      }

      return TextSpan(text: text);
    }

    int index = 0;
    for (var match in urlMatch) {
      String url = text.substring(match.start, match.end);
      if (match.start == index) {
        index = match.end;
      }
      if (index < match.start) {
        String a = text.substring(index, match.start);
        index = match.end;
        span.add(getSpan(a));
      }
      if (StringUtil.urlReg.hasMatch(url)) {
        span.add(TextSpan(
            text: url,
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.toNamed(Routers.webView, arguments: {'url': url});
              }));
      } else {
        span.add(getSpan(url));
      }
    }
    if (index < text.length) {
      String a = text.substring(index, text.length);
      span.add(getSpan(a));
    }

    if (span.isNotEmpty) {
      if (span.length == 1) {
        return PreViewUrl(
          url: span.first.toPlainText().replaceAll("www.", ''),
        );
      } else {
        return Text.rich(
          TextSpan(
            children: span,
            style: XFonts.size24Black0,
          ),
        );
      }
    }
    return null;
  }

  Widget? _getImageSpan(String text) {
    List<InlineSpan> span = [];

    List<Match> imgMatch = StringUtil.imgReg.allMatches(text).toList();

    int startIndex = 0;

    if (imgMatch.isEmpty) {
      return null;
    }

    for (Match match in imgMatch) {
      if (match.start > startIndex) {
        String a = text.substring(startIndex, match.start);
        span.add(TextSpan(text: a));
      }

      dynamic imageUrl = match.group(1)!;
      if (imageUrl.contains('base64')) {
        imageUrl = base64Decode(imageUrl.toString().split('base64,').last);
      } else {
        imageUrl = "${Constant.host}/$imageUrl";
      }
      span.add(
        WidgetSpan(
          child: imageWidget(imageUrl),
        ),
      );

      startIndex = match.end;
    }

    if (startIndex < text.length) {
      String a = text.substring(startIndex);
      span.add(TextSpan(text: a));
    }

    return Text.rich(
      TextSpan(
        children: span,
        style: XFonts.size24Black0,
      ),
    );
  }


  Widget imageWidget(dynamic url) {
    Map<String, String> headers = {
      "Authorization": kernel.anystore.accessToken,
    };

    return GestureDetector(
      onTap: (){
        Navigator.of(Get.context!).push(
          DialogRoute(
            context: Get.context!,
            builder: (BuildContext context) {
              return GestureDetector(
                onTap: (){
                  Get.back();
                },
                child: ImageWidget(
                  url,
                  httpHeaders: headers,
                ),
              );
            },
          ),
        );
      },
      child: ImageWidget(
        url,
        httpHeaders: headers,
      ),
    );
  }
}
