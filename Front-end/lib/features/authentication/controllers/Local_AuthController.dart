import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import 'package:local_auth/local_auth.dart';

class LocalLogin extends GetxController {
  @override
  void onInit() {
    // localAuth();
    super.onInit();
  }

  LocalAuthentication auth = LocalAuthentication();
  final box = GetStorage();
  Future<bool> localAuth() async {
    try {
      bool isDeviceSupported = await auth.isDeviceSupported();

      if (!isDeviceSupported) {
        Get.snackbar(
          "Security Required",
          "Enable screen lock in device settings",
        );
        return false;
      }

      final available = await auth.getAvailableBiometrics();

      if (available.isEmpty) {
        Get.snackbar(
          "No Biometrics",
          "Please add fingerprint or face lock",
        );
        return false;
      }

      return await auth.authenticate(
        localizedReason: "Authenticate to continue",
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
  }
}
