class RequestEntity {
  final String module;
  final String action;
  final dynamic params;

  const RequestEntity({
    required this.module,
    required this.action,
    required this.params,
  });
}
