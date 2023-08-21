import 'package:dio/dio.dart';
import 'package:lotus_bridge_window/models/result.dart';

import '../models/storage.dart';
import '../router/router.dart';
class HttpUtil {
  static String domain = "http://192.168.0.189:8000";
  static Dio dio = Dio();

  HttpUtil() {
    dio.options.baseUrl = domain;
    dio.options.connectTimeout = const Duration(seconds: 5); //5s
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(const LoginInterceptor(skipUrl: [
      '/login'
    ]));
  }

  Future<Result<T>> post<T>(
    String url,
    Object? data,
  ) async {
    Response response = await dio.post(url, data: data);
    Result<T> result = await parseResponse<T>(response);
    return result;
  }

  Future<Result<T>> parseResponse<T>(Response response) async {
    try {
      Map<String, dynamic> data = response.data;
      return Result.fromJson(data);
    } catch (e) {
      return Result.fail(msg: '解析数据失败');
    }
  }
}
class LoginInterceptor extends Interceptor{

  final List<String> skipUrl;
  const LoginInterceptor({ required this.skipUrl});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    TokenStorage tokenStorage = TokenStorage.getInstance();
    if(skipUrl.contains(options.path)||tokenStorage.isLogin) {
      handler.next(options);
      return;
    }
    router.pushNamed('login');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Response? response =err.response;
    if(response!=null){
      handler.resolve(response);
      return ;
    }
    super.onError(err, handler);
  }
}
