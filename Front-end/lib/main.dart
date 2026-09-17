import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

import 'package:get_storage/get_storage.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/New_APP_Art_Design/Splash_screen.dart';
import 'package:hrapp/Services/Push_Notfication.dart';

import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/constants/NoInternet_screen.dart';
import 'package:hrapp/features/authentication/controllers/AppCodeController.dart';
import 'package:hrapp/core/network/CheckInternetConnection.dart';
import 'package:hrapp/features/task/controllers/Comment_Controller.dart';

import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/features/task/controllers/TaskController.dart';

import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
import 'package:hrapp/view/Auth_Screen/Auth.dart';
import 'package:hrapp/view/Auth_Screen/UserCheack.dart';

import 'package:hrapp/view/navbar.dart' hide box;

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:upgrader/upgrader.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("🔵 Background message: ${message.notification?.title}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // Get.put(CodeController(), permanent: true);
  Get.put(NetworkController(), permanent: true);
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseMessaging.instance.requestPermission(); // Android 13+

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  /// ✅ Notification Channel (IMPORTANT)
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    importance: Importance.max,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showNotification(
      title: message.notification?.title ?? "",
      body: message.notification?.body ?? "",
    );

    print("🔴 Foreground message: ${message.notification?.title}");
  });

  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'location_channel',
      channelName: 'Location Tracking',
      channelDescription: 'Background location service',
      channelImportance: NotificationChannelImportance.LOW,
      priority: NotificationPriority.LOW,
    ),
    iosNotificationOptions: const IOSNotificationOptions(
      showNotification: true,
      playSound: false,
    ),
    foregroundTaskOptions: ForegroundTaskOptions(
      autoRunOnBoot: true,
      allowWakeLock: true,
      allowWifiLock: true,
      eventAction: ForegroundTaskEventAction.repeat(900000),

      /// 15 min
    ),
  );

  // ✅ Android settings
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // ✅ iOS settings
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(); // Use this instead of old IOSInitializationSettings

  // ✅ Combine both
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // ✅ Initialize plugin
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final upgrader = Upgrader();
  await upgrader.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // ✅ receive it

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    // final login = Get.put(Logincontroller());

    final RoleController roleController =
        Get.put(RoleController(), permanent: true);

    final taskControler = Get.put(TaskControler(), permanent: true);
    final commentController = Get.put(CommentController(), permanent: true);

    Logincontroller logincontroller =
        Get.put(Logincontroller(), permanent: true);

    //  Logincontroller logincontroller = Get.put(Logincontroller() );
    final networkCtrl = Get.put(NetworkController(), permanent: true);

    // LeaveTypeController leaveTypeController =
    //     Get.put(LeaveTypeController(), permanent: true);

    // leaveTypeController.getLeaveType();
    // Get.put(Dashboardcontroller(), permanent: true);
    // int? id = login.box.read("UserId");

    RSHRMSTheme rshrmsTheme = RSHRMSTheme();

    Widget initialScreen = const SessionGate();

    return ScreenUtilInit(
      designSize: const Size(370, 825),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('hi', ''),
          ],
          theme: rshrmsTheme.hrapptheme,
          home: Obx(() {
            final isConnected = networkCtrl.isConnected.value;
            if (!isConnected) return NoInternetScreen();
            return initialScreen; // ✅ no dialog logic here anymore
          })),
    );
  }
}

class SessionGate extends StatefulWidget {
  const SessionGate({super.key});

  @override
  State<SessionGate> createState() => _SessionGateState();
}

class _SessionGateState extends State<SessionGate> {
  late final Future<Widget> _initialScreen;

  @override
  void initState() {
    super.initState();
    _initialScreen = _resolveInitialScreen();
  }

  Future<Widget> _resolveInitialScreen() async {
    final appCode = box.read('AppCode');

    // First installation: stay on App Code screen
    if (appCode == null || appCode.toString().trim().isEmpty) {
      return const UserCheack();
    }

    final userId = box.read('UserId');

    // App code exists, but user has not logged in
    if (userId == null) {
      return Newloginscreen();
    }

    final accessToken = await Rs_hrms_config.storage.read(key: 'accessToken');

    final refreshToken = await Rs_hrms_config.storage.read(key: 'refreshToken');

    if (refreshToken == null || refreshToken.trim().isEmpty) {
      await clearStoredSession();
      return Newloginscreen();
    }

    if (accessToken == null || accessToken.trim().isEmpty) {
      final refreshed = await refreshApi();

      if (!refreshed) {
        await clearStoredSession();
        return Newloginscreen();
      }
    }

    final fingerprintEnabled = box.read('isauth') == true;

    if (fingerprintEnabled) {
      return AuthScreen();
    }

    return Navbar();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _initialScreen,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          debugPrint('SessionGate error: ${snapshot.error}');
          return const UserCheack();
        }

        return snapshot.data ?? const UserCheack();
      },
    );
  }
}

