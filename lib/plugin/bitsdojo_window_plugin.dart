import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

///初始化window管理程序
Future<void> initWindowManager() async {
  await windowManager.ensureInitialized();
  WindowOptions windowOptions =  const WindowOptions(
    size: Size(1200, 800),
    center: true,
    skipTaskbar: false,
    title: '莲花桥',
    titleBarStyle: TitleBarStyle.normal,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
