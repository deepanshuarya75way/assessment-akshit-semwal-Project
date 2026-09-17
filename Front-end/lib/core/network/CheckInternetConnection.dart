import 'dart:io';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkController extends GetxController {
  var isConnected = true.obs;

  @override
  void onInit() {
    super. onInit();
    _checkInternet();

    Connectivity().onConnectivityChanged.listen((event) {
      _checkInternet();
    });
  }

  Future<void> _checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      isConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      isConnected.value = false;
    }
  }
}
