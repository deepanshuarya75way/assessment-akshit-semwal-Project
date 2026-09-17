import 'dart:async';
import 'dart:convert';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/authentication/screens/NewLoginScreen.dart';
import 'package:hrapp/features/dashboard/models/DashboardModel.dart';
import 'package:hrapp/Services/Push_Notfication.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';
import 'package:hrapp/core/network/CheckInternetConnection.dart';
import 'package:hrapp/features/authentication/controllers/LoginController.dart';
import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/core/utils/RS_HRMS_LOG.dart';
import 'package:hrapp/features/authentication/controllers/Refresh-api-controller.dart';
import 'package:hrapp/features/authentication/controllers/UserMasterController.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Profilecontroller profilecontroller = Get.put(Profilecontroller());
final networkCtrl = Get.find<NetworkController>();
final RoleController roleController = Get.find<RoleController>();

class Dashboardcontroller extends GetxController {
  @override
  void onInit() {
    roleController.getUserRole();
    updateTime();
    profilecontroller.GetProfile();
    getdashboardDetails();
    super.onInit();
    ever(networkCtrl.isConnected, (bool connected) {
      if (connected) {
        getdashboardDetails();
        roleController.getUserRole();
        updateTime();
        profilecontroller.GetProfile();
      }
    });
  }

  // final controller = Get.put(Logincontroller());

  RS_HRMS_LOG rs_hrms_log = Get.put(RS_HRMS_LOG());

  Rs_hrms_config rs_hrms_config = Rs_hrms_config();

  final leavedatalist = <LeaveDataModel>[].obs;
  final activitieslist = <UpcomingActivites>[].obs;
  final brithdayslist = <UpcomingBrithday>[].obs;

  final totaltaskList = <TotalTaskmdoel>[].obs;
  var expandedList = <bool>[].obs;

  final gettimes =
      <GetTime>[].obs; // Make sure this is the correct naming convention
  Rx<TimeOfDay> timeOfDay = TimeOfDay.now().obs;

  Dashboardmodel dashboardmodel = Dashboardmodel();
  RxBool isloading = false.obs;
  RxBool loading = false.obs;

  RxBool Cheackmarkatt = false.obs;

  GetTime getTime = GetTime();

  RxString Signin = ''.obs;
  RxString Signout = ''.obs;
  RxInt pendingcount = 0.obs;
  RxInt Completedcount = 0.obs;
  RxInt Inprogesscount = 0.obs;

  RxString payrollmonth = ''.obs;

  RxInt payrollyear = 0.obs;

  RxString currencyCode = ''.obs;
  RxInt NetSalary = 0.obs;

  RxInt count = 0.obs;

  RxInt Overduecount = 0.obs;

  // Rx<Duration> output1 = Duration().obs;

  Rx<Duration> difference = Duration().obs;

  Rx<int> outputSeconds = Rx<int>(0);

  Rx<int> outputmin = Rx<int>(0);

  Rx<int> outputSeconds1 = Rx<int>(0);

  void updateTime() {
    timeOfDay.value = TimeOfDay.now();
  }

  Future<void> getdashboardDetails() async {
    isloading.value = true;
    loading.value = true;

    try {
      final empid = controller.box.read("UserId");

      String? name = profilecontroller.profilemodel.empname.toString();

      String? accessToken = await Rs_hrms_config.storage.read(
        key: "accessToken",
      );

      print(accessToken);

      String url =
          "${Rs_hrms_config.Rs_hrms_baseUrl}/api/HRMSWEBAPI/Dashboard?authcode=${controller.box.read("AppCode")}";
      final Response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $accessToken",
        },
      );
      print(Response.body.toString());

