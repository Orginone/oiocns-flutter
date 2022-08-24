import 'dart:convert';

import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:orginone/model/target.dart';
import 'package:orginone/model/user.dart';
import 'package:orginone/model/target_relation.dart';
import 'package:orginone/model/user_space_relation.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

import 'message_detail.dart';

part 'db_model.g.dart';

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(dbModel)
const dbModel = SqfEntityModel(
    sequences: [seqIdentity],
    databaseName: "orginone.db",
    databaseTables: [
      userTable,
      userSpaceRelationTable,
      targetRelationTable,
      targetTable,
      messageDetailTable
    ]);
