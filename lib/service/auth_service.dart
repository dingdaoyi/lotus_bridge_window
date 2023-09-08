import 'package:fluent_ui/fluent_ui.dart';
import 'package:motion_toast/motion_toast.dart';

import '../models/result.dart';
import '../models/storage.dart';
import 'http_utils.dart';

class AuthService {
  HttpUtil httpUtil = HttpUtil();

  Future<bool> login(String username, String password,BuildContext context) async {
    Result result = await httpUtil.post('/login', {
      'username':username,
      'password':password
    });
    if(result.success) {
      var instance = TokenStorage.getInstance();
      instance.username=username;
      instance.token=result.data;
      return true;
    }
    MotionToast.error(title: const Text('登录失败'), description: Text(result.msg??'网络异常!'))
        .show(context);
    return false;
  }
}
