import 'dart:convert';

import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:http/http.dart' as http;

Future<bool>? _refreshInProgress;
String? _lastRefreshedAccessToken;
DateTime? _lastRefreshTime;

Future<bool> refreshApi() async {
  if (_refreshInProgress != null) return _refreshInProgress!;

  final currentAccessToken =
      await Rs_hrms_config.storage.read(key: "accessToken");
  final refreshedRecently = _lastRefreshTime != null &&
      DateTime.now().difference(_lastRefreshTime!) < const Duration(seconds: 60);

  if (refreshedRecently && currentAccessToken == _lastRefreshedAccessToken) {
    await clearStoredSession();
    return false;
  }

  _refreshInProgress = _performRefresh();
  try {
    return await _refreshInProgress!;
  } finally {
    _refreshInProgress = null;
  }
}

Future<bool> _performRefresh() async {
  try {
    final url = "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Refreshtoken";

    final refreshToken = await Rs_hrms_config.storage.read(key: "refreshToken");

    if (refreshToken == null || refreshToken.isEmpty) {
      await clearStoredSession();
      return false;
    }

    final res = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "RefreshToken": refreshToken,
        "authcode": box.read("AppCode"),
      }),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final accessToken = data["AccessToken"];
      final newRefreshToken = data["Newrefreshtoken"];

      if (accessToken is! String ||
          accessToken.isEmpty ||
          newRefreshToken is! String ||
          newRefreshToken.isEmpty) {
        await clearStoredSession();
        return false;
      }

      await Rs_hrms_config.storage.write(
        key: "accessToken",
        value: accessToken,
      );

      await Rs_hrms_config.storage.write(
        key: "refreshToken",
        value: newRefreshToken,
      );

      _lastRefreshedAccessToken = accessToken;
      _lastRefreshTime = DateTime.now();

      return true;
    }

    await clearStoredSession();
    return false;
  } catch (e) {
    print(e);
    await clearStoredSession();
    return false;
  }
}

Future<void> clearStoredSession() async {
  await Rs_hrms_config.storage.delete(key: "accessToken");
  await Rs_hrms_config.storage.delete(key: "refreshToken");
  await box.remove("UserId");
  await box.remove("isauth");
}
