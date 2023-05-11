import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

abstract class BaseBreadcrumbNavState<T extends BaseBreadcrumbNavModel> extends BaseGetState{

  List<BaseBreadcrumbNavInfo> bcNav = [];

  String title  = '';

  Rxn<T> model = Rxn();

}

 class BaseBreadcrumbNavModel<T> {
  late String id;
  late String name;
  late List<T> children;
  dynamic image;
  dynamic source;

  BaseBreadcrumbNavModel({this.id = '',this.name = '',this.children = const [],this.source,this.image});
}

class BaseBreadcrumbNavInfo{
  late String route;

  late String title;

  BaseBreadcrumbNavModel? data;

  BaseBreadcrumbNavInfo({this.route = '',this.title = '',this.data});
}