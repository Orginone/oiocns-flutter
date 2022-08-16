import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'target.g.dart';

const targetTable = SqfEntityTable(
    tableName: 'target',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('id', DbType.integer),
      SqfEntityField('name', DbType.text),
      SqfEntityField('code', DbType.text),
      SqfEntityField('typeName', DbType.text),
      SqfEntityField('thingId', DbType.integer),
      SqfEntityField('status', DbType.integer),
      SqfEntityField('createUser', DbType.integer),
      SqfEntityField('updateUser', DbType.integer),
      SqfEntityField('version', DbType.integer),
      SqfEntityField('createTime', DbType.datetime),
      SqfEntityField('updateTime', DbType.datetime),
    ]);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(targetModel)
const targetModel = SqfEntityModel(
    sequences: [seqIdentity],
    databaseName: "orginone.db",
    databaseTables: [targetTable]);
