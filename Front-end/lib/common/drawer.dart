import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:hrapp/New_APP_Art_Design/New_ProfileScreen/Password_Change_Screen.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(
      {super.key,
      required this.Username,
      required this.Designation,
      required this.Userprofile});

  final String Username;
  final String Designation;
  final String Userprofile;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(right: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // 🔹 Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: Userprofile,

                        width: 110, // 55 radius × 2
                        height: 110,
                        fit: BoxFit.cover,

                        fadeInDuration: const Duration(milliseconds: 250),

                        placeholder: (context, url) => const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),

                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.grey,
                        ),

                        memCacheWidth: 150,
                        memCacheHeight: 150,
                        cacheKey: Userprofile,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Username,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        Designation,
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 🔹 Menu Items

            _drawerItem(
              icon: Icons.logout_rounded,
              title: "Logout",
              onTap: () async {
                await clearStoredSession();
                Get.off(() => Newloginscreen());
              },
            ),
            _drawerItem(
              icon: Icons.lock_outline,
              title: "Change Password",
              onTap: () {
                Get.to(() => ChangePasswordScreen());

               
              },
            ),

            // _drawerItem(
            //   icon: Icons.dark_mode_outlined,
            //   title: "Dark Mode",
            //   onTap: () {
            //     Get.changeTheme(ThemeData.dark());
            //   },
            // ),

            // _drawerItem(
            //   icon: Icons.light_mode_outlined,
            //   title: "Light Mode",
            //   onTap: () {
            //     Get.changeTheme(ThemeData.light());
            //   },
            // ),

            const Spacer(),

            // const Divider(),

            // _drawerItem(
            //   icon: Icons.logout_rounded,
            //   title: "Logout",
            //   color: Colors.red,
            //   onTap: () {
            //     Navigator.pop(context);
            //     Get.snackbar(
            //       "Logout",
            //       "You have been logged out",
            //       backgroundColor: Colors.red,
            //       colorText: Colors.white,
            //     );
            //   },
            // ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, color: color),
      ),
      onTap: onTap,
    );
  }
}
