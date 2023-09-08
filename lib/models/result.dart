class Result {
  int code;
  bool success;
  String? msg;
  dynamic data;

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
    data['code'] = code;
    data['success'] = success;
    data['msg'] = msg;
    data['data'] = this.data;
    return data;
  }

  static Result fail({ String? msg}) {
    return Result(
      code: 400,
      success: false,
      msg: msg,
    );
  }
}