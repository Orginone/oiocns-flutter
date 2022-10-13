import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

import 'config/constant.dart';

Future<void> main() async {
  await shelf_io.serve(proxyHandler(Constant.host), 'localhost', 8080);
}
