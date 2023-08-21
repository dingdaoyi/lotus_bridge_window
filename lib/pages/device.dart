import 'package:fluent_ui/fluent_ui.dart';
class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('设备管理'),
    );
  }
}
