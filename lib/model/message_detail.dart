import 'package:sqfentity_gen/sqfentity_gen.dart';

const messageDetailTable = SqfEntityTable(
    tableName: 'messageDetail',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text, isIndex: true),
      SqfEntityField('id', DbType.integer, isIndex: true),
      SqfEntityField('spaceId', DbType.integer, isIndex: true),
      SqfEntityField('fromId', DbType.integer, isIndex: true),
      SqfEntityField('toId', DbType.integer, isIndex: true),
      SqfEntityField('msgType', DbType.text),
      SqfEntityField('msgBody', DbType.text),
      SqfEntityField('status', DbType.integer),
      SqfEntityField('createUser', DbType.integer),
      SqfEntityField('updateUser', DbType.integer),
      SqfEntityField('version', DbType.integer),
      SqfEntityField('createTime', DbType.datetime),
      SqfEntityField('updateTime', DbType.datetime),
      SqfEntityField('isRead', DbType.bool),
      SqfEntityField('typeName', DbType.text)
    ]);
