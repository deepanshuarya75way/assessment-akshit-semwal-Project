import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/New_APP_Art_Design/New_ProfileScreen/Setting_screen.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final controller = Get.put(Logincontroller());

  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ===== HEADER =====
          // UserAccountsDrawerHeader(
          //   decoration: const BoxDecoration(
          //     color: Colors.blue,
          //   ),
          //   accountName: Text(""),
          //   accountEmail: Text(""),
          //   currentAccountPicture: const CircleAvatar(
          //     backgroundColor: Colors.white,
          //     child: Icon(Icons.person, size: 40),
          //   ),
          // ),

          SizedBox(height: 20),

          // ===== SETTINGS =====
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Get.to(() => SettingsPage());
              Get.snackbar("Settings", "Open settings page");
              // Get.to(() => SettingsPage());
            },
          ),

          // ===== ABOUT =====
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About"),
            onTap: () {
              Get.back();
              Get.snackbar("About", "App version 1.2.5");
              // Get.to(() => AboutPage());
            },
          ),

         
        ],
      ),
    );
  }
}
