


import 'package:common_utils/common_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TextUtils{
  static String textReplace(String text){
    String str = '';
    var findMe = RegExp(r'\$FINDME\[([^\]]*)\]');
    var citeMessage = RegExp(r'\$CITE\[([^\]]*)\]');
    str = text.replaceAll(findMe, '');
    str = str.replaceAll(citeMessage, '');
    return str;
  }

  static List<String> findUserId(String text) {
    var reg = RegExp(r'\$FINDME\[([^\]]*)\]');
    List<String> user =
    reg.allMatches(text).map((e) => e.group(1) ?? "").toList();
    return user;
  }

  static String? isReplyMsg(String text) {
    String? msg;
    var reg = RegExp(r'\$CITEMESSAGE\[([^\]]*)\]');
    try {
      msg = reg.allMatches(text).map((e) => e.group(1) ?? "").first;
    } catch (e) {
      return msg;
    }
    return msg;
  }


  static String? containsWebUrl(String text) {
    String? msg;
    var reg = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    try {
      Iterable<RegExpMatch> matches = reg.allMatches(text);
      if(matches.isNotEmpty){
        print('');
      }
    } catch (e) {
      return msg;
    }
    return msg;
  }


}

enum TextType{
  web,
  findme,
  reply,
}