import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

GetStorage box = GetStorage();

class Rs_hrms_config {
  static const String Rs_hrms_baseUrl =
      "https://services.rs-apps.online/hrms-api";
  // https://rs-apps.online/Rs-HrmsApi

  static const String App_version = "1.2.6";

  static final appcode = box.read("AppCode");

  static const FlutterSecureStorage storage = FlutterSecureStorage();

  static String get imageLink {
    if (appcode == "RSgh3ah8978b2-t57-4d1a-9613-2c719e7g567" ||
        appcode == "000-000" ||
        appcode == "test" ||
        appcode == 'Test') {
      return "https://rshrms.rs-apps.online/EmployeeDocument";
    } else if (appcode ==
        "RSf3a9e8b2-3bROLA78Facec1-4d1a-9613-2c719eHRMS7cd870") {
      return "https://rs-apps.online/Rs-HrmsApi/emp-photo/EmployeeDocument";
    }

    return "https://rs-apps.online/Rs-HrmsApi/EmployeeDocument";
  }

  String UserFriendlyDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      DateTime dt = DateTime.parse(rawDate); // parse ISO or SQL date
      return DateFormat('dd MMM yyyy').format(dt); // e.g., 15 Mar 2026
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }
}
