import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'message_detail.g.dart';

const messageDetailTable = SqfEntityTable(
    tableName: 'messageDetail',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text),
      SqfEntityField('id', DbType.integer),
      SqfEntityField('fromId', DbType.integer, isIndex: true),
      SqfEntityField('toId', DbType.integer),
      SqfEntityField('msgType', DbType.text),
      SqfEntityField('msgBody', DbType.text),
      SqfEntityField('status', DbType.integer),
      SqfEntityField('createUser', DbType.integer),
      SqfEntityField('updateUser', DbType.integer),
      SqfEntityField('version', DbType.integer),
      SqfEntityField('createTime', DbType.datetime),
      SqfEntityField('updateTime', DbType.datetime),
      SqfEntityField('isRead', DbType.bool)
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(messageDetailModel)
const messageDetailModel = SqfEntityModel(
    sequences: [seqIdentity],
    databaseName: "orginone.db",
    databaseTables: [messageDetailTable]);
