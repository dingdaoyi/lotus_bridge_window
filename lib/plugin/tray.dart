import 'dart:io';

import 'package:flutter/material.dart';
import 'package:system_tray/system_tray.dart';
import 'package:window_manager/window_manager.dart';
Future<void> initSystemTray() async {
  String path =
  Platform.isWindows ? 'assets/images/app_icon.ico' : 'assets/images/app_icon.png';

  final SystemTray systemTray = SystemTray();

  // We first init the systray menu
  await systemTray.initSystemTray(
    // title: "莲花桥",
    iconPath: path,
  );

  // create context menu
  final Menu menu = Menu();
  await menu.buildFrom([
    MenuItemLabel(label: '打开', onClicked: (menuItem) => windowManager.show()),
    MenuItemLabel(label: '隐藏', onClicked: (menuItem) => windowManager.hide()),
    SubMenu(label: '操纵',
        image: getImagePath('gift_icon'),
        children: [
      MenuItemLabel(label: '系统管理', onClicked: (menuItem){
        debugPrint('');
      }),
      MenuItemLabel(label: '南向链接', onClicked: (menuItem){
        debugPrint('');
      }),
      MenuItemLabel(label: '北向应用', onClicked: (menuItem){
        debugPrint('');
      }),
      MenuItemLabel(label: '插件管理', onClicked: (menuItem){
        debugPrint('');
      }),
    ]),
    MenuItemLabel(label: '退出', onClicked: (menuItem) => windowManager.destroy()),
  ]);

  await systemTray.setContextMenu(menu);
  systemTray.registerSystemTrayEventHandler((eventName) {
    debugPrint("eventName: $eventName");
    if (eventName == kSystemTrayEventClick) {
      Platform.isWindows ? windowManager.show() : systemTray.popUpContextMenu();
    } else if (eventName == kSystemTrayEventRightClick) {
      Platform.isWindows ? systemTray.popUpContextMenu() : windowManager.show();
    }
  });
}

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/images/$imageName.ico' : 'assets/images/$imageName.png';
}

String getImagePath(String imageName) {
  return Platform.isWindows ? 'assets/images/$imageName.bmp' : 'assets/images/$imageName.png';
}