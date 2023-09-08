

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import '../models/colors.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/thematic_gradient.dart';

class DeviceAdd extends StatefulWidget {
  const DeviceAdd({super.key});

  @override
  State<DeviceAdd> createState() => _DeviceAddState();
}

class _DeviceAddState extends State<DeviceAdd> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PluginService pluginService=PluginService();
  int? _pluginConfigId;
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ThematicGradientDecoration(),
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
                          child: const TextBox(
                            placeholder: '请输入名称',
                          ),
                        ),
                        const SizedBox(height: 20,),
                        InfoLabel(
                          label: '设备协议',
                          child: ComboBoxPluginConfig(
                            onChanged: (value)=> _pluginConfigId=value,
                          ),
                        ),
                        const SizedBox(height: 40,),
                        const ListTile(
                          leading: Icon(FluentIcons.circle_fill,color: BridgeColors.primary,),
                          title: Text('协议配置'),
                        ),
                      ],
                    ),
                  ),
                )
            ),
            Expanded(
                child:
                Container(
                  color: Colors.blue,
                )
            ),
          ],
        ),
      ),
    );
  }

}
