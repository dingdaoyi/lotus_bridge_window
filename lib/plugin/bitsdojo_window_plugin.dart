import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

///初始化window管理程序
Future<void> initWindowManager() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions =  const WindowOptions(
    size: Size(800, 600),
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
