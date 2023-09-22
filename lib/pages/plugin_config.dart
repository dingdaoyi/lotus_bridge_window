import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show ElevatedButton;
import 'package:lotus_bridge_window/models/plugin_config.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import 'package:lotus_bridge_window/widgets/thematic_gradient.dart';

import '../models/colors.dart';
import '../router/router.dart';
import '../widgets/number_pagination.dart';

class PluginConfigPage extends StatefulWidget {
  const PluginConfigPage({super.key});

  @override
  State<PluginConfigPage> createState() => _PluginConfigPageState();
}

class _PluginConfigPageState extends State<PluginConfigPage> {
  PluginService pluginService = PluginService();

  int _currentIndex = 1;

  List<PluginConfig> _pluginConfigList = [];
  Map<String, String> componentMap = {
    'Protocol': '协议解析',
    'DataOutput': '服务配置',
    'RuleEngine': '规则引擎',
  };
  String? pluginType;

  @override
  void initState() {
    super.initState();
    initPluginConfigList();
  }

  Future<void> initPluginConfigList() async {
    List<PluginConfig> resList =
        await pluginService.pluginList(pluginType: pluginType);
    if (resList.isNotEmpty) {
      setState(() {
        _pluginConfigList = resList;
      });
    }
  }

  Widget _pluginConfigItem(BuildContext context, int index) {
    PluginConfig pluginConfig = _pluginConfigList[index];
    return Card(
        child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(47, 182, 255, 0.24),
            Color.fromRGBO(19, 23, 32, 0),
          ],
        ),
      ),
      child: Column(
        children: [
          Expanded(
              child: Row(
            children: [
              Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        componentMap[pluginConfig.pluginType] ?? '',
                        style: const TextStyle(
                            color: Color.fromRGBO(14, 196, 202, 1)),
                      ),
                      Image.asset('assets/images/device_1.png')
                    ],
                  )),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pluginConfig.name,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                          TextSpan(
                              text: '插件描述',
                              style: const TextStyle(
                                  color: Color.fromRGBO(159, 172, 175, 1),
                                  fontSize: 12),
                              children: [
                                TextSpan(
                                    text: ' ${pluginConfig.description ?? ''}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(238, 248, 250, 1),
                                        fontSize: 12))
                              ]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  child: const Text('禁用'),
                  onPressed: () => debugPrint('pressed button'),
                ),
                FilledButton(
                  child: const Text('详情'),
                  onPressed: () {
                    router.goNamed('pluginConfigDetails',
                        pathParameters: {'id': pluginConfig.id.toString()});
                  },
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: _pluginConfigList.isEmpty
          ? Container()
          : Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  height: 60,
                  // width: 550,
                  padding: const EdgeInsets.all(5),
                  decoration: const ThematicGradientDecoration(),
                  // color: Colors.green,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 220,
                        child: ComboBox<String>(
                          isExpanded: true,
                          value: pluginType,
                          //'Protocol', 'DataOutput', 'RuleEngine'
                          items: componentMap.entries
                              .map((entry) => ComboBoxItem<String>(
                                    value: entry.key,
                                    child: Text(entry.value),
                                  ))
                              .toList(),
                          onChanged: (changedValue) {
                            setState(() {
                              pluginType = changedValue ?? pluginType;
                            });
                          },
                          placeholder: const Text('插件类型'),
                        ),
                      ),
                      const SizedBox(width: 40),
                      const SizedBox(
                        width: 220,
                        child: TextBox(
                          placeholder: '配置名称',
                          expands: false,
                        ),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton.icon(
                        icon: const Icon(FluentIcons.search),
                        label: const Text('搜索'),
                        onPressed: initPluginConfigList,
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton.icon(
                        icon: const Icon(FluentIcons.reset),
                        label: const Text('重置'),
                        onPressed: () {
                          setState(() {
                            pluginType= null;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.3,
                              crossAxisSpacing: 3,
                              mainAxisSpacing: 3),
                      itemCount: _pluginConfigList.length,
                      itemBuilder: _pluginConfigItem),
                ),
                NumberPagination(
                  onPageChanged: (int pageNumber) {
                    setState(() {
                      _currentIndex = pageNumber;
                    });
                  },
                  colorSub: BridgeColors.primary,
                  pageTotal: 1,
                  pageInit: _currentIndex,
                ),
              ],
            ),
    );
  }

  Future<bool?> showContentDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: const Text('确认要删除'),
        content: const Text(
          '删除后无法恢复数据',
        ),
        actions: [
          Button(
            child: const Text('删除'),
            onPressed: () {
              Navigator.pop(context, true);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}
