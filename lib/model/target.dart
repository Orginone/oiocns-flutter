import 'package:sqfentity_gen/sqfentity_gen.dart';

const targetTable = SqfEntityTable(
  tableName: 'target',
  primaryKeyName: 'id',
  primaryKeyType: PrimaryKeyType.integer_unique,
  fields: [
    SqfEntityField("code", DbType.text),
    SqfEntityField("name", DbType.text),
    SqfEntityField("typeName", DbType.text),
    SqfEntityField("belongId", DbType.integer),
    SqfEntityField("thingId", DbType.integer),
  ],
);
