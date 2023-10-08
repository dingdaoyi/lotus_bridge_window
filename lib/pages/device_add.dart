import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lotus_bridge_window/service/device_service.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import '../models/colors.dart';
import '../models/device_models.dart';
import '../models/plugin_config.dart';
import '../router/router.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/dynamicForm.dart';
import '../widgets/thematic_gradient.dart';

class DeviceAdd extends StatefulWidget {
  final int? deviceId;

  const DeviceAdd({super.key,this.deviceId});

  @override
  State<DeviceAdd> createState() => _DeviceAddState();
}

class _DeviceAddState extends State<DeviceAdd> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PluginService pluginService=PluginService();
  DeviceService deviceService=DeviceService();
  TextEditingController deviceNameController=TextEditingController();
  List<PluginConfig>? _pluginConfigList;
  DeviceDTO? dataDevice;
  final TextEditingController _protocolNameController = TextEditingController();
  PluginConfig? _pluginConfig;
  Map<String,String> formDataMap={};

  String get description{
    return _pluginConfig?.description??'';
  }

  bool get isEdite=>widget.deviceId!=null;

  @override
  void initState() {
    super.initState();
    if(isEdite) {
      initPluginData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _protocolNameController.dispose();
    deviceNameController.dispose();
  }


  Future<void> initDeviceData() async {
    if(widget.deviceId!=null) {
      DeviceDTO? deviceDTO= await deviceService.deviceDetails(widget.deviceId!);
      if(deviceDTO!=null) {
        setState(() {
          dataDevice=deviceDTO;
          _protocolNameController.text=dataDevice?.protocolName??'';
          deviceNameController.text=dataDevice?.name??'';
          if(_pluginConfigList!=null) {
            for( PluginConfig config in _pluginConfigList!){
              if(config.name==deviceNameController.text) {
                _pluginConfig=config;
              }
            }
          }
        });
      }
    }
  }


  Future<void> _submitData() async{
    if(formKey.currentState!.validate()) {
      formKey.currentState!.save();
      DeviceDTO device=DeviceDTO(
          id: widget.deviceId??-1,
          name: deviceNameController.text,
          deviceType: 'Gateway',
          protocolName:_pluginConfig?.name??'',
          customData:formDataMap
      );
     bool res=  isEdite?  await deviceService.update(device, context):
     await deviceService.save(device, context);
     if(res) {
      router.replaceNamed('device');

     }
    }

  }

  List<Widget> _customConfig(){
    List<Map<String,dynamic>>? formCustomization=_pluginConfig?.formCustomization;
    if(formCustomization==null) {
      return [];
    }
    List<Widget>resForm=[];
    for (Map<String,dynamic> colum in formCustomization) {
      String? value=dataDevice?.customData?[colum['name']??'name'];
      resForm.add(const SizedBox(height: 20,));
      resForm.add( DynamicForm(
        value: value,
        formData: colum,
        onSubmit: (Map<String, String> data ) {
          formDataMap.addAll(data);
      },
      ));
    }
    return resForm;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ThematicGradientDecoration(),
      child: Column(
        children: [
          CommandBar(
            primaryItems: [
              CommandBarButton(
                icon: const Icon(FluentIcons.back),
                label: const Text('返回'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Row(
                children: [
                  Expanded(
                      child:
                      Container(
                        padding: const EdgeInsets.fromLTRB(40, 20, 30, 20),
                        child:  Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const ListTile(
                                leading: Icon(FluentIcons.circle_fill,color: BridgeColors.primary,),
                                title: Text('基础信息'),
                              ),
                              const SizedBox(height: 20,),
                              InfoLabel(
                                label: '设备名称',
                                child:  TextFormBox(
                                  controller: deviceNameController,
                                  placeholder: '请输入名称',
                                  validator: (value){
                                  return  value==null||value.isEmpty?'设备名称不能为空':null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20,),
                              InfoLabel(
                                label: '设备协议',
                                child: ComboBoxPluginConfig(
                                  initPluginConfigList: _pluginConfigList,
                                  controller: _protocolNameController,
                                  onChanged: (value){
                                    setState(() {
                                      _pluginConfig=value;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(height: 40,),
                              const ListTile(
                                leading: Icon(FluentIcons.circle_fill,color: BridgeColors.primary,),
                                title: Text('协议配置'),
                              ),
                              ..._customConfig(),
                            ],
                          ),
                        ),
                      )
                  ),
                  Expanded(
                      child:
                      Markdown(
                        data: description,
                      )
                  ),
                ],
              ),
            ),
          ),

          FilledButton(
            child: const Text('保存'),
            onPressed: _submitData,
          ),
          const SizedBox(height: 50,),
        ],
      ),
    );
  }

  Future<void> initPluginData() async {
    var list=  await pluginService.pluginList(pluginType: 'Protocol');
    if(list.isNotEmpty) {
      setState(() {
        _pluginConfigList=list;
      });
    }
    initDeviceData();
  }


}
