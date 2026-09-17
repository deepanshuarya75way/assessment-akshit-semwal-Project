import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/models/LoginModel.dart';
import 'package:hrapp/Services/Push_Notfication.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/Services/location_service.dart';
import 'package:hrapp/Services/location_task_handler.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
import 'package:hrapp/view/navbar.dart';

import 'package:http/http.dart' as http;

import 'package:permission_handler/permission_handler.dart';

class Logincontroller extends GetxController {
  @override
  void onInit() {
    // PostLogin();

    // AllEmployee();

    // _requestaudoio();
    super.onInit();
  }

  final RoleController roleController = Get.put(RoleController());

  RxBool login = false.obs;

  final box = GetStorage();
  Loginmodel loginmodel = Loginmodel();

  LoginmodelReponse loginmodelReponse = LoginmodelReponse();
  TextEditingController EmailController = TextEditingController();

  TextEditingController PasswordController = TextEditingController();

  UserData userData = UserData();

  Future<void> PostLogin() async {
    // showLoading("Loading.....");

    login.value = true;
    try {
      String url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Userlogin";

      Map newuser = {
        'Email_work': EmailController.text,
        'Password': PasswordController.text,
        "authcode": box.read('AppCode')
      };
      print(newuser);

      final Response = await http.post(Uri.parse(url),
          body: jsonEncode(
            newuser,
          ),
          headers: {"Content-Type": "application/json"});

      print(Response.body.toString());

      if (Response.statusCode == 200) {
        // login sucess
        login.value = true;
        final extractedData = jsonDecode(Response.body);

        loginmodelReponse.iserror = extractedData["isError"];
        loginmodelReponse.errormsg = extractedData["errorMsg"];
        final data = extractedData["userDetails"];

        final iserror = extractedData["isError"];

        final Acessstoken = extractedData["Acessstoken"];
        final refreshToken = extractedData["Refreshtoken"];

        await Rs_hrms_config.storage
            .write(key: "accessToken", value: Acessstoken);
        await Rs_hrms_config.storage.write(
          key: "refreshToken",
          value: refreshToken,
        );

        String? access = await Rs_hrms_config.storage.read(key: "accessToken");
        String? refresh =
            await Rs_hrms_config.storage.read(key: "refreshToken");

        print("Access Token: $access");
        print("Refresh Token: $refresh");

        if (loginmodelReponse.iserror == false) {
          userData.id = extractedData["userData"]["ID"];

          userData.propic = extractedData["userData"]["profilePic"];
          userData.empName = extractedData["userData"]["EmpName"];
          userData.empCode = extractedData["userData"]["EmpCode"];
          userData.gender = extractedData["userData"]["Gender"];
          userData.department = extractedData["userData"]["Department"];
          userData.designation = extractedData["userData"]["Designation"];
          userData.AccessHRMS = extractedData["userData"]["AccessHRMS"];
          // userData.UserCurency = extractedData["userData"]["currency"];
          loginmodelReponse.userData = userData;
          bool isactive =
              userData.isactive = extractedData["userData"]["Isactive"];

          await box.write("AccessHRMS", userData.AccessHRMS);

          await box.write("UserId", userData.id!);

          if (isactive == false) {
            Get.snackbar(
              "Account Disabled",
              "Please contact admin",
              snackPosition: SnackPosition.top,
              backgroundColor: Colors.red, // ✅ error color
              colorText: Colors.white,
              icon: const Icon(
                Icons.error_outline, // ✅ error icon
                color: Colors.white,
              ),
              duration: const Duration(seconds: 3),
            );

            return; // ⛔ STOP HERE
          }

          // 🔥 1️⃣ Request permissions AFTER login
          await _requestPermissions();
          await _requestmessage();

          // await sendSingleLoginLocation();

          Get.snackbar(
            "Login Successful", // Title of the snackbar
            "You have logged in successfully!", // Message of the snackbar
            snackPosition:
                SnackPosition.top, // Position of the snackbar (BOTTOM or TOP)
            backgroundColor: Colors.green, // Background color of the snackbar
            colorText: Colors.white, // Text color
            icon:
                Icon(Icons.check_circle, color: Colors.white), // Optional icon
            duration:
                Duration(seconds: 3), // Duration the snackbar will be displayed
          );

          await roleController.getUserRole();

          Get.offAll(() => Navbar());
        } else {
          if (iserror == true) {
            Get.snackbar("Failed", data["errorMsg"] ?? "Invalid credentials",
                backgroundColor: Colors.red, colorText: Colors.white);
          }
        }
      } else if (Response.statusCode == 404) {
        // Not found (wrong URL)
        Get.snackbar("Wrong URL",
            "The requested URL was not found. Please check the URL and try again.",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (Response.statusCode == 400) {
        // Bad request
        Get.snackbar(
            "Failed", loginmodelReponse.errormsg ?? "Invalid credentials",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (Response.statusCode == 500) {
        // Server error
        Get.snackbar("Server Error",
            "The server encountered an internal error. Please try again later.",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (Response.statusCode == 503) {
        // Service unavailable
        Get.snackbar("Service Unavailable",
            "The server is currently unavailable. Please try again later.",
            backgroundColor: Colors.red, colorText: Colors.white);
      } else if (Response.statusCode == 504) {
        // Gateway timeout
        Get.snackbar("Timeout",
            "The server took too long to respond. Please try again later.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (ex) {
      print(ex.toString());
      Get.snackbar("Error",
          'Unable to connect to the server. Please check your connection and try again.');
    } finally {
      login.value = false;
    }
  }

  var emplist = <UserData>[].obs;

  Future<void> AllEmployee() async {
    try {
      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/EmpName";

      final res = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "authcode": box.read("AppCode"),
          },
        ),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);

        final empName = data["emp_Names"];

        if (empName != null) {
          for (var element in empName) {
            UserData userData = UserData();

            userData.id = element["id"];
            userData.empName = element["EmpName"];

            emplist.add(userData);
          }
        }
        print("emplist $emplist");
      }
    } catch (ex) {
      print(ex.toString());
    }
  }

  // Future<void> afterLoginSuccess() async {
  //   // bool granted = await _requestPermissions();

  //   if (granted) {
  //     await startLocationService();
  //     print("Location service started 🔥");
  //   } else {
  //     print("Location permission denied ❌");
  //   }
  // }

  Future<void> _requestPermissions() async {
    // Request location permission
    PermissionStatus status = await Permission.location.request();

    if (status.isGranted) {
      print("Permission granted");
      // Do something if permission is granted (e.g., fetch user location)
    } else if (status.isDenied) {
      print("Permission denied");
      // Handle the case where the user denies permission
    } else if (status.isPermanentlyDenied) {
      print("Permission permanently denied. Open settings.");
      // Optionally, open the app settings to allow the user to grant permission
      openAppSettings();
    }
  }
}

Future<void> _requestmessage() async {
  PermissionStatus status = await Permission.notification.request();

  if (status.isGranted) {
    print("Permission granted");
  }

  if (status.isDenied) {
    print("Permission denied");
  } else if (status.isPermanentlyDenied) {
    print("Permission permanently denied. Open settings.");

    openAppSettings();
  }
}

// Future<void> _requestaudoio() async {
//   // Request location permission
//   PermissionStatus status = await Permission.microphone.request();

//   if (status.isGranted) {
//     print("Permission granted");
//     // Do something if permission is granted (e.g., fetch user location)
//   } else if (status.isDenied) {
//     print("Permission denied");
//     // Handle the case where the user denies permission
//   } else if (status.isPermanentlyDenied) {
//     print("Permission permanently denied. Open settings.");
//     // Optionally, open the app settings to allow the user to grant permission
//     openAppSettings();
//   }
// }

// class MyHttpOverrides extends HttpOverrides {
//   @override
//   HttpClient createHttpClient(SecurityContext? context) {
//     return super.createHttpClient(context)
//       ..badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//   }
// }

Future<void> sendSingleLoginLocation() async {
  GetStorage box = GetStorage();

  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
  int userId = box.read("UserId") ?? 0;
  List<Map<String, dynamic>> locationData = [
    {
      "EmployeeId": userId,
      "DeviceId": "Android",
      "Latitude": position.latitude,
      "Longitude": position.longitude,
      "Accuracy": position.accuracy,
      "RecordedAt": DateTime.now().toIso8601String(),
      "ReceivedAt": null,
      "Source": "Login", // change from Background
      "CreatedAt": DateTime.now().toIso8601String(),
      "issync": 0
    }
  ];

  await sendLocation(locationData);

  print("Location sent successfully ✅");
}

// Future<void> getPackageData() async {
//   PackageInfo _packageInfo = await PackageManager.getPackageInfo();
// }

// Future<void> checkForUpdate() async {
//   try {
//     AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();

//     if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
//       if (updateInfo.immediateUpdateAllowed) {
//         // Force update
//         await InAppUpdate.performImmediateUpdate();
//       } else if (updateInfo.flexibleUpdateAllowed) {
//         // Background update
//         await InAppUpdate.startFlexibleUpdate();
//         await InAppUpdate.completeFlexibleUpdate();
//       }
//     }
//   } catch (e) {
//     print("Update error: $e");
//   }
// }
