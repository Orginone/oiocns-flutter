import 'dart:convert';

List<Dashboard> dashboardListFromJson(String str) =>
    List<Dashboard>.from(json.decode(str).map((x) => Dashboard.fromJson(x)));

class Dashboard {
  String? title;
  String? id;
  String? CREAT_NAME;
  String? UPDATE_TIME;
  StyleData? styleData;
  List<ListElement>? list;
  bool? isPublish;
  int? sort;

  Dashboard({
    this.title,
    this.id,
    this.CREAT_NAME,
    this.UPDATE_TIME,
    this.styleData,
    this.list,
    this.isPublish,
    this.sort,
  });

  factory Dashboard.fromJson(Map<String, dynamic> json) => Dashboard(
    title: json["title"],
    id: json["id"],
    CREAT_NAME: json["CREAT_NAME"],
    UPDATE_TIME: json["UPDATE_TIME"],
    styleData: StyleData.fromJson(json["styleData"]),
    list: List<ListElement>.from(
        json["list"].map((x) => ListElement.fromJson(x))),
    isPublish: json["isPublish"],
    sort: json["sort"],
  );
}

class ListElement {
  String? name;
  int? w;
  int? h;
  String? type;
  int? x;
  int? y;
  String? i;
  bool? static;
  int? minW;
  int? minH;
  bool? moved;
  Data? data;

  ListElement({
    this.name,
    this.w,
    this.h,
    this.type,
    this.x,
    this.y,
    this.i,
    this.static,
    this.minW,
    this.minH,
    this.moved,
    this.data,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    name: json["name"],
    w: json["w"],
    h: json["h"],
    type: json["type"],
    x: json["x"],
    y: json["y"],
    i: json["i"],
    static: json["static"],
    minW: json["minW"],
    minH: json["minH"],
    moved: json["moved"],
    data: Data.fromJson(json["data"]),
  );
}

class Data {
  Data();

  factory Data.fromJson(Map<String, dynamic> json) => Data();
}

class StyleData {
  StyleData();

  factory StyleData.fromJson(Map<String, dynamic> json) => StyleData();
}
