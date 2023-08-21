import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';

import '../pages/data_export.dart';
import '../pages/device.dart';
import '../pages/login.dart';
import '../pages/navigationPage.dart';

final router = GoRouter(
  initialLocation: "/login", //初始化的路由
  routes: [
    GoRoute(
      name: "login",
      path: '/login',
      redirect: (context, state) async {
        //判断用户有没有登录 加载不同的路由
        // bool isLogin = await UserService.isLogin();
        // if (isLogin) {
        //   return "/device"; //跳转路由
        // }
        return null; //返回空表示不执行跳转
      },
      builder: (context, state) => const LoginPage(),
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return NavigationPage(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          name: "device",
          path: '/device',
          builder: (context, state) => const DevicePage(),
        ),
        GoRoute(
          name: "dataExport",
          path: '/dataExport',
          builder: (context, state) => const DataExport(),
        ),
      ],
    ),
  ],
);
