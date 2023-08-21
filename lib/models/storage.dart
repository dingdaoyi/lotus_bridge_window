class TokenStorage {
  static TokenStorage? _instance;

  String? token;

  String? username;

  // 是否已登录
  bool get isLogin => token != null;

  TokenStorage._();

  static TokenStorage getInstance() {
    _instance ??= TokenStorage._();
    return _instance!;
  }
}
