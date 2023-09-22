import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lotus_bridge_window/models/export_config.dart';
import 'package:lotus_bridge_window/service/device_service.dart';
import 'package:lotus_bridge_window/service/export_service.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import '../models/colors.dart';
import '../models/device_models.dart';
import '../models/plugin_config.dart';
import '../router/router.dart';
import '../widgets/comboBoxPluginConfig.dart';
import '../widgets/dynamicForm.dart';
import '../widgets/thematic_gradient.dart';

class ExportConfigEdit extends StatefulWidget {
  final int? exportConfigId;

  const ExportConfigEdit({super.key, this.exportConfigId});

  @override
  State<ExportConfigEdit> createState() => _ExportConfigEditState();
}

class _ExportConfigEditState extends State<ExportConfigEdit> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  PluginService pluginService = PluginService();
  ExportService exportService = ExportService();
  TextEditingController exportNameController = TextEditingController();
  List<PluginConfig>? _pluginConfigList;
  ExportConfig? exportConfig;

  TextEditingController pluginConfigController = TextEditingController();
  PluginConfig? _pluginConfig;
  Map<String, String> formDataMap = {};

  String get description {
    return _pluginConfig?.description ?? '';
  }

  bool get isEdite => widget.exportConfigId != null;

  @override
  void initState() {
    super.initState();
    initPluginData();
  }


  @override
  void dispose() {
    super.dispose();
    exportNameController.dispose();
    pluginConfigController.dispose();
  }

  Future<void> initExportConfigData() async {
    if (widget.exportConfigId != null) {
      ExportConfig? config =
          await exportService.details(widget.exportConfigId!);
      if (config != null) {
        setState(() {
          exportConfig = config;
          exportNameController.text = exportConfig?.name ?? '';
          if (_pluginConfigList != null) {
            for (PluginConfig config in _pluginConfigList!) {
              if (config.name == pluginConfigController.text) {
                _pluginConfig = config;
              }
            }
          }
        });
      }
    }
  }

  Future<void> _submitData() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      ExportConfig exportConfig = ExportConfig(
        id: widget.exportConfigId ?? -1,
        name: exportNameController.text,
        configuration: formDataMap,
        description: description,
        pluginId: _pluginConfig!.id,
      );
      bool res = isEdite
          ? await exportService.update(exportConfig, context)
          : await exportService.save(exportConfig, context);
      if (res) {
        router.replaceNamed('dataExport');
      }
    }
  }

  List<Widget> _customConfig() {
    List<Map<String, dynamic>>? formCustomization =
        _pluginConfig?.formCustomization;
    if (formCustomization == null) {
      return [];
    }
    List<Widget> resForm = [];
    for (Map<String, dynamic> colum in formCustomization) {
      String? value = exportConfig?.configuration[colum['name'] ?? 'name'];
      resForm.add(const SizedBox(
        height: 20,
      ));
      resForm.add(DynamicForm(
        value: value,
        formData: colum,
        onSubmit: (Map<String, String> data) {
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
            child: Row(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                  padding: const EdgeInsets.fromLTRB(40, 20, 30, 20),
                  child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ListTile(
                            leading: Icon(
                              FluentIcons.circle_fill,
                              color: BridgeColors.primary,
                            ),
                            title: Text('基础信息'),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InfoLabel(
                            label: '服务名称',
                            child: TextFormBox(
                              controller: exportNameController,
                              placeholder: '请输入名称',
                              validator: (value) {
                                return value == null || value.isEmpty
                                    ? '服务名称不能为空'
                                    : null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InfoLabel(
                            label: '插件名称',
                            child: ComboBoxPluginConfig(
                              pluginType: 'DataOutput',
                              controller: pluginConfigController,
                              initPluginConfigList: _pluginConfigList,
                              onChanged: (value){
                                setState(() {
                                  _pluginConfig=value;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          const ListTile(
                            leading: Icon(
                              FluentIcons.circle_fill,
                              color: BridgeColors.primary,
                            ),
                            title: Text('插件配置'),
                          ),
                          ..._customConfig(),
                        ],
                      ),
                  ),
                ),
                    )),
                Expanded(
                    child: Markdown(
                  data: description,
                )),
              ],
            ),
          ),
          FilledButton(
            onPressed: _submitData,
            child: const Text('保存'),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Future<void> initPluginData() async {
    var list = await pluginService.pluginList(pluginType: 'DataOutput');
    if (list.isNotEmpty) {
      setState(() {
        _pluginConfigList = list;
      });
    }
    initExportConfigData();
  }
}
