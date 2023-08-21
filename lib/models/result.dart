class Result<T> {
  int code;
  bool success;
  String? msg;
  T? data;

  Result({required this.code, required this.success,  this.msg, this.data});

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      code: json['code'],
      success: json['success'],
      msg: json['msg'],
      data: json['data'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = this.code;
    data['success'] = this.success;
    data['msg'] = this.msg;
    data['data'] = this.data;
    return data;
  }

  static Result<T> fail<T>({required String msg}) {
    return Result(
      code: 400,
      success: false,
      msg: msg,
    );
  }
}