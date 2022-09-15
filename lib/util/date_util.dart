import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

class CustomDateUtil {
  static List<String> chineseWeekdays = ["", "周一", "周二", "周三", "周四", "周五", "周六", "周日"];

  static String getSessionTime(DateTime targetTime) {
    int targetYear = targetTime.year;
    int targetMonth = targetTime.month;
    int targetDay = targetTime.day;
    int targetWeekday = targetTime.weekday;
    int targetHour = targetTime.hour;

    DateTime now = DateTime.now();
    int nowYear = now.year;
    int nowMonth = now.month;
    int nowDay = now.day;
    int nowWeekday = now.weekday;

    if (targetYear != nowYear) {
      return DateUtil.formatDate(targetTime, format: "yyyy年MM月dd日");
    } else {
      if (targetMonth != nowMonth) {
        return DateUtil.formatDate(targetTime, format: "MM月dd日");
      } else {
        if (targetDay != nowDay) {
          var differDay = nowDay - targetDay;
          if (differDay == 1) {
            return "昨天";
          } else {
            if (differDay < nowWeekday) {
              return chineseWeekdays[targetWeekday];
            } else {
              return DateUtil.formatDate(targetTime, format: "MM月dd日");
            }
          }
        } else {
          if (targetHour < 6) {
            return DateUtil.formatDate(targetTime, format: "凌晨 HH:mm");
          } else if (targetHour < 12) {
            return DateUtil.formatDate(targetTime, format: "上午 HH:mm");
          } else if (targetHour < 18) {
            return DateUtil.formatDate(targetTime, format: "下午 HH:mm");
          } else {
            return DateUtil.formatDate(targetTime, format: "晚上 HH:mm");
          }
        }
      }
    }
  }
}
