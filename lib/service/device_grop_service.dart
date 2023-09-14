import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/result.dart';

import '../models/device_group.dart';
import '../models/device_models.dart';
import 'http_utils.dart';

class DeviceGroupService {
  HttpUtil httpUtil = HttpUtil();

  Future<List<DeviceGroup>> deviceGroupList(int deviceId) async {
    Result result = await httpUtil.get('/device-group/list/$deviceId');
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
}
