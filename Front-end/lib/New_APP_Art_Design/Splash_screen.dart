// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// import 'dart:ui';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_foreground_task/flutter_foreground_task.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/root/get_material_app.dart';

// import 'package:get_storage/get_storage.dart';
// import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';

// import 'package:hrapp/Themecolor/Palette.dart';
// import 'package:hrapp/constants/NoInternet_screen.dart';
// import 'package:hrapp/features/authentication/controllers/AppCodeController.dart';
// import 'package:hrapp/core/network/CheckInternetConnection.dart';
// import 'package:hrapp/features/task/controllers/Comment_Controller.dart';

// import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
// import 'package:hrapp/features/authentication/controllers/LoginController.dart';
// import 'package:hrapp/features/task/controllers/TaskController.dart';

// import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
// import 'package:hrapp/view/Auth_Screen/Auth.dart';
// import 'package:hrapp/view/Auth_Screen/UserCheack.dart';

// import 'package:hrapp/view/navbar.dart';

// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import 'package:upgrader/upgrader.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   final box = GetStorage();

//   @override
//   void initState() {
//     super.initState();
//     startFlow();
//   }

//   Future<void> startFlow() async {
//     final codeCtrl = Get.find<CodeController>();

//     /// ✅ STEP 1: Check App Version
//     bool isMandatory = await codeCtrl.appersionCheck();

//     /// 🔴 STOP APP IF MANDATORY
//     if (isMandatory) return;

//     /// ✅ STEP 2: Normal Flow
//     final userid = box.read("UserId");
//     final isauth = box.read("isauth") ?? false;
//     final appcode = box.read("AppCode");

//     await Future.delayed(const Duration(milliseconds: 500));

//     if (appcode == null) {
//       Get.offAll(() => UserCheack());
//     } else if (userid == null) {
//       Get.offAll(() => Newloginscreen());
//     } else if (isauth) {
//       Get.offAll(() => AuthScreen());
//     } else {
//       Get.offAll(() => const Navbar());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(child: CircularProgressIndicator()),
//     );
//   }
// }