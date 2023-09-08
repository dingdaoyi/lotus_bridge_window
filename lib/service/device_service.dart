
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
}