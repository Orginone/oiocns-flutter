import 'package:orginone/api_resp/task_entity.dart';
import 'package:orginone/page/home/affairs/affairs_type_enum.dart';

class DetailArguments {
  late AffairsTypeEnum typeEnum;
  late int itemPos;
  TaskEntity? taskEntity;

  DetailArguments(this.typeEnum,this.itemPos, {this.taskEntity});
}
