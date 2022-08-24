import 'package:sqfentity_gen/sqfentity_gen.dart';

const targetRelationTable = SqfEntityTable(
  tableName: 'targetRelation',
  fields: [
    SqfEntityField('activeTargetId', DbType.integer,
        isIndexGroup: 1, isPrimaryKeyField: true),
    SqfEntityField("passiveTargetId", DbType.integer,
        isIndexGroup: 1, isPrimaryKeyField: true),
    SqfEntityField('name', DbType.text),
    SqfEntityField("label", DbType.text),
    SqfEntityField("remark", DbType.text),
    SqfEntityField("typeName", DbType.text),
    SqfEntityField("priority", DbType.integer),
  ],
);
