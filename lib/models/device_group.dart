class DeviceGroup {
  int? id;
  String name;
  int interval;
  int deviceId;

  DeviceGroup({
     this.id,
    required this.name,
    required this.interval,
    required this.deviceId,
  });
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['interval'] = interval;
    data['device_id'] = deviceId;
    return data;
  }
  factory DeviceGroup.fromJson(Map<String, dynamic> json) {
    return DeviceGroup(
      id: json['id'],
      name: json['name'],
      interval: json['interval'],
      deviceId: json['device_id'],
    );
  }
}