import 'dart:convert';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:lotus_bridge_window/service/plugin_service.dart';
import '../models/plugin_config.dart';
import '../widgets/thematic_gradient.dart';
import 'package:flutter_json_view/flutter_json_view.dart';

class PluginDetails extends StatefulWidget {
  final int pluginId;

  const PluginDetails({super.key, required this.pluginId});

  @override
  State<PluginDetails> createState() => _PluginDetailsState();
}

class _PluginDetailsState extends State<PluginDetails> {
  PluginService pluginService = PluginService();
  PluginConfig? _pluginConfig;

  @override
  void initState() {
    super.initState();
    initPluginData();
  }

  Future<void> initPluginData() async {
    PluginConfig? config = await pluginService.pluginDetails(widget.pluginId);
    if (config != null) {
      setState(() {
        _pluginConfig = config;
      });
    }
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
          SizedBox(
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('名称'),
                Text(
                  _pluginConfig?.name ?? '',)
              ],
            ),
          ),
          const Slider(value: 100, onChanged: null),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: JsonView.string(
                        json.encode(_pluginConfig?.formCustomization ?? []))
                ),
                Expanded(
                    child: Markdown(
                      data: _pluginConfig?.description ?? '',
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
