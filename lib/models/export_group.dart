class ExportGroup {
  int id;
  int groupId;
  int exportId;

  ExportGroup({required this.id, required this.groupId, required this.exportId});

  factory ExportGroup.fromJson(Map<String, dynamic> json) {
    return ExportGroup(
      id: json['id'] as int,
      groupId: json['groupId'] as int,
      exportId: json['exportId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['groupId'] = groupId;
    data['exportId'] = exportId;
    return data;
  }
}