import 'package:sqfentity_gen/sqfentity_gen.dart';

const userSpaceRelationTable = SqfEntityTable(
  tableName: 'userSpaceRelation',
  fields: [
    SqfEntityField("account", DbType.text, isPrimaryKeyField: true),
    SqfEntityField("targetId", DbType.integer, isPrimaryKeyField: true),
    SqfEntityField("name", DbType.text),
    SqfEntityField("isExpand", DbType.bool)
  ],
);
