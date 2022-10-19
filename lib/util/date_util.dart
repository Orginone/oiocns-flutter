import 'package:common_utils/common_utils.dart';

class CustomDateUtil {
  static List<String> chineseWeekdays = [
    "",
    "周一",
    "周二",
    "周三",
    "周四",
    "周五",
    "周六",
    "周日"
  ];

  static String getSessionTime(DateTime? targetTime) {
    if (targetTime == null) {
      return "";
    }

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
          String dayDescription = getDayDescription(targetHour);
          String format = "${dayDescription}HH:mm";
          return DateUtil.formatDate(targetTime, format: format);
        }
      }
    }
  }

  static String getDayDescription(int hour) {
    if (hour < 6) {
      return "凌晨";
    } else if (hour < 12) {
      return "上午";
    } else if (hour < 18) {
      return "下午";
    } else {
      return "晚上";
    }
  }

  static String getDetailTime(DateTime targetTime) {
    String dayDescription = getDayDescription(targetTime.hour);

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
      String format = "yyyy年MM月dd日 ${dayDescription}HH:mm";
      return DateUtil.formatDate(targetTime, format: format);
    } else {
      if (targetMonth != nowMonth) {
        String format = "MM月dd日 ${dayDescription}HH:mm";
        return DateUtil.formatDate(targetTime, format: format);
      } else {
        if (targetDay != nowDay) {
          var differDay = nowDay - targetDay;
          if (differDay == 1) {
            String format = "昨天 ${dayDescription}HH:mm";
            return DateUtil.formatDate(targetTime, format: format);
          } else {
            if (differDay < nowWeekday) {
              String format =
                  "${chineseWeekdays[targetWeekday]} ${dayDescription}HH:mm";
              return DateUtil.formatDate(targetTime, format: format);
            } else {
              String format = "MM月dd日 ${dayDescription}HH:mm";
              return DateUtil.formatDate(targetTime, format: format);
            }
          }
        } else {
          String dayDescription = getDayDescription(targetHour);
          String format = "${dayDescription}HH:mm";
          return DateUtil.formatDate(targetTime, format: format);
        }
      }
    }
  }
}
