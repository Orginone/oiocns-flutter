import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const groupTable = SqfEntityTable(
    tableName: 'messageGroup',
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
      SqfEntityField("priority", DbType.integer)
    ]);

const messageTable = SqfEntityTable(
    tableName: 'messageDetail',
    primaryKeyName: 'seqId',
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
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

@SqfEntityBuilder(dbModel)
const dbModel = SqfEntityModel(
    modelName: "orginone",
    databaseName: "orginone.db",
    databaseTables: [groupTable, messageTable]);
