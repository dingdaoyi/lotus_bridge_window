import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/router/router.dart';
import 'package:lotus_bridge_window/service/point_service.dart';

import '../models/colors.dart';
import '../models/pagination_response.dart';
import '../models/point.dart';
import '../utils/toast_utils.dart';
import '../widgets/drawerNavigation.dart';
import '../widgets/number_pagination.dart';
import '../widgets/thematic_gradient.dart';
import 'package:flutter/material.dart'
    show ElevatedButton, DataTable, DataColumn, DataRow, DataCell, TextButton;

class PointPage extends StatefulWidget {
  final int deviceGroupId;

  const PointPage({super.key, required this.deviceGroupId});

  @override
  State<PointPage> createState() => _PointPageState();
}

class _PointPageState extends State<PointPage> {
  PointService pointService = PointService();

  int _currentIndex = 1;
  int _pageTotal = 1;
  List<Point> list = [];

  @override
  void initState() {
    super.initState();
    initPointPage();
  }

  Future<void> initPointPage() async {
    PaginationResponse<Point> response = await pointService
        .pointPage(widget.deviceGroupId, page: _currentIndex, limit: 20);
    setState(() {
      _pageTotal = response.total ~/ 20 + 1;
      list = response.data;
    });
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
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text('查看值'),
                onPressed: () => _readPointValue(point),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text('编辑'),
                onPressed: () => _editPoint(point: point),
              ),
              const SizedBox(
                width: 10,
              ),
              TextButton(
                child: const Text(
                  '删除',
                  style: TextStyle(color: Colors.warningPrimaryColor),
                ),
                onPressed: () => deletePoint(point.id!),
              ),
            ],
          ),
        )),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ThematicGradientDecoration(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                    child: DrawerNavigation(items: [
                      DrawerNavItem(
                          title: '向南链接',
                          callback: () => router.replaceNamed('device')),
                      DrawerNavItem(
                          title: '分组管理',
                          callback: () => Navigator.of(context).pop()),
                      DrawerNavItem(
                          title: '点位管理',
                          callback: () => Navigator.of(context).pop()),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    ElevatedButton.icon(
                      icon: const Icon(FluentIcons.add),
                      label: const Text('新增'),
                      onPressed: _editPoint,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(FluentIcons.upload),
                      label: const Text('导入'),
                      onPressed: () => debugPrint('pressed button'),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(FluentIcons.download),
                      label: const Text('导出'),
                      onPressed: () => debugPrint('pressed button'),
                    ),
                  ]),
                  DataTable(
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
                            child: const Text('精度')),
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
                            child: const Text('乘系数')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 80,
                            alignment: Alignment.center,
                            child: const Text('读写类型')),
                      ),
                      DataColumn(
                        label: Container(
                            alignment: Alignment.center,
                            width: 180,
                            child: const Text('操作')),
                      )
                    ],
                    rows: _itemData(),
                  ),
                ],
              ),
            ),
          ),
          NumberPagination(
            onPageChanged: (int pageNumber) {
              setState(() {
                _currentIndex = pageNumber;
                initPointPage();
              });
            },
            colorPrimary: Colors.black,
            colorSub: BridgeColors.primary,
            pageTotal: _pageTotal,
            pageInit: _currentIndex,
          ),
        ],
      ),
    );
  }

  Future<void> _readPointValue(Point point) async {
    var value=await pointService.readPointValue(point.id!, context);
    ToastUtils.showData(context,  content: '点位值:${value}', tile: '点位值');
  }

  Future<void> _editPoint({Point? point}) async {
    await showDialog(
        context: context,
        builder: (context) {
          return PointEdit(
            groupId: widget.deviceGroupId,
            point: point,
          );
        });
    initPointPage();
  }

  Future<void> deletePoint(int id) async {
    if (await ToastUtils.confirm(context, content: '确认要删除点位?', tile: '删除点位')) {
      await pointService.deletePoint(id, context);
      initPointPage();
    }
  }
}

