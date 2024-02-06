import 'main_base.dart';
import 'env.dart';

Future<void> main() async {
  EnvConfig.env = Env.dev;
  await initApp();
}
