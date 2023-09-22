import 'package:fluent_ui/fluent_ui.dart';

import '../router/router.dart';
import '../widgets/win_manager_listener.dart';

class NavigationPage extends StatefulWidget {
  final Widget child;

  const NavigationPage({super.key, required this.child});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int topIndex = 0;
  List<NavigationPaneItem> items = [
    PaneItem(
      icon: const ImageIcon(AssetImage('assets/images/device_link.png')),
      title: const Text(
        '向南链接',
      ),
      body: const SizedBox.shrink(),
      onTap: () {
        router.pushNamed('device');
      },
    ),
    PaneItemSeparator(),
    PaneItem(
      icon: const ImageIcon(AssetImage('assets/images/export_config.png')),
      title: const Text(
        '北向应用',
      ),
      body: const SizedBox.shrink(),
      onTap: () {
        router.pushNamed('dataExport');
      },
    ),
    PaneItemSeparator(),
    PaneItem(
      icon: const ImageIcon(AssetImage('assets/images/plugin_config.png')),
      title: const Text(
        '插件管理',
      ),
      body: const SizedBox.shrink(),
      onTap: () {
        router.pushNamed('pluginConfig');
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WinManagerListener(
      child: NavigationView(
        appBar: const NavigationAppBar(
          automaticallyImplyLeading: false,
          height: 36,
        ),
        //右侧区域
        paneBodyBuilder: (item, child) {
          return widget.child;
        },
        pane: NavigationPane(
          size: const NavigationPaneSize(openWidth: 220),
          //配置左侧宽度
          selected: topIndex,
          onChanged: (index) => setState(() => topIndex = index),
          displayMode: PaneDisplayMode.top,
          items: items,
          footerItems: [
            PaneItem(
              icon: const Icon(FluentIcons.settings),
              title: const Text('Settings'),
              body: const SizedBox.shrink(),
              onTap: () {
                router.goNamed('settings');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBodyItem extends StatelessWidget {
  const NavigationBodyItem({
    Key? key,
    this.header,
    this.content,
  }) : super(key: key);

  final String? header;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}
