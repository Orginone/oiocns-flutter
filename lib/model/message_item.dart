import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'message_item.g.dart';

const messageItemTable = SqfEntityTable(
    tableName: 'messageItem',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text),
      SqfEntityField('id', DbType.integer),
      SqfEntityField('name', DbType.text),
      SqfEntityField('label', DbType.text),
      SqfEntityField('remark', DbType.text),
      SqfEntityField('typeName', DbType.text),
      SqfEntityField("msgTime", DbType.datetime)
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(messageItemModel)
const messageItemModel = SqfEntityModel(
    sequences: [seqIdentity],
    databaseName: "orginone.db",
    databaseTables: [messageItemTable]);
