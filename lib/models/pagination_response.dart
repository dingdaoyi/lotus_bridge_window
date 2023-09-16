class PaginationResponse<T> {
  int total;
  List<T> data;

  PaginationResponse({
    required this.total,
    required this.data,
  });

  PaginationResponse.empty():data=const [],total=0;
  
  factory PaginationResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return PaginationResponse<T>(
      total: json['total'] as int,
      data: (json['data'] as List<dynamic>).map((e) => fromJsonT(e)).toList(),
    );
  }
  

  Map<String, dynamic> toJson(dynamic Function(T) toJsonT) {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['data'] = this.data.map((e) => toJsonT(e)).toList();
    return data;
  }
}