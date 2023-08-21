import 'tray.dart';
import 'bitsdojo_window_plugin.dart' ;


Future<void> initPlugin() async {
  await initSystemTray();
}

void postInitPlugin(){
  initWindowManager();
}