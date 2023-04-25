import 'package:orginone/dart/base/schema.dart';
import 'package:orginone/dart/core/target/itarget.dart';
import 'package:orginone/util/common_tree_management.dart';

class ChoiceAssets {
  late AssetsCategoryGroup? selectedAsset;

  ChoiceAssets(this.selectedAsset);
}


class ChoicePeople{
  late XTarget user;
  late ITarget department;

  ChoicePeople({required this.user,required this.department});
}

class ChoiceDepartment{
  late ITarget department;

  ChoiceDepartment({required this.department});
}