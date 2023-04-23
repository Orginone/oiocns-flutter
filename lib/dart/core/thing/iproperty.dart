

import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/base/schema.dart';

abstract class IProperty{
  late String belongId;

  Future<XPropertyArray?> loadProperty(PageRequest page);

  Future<XProperty?> createProperty(PropertyModel data);

  Future<XProperty?> updateProperty(PropertyModel data);

  Future<bool> deleteProperty(String id);
}