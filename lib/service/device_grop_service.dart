import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/result.dart';

import '../models/device_group.dart';
import '../models/device_models.dart';
import '../utils/context.dart';
import 'http_utils.dart';

class DeviceGroupService {
  HttpUtil httpUtil = HttpUtil();

  Future<List<DeviceGroup>> deviceGroupList({int? deviceId}) async {
    Result result = await httpUtil.get('/device-group/list?device_id=$deviceId',);
    List<DeviceGroup> list = [];
    if (result.success) {
      List resList = result.data;
      for (var item in resList) {
        DeviceGroup deviceGroup = DeviceGroup.fromJson(item);
        list.add(deviceGroup);
      }
    }
    return list;
  }

  Future<bool> insert(DeviceGroup deviceGroup,BuildContext context) async {
    Result result = await httpUtil.post('/device-group',
        deviceGroup.toJson());
    if (result.success) {
      return true;
    }
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('添加失败'),
        content:  Text(result.msg??'添加设备组失败'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }



  Future<bool> update(DeviceGroup deviceGroup,BuildContext context) async {
    Result result = await httpUtil.put('/device-group/${deviceGroup.id}',
        deviceGroup.toJson());
    if (result.success) {
      return true;
    }
    displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: const Text('修改失败'),
        content:  Text(result.msg??'修改设备组失败'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }

  Future<bool> delete(int id) async {
    Result result = await httpUtil.delete('/device-group/$id');
    if (result.success) {
      return true;
    }
    displayInfoBar(LotusBridge.context!, builder: (context, close) {
      return InfoBar(
        title: const Text('删除错误'),
        content:  Text(result.msg??'删除设备组失败'),
        severity: InfoBarSeverity.error,
      );
    });
    return false;
  }
}
