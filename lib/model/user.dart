import 'package:sqfentity_gen/sqfentity_gen.dart';

const userTable = SqfEntityTable(
    tableName: 'user',
    primaryKeyName: 'account',
    primaryKeyType: PrimaryKeyType.text,
    fields: [
      SqfEntityField("userName", DbType.text),
      SqfEntityField("motto", DbType.text),
    ]);
