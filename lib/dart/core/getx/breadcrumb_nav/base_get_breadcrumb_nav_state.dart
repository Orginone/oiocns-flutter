import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:orginone/dart/core/enum.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';

abstract class BaseBreadcrumbNavState<T extends BaseBreadcrumbNavModel> extends BaseGetState{

  var bcNav = <BaseBreadcrumbNavInfo>[].obs;

  String title  = '';

  Rxn<T> model = Rxn();

  final ScrollController navBarController = ScrollController();

  bool get isRootDir => (bcNav.length - 1) == 0;

  var showSearch = false.obs;

  var keyword = ''.obs;

  bool showSearchButton = true;
}

 class BaseBreadcrumbNavModel<T> {
  late String id;
  late String name;
  late List<T> children;
  dynamic image;
  dynamic source;
  SpaceEnum? spaceEnum;
  bool showPopup;
  Future<void> Function(dynamic)? onNext;
  BaseBreadcrumbNavModel({this.id = '',this.name = '',this.children = const [],this.source,this.image,this.spaceEnum,this.showPopup = true,this.onNext});
}

class BaseBreadcrumbNavInfo{
  late String route;

  late String title;

  BaseBreadcrumbNavModel? data;

  BaseBreadcrumbNavInfo({this.route = '',this.title = '',this.data});
}