      if (Response.statusCode == 200) {
        leavedatalist.clear();
        activitieslist.clear();
        brithdayslist.clear();
        gettimes.clear();

        totaltaskList.clear();

        // await checkForUpdate();
        // if (empid != null) {
        //   await GetToken(empid); // ✅ CALL HERE
        // }
        final extractedData = jsonDecode(Response.body);
        var data = extractedData["TotalTask"];

        dashboardmodel.isError = extractedData["isError"];
        dashboardmodel.errorMsg = extractedData['errorMsg'];
        dashboardmodel.markatt = extractedData["markatt"];

        Cheackmarkatt.value = dashboardmodel.markatt!;

        final leavedata = extractedData["LeaveData"];
        final brithdaysdata = extractedData["employeeBrithdaysList"];
        final Activitiesdata = extractedData['ActivitiesList'];

        final Payroll = extractedData['GetPayRoll'];

        // print("totaltaskList: $totaltaskList");

        // Handle LeaveData parsing
        for (var element in leavedata) {
          LeaveDataModel leaveDataModel = LeaveDataModel();
          leaveDataModel.id = element['ID'];
          leaveDataModel.empname = element['EmpName'];
          leaveDataModel.leavetypes = element["LeaveType"];
          leaveDataModel.leavedays = element["LeaveDays"];
          leaveDataModel.leavebf = element["LeaveBf"];
          leaveDataModel.daystaken = element["DaysTaken"];
          leaveDataModel.balance = element["Balance"];
          leavedatalist.add(leaveDataModel);
        }

        pendingcount.value = data["PendingCount"];

        Completedcount.value = data["CompletedCount"];

        Inprogesscount.value = data["InProgressCount"];

        Overduecount.value = data["OVERDUECOUNT"];
        count.value = extractedData["Count"] ?? 0;

        payrollmonth.value = Payroll["D_Month"] ?? '';
        payrollyear.value = Payroll["ProcessingYear"] ?? 0;
        currencyCode.value = Payroll["currencyCode"] ?? '';
        NetSalary.value = Payroll["NetSalary"] ?? 0;

        print("count $count");

        print("pendingcount: $pendingcount");
        print("Completedcount: $Completedcount");
        print("Inprogesscount: $Inprogesscount");

        // Handle Brithdays parsing
        for (int i = 0; i < brithdaysdata.length; i++) {
          UpcomingBrithday upcomingBrithday = UpcomingBrithday();
          upcomingBrithday.empcode = brithdaysdata[i]["EmpCode"];
          upcomingBrithday.empname = brithdaysdata[i]["EmpName"];
          upcomingBrithday.emailwork = brithdaysdata[i]["Email_Work"];
          upcomingBrithday.dob = brithdaysdata[i]["DOB"];
          upcomingBrithday.userimage = brithdaysdata[i]["profilePic"];
          // if (brithdaysdata[i]["profilePic"] != null) {
          //   upcomingBrithday.imageBytes =
          //       base64Decode(brithdaysdata[i]["profilePic"].toString());
          // }
          brithdayslist.add(upcomingBrithday);
        }
        // for (var element in totaltaskdetials) {
        //   TotalTaskmdoel totalTask = TotalTaskmdoel();
        //   totalTask.total = element["TotalCount"];
        //   totalTask.statusName = element["StatusName"];
        //   totaltaskList.add(totalTask);
        // }

        // Handle Activities parsing
        for (int i = 0; i < Activitiesdata.length; i++) {
          UpcomingActivites upcomingActivites = UpcomingActivites();
          upcomingActivites.id = Activitiesdata[i]["ID"];
          upcomingActivites.meassage = Activitiesdata[i]["Message"];
          upcomingActivites.title = Activitiesdata[i]["Title"];
          upcomingActivites.date = Activitiesdata[i]["PublishDate"];

          upcomingActivites.edate = Activitiesdata[i]["ExprieDate"];
          upcomingActivites.createdBy = Activitiesdata[i]["empname"];
          activitieslist.add(upcomingActivites);
        }

        // profilemodel.id = extractedData["UserProFileData"]["ID"];
        getTime.AttendenceId = extractedData["gettimes"]["AttendenceID"];
        getTime.signin = extractedData["gettimes"]["singin"];
        getTime.signout = extractedData["gettimes"]["singout"];

        dashboardmodel.getime = getTime;

        Signin.value = dashboardmodel.getime!.signin!;
        Signout.value = dashboardmodel.getime!.signout ?? "";

        print(Signin.value);

        print(Signout.value);
      } else if (Response.statusCode == 401) {
        //  refresh api call
        bool success = await refreshApi();

        if (success) {
          await getdashboardDetails(); // Retry API
          return;
        } else {
          // Refresh token expired
          await Rs_hrms_config.storage.deleteAll();
          Get.offAll(() => Newloginscreen());
        }
      } else {}
//  getUserRole();

