import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show ElevatedButton;
import 'package:lotus_bridge_window/models/plugin_config.dart';
import 'package:lotus_bridge_window/service/device_service.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import 'package:lotus_bridge_window/widgets/thematic_gradient.dart';
import '../models/colors.dart';
import '../models/device_models.dart';
import '../router/router.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/number_pagination.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  DeviceService deviceService = DeviceService();
  PluginService pluginService = PluginService();

  int _currentIndex = 1;
  String? _protocolName;

  List<DeviceDTOStatistics> _deviceList = [];

  @override
  void initState() {
    super.initState();
    initDeviceList();
  }


  Future<void> initDeviceList() async {
    List<DeviceDTOStatistics> resList = await deviceService.deviceList();
    if (resList.isNotEmpty) {
      setState(() {
        _deviceList = resList;
      });
    }
  }


  Widget _deviceItem(BuildContext context, int index) {
    Typography typography = FluentTheme
        .of(context)
        .typography;
    DeviceDTOStatistics dtoStatistics = _deviceList[index];
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
                                '链接中',
                                style:
                                TextStyle(color: Color.fromRGBO(
                                    14, 196, 202, 1)),
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
                                dtoStatistics.name,
                              ),
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
                                        text: ' ${dtoStatistics.protocolName}',
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                238, 248, 250, 1),
                                            fontSize: 12))
                                  ])),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${dtoStatistics.pointCount}',
                                          style: typography.titleLarge,
                                        ),
                                        const Text('点位数'),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text(
                                          '${dtoStatistics.groupCount}',
                                          style: typography.titleLarge,
                                        ),
                                        const Text('设备数'),
                                      ],
                                    ),
                                  )
                                ],
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
                      child: const Text('断开'),
                      onPressed: () => debugPrint('pressed button'),
                    ),
                    FilledButton(
                      child: const Text('编辑'),
                      onPressed: () {
                        router.goNamed('deviceEdit',pathParameters: {
                          'id': dtoStatistics.id.toString()
                        });
                      },
                    ),
                    FilledButton(
                      child: const Text('数据统计'),
                      onPressed: () => debugPrint('pressed button'),
                    ),
                    FilledButton(
                      child: const Text('分组管理'),
                      onPressed: () =>router.pushNamed('deviceGroup',
                      pathParameters: {
                        'deviceId':dtoStatistics.id.toString()
                      }),
                    ),
                    FilledButton(
                      child: const Text('删除'),
                      onPressed: ()=>_deleteDevice(dtoStatistics.id),
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
      child: _deviceList.isEmpty
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
                    value: _protocolName,
                    onChanged: (value){
                      setState(() {
                        _protocolName=value?.name;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 40),
                const SizedBox(
                  width: 220,
                  child: TextBox(
                    placeholder: '设备名称',
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
                  onPressed: () =>   router.goNamed('deviceAdd'),
                ),
                const SizedBox(width: 40),
                ElevatedButton.icon(
                  icon: const Icon(FluentIcons.add),
                  label: const Text('重置'),
                  onPressed: () {
                    setState(() {
                      _protocolName=null;
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
                itemCount: _deviceList.length,
                itemBuilder: _deviceItem),
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
            onPressed: () =>  Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDevice(int id) async {
    if(!(await showContentDialog()??false)){
      return;
    }
   bool res= await deviceService.delete(id,context);
   if(res) {
     displayInfoBar(context, builder: (context, close) {
       return InfoBar(
         title: const Text('删除成功'),
         severity: InfoBarSeverity.info,
       );
     });
     initDeviceList();
   }
  }
}
