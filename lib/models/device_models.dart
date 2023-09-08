import 'dart:convert';

class DeviceDTOStatistics {
  int id;
  String name;
  String deviceType;
  Map<String, String>? customData;
  String protocolName;
  int groupCount;
  int pointCount;

  DeviceDTOStatistics({
    required this.id,
    required this.name,
    required  this.deviceType,
      this.customData,
    required this.protocolName,
    required  this.groupCount,
    required  this.pointCount,
  });
  String toJson(){
    return jsonEncode({
      'id': id,
      'name': name,
      'deviceType': deviceType,
      'customData': customData,
      'protocolName': protocolName,
      'groupCount': groupCount,
      'pointCount': pointCount,
    });
  }

  factory DeviceDTOStatistics.fromJson(Map<String, dynamic> data) {
    return DeviceDTOStatistics(
      id: data['id'],
      name: data['name'],
      deviceType: data['deviceType'],
      customData: Map<String, String>.from(data['customData']),
      protocolName: data['protocolName'],
      groupCount: data['groupCount'],
      pointCount: data['pointCount'],
    );
  }
}