      roleController.getUserRole();
      timer();
      timecal();
    } catch (ex, s) {
      FirebaseCrashlytics.instance.recordError(ex, s);

      rs_hrms_log.createlogs("Reason: ${ex.toString()}\n"
          "StackTrace: ${s.toString()}");
      print(ex.toString());
    }
    isloading.value = false;
    loading.value = false;
  }

  Rx<int> differenceInSeconds = Rx<int>(0);

  int? hours;

  RxInt min = 0.obs;
  RxInt sec = 0.obs;

  var differenceInSeconds1 = 0.obs;

  // Initialize to 0 seconds

  void timer() {
    // Example signin time in string format
    String? signin = dashboardmodel.getime!.signin;

    if (signin != null) {
      try {
        // Add the current date to the signin time to create a complete datetime string
        String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
        String fullSignin = "$todayDate $signin";

        // Parse the signin time with the date
        DateFormat format = DateFormat("yyyy-MM-dd hh:mm a");
        DateTime startTime = format.parse(fullSignin);

        print("Parsed Start Time: $startTime");

        // Set up a timer to calculate the difference every second
        Timer.periodic(Duration(seconds: 1), (timer) {
          DateTime currentTime = DateTime.now();
          Duration difference = currentTime.difference(startTime);

          differenceInSeconds.value = difference.inSeconds;

          // Calculate hours, minutes, and seconds
          hours = difference.inSeconds ~/ 3600;
          int minutes = (difference.inSeconds % 3600) ~/ 60;
          int seconds = difference.inSeconds % 60;

          // Print the difference
        });
      } catch (e) {
        print("Error parsing time: $e");
      }
    } else {
      print('Sign-in time is null');
    }
  }

  void timecal() {
    // Get the signin and signout values
    String? ckeckin = dashboardmodel.getime!.signin;
    print("Check-in: $ckeckin");

    String? ckeckout = dashboardmodel.getime!.signout; // Corrected this line
    print("Check-out: $ckeckout");

    // Check if both values are not null
    if (ckeckin != null && ckeckout != null) {
      // Initialize the DateFormat for parsing the time
      DateFormat format = DateFormat("hh:mm a");

      // Parse the check-in and check-out times into DateTime objects
      DateTime startTime = format.parse(ckeckin); // Parse check-in time
      print("Start time: $startTime");

      DateTime endTime = format.parse(ckeckout); // Parse check-out time
      print("End time: $endTime");

      // Calculate the time difference
      Duration difference1 = endTime.difference(startTime);
      print("Time differences: $difference");

      outputSeconds.value = difference1.inHours;
      outputmin.value = difference1.inMinutes % 60;
      outputSeconds1.value = difference1.inSeconds % 60;

      // difference = difference1;

      // Store the difference
      // Assuming output1 is a variable to store the difference
    } else {
      print('Both check-in and check-out are empty');
    }
  }
}

// Future<void> checkForUpdate() async {
//   final newVersion = NewVersionPlus();

//   final status = await newVersion.getVersionStatus();

//   if (status != null) {
//     if (status.canUpdate) {
//       newVersion.showUpdateDialog(
//         context: Get.context!,
//         versionStatus: status,
//         dialogTitle: "Update Available",
//         dialogText:
//             "A new version of the app is available. Please update to continue.",
//         updateButtonText: "Update Now",
//         launchModeVersion: LaunchModeVersion.external,
//         dismissButtonText: "Later",
//       );
//     }
//   }
// }
