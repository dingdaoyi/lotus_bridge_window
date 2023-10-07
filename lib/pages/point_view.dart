import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show ElevatedButton;
import 'package:lotus_bridge_window/models/device_group.dart';
import 'package:lotus_bridge_window/models/export_config.dart';
import 'package:lotus_bridge_window/models/export_group.dart';
import 'package:lotus_bridge_window/models/plugin_config.dart';
import 'package:lotus_bridge_window/service/device_grop_service.dart';
import 'package:lotus_bridge_window/service/export_service.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import 'package:lotus_bridge_window/utils/toast_utils.dart';
import 'package:lotus_bridge_window/widgets/thematic_gradient.dart';
import '../models/colors.dart';
import '../router/router.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/number_pagination.dart';

class PointViewPage extends StatefulWidget {
  const PointViewPage({super.key});

  @override
  State<PointViewPage> createState() => _PointViewPageState();
}

class _PointViewPageState extends State<PointViewPage> {
  ExportService exportService = ExportService();
  PluginService pluginService = PluginService();
  final TextEditingController _protocolNameController = TextEditingController();
  int _currentIndex = 1;
  List<ExportConfig> _exportConfigList = [];
  Map<int, PluginConfig> _pluginConfigMap = {};

  @override
  void initState() {
    super.initState();
    initExportConfigList();
  }


  @override
  void dispose() {
    super.dispose();
    _protocolNameController.dispose();
  }


  Future<void> initExportConfigList() async {
    List<ExportConfig> resList = await exportService.exportConfigList();
    if (resList.isNotEmpty) {
      setState(() {
        _exportConfigList = resList;
      });
    }
  }

  Widget _exportConfigItem(BuildContext context, int index) {
    ExportConfig exportConfig = _exportConfigList[index];
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
                      const Text(
                        '正常',
                        style:
                            TextStyle(color: Color.fromRGBO(14, 196, 202, 1)),
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
                        exportConfig.name,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(
                          TextSpan(
                              text: '设备群组',
                              style: const TextStyle(
                                  color: Color.fromRGBO(159, 172, 175, 1),
                                  fontSize: 12),
                              children: [
                                TextSpan(
                                    text:
                                        ' ${exportConfig.groupNames??''}',
                                    style: const TextStyle(
                                        color: Color.fromRGBO(238, 248, 250, 1),
                                        fontSize: 12))
                              ]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(
                        height: 20,
                      ),
                      Text.rich(TextSpan(
                          text: '使用插件',
                          style: const TextStyle(
                              color: Color.fromRGBO(159, 172, 175, 1),
                              fontSize: 12),
                          children: [
                            TextSpan(
                                text:
                                    ' ${_pluginConfigMap[exportConfig.pluginId]?.name}',
                                style: const TextStyle(
                                    color: Color.fromRGBO(238, 248, 250, 1),
                                    fontSize: 12))
                          ])),
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
                  child: const Text('编辑'),
                  onPressed: () {
                    router.goNamed('exportConfigEdit',
                        pathParameters: {'id': exportConfig.id.toString()});
                  },
                ),
                FilledButton(
                  child: const Text('群组配置'),
                  onPressed: () {


                  },
                ),
                FilledButton(
                  child: const Text('删除'),
                  onPressed: () => _deleteDevice(exportConfig.id),
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
      child: _exportConfigList.isEmpty
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
                        child: ComboBoxPluginConfig(
                          controller: _protocolNameController,
                          pluginType: 'DataOutput',
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
                        onPressed: () => debugPrint('pressed button'),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton.icon(
                        icon: const Icon(FluentIcons.add),
                        label: const Text('添加'),
                        onPressed: () => router.goNamed('exportConfigAdd'),
                      ),
                      const SizedBox(width: 40),
                      ElevatedButton.icon(
                        icon: const Icon(FluentIcons.reset),
                        label: const Text('重置'),
                        onPressed: () {
                          _protocolNameController.clear();
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
                      itemCount: _exportConfigList.length,
                      itemBuilder: _exportConfigItem),
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

  Future<void> _deleteDevice(int id) async {
    if (!(await showContentDialog() ?? false)) {
      return;
    }
    bool res = await exportService.delete(id, context);
    if (res) {
      displayInfoBar(context, builder: (context, close) {
        return InfoBar(
          title: const Text('删除成功'),
          severity: InfoBarSeverity.info,
        );
      });
      initExportConfigList();
    }
  }
}
