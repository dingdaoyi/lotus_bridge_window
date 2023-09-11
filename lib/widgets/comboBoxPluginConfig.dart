import 'package:fluent_ui/fluent_ui.dart';
import '../models/plugin_config.dart';
import '../service/plugin_service.dart';

class ComboBoxPluginConfig extends StatefulWidget {
  final String? value;
  final String?pluginType;
  final void Function(PluginConfig?)? onChanged;
  final  List<PluginConfig>? initPluginConfigList;
  const ComboBoxPluginConfig({
    Key? key,
    this.value,
     this.pluginType='Protocol',
    this.onChanged,
    this.initPluginConfigList
  }) : super(key: key);

  @override
  _ComboBoxPluginConfigState createState() => _ComboBoxPluginConfigState();
}

class _ComboBoxPluginConfigState extends State<ComboBoxPluginConfig> {
  PluginService pluginService=PluginService();
   List<PluginConfig> _pluginConfigList=[];
   String? value;
  @override
  void initState() {
    super.initState();
    initData();
    setState(() {
      value=widget.value;
    });
  }

  Future<void> initData() async {
    if(widget.initPluginConfigList!=null) {
      setState(() {
        _pluginConfigList=widget.initPluginConfigList!;
      });
      return;
    }
    var list=  await pluginService.pluginList(pluginType:widget.pluginType);
    if(list.isNotEmpty) {
      setState(() {
        _pluginConfigList=list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ComboBox<String>(
      isExpanded: true,
      value: value,
      items: _pluginConfigList.map<ComboBoxItem<String>>((pluginConfig) {
        return ComboBoxItem<String>(
          value: pluginConfig.name,
          child: Text(pluginConfig.name),
        );
      }).toList(),
      onChanged: (value) {
        if (widget.onChanged!=null) {
          PluginConfig? data= _pluginConfigList.where((element) => element.name==value
          ).firstOrNull;
          widget.onChanged!(value==null?null:data);
        }
      },
      placeholder: const Text('插件选择'),
    );
  }
}