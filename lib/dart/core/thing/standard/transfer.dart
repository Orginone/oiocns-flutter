import 'package:orginone/dart/base/common/commands.dart';
import 'package:orginone/dart/base/model.dart';
import 'package:orginone/dart/core/thing/directory.dart';
import 'package:orginone/dart/core/thing/fileinfo.dart';

typedef GraphData = dynamic Function();

abstract class ITransfer extends IStandardFileInfo<XTransfer> {
  Command command;
  List<ITask> taskList;
  ITask? curTask;
  ITransfer? getTransfer(String id);
  GraphData? getData;
  void binding(GraphData getData);
  void unbinding();
  bool hasLoop();
  Node? getNode(String id);
  Future<void> addNode(Node node);
  Future<void> updNode(Node node);
  Future<void> delNode(String id);
  Edge? getEdge(String id);
  Future<bool> addEdge(Edge edge);
  Future<void> updEdge(Edge edge);
  Future<void> delEdge(String id);
  Future<void> addEnv(Environment env);
  Future<void> updEnv(Environment env);
  Future<void> delEnv(String id);
  Environment? getCurEnv();
  Future<void> changeEnv(String id);
  Future<HttpResponseType> request(Node node, {KeyValue? env});
  dynamic running(String code, dynamic args, {KeyValue? env});
  Future<List<dynamic>> mapping(Node node, List<dynamic> array);
  Future<List<dynamic>> writing(Node node, List<dynamic> array);
  Future<List<Sheet<T>>> template<T>(Node node);
  Future<dynamic> reading(Node node);
  Future<void> execute(GStatus status, GEvent event);
  Future<void> nextExecute(ITask preTask);
}

class Transfer extends StandardFileInfo<XTransfer> implements ITransfer {
  @override
  Command command;
  @override
  List<ITask> taskList;
  @override
  ITask? curTask;
  @override
  GraphData? getData;

  Transfer(XTransfer metadata, IDirectory dir)
      : super(metadata, dir, dir.resource.transferColl) {
    taskList = [];
    command = Command();
    setEntity();
  }

  String get cacheFlag => 'transfers';

  @override
  bool isContainer;

  @override
  Future<bool> addEdge(Edge edge) {
    // TODO: implement addEdge
    throw UnimplementedError();
  }

  @override
  Future<void> addEnv(Environment env) {
    // TODO: implement addEnv
    throw UnimplementedError();
  }

  @override
  Future<void> addNode(Node node) {
    // TODO: implement addNode
    throw UnimplementedError();
  }

  @override
  void binding(GraphData getData) {
    // TODO: implement binding
  }

  @override
  Future<void> changeEnv(String id) {
    // TODO: implement changeEnv
    throw UnimplementedError();
  }

  @override
  Future<void> delEdge(String id) {
    // TODO: implement delEdge
    throw UnimplementedError();
  }

  @override
  Future<void> delEnv(String id) {
    // TODO: implement delEnv
    throw UnimplementedError();
  }

  @override
  Future<void> delNode(String id) {
    // TODO: implement delNode
    throw UnimplementedError();
  }

  @override
  Future<void> execute(status, event) {
    // TODO: implement execute
    throw UnimplementedError();
  }

  @override
  Environment? getCurEnv() {
    // TODO: implement getCurEnv
    throw UnimplementedError();
  }

  @override
  Edge? getEdge(String id) {
    // TODO: implement getEdge
    throw UnimplementedError();
  }

  @override
  Node? getNode(String id) {
    // TODO: implement getNode
    throw UnimplementedError();
  }

  @override
  ITransfer? getTransfer(String id) {
    // TODO: implement getTransfer
    throw UnimplementedError();
  }

  @override
  bool hasLoop() {
    // TODO: implement hasLoop
    throw UnimplementedError();
  }

  @override
  Future<List> mapping(Node node, List array) {
    // TODO: implement mapping
    throw UnimplementedError();
  }

  @override
  Future<void> nextExecute(preTask) {
    // TODO: implement nextExecute
    throw UnimplementedError();
  }

  @override
  Future reading(Node node) {
    // TODO: implement reading
    throw UnimplementedError();
  }

  @override
  Future<HttpResponseType> request(Node node, {KeyValue? env}) {
    // TODO: implement request
    throw UnimplementedError();
  }

  @override
  running(String code, args, {KeyValue? env}) {
    // TODO: implement running
    throw UnimplementedError();
  }

  @override
  Future<List> template<T>(Node node) {
    // TODO: implement template
    throw UnimplementedError();
  }

  @override
  void unbinding() {
    // TODO: implement unbinding
  }

  @override
  Future<void> updEdge(Edge edge) {
    // TODO: implement updEdge
    throw UnimplementedError();
  }

  @override
  Future<void> updEnv(Environment env) {
    // TODO: implement updEnv
    throw UnimplementedError();
  }

  @override
  Future<void> updNode(Node node) {
    // TODO: implement updNode
    throw UnimplementedError();
  }

  @override
  Future<List> writing(Node node, List array) {
    // TODO: implement writing
    throw UnimplementedError();
  }
}
