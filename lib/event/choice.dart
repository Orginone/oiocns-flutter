import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/base/target.dart';


class ChoicePeople{
  late XTarget user;
  late ITarget department;

  ChoicePeople({required this.user,required this.department});
}

class ChoiceDepartment{
  late ITarget department;

  ChoiceDepartment({required this.department});
}