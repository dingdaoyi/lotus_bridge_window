import '../models/global.dart';
import 'tray.dart';
import 'bitsdojo_window_plugin.dart' ;


Future<void> initPlugin() async {
  await initSystemTray();
  await Global.init();
}

void postInitPlugin(){
  initWindowManager();
}