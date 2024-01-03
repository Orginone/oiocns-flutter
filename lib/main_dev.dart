import 'main.dart';
import 'env.dart';

Future<void> main() async {
  EnvConfig.env = Env.dev;
  await initApp();
}
