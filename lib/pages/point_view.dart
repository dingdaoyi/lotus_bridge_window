import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart'
    show DataCell, DataColumn, DataRow, DataTable, ElevatedButton;
import 'package:lotus_bridge_window/models/device_group.dart';
import 'package:lotus_bridge_window/service/device_grop_service.dart';
import 'package:lotus_bridge_window/widgets/thematic_gradient.dart';
import '../models/point.dart';
import '../service/point_service.dart';

class PointViewPage extends StatefulWidget {
  const PointViewPage({super.key});

  @override
  State<PointViewPage> createState() => _PointViewPageState();
}

class _PointViewPageState extends State<PointViewPage> {
  PointService pointService = PointService();
  DeviceGroupService deviceGroupService = DeviceGroupService();

  List<PointValue> list = [];
  List<DeviceGroup> _deviceGroupList = [];
  int? deviceGroupId;

  @override
  void initState() {
    super.initState();
    initGroupList();
  }

  Future<void> initPointPage() async {
    if (deviceGroupId != null) {
      List<PointValue> response =
          await pointService.readPointValuesByGroupId(deviceGroupId!, context);
      setState(() {
        list = response;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<DataRow> _itemData() {
    return list.map((pointValue) {
      var value= pointValue.value;
      if(pointValue.isNumber()){
        value=pointValue.parseNumber();
      }
      return DataRow(cells: [
        DataCell(Center(child: SelectableText('${pointValue.id}'))),
        DataCell(Center(child: SelectableText(pointValue.point.address))),
        DataCell(Center(child: SelectableText(pointValue.point.description))),
        DataCell(
            Center(child: SelectableText(pointValue.point.partNumber ?? ''))),
        DataCell(Center(child: SelectableText('$value'))),
      ]);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: const ThematicGradientDecoration(),
      child: Column(
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
                  child: ComboBox<int>(
                    isExpanded: true,
                    value: deviceGroupId,
                    items: _initGroupList(),
                    onChanged: (changedValue) {
                      setState(() {
                        deviceGroupId = changedValue;
                      });
                      initPointPage();

                    },
                    placeholder: const Text('群组选择'),
                  ),
                ),
                // const SizedBox(width: 40),
                // ElevatedButton.icon(
                //   icon: const Icon(FluentIcons.search),
                //   label: const Text('搜索'),
                //   onPressed: () => debugPrint('pressed button'),
                // ),
              ],
            ),
          ),
          deviceGroupId == null
              ? const Center(child: Text('请选择设备组'))
              : Expanded(
                  child: DataTable(
                    columnSpacing: 12,
                    horizontalMargin: 12,
                    sortColumnIndex: 0,
                    columns: [
                      DataColumn(
                        label: Container(
                          width: 120,
                          alignment: Alignment.center,
                          child: const Text('id'),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                            alignment: Alignment.center,
                            width: 160,
                            child: const Text('点位地址')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 220,
                            alignment: Alignment.center,
                            child: const Text('点位描述')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 120,
                            alignment: Alignment.center,
                            child: const Text('部件号')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 120,
                            alignment: Alignment.center,
                            child: const Text('点位值')),
                      ),
                    ],
                    rows: _itemData(),
                  ),
                ),
        ],
      ),
    );
  }

  _initGroupList() {
    return _deviceGroupList.map<ComboBoxItem<int>>((deviceGroup) {
      return ComboBoxItem<int>(
        value: deviceGroup.id,
        child: Text(deviceGroup.name),
      );
    }).toList();
  }

  Future<void> initGroupList() async {
    List<DeviceGroup> res = await deviceGroupService.deviceGroupList();
    setState(() {
      _deviceGroupList = res;
    });
  }
}
