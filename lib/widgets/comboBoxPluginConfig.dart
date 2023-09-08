import 'package:fluent_ui/fluent_ui.dart';
import '../models/plugin_config.dart';
import '../service/plugin_service.dart';

class ComboBoxPluginConfig extends StatefulWidget {
  final int? value;
  final String?pluginType;
  final void Function(int?)? onChanged;

  const ComboBoxPluginConfig({
    Key? key,
    this.value,
     this.pluginType='Protocol',
    this.onChanged,
  }) : super(key: key);

  @override
  _ComboBoxPluginConfigState createState() => _ComboBoxPluginConfigState();
}

class _ComboBoxPluginConfigState extends State<ComboBoxPluginConfig> {
  PluginService pluginService=PluginService();
   List<PluginConfig> _pluginConfigList=[];
  @override
  void initState() {
    super.initState();
    initData();
  }
  Future<void> initData() async {
    var list=  await pluginService.pluginList(pluginType:widget.pluginType);
    if(list.isNotEmpty) {
      setState(() {
        _pluginConfigList=list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ComboBox<int>(
      isExpanded: true,
      value: widget.value,
      items: _pluginConfigList.map<ComboBoxItem<int>>((pluginConfig) {
        return ComboBoxItem<int>(
          value: pluginConfig.id,
          child: Text(pluginConfig.name),
        );
      }).toList(),
      onChanged: (value) {
        if (widget.onChanged!=null) {
          widget.onChanged!(value);
        }
      },
      placeholder: const Text('插件选择'),
    );
  }
}