import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/view/Auth_Screen/Auth.dart';
import 'package:http/http.dart' as http;

import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';
import 'package:url_launcher/url_launcher.dart';

class CodeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    appersionCheck();
    getAppVersion();
    // await checkForUpdate();
  }

  TextEditingController appcode = TextEditingController();
  final box = GetStorage();

  RxBool isloading = false.obs;
  Future<void> checkAppCode() async {
    try {
      isloading.value = true;
      final String code = appcode.text;

      final url =
          '${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/AppcodeCheack?authcode=$code';

      print(url);
      final response = await http.get(Uri.parse(url));

      print(response.body);

      if (response.statusCode == 200) {
        print("sucess");
        final appcode = box.write('AppCode', code);
        print(appcode);

        Get.offAll(() => Newloginscreen());
        Get.snackbar("Success", "App code is valid");
      } else {
        print("error");
        Get.snackbar("Error", "App code is invalid");
      }
    } catch (e) {
      print(e);
    } finally {
      isloading.value = false;
    }
  }

  RxBool mandatory = false.obs;

  RxString bundle_num = "".obs;

  String isbundle = "";
  final upgrader = Upgrader();

  Future<void> appersionCheck() async {
    try {
      final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/AppVersion";

      final res = await http.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({"Authcode": box.read("AppCode")}));

      if (res.statusCode == 200) {
        print(res.body);
        final data = jsonDecode(res.body);
        final version = data["appVersion"];

        isbundle = await getAppVersion(); // ✅ current app bundle
        bundle_num.value = version["BundleNum"]; // ✅ latest bundle from API
        mandatory.value = version["IsMandatory"]; // ✅ mandatory flag

        print("✅ currentBundle: $isbundle");
        print("✅ newBundle: ${bundle_num.value}");
        print("✅ mandatory: ${mandatory.value}");

        // if(isloguted == true){

        //   // clean all the data
        // }

        checkAndShowUpdate(); // ✅ NOW call this after all data is ready
      }
    } catch (ex) {
      print("❌ appersionCheck error: $ex");
    }
  }

  bool _updateDialogShown = false; // ✅ add this to your controller

  void checkAndShowUpdate() {
    if (_updateDialogShown) return; // ✅ prevent multiple calls

    int newBundle = int.tryParse(bundle_num.value.toString()) ?? 0;
    int currentBundle = int.tryParse(isbundle.toString()) ?? 0;

    final isUpdateAvailable = newBundle > currentBundle;

    print("🔍 newBundle: $newBundle");
    print("🔍 currentBundle: $currentBundle");
    print("🔍 isMandatory: ${mandatory.value}");
    print("🔍 isUpdateAvailable: $isUpdateAvailable");

    // if (mandatory.value) {
    //   _updateDialogShown = true;
    //   _showMandatoryDialog();

    //   return;
    // }

    if (isUpdateAvailable) {
      _updateDialogShown = true;
      _showOptionalDialog();
      return;
    }

    print("✅ No update needed");
  }

  void _showMandatoryDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen ?? false) return; // ✅ moved inside callback
      Get.dialog(
        PopScope(
          canPop: false,
          child: AlertDialog(
            title: const Text("Update Required"),
            content: const Text("You must update the app to continue."),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  await openStore();
                  Get.back();
                  Get.backLegacy();
                },
                child: const Text("Update Now"),
              ),
            ],
          ),
        ),
        barrierDismissible: false,
      );
    });
  }

  void _showOptionalDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isDialogOpen ?? false) return; // ✅ moved inside callback
      Get.dialog(
        AlertDialog(
          title: const Text("Update Available"),
          content:
              const Text("A new version is available. Do you want to update?"),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await openStore();
                Get.back();
                Get.backLegacy();
              },
              child: const Text("Update Now"),
            ),
            mandatory.value == false
                ? TextButton(
                    onPressed: () {
                      Get.back();
                      Get.backLegacy();
                    },
                    child: const Text("Later"),
                  )
                : SizedBox.shrink()
          ],
        ),
        barrierDismissible: true,
      );
    });
  }

  Future<void> openStore() async {
    String url;

    if (Platform.isAndroid) {
      url = "https://play.google.com/store/apps/details?id=com.redsecure.hrapp";
    } else if (Platform.isIOS) {
      url = "https://apps.apple.com/app/id6756217387";
    } else {
      return;
    }

    await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
  }

  Future<String> getAppVersion() async {
    final info = await PackageInfo.fromPlatform();

    String version = info.version; // e.g. 1.2.1
    String buildNumber = info.buildNumber; // e.g. 34

    print("Version: $version");
    print("Build: $buildNumber");

    return buildNumber;
  }
}
