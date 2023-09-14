import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/device_group.dart';
import 'package:lotus_bridge_window/service/device_grop_service.dart';

import '../models/colors.dart';
import '../widgets/drawerNavigation.dart';
import '../widgets/number_pagination.dart';
import '../widgets/thematic_gradient.dart';
import 'package:flutter/material.dart'
    show ElevatedButton, DataTable, DataColumn, DataRow, DataCell,TextButton;

class DeviceGroupPage extends StatefulWidget {
  final int deviceId;

  const DeviceGroupPage({super.key, required this.deviceId});

  @override
  State<DeviceGroupPage> createState() => _DeviceGroupPageState();
}

class _DeviceGroupPageState extends State<DeviceGroupPage> {
  DeviceGroupService deviceGroupService = DeviceGroupService();
  int _currentIndex = 1;
  List<DeviceGroup> deviceGroupList = [];

  @override
  void initState() {
    super.initState();
    queryDeviceGroup();
  }

  Future<void> queryDeviceGroup() async {
    List<DeviceGroup> res =
        await deviceGroupService.deviceGroupList(widget.deviceId);
    if (res.isNotEmpty) {
      setState(() {
        deviceGroupList = res;
      });
    }
  }

  List<DataRow> _mapData() {
    List<DataRow> res = [];

    for (int index = 0; index < deviceGroupList.length; index++) {
      DeviceGroup group = deviceGroupList[index];
      res.add(DataRow(cells: [
        DataCell(
          Center(child: Text('${index + 1}')),
        ),
        DataCell(Center(child: Text(group.name))),
        DataCell(Center(child: Text(group.interval.toString()))),
        DataCell(Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: const Text('编辑'),
                onPressed: _editDeviceGroup,
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text('删除',style: TextStyle(
                  color: Color.fromRGBO(202, 42, 14, 1.0)
                ),),
                onPressed: () => debugPrint('pressed button'),
              ),
            ],
          ),
        )),
      ]));
    }
    return res;
  }


  void _editDeviceGroup() {

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
                          callback: () => Navigator.of(context).pop()),
                      const DrawerNavItem(title: '分组管理'),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(children: [
                    ElevatedButton.icon(
                      icon: const Icon(FluentIcons.add),
                      label: const Text('新增'),
                      onPressed: () => debugPrint('pressed button'),
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
                          width: 280,
                          alignment: Alignment.center,
                          child: const Text('序号'),
                        ),
                      ),
                      DataColumn(
                        label: Container(
                            alignment: Alignment.center,
                            width: 280,
                            child: const Text('名称')),
                      ),
                      DataColumn(
                        label: Container(
                            width: 280,
                            alignment: Alignment.center,
                            child: const Text('采集间隔/s')),
                      ),
                      DataColumn(
                        label: Container(
                            alignment: Alignment.center,
                            width: 280,
                            child: const  Text('操作')),
                      )
                    ],
                    rows: _mapData(),
                  ),
                ],
              ),
            ),
          ),
          NumberPagination(
            onPageChanged: (int pageNumber) {
              setState(() {
                _currentIndex = pageNumber;
              });
            },
            colorPrimary: Colors.black,
            colorSub: BridgeColors.primary,
            pageTotal: 1,
            pageInit: _currentIndex,
          ),
        ],
      ),
    );
  }

}
