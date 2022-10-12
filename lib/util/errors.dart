class ServerError extends Error {
  final String errorMsg;

  ServerError(this.errorMsg);
}
