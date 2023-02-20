import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:orginone/pages/other/login.dart';
import 'package:orginone/pages/todo/todo_detail.dart';
import 'package:orginone/pages/todo/todo_tab_page.dart';
import 'package:orginone/pages/todo/todo_page.dart';

class Routers {
  static const String main = "/";
  static const String login = "/login";
  static const String home = "/home";
  static const String todo = "/todo";
  static const String todoList = "/todoList";
  static const String todoDetail = "/todoDetail";

  static List<GetPage> getInitRouters() {
    return [
      GetPage(
        name: Routers.main,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.home,
        page: () => const LoginPage(),
        binding: LoginBinding(),
      ),
      GetPage(
        name: Routers.todo,
        page: () => TodoPage(),
        binding: TodoBinding(),
      ),
      GetPage(
        name: Routers.todoList,
        page: () => const TodoTabPage(),
        binding: TodoListBinding(),
      ),
      GetPage(
        name: Routers.todoDetail,
        page: () => const TodoDetail(),
        binding: TodoDetailBinding(),
      ),
    ];
  }
}
