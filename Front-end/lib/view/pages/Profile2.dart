import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/Widget/Profilewid.dart';

import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';

class Profile2 extends StatelessWidget {
  const Profile2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(Logincontroller());
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey[100],
          actions: [
            IconButton(
                onPressed: () async {
                  await clearStoredSession();
                  Get.off(() => Newloginscreen());
                },
                icon: Icon(
                  Icons.logout_outlined,
                  size: 25,
                ))
          ],
          title: Text("Your Profile"),
          centerTitle: true,
        ),
        body: Profilewid());
  }
}
