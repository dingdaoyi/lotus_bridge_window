import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WinManagerListener extends StatefulWidget {
  final Widget child;
  const WinManagerListener({super.key, required this.child});

  @override
  State<WinManagerListener> createState() => _WinManagerListenerState();
}

class _WinManagerListenerState extends State<WinManagerListener>
    with WindowListener {
  @override
  void initState() {
    //注册监听
    windowManager.addListener(this);
    _init();
    super.initState();
  }

  @override
  void dispose() {
    //删除监听
    windowManager.removeListener(this);
    super.dispose();
  }

  void _init() async {
    await windowManager.setPreventClose(true);
    setState(() {});
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('要关闭程序吗?'),
            actions: [
              TextButton(
                child: Text('不'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('是'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await windowManager.hide();
                },
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
