import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

abstract class BaseBreadcrumbNavState extends BaseGetState{

  List<BaseBreadcrumbNavInfo> bcNav = [];

  String title  = '';

  BaseBreadcrumbNavModel? model;

}

 class BaseBreadcrumbNavModel {
  late String id;
  late String name;
  late List<BaseBreadcrumbNavModel> children;
  Uint8List? image;
  dynamic source;

  BaseBreadcrumbNavModel({this.id = '',this.name = '',this.children = const []});
}

class BaseBreadcrumbNavInfo{
  late String route;

  late String title;

  BaseBreadcrumbNavModel? data;

  BaseBreadcrumbNavInfo({this.route = '',this.title = '',this.data});
}