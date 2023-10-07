import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/point.dart';

import '../models/pagination_response.dart';
import '../models/result.dart';
import '../utils/toast_utils.dart';
import 'http_utils.dart';

class PointService{
  HttpUtil httpUtil = HttpUtil();

  Future<PaginationResponse<Point>> pointPage(int groupId,{int page=1,int limit=10}) async {
    Result result = await httpUtil.post('/point/page',
        {
          'groupId':groupId,
          'page':{
            'page':page,
            'limit':limit
          }
        });
    if (result.success) {
      PaginationResponse<Point> response=  PaginationResponse.fromJson(result.data, (pointJson) => Point.fromJson(pointJson));
      return response;
    }
    return PaginationResponse.empty();
  }

  Future<bool> savePoint(Point point,BuildContext context) async {
    Result result = await httpUtil.post('/point',point.toJson());
    if (result.success) {
      return true;
    }
   await ToastUtils.error(context, title: '添加点位失败',message: result.msg);
    return false;
  }
  Future<bool> updatePoint(Point point,BuildContext context) async {
    Result result = await httpUtil.put('/point/${point.id}',point.toJson());
    if (result.success) {
      return true;
    }
    await ToastUtils.error(context, title: '修改点位失败',message: result.msg);
    return false;
  }

  Future<bool> deletePoint(int id,BuildContext context) async {
    Result result = await httpUtil.delete('/point/$id');
    if (result.success) {
      return true;
    }
    await ToastUtils.error(context, title: '删除点位失败',message: result.msg);
    return false;
  }

  Future<dynamic>   readPointValue(int id, BuildContext context) async{
    Result result = await httpUtil.get('/point/value/$id');
    if (result.success) {
      return result.data;
    }
    await ToastUtils.error(context, title: '读取点位失败',message: result.msg);
    return null;
  }
}