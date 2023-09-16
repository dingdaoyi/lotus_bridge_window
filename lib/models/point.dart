class Point {
  int? id;
  int? deviceId;
  int groupId;
  String address;
  DataType dataType;
  AccessMode accessMode;
  double multiplier;
  int precision;
  String description;
  String? partNumber;

  Point({
     this.id,
     this.deviceId,
    required this.groupId,
    required this.address,
    required this.dataType,
    required this.accessMode,
    required this.multiplier,
    required this.precision,
    required this.description,
    this.partNumber,
  });

  factory Point.fromJson(Map<String, dynamic> json) {
    return Point(
      id: json['id'],
      deviceId: json['deviceId'],
      groupId: json['groupId'] as int,
      address: json['address'] as String,
      dataType: dataTypeFromString(json['dataType'] as String),
      accessMode: _accessModeFromString(json['accessMode'] as String),
      multiplier: json['multiplier'] as double,
      precision: json['precision'] as int,
      description: json['description'] as String,
      partNumber: json['partNumber'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['deviceId'] = deviceId;
    data['groupId'] = groupId;
    data['address'] = address;
    data['dataType'] = dataTypeToString(dataType);
    data['accessMode'] = _accessModeToString(accessMode);
    data['multiplier'] = multiplier;
    data['precision'] = precision;
    data['description'] = description;
    data['partNumber'] = partNumber;
    return data;
  }

  static DataType dataTypeFromString(String value) {
    switch (value) {
      case 'Integer':
        return DataType.Integer;
      case 'Float':
        return DataType.Float;
      case 'String':
        return DataType.String;
      case 'Boolean':
        return DataType.Boolean;
      default:
        throw Exception('Invalid DataType value: $value');
    }
  }

  static String dataTypeToString(DataType value) {
    switch (value) {
      case DataType.Integer:
        return 'Integer';
      case DataType.Float:
        return 'Float';
      case DataType.String:
        return 'String';
      case DataType.Boolean:
        return 'Boolean';
      default:
        throw Exception('Invalid DataType value: $value');
    }
  }

  static AccessMode _accessModeFromString(String value) {
    switch (value) {
      case 'ReadWrite':
        return AccessMode.ReadWrite;
      case 'ReadOnly':
        return AccessMode.ReadOnly;
      case 'WriteOnly':
        return AccessMode.WriteOnly;
      default:
        throw Exception('Invalid AccessMode value: $value');
    }
  }

  static String _accessModeToString(AccessMode value) {
    switch (value) {
      case AccessMode.ReadWrite:
        return 'ReadWrite';
      case AccessMode.ReadOnly:
        return 'ReadOnly';
      case AccessMode.WriteOnly:
        return 'WriteOnly';
      default:
        throw Exception('Invalid AccessMode value: $value');
    }
  }
}

enum DataType {
  Integer,
  Float,
  String,
  Boolean,
}
enum AccessMode {
  ReadWrite,
  ReadOnly,
  WriteOnly,
}

extension AccessModeExtension on AccessMode {
  String toChineseString() {
    switch (this) {
      case AccessMode.ReadWrite:
        return '读写';
      case AccessMode.ReadOnly:
        return '只读';
      case AccessMode.WriteOnly:
        return '只写';
      default:
        return '';
    }
  }
}