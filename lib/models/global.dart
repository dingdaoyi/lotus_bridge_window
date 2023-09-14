import '../service/storage.dart';

class Global {
  static String domain = 'http://localhost:8001';

  static updateUrl(String url) async {
    await LocalStorage.setData('serverUrl', url);
    domain = url;
  }

  static init() async {
    domain= await LocalStorage.getData('serverUrl')??'http://localhost:8000';
  }
}
