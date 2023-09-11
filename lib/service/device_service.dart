
import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/result.dart';

import '../models/device_models.dart';
import 'http_utils.dart';

class DeviceService{
  HttpUtil httpUtil = HttpUtil();


  Future<List<DeviceDTOStatistics>> deviceList() async {
    Result result= await httpUtil.get('/device');
    List<DeviceDTOStatistics> list=[];
    if(result.success){
     List resList= result.data;
    for(var item in  resList){
      DeviceDTOStatistics dtoStatistics= DeviceDTOStatistics.fromJson(item);
      list.add(dtoStatistics);
    }
    }
    return list;
  }


  Future<DeviceDTO?> deviceDetails(int id) async {
    Result result = await httpUtil.get('/device/$id');
    if (result.success) {
      return DeviceDTO.fromJson(result.data);
    }
    return null;
  }

  Future<bool> save(DeviceDTO deviceDTO,BuildContext context) async {
    Result result = await httpUtil.post('/device',deviceDTO.toJson());
    if (result.success) {
      return true;
    }
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('添加设备错误'),
        content:  Text(result.msg??'保存错误'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }


  Future<bool> update(DeviceDTO deviceDTO,BuildContext context) async {
    Result result = await httpUtil.put('/device/${deviceDTO.id}',deviceDTO.toJson());
    if (result.success) {
      return true;
    }
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('修改设备错误'),
        content:  Text(result.msg??'修改错误'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }

  Future<bool>  delete(int id,BuildContext context)async {
    Result result = await httpUtil.delete('/device/$id');
    if (result.success) {
      return true;
    }
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('删除设备错误'),
        content:  Text(result.msg??'修改错误'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }
}