
import 'dart:convert';

class PluginConfig {
  final int id;
  final String name;
  final  String? description;
  final  List<Map<String,dynamic>>? formCustomization;
  final String pluginType;

  PluginConfig({
    required this.id,
    required this.name,
    this.description,
    this.formCustomization,
    required this.pluginType,
  });

  factory PluginConfig.fromJson(Map<String, dynamic> data) {
    List<Map<String, dynamic>>? formCustomization;
    if (data['formCustomization'] != null) {
      final String formCustomizationString = data['formCustomization'];
      final List<dynamic> formCustomizationList = json.decode(formCustomizationString);
      formCustomization = formCustomizationList.map((x) => x as Map<String, dynamic>).toList();
    }
    return PluginConfig(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      formCustomization: formCustomization,
      pluginType: data['pluginType'],
    );
  }
}