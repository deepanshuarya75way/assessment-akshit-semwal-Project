import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/UserDeleteAccountControoler.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});

  final box = GetStorage();

  @override
  UserDeleteController userdeletecontoller = Get.put(UserDeleteController());
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),

          // ===== DANGER ZONE =====
          ListTile(
            leading: const Icon(
              Icons.delete_forever,
              color: Colors.red,
            ),
            title: const Text(
              "Delete Account",
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: const Text(
              "This action is permanent",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: _confirmDelete,
          ),
        ],
      ),
    );
  }

  void _confirmDelete() {
    final login = Get.put(Logincontroller());
    final userDeleteController = Get.put(UserDeleteController());

    Get.defaultDialog(
      title: "Delete Account",
      middleText: "Are you sure? This action cannot be undone.",
      content: Obx(
        () => userDeleteController.isLoading.value
            ? const Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              )
            : const SizedBox(),
      ),
      textCancel: "Cancel",
      textConfirm: userDeleteController.isLoading.value ? "" : "Delete",
      confirmTextColor: Colors.white,
      onConfirm: () async {
        login.EmailController.clear();
        login.PasswordController.clear();

        await userDeleteController.deleteUser();
      },
    );
  }
}
