import 'main_bean.dart';
import 'env.dart';

Future<void> main() async {
  EnvConfig.env = Env.dev;
  await initApp();
}