class PointEdit extends StatefulWidget {
  final Point? point;
  final int groupId;

  const PointEdit({super.key, required this.groupId, this.point});

  @override
  State<PointEdit> createState() => _PointEditState();
}

class _PointEditState extends State<PointEdit> {
  PointService pointService = PointService();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController partNumController = TextEditingController();
  DataType dataType = DataType.Integer;
  int precision = 1;
  double multiplier = 1;
  AccessMode accessMode = AccessMode.ReadOnly;
  int? deviceId;
  int? id;

  @override
  void initState() {
    super.initState();
    initDeviceGroup();
  }

  @override
  void dispose() {
    super.dispose();
    descriptionController.dispose();
    addressController.dispose();
    partNumController.dispose();
    formKey.currentState?.dispose();
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
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        widget.point == null ? '新增' : '编辑',
                        style: FluentTheme.of(context).typography.title,
                      ),
                      InfoLabel(
                        label: '点位地址',
                        child: TextFormBox(
                            controller: addressController,
                            validator: (value) => value == null || value.isEmpty
                                ? '点位地址不能为空'
                                : null,
                            placeholder: '请输入点位地址'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '点位描述',
                        child: TextFormBox(
                            controller: descriptionController,
                            validator: (value) => value == null || value.isEmpty
                                ? '点位描述不能为空'
                                : null,
                            placeholder: '请输入描述信息'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '数据类型',
                        child: ComboboxFormField<DataType>(
                          // controller: descriptionController,
                          value: dataType,
                          validator: (value) =>
                              value == null ? '点位描述不能为空' : null,
                          items: DataType.values.map((e) {
                            return ComboBoxItem<DataType>(
                              value: e,
                              child: SizedBox(
                                width: 515,
                                child: Text(Point.dataTypeToString(e)),
                              ),
                            );
                          }).toList(),
                          onChanged: (DataType? value) {
                            if (value != null) {
                              dataType = value;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '精度',
                        child: NumberBox(
                          value: precision,
                          mode: SpinButtonPlacementMode.inline,
                          onChanged: (value) => precision = value ?? 1,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '乘系数',
                        child: NumberFormBox(
                          value: multiplier,
                          mode: SpinButtonPlacementMode.none,
                          smallChange: 0.01,
                          onChanged: (value) {
                            if (value != null) {
                              multiplier = value;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '部件号',
                        child: TextFormBox(
                            controller: partNumController,
                            placeholder: '请输入部件号'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InfoLabel(
                        label: '读写类型',
                        child: ComboboxFormField<AccessMode>(
                          value: accessMode,
                          items: AccessMode.values.map((e) {
                            return ComboBoxItem<AccessMode>(
                              value: e,
                              child: SizedBox(
                                width: 515,
                                child: Text(e.toChineseString()),
                              ),
                            );
                          }).toList(),
                          onChanged: (AccessMode? value) {
                            if (value != null) {
                              accessMode = value;
                            }
                          },
                        ),
                      ),
                    ],
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

  Future<void> _saveChanged() async {
    if (formKey.currentState!.validate()) {
      Point point = collectPoint();
      bool result = await (id == null
          ? pointService.savePoint(point, context)
          : pointService.updatePoint(point, context));
      if (result) {
          Navigator.pop(context);
      }
    }
  }

  Point collectPoint() {
    return Point(
        groupId: widget.groupId,
        deviceId: deviceId,
        address: addressController.text,
        dataType: dataType,
        accessMode: accessMode,
        multiplier: multiplier,
        precision: precision,
        description: descriptionController.text,
        id: id,
        partNumber: partNumController.text);
  }

  void initDeviceGroup() {
    Point? point = widget.point;
    if (point != null) {
      setState(() {
        id = point.id;
        deviceId = point.deviceId;
        descriptionController.text = point.description;
        addressController.text = point.address;
        partNumController.text = point.partNumber ?? '';
        dataType = point.dataType;
        precision = point.precision;
        multiplier = point.multiplier;
        accessMode = point.accessMode;
      });
    }
  }
}
