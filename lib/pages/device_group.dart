import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/device_group.dart';
import 'package:lotus_bridge_window/router/router.dart';
import 'package:lotus_bridge_window/service/device_grop_service.dart';

import '../models/colors.dart';
import '../widgets/drawerNavigation.dart';
import '../widgets/number_pagination.dart';
import '../widgets/thematic_gradient.dart';
import 'package:flutter/material.dart'
    show ElevatedButton, DataTable, DataColumn, DataRow, DataCell, TextButton;

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
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text(
                  '点位信息',
                ),
                onPressed: () => router.pushNamed('point',pathParameters: {
                  'groupId':group.id.toString()

                }),
              ),
              TextButton(
                child: const Text('编辑'),
                onPressed: () => _editDeviceGroup(deviceGroup: group),
              ),
              const SizedBox(
                width: 20,
              ),
              TextButton(
                child: const Text(
                  '删除',
                  style: TextStyle(color: Colors.warningPrimaryColor),
                ),
                onPressed: () => _deleteDeviceGroup(group.id!),
              ),
            ],
          ),
        )),
      ]));
    }
    return res;
  }

  Future<void> _editDeviceGroup({DeviceGroup? deviceGroup}) async {
   await  showDialog(
        context: context,
        builder: (context) {
          return DeviceGroupEdit(
            deviceId: widget.deviceId,
            deviceGroup: deviceGroup,
          );
        });
   queryDeviceGroup();
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
                      onPressed: () => _editDeviceGroup(),
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
                            child: const Text('操作')),
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

 Future<void> _deleteDeviceGroup(int id) async {
   bool? result = await showDialog<bool>(
     context: context,
     builder: (context) =>
         ContentDialog(
           title: const Text('删除设备组'),
           content: const Text(
             '确认删除设备组',
           ),
           actions: [
             Button(
               child: const Text('删除'),
               onPressed: () {
                 Navigator.pop(context,true);
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
   if(result==true) {
     await deviceGroupService.delete(id);
     queryDeviceGroup();
   }
 }
}

class DeviceGroupEdit extends StatefulWidget {
  final DeviceGroup? deviceGroup;
  final int deviceId;

  const DeviceGroupEdit({super.key, required this.deviceId,this.deviceGroup});

  @override
  State<DeviceGroupEdit> createState() => _DeviceGroupEditState();
}

class _DeviceGroupEditState extends State<DeviceGroupEdit> {
  DeviceGroupService deviceGroupService = DeviceGroupService();

  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  int defaultInterval = 1200;
  int? id;

  @override
  void initState() {
    super.initState();
    initDeviceGroup();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 300,
        width: 600,
        padding: const EdgeInsets.all(20),
        decoration: const ThematicGradientDecoration(),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Text(
                widget.deviceGroup == null ? '新增' : '编辑',
                style: FluentTheme.of(context).typography.title,
              ),
              InfoLabel(
                label: '群组名称',
                child: TextFormBox(
                    controller: nameController,
                    validator: (value) =>
                        value == null || value.isEmpty ? '名称不能为空' : null,
                    placeholder: '请输入群组名称'),
              ),
              const SizedBox(
                height: 20,
              ),
              InfoLabel(
                label: '采集间隔/秒',
                child: NumberBox(
                  value: defaultInterval,
                  mode: SpinButtonPlacementMode.inline,
                  onChanged: (value) => defaultInterval = value??1200,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HyperlinkButton(
                      onPressed: _saveChanged, child:  const Text('确认'),),
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
      DeviceGroup data=DeviceGroup(name: nameController.text,
          interval: defaultInterval,
          deviceId: widget.deviceId,
        id: id
      );
     bool result= await (id==null?  deviceGroupService.insert(data,context):deviceGroupService.update(data,context));
      if(result) {
        Navigator.pop(context);
      }
    }
  }

  void initDeviceGroup() {
    DeviceGroup? deviceGroup = widget.deviceGroup;
    if (deviceGroup != null) {
      setState(() {
        id = deviceGroup.id;
        defaultInterval = deviceGroup.interval;
        nameController.text = deviceGroup.name;
      });
    }
  }
}
