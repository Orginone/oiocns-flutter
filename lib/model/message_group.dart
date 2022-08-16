import 'package:sqfentity_gen/sqfentity_gen.dart';

const messageGroupTable = SqfEntityTable(
    tableName: 'messageGroup',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text, isIndex: true),
      SqfEntityField('id', DbType.integer),
      SqfEntityField('name', DbType.text),
      SqfEntityField('isExpand', DbType.bool),
    ]);
