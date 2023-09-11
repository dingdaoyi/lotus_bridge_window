
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/result.dart';

import '../models/storage.dart';
import '../router/router.dart';
import '../utils/context.dart';

class HttpUtil {
  static String domain = "http://127.0.0.1:8000";
  static Dio dio = Dio();

  HttpUtil() {
    dio.options.baseUrl = domain;
    dio.options.connectTimeout = const Duration(seconds: 5); //5s
    dio.options.receiveTimeout = const Duration(seconds: 5);
    dio.interceptors.add(LogInterceptor(responseBody: true));
    dio.interceptors.add(const LoginInterceptor(skipUrl: ['/login']));
  }

  Future<Result> post<T>(
    String url,
    Object? data,
  ) async {
    try {
      Response response = await dio.post(url, data: data);
      Result result = await parseResponse<T>(response);
      return result;
    } catch (e) {
      if (e is DioException) {
        debugPrint('接口异常${e.message}');
        return Result.fail(msg: e.message);
      }
      return Result.fail(msg: e.toString());
    }
  }

  Future<Result> put<T>(
      String url,
      Object? data,
      ) async {
    try {
      Response response = await dio.put(url, data: data);
      Result result = await parseResponse<T>(response);
      return result;
    } catch (e) {
      if (e is DioException) {
        debugPrint('接口异常${e.message}');
        return Result.fail(msg: e.message);
      }
      return Result.fail(msg: e.toString());
    }
  }

  Future<Result> delete<T>(
      String url,
  { Map<String, dynamic>? queryParameters,}
      ) async {
    try {
      Response response = await dio.delete(url, queryParameters: queryParameters);
      Result result = await parseResponse<T>(response);
      return result;
    } catch (e) {
      if (e is DioException) {
        debugPrint('接口异常${e.message}');
        return Result.fail(msg: e.message);
      }
      return Result.fail(msg: e.toString());
    }
  }
  Future<Result> get<T>(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      Response response = await dio.get(url, queryParameters: queryParameters);
      Result result = await parseResponse<T>(response);
      return result;
    } catch (e) {
      if (e is DioException) {
        debugPrint('接口异常${e.message}');
        return Result.fail(msg: e.message);
      }
      return Result.fail(msg: e.toString());
    }
  }

  Future<Result> parseResponse<T>(Response response) async {
    try {
      if(response.statusCode==HttpStatus.badRequest){
      return  Result.fail(msg: response.data);
      }
      if(response.statusCode==HttpStatus.unauthorized){
        router.pushNamed('login');
        Result result= Result.fromJson(response.data);
        displayInfoBar(LotusBridge.context!, builder: (context, close) {
          return InfoBar(
            title: const Text('删除设备错误'),
            content:  Text(result.msg??'修改错误'),
            severity: InfoBarSeverity.error,
          );
        });
        return result;
      }

      Map<String, dynamic> data = response.data;
      return Result.fromJson(data);
    } catch (e) {
      debugPrint('数据错误:$e');
      return Result.fail(msg: '解析数据失败');
    }
  }
}

class LoginInterceptor extends Interceptor {
  final List<String> skipUrl;

  const LoginInterceptor({required this.skipUrl});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    TokenStorage tokenStorage = TokenStorage.getInstance();
    if (skipUrl.contains(options.path) || tokenStorage.isLogin) {
      options.headers
      .addAll({
        'Authorization':'Bearer ${tokenStorage.token}'
      });
      handler.next(options);
      return;
    }
    router.pushNamed('login');
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Response? response = err.response;
    if (response != null) {
      handler.resolve(response);
      return;
    }
    super.onError(err, handler);
  }
}
