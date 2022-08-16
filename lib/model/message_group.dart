import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'message_group.g.dart';

const messageGroupTable = SqfEntityTable(
    tableName: 'messageGroup',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('account', DbType.text),
      SqfEntityField('id', DbType.integer),
      SqfEntityField('name', DbType.text),
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(messageGroupModel)
const messageGroupModel = SqfEntityModel(
    sequences: [seqIdentity],
    databaseName: "orginone.db",
    databaseTables: [messageGroupTable]);
