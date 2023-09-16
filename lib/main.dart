import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:lotus_bridge_window/utils/context.dart';
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
    LotusBridge.initContext(context);
    return FluentApp.router(
      title: '莲花桥',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'), // 英文
        Locale('zh', 'CN'), // 中文（简体）
      ],
      locale: const  Locale('zh', 'CN'),
      theme: FluentThemeData(
        
        accentColor: 
        AccentColor.swatch(const <String, Color>{
          'darkest': Color.fromRGBO(14, 196, 202, 1),
          'darker': Color.fromRGBO(14, 196, 202, 1),
          'dark': Color.fromRGBO(14, 196, 202, 1),
          'normal': Color.fromRGBO(14, 196, 202, 1),
          'light': Color.fromRGBO(14, 196, 202, 1),
          'lighter': Color.fromRGBO(14, 196, 202, 1),
          'lightest': Color.fromRGBO(14, 196, 202, 1),
        }),
          brightness:Brightness.dark,
        typography: const Typography.raw(
          title: TextStyle(
            fontSize: 24
          )
        )
      ),
      //配置路由
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
    );
  }
}
