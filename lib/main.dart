import 'package:fluent_ui/fluent_ui.dart';
import './router/router.dart';
import 'plugin/plugin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initPlugin();
  runApp(const LotusBridgeApp());
  postInitPlugin();
}

class LotusBridgeApp extends StatelessWidget {
  const LotusBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp.router(
      title: '莲花桥',
      debugShowCheckedModeBanner: false,
      theme: FluentThemeData(
        accentColor: Colors.magenta,
          brightness:Brightness.dark
      ),
      //配置路由
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
