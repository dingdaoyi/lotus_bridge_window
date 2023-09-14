import 'package:flutter/material.dart';
import 'package:lotus_bridge_window/router/router.dart';

import '../models/global.dart';
import '../widgets/thematic_gradient.dart';

class GlobalSettings extends StatefulWidget {
  const GlobalSettings({super.key});

  @override
  State<GlobalSettings> createState() => _GlobalSettingsState();
}

class _GlobalSettingsState extends State<GlobalSettings> {
  TextEditingController appUrlController=TextEditingController();

  @override
  void initState() {
    super.initState();
    appUrlController.text=Global.domain;

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(40),
        decoration: const ThematicGradientDecoration(),
        child: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                    child: Text('服务器地址')),
                const SizedBox(height: 20,),
                TextFormField(
                  controller: appUrlController,
                ),
                const SizedBox(height: 30,),
                ElevatedButton(onPressed: () async {
                await   Global.updateUrl(appUrlController.text);
                  router.pop();
                }, child:const Text('保存')
    )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
