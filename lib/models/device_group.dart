class DeviceGroup {
  int id;
  String name;
  int interval;
  int deviceId;

  DeviceGroup({
    required this.id,
    required this.name,
    required this.interval,
    required this.deviceId,
  });

  factory DeviceGroup.fromJson(Map<String, dynamic> json) {
    return DeviceGroup(
      id: json['id'] as int,
      name: json['name'] as String,
      interval: json['interval'] as int,
      deviceId: json['device_id'] as int,
    );
  }
}