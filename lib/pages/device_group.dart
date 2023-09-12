import 'package:fluent_ui/fluent_ui.dart';

import '../widgets/drawerNavigation.dart';
import '../widgets/thematic_gradient.dart';
import 'navigationPage.dart';

class DeviceGroup extends StatefulWidget {
  final int deviceId;

  const DeviceGroup({super.key,required this.deviceId});

  @override
  State<DeviceGroup> createState() => _DeviceGroupState();
}

class _DeviceGroupState extends State<DeviceGroup> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const ThematicGradientDecoration(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(
        children: [
          SizedBox(height: 40,
            child: DrawerNavigation(
                items: [
                  DrawerNavItem(title: '向南链接',callback: ()=>Navigator.of(context).pop()),
                 const  DrawerNavItem(title: '分组管理'),
                ]
            ),
          ),

        ],
      ),
    );
  }
}
