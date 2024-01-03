import 'package:uuid/uuid.dart';

abstract class IEntity {
  abstract String key;
}

const uuid = Uuid();

class Entity implements IEntity {
  @override
  String key;

  Entity() : key = uuid.v4();
}
