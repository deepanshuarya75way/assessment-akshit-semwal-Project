import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hrapp/New_APP_Art_Design/New_DashBoard_Screen/New_Dashboard_screen.dart';
import 'package:hrapp/New_APP_Art_Design/New_ProfileScreen/New_profile_screen.dart';
import 'package:hrapp/New_APP_Art_Design/New_Services_Screen/New_Services_screnn.dart';
import 'package:hrapp/Services/Push_Notfication.dart';

import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/constants/NoInternet_screen.dart';
import 'package:hrapp/features/authentication/controllers/AppCodeController.dart';
import 'package:hrapp/core/network/CheckInternetConnection.dart';
import 'package:hrapp/features/authentication/controllers/Local_AuthController.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/dashboard/controllers/Tabcontroller.dart';
import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';

import 'package:hrapp/view/pages/Dashboard.dart';
import 'package:hrapp/view/pages/Profile2.dart';

import 'package:hrapp/view/pages/services.dart';
import 'package:line_icons/line_icons.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  void initState() {
    super.initState();

    LocalLogin authController = Get.put(LocalLogin());
    //

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final isauth = authController.box.read("isauth");
      setupIfLoggedIn();
      final RoleController roleController = Get.find<RoleController>();
      Get.put(CodeController(), permanent: true);
      // Show dialog only if fingerprint has not been asked yet
      if (isauth == null) {
        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.fingerprint, size: 48, color: Colors.blue),
                  const SizedBox(height: 16),
                  const Text(
                    "Do you want to add the Biometric?",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          authController.box.write("isauth", false);
                          Get.close();
                        },
                        child: const Text("No"),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          authController.box.write("isauth", true);
                          Get.close();
                        },
                        child: const Text("Yes"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Widget build(BuildContext context) {
    final networkCtrl = Get.find<NetworkController>();

    List<Widget> pages = [
      Obx(() => networkCtrl.isConnected.value
          ? ModernDashboardPage()
          : NoInternetScreen()),
      Obx(() => networkCtrl.isConnected.value
          ? ServicesScreen()
          : NoInternetScreen()),
      Obx(() => networkCtrl.isConnected.value
          ? NewProfileScreen()
          : NoInternetScreen()),
    ];
    final indexcontroller = Get.put(Tabcontroller());
    return Obx(() => SafeArea(
          top: false,
          bottom: true,
          child: Scaffold(
            body: pages[indexcontroller.tabindex],
            bottomNavigationBar: CurvedNavigationBar(
                animationCurve: Curves.easeOutQuint,
                buttonBackgroundColor: Colors.transparent,
                key: ValueKey(indexcontroller.tabindex),
                backgroundColor: Colors.transparent,
                color: Palette.KmainDark2,
                index: indexcontroller.tabindex,
                onTap: (index) {
                  indexcontroller.indexchange(index);
                },
                items: [
                  CurvedNavigationBarItem(
                    label: "Home",
                    labelStyle: TextStyle(color: Colors.white),
                    child: Icon(
                      Icons.home,
                      size: 30,
                      color: indexcontroller.tabindex == 0
                          ? Palette.Kmain
                          : Colors.white,
                    ),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.menu,
                      size: 30,
                      color: indexcontroller.tabindex == 1
                          ? Palette.Kmain
                          : Colors.white, //Palette.Kmain,
                    ),
                    label: "Service",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  CurvedNavigationBarItem(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: indexcontroller.tabindex == 2
                          ? Palette.Kmain
                          : Colors.white, // Palette.Kmain,
                    ),
                    label: "Profile",
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ]),
          ),
        ));
  }
}

GetStorage box = GetStorage();
void setupIfLoggedIn() async {
  // final CodeController appCodeController =
  //     Get.put(CodeController(), permanent: true);
  final userid = box.read("UserId");

  print(userid);

  if (userid != null) {
    await getToken(userid); // ✅ Correct place
  }
}
