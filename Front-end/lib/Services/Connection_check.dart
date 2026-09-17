import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectionCheck {
  static Future<bool> isOnline() async {
    return await InternetConnection().hasInternetAccess;
  }
}
