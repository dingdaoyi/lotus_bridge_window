import 'package:fluent_ui/fluent_ui.dart';

class ToastUtils {
  static Future<void> info(BuildContext context,
      {required String title, String? message}) async {
    await display(context,
        title: title, message: message, severity: InfoBarSeverity.info);
  }

  static Future<void> warning(BuildContext context,
      {required String title, String? message}) async {
    await display(context,
        title: title, message: message, severity: InfoBarSeverity.warning);
  }

  static Future<void> error(BuildContext context,
      {required String title, String? message}) async {
    await display(context,
        title: title, message: message, severity: InfoBarSeverity.error);
  }

  static Future<void> display(BuildContext context,
      {required String title,
      String? message,
      InfoBarSeverity severity = InfoBarSeverity.info}) async {
    await displayInfoBar(context, builder: (context, close) {
      return InfoBar(
        title: Text(title),
        content: message!=null?Text(message):null,
        severity: InfoBarSeverity.info,
      );
    });
  }

  static Future<bool> confirm(BuildContext context,
      {String? tile, required String content}) async {
    return (await showDialog<bool>(
      context: context,
      builder: (context) => ContentDialog(
        title: Text(tile ?? '确认操作'),
        content: Text(
          content,
        ),
        actions: [
          Button(
            child: const Text('删除'),
            onPressed: () {
              Navigator.pop(context, true);
              // Delete file here
            },
          ),
          FilledButton(
            child: const Text('取消'),
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ))??false;
  }
}
