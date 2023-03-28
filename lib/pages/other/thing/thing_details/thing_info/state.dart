

import 'package:get/get.dart';
import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/getx/base_get_state.dart';
import 'package:orginone/dart/core/thing/ispecies.dart';

class ThingInfoState extends BaseGetState{
  var details = <CardDetails>[].obs;
}


class CardDetails{
  late ISpeciesItem specie;
  late List<CardData> data;

  CardDetails(this.specie,this.data);
}

class CardData{
  late XAttribute xAttribute;
  late dynamic value;
  CardData(this.xAttribute,this.value);
}