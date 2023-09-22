import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:lotus_bridge_window/pages/device_add.dart';
import 'package:lotus_bridge_window/pages/device_group.dart';
import 'package:lotus_bridge_window/pages/export_edit.dart';
import 'package:lotus_bridge_window/pages/plugin_config.dart';

import '../models/storage.dart';
import '../pages/data_export.dart';
import '../pages/device.dart';
import '../pages/login.dart';
import '../pages/navigationPage.dart';
import '../pages/plugin_detail.dart';
import '../pages/point_page.dart';
import '../pages/settings.dart';

final router = GoRouter(
  initialLocation: "/login",
  routes: [
    GoRoute(
      name: "login",
      path: '/login',
      redirect: (context, state) async {
        bool isLogin = TokenStorage.getInstance().isLogin;
        if (isLogin) {
          return "/device";
        }
        return null;
      },
      builder: (context, state) => LoginPage(
        key: UniqueKey(),
      ),
    ),
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return NavigationPage(child: child);
      },
      routes: <RouteBase>[
        GoRoute(
          name: "device",
          path: '/device',
          routes: <RouteBase>[
            GoRoute(
              name: "deviceAdd",
              path: 'add',
              builder: (context, state) => const DeviceAdd(),
            ),
            GoRoute(
              name: "deviceEdit",
              path: 'edit/:id',
              builder: (context, state) => DeviceAdd(
                deviceId: int.parse(state.pathParameters['id']!),
              ),
            ),
            GoRoute(
              name: "deviceGroup",
              path: 'deviceGroup/:deviceId',
              builder: (context, state) => DeviceGroupPage(
                deviceId: int.parse(state.pathParameters['deviceId']!),
              ),
            ),
            GoRoute(
              name: "point",
              path: 'point/:groupId',
              builder: (context, state) => PointPage(
                deviceGroupId: int.parse(state.pathParameters['groupId']!),
              ),
            ),
          ],
          builder: (context, state) => const DevicePage(),
        ),
        GoRoute(
            name: "dataExport",
            path: '/dataExport',
            builder: (context, state) => DataExportConfigPage(key: UniqueKey()),
            routes: [
              GoRoute(
                name: "exportConfigAdd",
                path: 'add',
                builder: (context, state) => ExportConfigEdit(key: UniqueKey()),
              ),
              GoRoute(
                name: "exportConfigEdit",
                path: 'edit/:id',
                builder: (context, state) => ExportConfigEdit(
                  key: UniqueKey(),
                  exportConfigId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ]),
        GoRoute(
            name: "pluginConfig",
            path: '/pluginConfig',
            builder: (context, state) => PluginConfigPage(key: UniqueKey()),
            routes: [
              GoRoute(
                name: "pluginConfigDetails",
                path: 'details/:id',
                builder: (context, state) => PluginDetails(
                  key: UniqueKey(),
                  pluginId: int.parse(state.pathParameters['id']!),
                ),
              ),
            ]),
        GoRoute(
          name: "settings",
          path: '/settings',
          builder: (context, state) => const GlobalSettings(),
        ),
      ],
    ),
  ],
);
