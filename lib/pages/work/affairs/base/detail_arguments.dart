import 'package:orginone/dart/base/model/instance_task_entity.dart';
import 'package:orginone/dart/base/model/record_task_entity.dart';
import 'package:orginone/dart/base/model/task_entity.dart';
import 'package:orginone/pages/work/affairs/affairs_type_enum.dart';

class DetailArguments {
  late AffairsTypeEnum typeEnum;
  late int itemPos;
  TaskEntity? taskEntity;
  RecordTaskEntity? recordEntity;
  InstanceTaskEntity? instanceEntity;

  DetailArguments(
    this.typeEnum,
    this.itemPos, {
    this.taskEntity,
    this.recordEntity,
    this.instanceEntity,
  });
}
