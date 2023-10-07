import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataCell, DataColumn, DataRow, DataTable, ElevatedButton, TextButton;
import 'package:lotus_bridge_window/models/export_config.dart';
import 'package:lotus_bridge_window/models/plugin_config.dart';
import 'package:lotus_bridge_window/service/export_service.dart';
import 'package:lotus_bridge_window/widgets/thematic_gradient.dart';
import '../models/colors.dart';
import '../models/pagination_response.dart';
import '../models/point.dart';
import '../router/router.dart';
import '../service/point_service.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/number_pagination.dart';

class PointViewPage extends StatefulWidget {
  const PointViewPage({super.key});

  @override
  State<PointViewPage> createState() => _PointViewPageState();
}

class _PointViewPageState extends State<PointViewPage> {
  PointService pointService = PointService();
  final TextEditingController _protocolNameController = TextEditingController();
  int _currentIndex = 1;
  int _pageTotal = 1;
  List<Point> list = [];
  int deviceGroupId = 1;
  @override
  void initState() {
    super.initState();
  }

  Future<void> initPointPage() async {
    PaginationResponse<Point> response = await pointService
        .pointPage(deviceGroupId, page: _currentIndex, limit: 20);
    setState(() {
      _pageTotal = response.total ~/ 20 + 1;
      list = response.data;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _protocolNameController.dispose();
  }

  List<DataRow> _itemData() {
    return list.map((point) {
      return DataRow(cells: [
        DataCell(Center(child: SelectableText('${point.id}'))),
        DataCell(Center(child: SelectableText(point.address))),
        DataCell(Center(child: SelectableText(point.description))),
        DataCell(Center(
            child: SelectableText(Point.dataTypeToString(point.dataType)))),
        DataCell(Center(child: SelectableText('${point.precision}'))),
        DataCell(Center(child: SelectableText(point.partNumber ?? ''))),
        DataCell(Center(child: SelectableText('${point.multiplier}'))),
        DataCell(
            Center(child: SelectableText(point.accessMode.toChineseString()))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: list.isEmpty
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
                  child: DataTable(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                        label: Container(
                          width: 80,
                          alignment: Alignment.center,
                          child: const Text('id'),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                            alignment: Alignment.center,
                            width: 120,
                            child: const Text('点位地址')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 160,
                            alignment: Alignment.center,
                            child: const Text('点位描述')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text('数据类型')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text('部件号')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text('点位值')),
                      ),
                    ],
                    rows: _itemData(),
                  ),
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
