
class ExportConfig {
  int id;
  String name;
  Map<String, String> configuration;
  String description;
  int pluginId;

  ExportConfig({
    required this.id,
    required this.name,
    required this.configuration,
    required this.description,
    required this.pluginId,
  });

  factory ExportConfig.fromJson(Map<String, dynamic> json) {
    return ExportConfig(
      id: json['id'],
      name: json['name'] ,
      configuration: Map<String, String>.from(json['configuration']),
      description: json['description'],
      pluginId: json['pluginId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'configuration': configuration,
      'description': description,
      'pluginId': pluginId,
    };
  }
}