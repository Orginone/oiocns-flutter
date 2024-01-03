/*
 * @Descripttion: 
 * @version: 
 * @Author: congsir
 * @Date: 2022-12-07 18:33:34
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2022-12-08 20:50:17
 */
import 'main.dart';

import 'env.dart';

Future<void> main() async {
  EnvConfig.env = Env.prod;
  await initApp();
}
