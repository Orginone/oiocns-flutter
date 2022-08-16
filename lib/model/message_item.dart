import 'package:sqfentity_gen/sqfentity_gen.dart';

const messageItemTable = SqfEntityTable(
    tableName: 'messageItem',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text, isIndex: true),
      SqfEntityField('id', DbType.integer),
      SqfEntityField('name', DbType.text),
      SqfEntityField('label', DbType.text),
      SqfEntityField('remark', DbType.text),
      SqfEntityField('typeName', DbType.text),
      SqfEntityField("msgTime", DbType.datetime),
      SqfEntityField("msgGroupId", DbType.integer)
    ]);
