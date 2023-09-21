import 'package:fluent_ui/fluent_ui.dart';
import 'package:lotus_bridge_window/models/result.dart';
import 'package:lotus_bridge_window/utils/toast_utils.dart';

import '../models/device_models.dart';
import '../models/export_config.dart';
import '../models/export_group.dart';
import 'http_utils.dart';

class ExportService {
  HttpUtil httpUtil = HttpUtil();

  Future<List<ExportConfig>> exportConfigList() async {
    Result result = await httpUtil.get('/export-config/list');
    List<ExportConfig> list = [];
    if (result.success) {
      List resList = result.data;
      for (var item in resList) {
        ExportConfig exportConfig = ExportConfig.fromJson(item);
        list.add(exportConfig);
      }
    }
    return list;
  }

  Future<List<ExportGroup>> listExportGroup(int exportId) async {
    Result result = await httpUtil.get('/export-group/$exportId');
    List<ExportGroup> list = [];
    if (result.success) {
      List resList = result.data;
      for (var item in resList) {
        ExportGroup exportGroup = ExportGroup.fromJson(item);
        list.add(exportGroup);
      }
    }
    return list;
  }

  Future<bool> associatedDeviceGroup(
      List<int> groupIds, int exportId,BuildContext context) async {
    Result result = await httpUtil.post('/export-group', {"groupIds":groupIds, "exportId":exportId});
    if (result.success) {
      return true;
    }
   await ToastUtils.error(context, title: '关联设备群组失败',message: result.msg);
    return false;
  }

  Future<ExportConfig?> details(int id) async {
    Result result = await httpUtil.get('/export-config/$id');
    if (result.success) {
      return ExportConfig.fromJson(result.data);
    }
    return null;
  }

  Future<bool> save(ExportConfig exportConfig, BuildContext context) async {
    Result result =
        await httpUtil.post('/export-config', exportConfig.toJson());
    if (result.success) {
      return true;
    }
    await ToastUtils.error(context, title: '添加配置失败', message: result.msg);
    return false;
  }

  Future<bool> update(ExportConfig exportConfig, BuildContext context) async {
    Result result = await httpUtil.put(
        '/export-config/${exportConfig.id}', exportConfig.toJson());
    if (result.success) {
      return true;
    }
    await ToastUtils.error(context, title: '修改配置失败', message: result.msg);
    return false;
  }

  Future<bool> delete(int id, BuildContext context) async {
    Result result = await httpUtil.delete('/export-config/$id');
    if (result.success) {
      return true;
    }
    await ToastUtils.error(context, title: '删除配置失败', message: result.msg);

    return false;
  }
}
