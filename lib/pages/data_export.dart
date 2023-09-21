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
import '../models/device_models.dart';
import '../router/router.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/number_pagination.dart';

class DataExportConfigPage extends StatefulWidget {
  const DataExportConfigPage({super.key});

  @override
  State<DataExportConfigPage> createState() => _DataExportConfigPageState();
}

class _DataExportConfigPageState extends State<DataExportConfigPage> {
  ExportService exportService = ExportService();
  PluginService pluginService = PluginService();

  int _currentIndex = 1;
  String? _pluginName;

  List<ExportConfig> _exportConfigList = [];
  Map<int, PluginConfig> _pluginConfigMap = {};

  @override
  void initState() {
    super.initState();
    initPluginConfigList();
    initExportConfigList();
  }

  Future<void> initPluginConfigList() async {
    List<PluginConfig> resList =
        await pluginService.pluginList(pluginType: 'DataOutput');
    if (resList.isNotEmpty) {
      setState(() {
        _pluginConfigMap = convertListToMap(resList);
      });
    }
  }

  Future<void> initExportConfigList() async {
    List<ExportConfig> resList = await exportService.exportConfigList();
    if (resList.isNotEmpty) {
      setState(() {
        _exportConfigList = resList;
      });
    }
  }

  Future<void> _editExportGroup(int exportId) async {
    await showDialog(
        context: context,
        builder: (context) {
          return ExportGroupConfig(
            exportConfigId: exportId,
          );
        });
    initExportConfigList();
  }

  Map<int, PluginConfig> convertListToMap(List<PluginConfig> list) {
    return list.fold({}, (Map<int, PluginConfig> map, PluginConfig config) {
      map[config.id] = config;
      return map;
    });
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
                  onPressed: () => _editExportGroup(exportConfig.id),
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
                          key: UniqueKey(),
                          value: _pluginName,
                          pluginType: 'DataOutput',
                          onChanged: (value) {
                            setState(() {
                              _pluginName = value?.name;
                            });
                          },
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
                        icon: const Icon(FluentIcons.add),
                        label: const Text('重置'),
                        onPressed: () {
                          setState(() {
                            _pluginName = null;
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

class ExportGroupConfig extends StatefulWidget {
  final int exportConfigId;

  const ExportGroupConfig({super.key, required this.exportConfigId});

  @override
  State<ExportGroupConfig> createState() => _ExportGroupConfigState();
}

class _ExportGroupConfigState extends State<ExportGroupConfig> {
  DeviceGroupService deviceGroupService = DeviceGroupService();
  ExportService exportService = ExportService();

  List<DeviceGroup> deviceGroupList = [];
  List<int> selectedGroupIdList = [];
  List<int> selectedIdList = [];

  @override
  void initState() {
    super.initState();
    initDeviceGroupList();
  }

  ///初始化
  Future<void> initDeviceGroupList() async {
    List<DeviceGroup> res = await deviceGroupService.deviceGroupList();
    List<ExportGroup> exportGroupRes =
        await exportService.listExportGroup(widget.exportConfigId);
    setState(() {
      deviceGroupList = res;
      selectedGroupIdList = exportGroupRes.map((e) => e.groupId).toList();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  TreeViewItem _dataItem() {
    return TreeViewItem(
        content: const Text('全选'),
        value: -1,
        children: deviceGroupList
            .map((deviceGroup) => TreeViewItem(
                content: Text(deviceGroup.name),
                value: deviceGroup.id,
                selected: selectedGroupIdList.contains(deviceGroup.id)))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 640,
        width: 600,
        padding: const EdgeInsets.all(20),
        decoration: const ThematicGradientDecoration(),
        child: Form(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: TreeView(
                    selectionMode: TreeViewSelectionMode.multiple,
                    shrinkWrap: true,
                    items: [_dataItem()],
                    onSelectionChanged: _selectionChanged,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HyperlinkButton(
                    onPressed: _saveChanged,
                    child: const Text('确认'),
                  ),
                  HyperlinkButton(
                      child: const Text(
                        '取消',
                      ),
                      onPressed: () => Navigator.of(context).pop()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectionChanged(Iterable<TreeViewItem> selectedItems) async {
    selectedIdList = selectedItems
        .map((i) => i.value as int)
        .where((value) => value != -1)
        .toList();
  }

  Future<void> _saveChanged() async {
    bool res = await exportService.associatedDeviceGroup(
        selectedIdList, widget.exportConfigId, context);
    if (res) {
      await ToastUtils.info(context, title: '操作成功');
      Navigator.of(context).pop();
    }
  }
}
