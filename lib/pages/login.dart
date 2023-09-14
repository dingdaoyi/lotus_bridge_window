import 'package:flutter/material.dart';
import 'package:lotus_bridge_window/models/global.dart';
import 'package:lotus_bridge_window/router/router.dart';
import 'package:lotus_bridge_window/service/auth_service.dart';

import '../models/ali_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService =AuthService();
  TextEditingController usernameController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }

  _doLogin(context) async {
    if (formKey.currentState!.validate()) {
      bool success=  await authService.login(usernameController.text, passwordController.text,context);
      if(success) {
        router.goNamed('device');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 40,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              child: Center(
                child: Container(
                  alignment: Alignment.center,
                  width: 400,
                  height: 400,
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                AliIcons.lotus,
                                size: 60,
                                color: Color.fromRGBO(126, 145, 250, 1),
                              ),
                              Text(
                                " 莲花桥",
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                             const  Text('服务地址:'),
                              Text(
                                Global.domain,
                              )
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          width: 360,
                          child: TextFormField(
                            controller: usernameController,
                            validator: (username)=>username!.trim().isNotEmpty ?null:'用户名不能为空',
                            decoration: const InputDecoration(
                                hintText: "账号", border: OutlineInputBorder()),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          width: 360,
                          child: TextFormField(
                            controller: passwordController,
                            validator: (value)=>value!.trim().isNotEmpty ?null:'密码不能为空',
                            decoration: const InputDecoration(
                                hintText: "密码", border: OutlineInputBorder()),
                          ),
                        ),
                        SizedBox(
                          width: 320,
                          height: 42,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all(//圆角
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12))
                                )
                            ),
                            child: const Text('登录'),
                            onPressed: ()=>_doLogin(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(onPressed: (){
                router.pushNamed('settings');
              }, icon: const Icon(Icons.settings)),
            )
          ],
        ),
      ),
    );
  }
}
