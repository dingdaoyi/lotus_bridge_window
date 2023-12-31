import 'package:lotus_bridge_window/models/result.dart';

import '../models/plugin_config.dart';
import 'http_utils.dart';

class PluginService {
  HttpUtil httpUtil = HttpUtil();

  Future<List<PluginConfig>> pluginList(
      {String? name, String? pluginType}) async {
    Map<String, dynamic>? queryParameters = {};
    if (name != null) {
      queryParameters['name'] = name;
    }
    if (pluginType != null) {
      queryParameters['pluginType'] = pluginType;
    }
    Result result =
        await httpUtil.get('/plugin/list', queryParameters: queryParameters);
    List<PluginConfig> list = [];
    if (result.success) {
      List resList = result.data;
      for (var item in resList) {
        PluginConfig dtoStatistics = PluginConfig.fromJson(item);
        list.add(dtoStatistics);
      }
    }
    return list;
  }

  Future<PluginConfig?> pluginDetails(int id) async {
    Result result = await httpUtil.get('/plugin/$id');
    if (result.success) {
      return PluginConfig.fromJson(result.data);
    }
    return null;
  }
}
