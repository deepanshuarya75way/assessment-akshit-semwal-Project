import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hrapp/core/config/Rs_hrms_config.dart';

import 'package:hrapp/features/approval/controllers/ApprovalDetailsController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/bulider/actvities.dart';
import 'package:hrapp/bulider/brithdaywid.dart';

import 'package:hrapp/features/attendance/controllers/Attendencecontroller.dart';
import 'package:hrapp/features/dashboard/controllers/DashboardController.dart';
import 'package:hrapp/features/location/controllers/LocationController.dart';

import 'package:hrapp/features/profile/controllers/Profilecontroller.dart';
import 'package:hrapp/features/checkout/controllers/checkoutcontroller.dart';
import 'package:hrapp/view/notifications/notificationsScreen.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    Approvaldetailscontroller approvaldetailscontroller =
        Get.put(Approvaldetailscontroller());

    approvaldetailscontroller.GetApprovaldetails();
    Profilecontroller profilecontroller = Get.put(Profilecontroller());

    // final Login = Get.put(Logincontroller());
    // final profile = Get.put(Profilecontroller());

    final controller = Get.put(Dashboardcontroller());

    // int? count = approvaldetailscontroller.approvalerlist.length;

    // final profile = Get.put(Profilecontroller());

    controller.getdashboardDetails();

    // final pos = locationController.currentPosition.value;
    // final LatLng officeLatLng = LatLng(
    //   locationController.officeLat,
    //   locationController.officeLng,
    // );
    // final LatLng initialTarget = pos != null
    //     ? LatLng(pos.latitude, pos.longitude)
    //     : officeLatLng; // Default to office if position is null

    Attendencecontroller attendencecontroller = Get.put(Attendencecontroller());

    Checkoutcontroller checkoutcontroller = Get.put(Checkoutcontroller());

    // String signIn = controller.getTime.signin ?? "2024-11-21T09:00:00";
    // String signOut = controller.getTime.signout ?? "2024-11-21T18:00:00";

    // DateTime signInTime = DateTime.parse(signIn);

    // print(signInTime);
    // DateTime signOutTime = DateTime.parse(signOut);

    // Duration duration = signOutTime.difference(signInTime);
    // print('Duration: ${duration.inHours} hours');

    // String? signin = controller.getTime.signin;

    // // Removed the '!' because the string could be null

    // print(signin);
    // Duration? difference1;

    // print(difference1);

    // if (signin != null) {
    //   DateFormat format = DateFormat(
    //       "hh:mm a"); // 'hh:mm a' is for the 12-hour format with AM/PM
    //   DateTime startTime = format.parse(signin);

    //   print("  starttime  $startTime");

    //   // Parse the time string into DateTime
    //   // DateTime startTime = DateTime.parse(signin);
    //   DateTime currentTime = DateTime.now();

    //   print('$currentTime');

    //   // Calculate the difference as a Duration
    //   Duration difference = currentTime.difference(startTime);

    //   print("$difference");

    //   difference1 = difference;

    //   print("$difference1");

    //   // Print the difference in hours, minutes, and seconds
    //   print(
    //       'Difference: ${difference.inHours} hours, ${difference.inMinutes % 60} minutes, ${difference.inSeconds % 60} seconds');
    // } else {
    //   print('Sign-in time is null');
    // }

    // Duration? output1;

    // print("$output1");

    // String? ckeckin = controller.getTime.signin;

    // print("$ckeckin");

    // String? ckeckout = controller.getTime.signout;

    // print("$ckeckout");

    // if (ckeckin != null && ckeckout != null) {
    //   DateFormat format = DateFormat("hh:mm a");

    //   DateTime startTime = format.parse(ckeckin); // Parse checkin time

    //   print("$startTime");
    //   DateTime endTime = format.parse(ckeckout); // Parse checkout time
    //   print("$endTime ");

    //   Duration difference =
    //       endTime.difference(startTime); // Calculate the difference

    //   print("$difference ");

    //   // Store the difference
    //   output1 = difference;

    //   print("$output1 ");
    // } else {
    //   print('both are empty');
    // }

    // Obx(() {
    //   // Calculate hours, minutes, and seconds from Rx<int>
    //   int hours = controller.differenceInSeconds.value ~/ 3600;
    //   int minutes = (controller.differenceInSeconds.value % 3600) ~/ 60;
    //   int seconds = controller.differenceInSeconds.value % 60;

    //   // Display the time difference
    //   return Text(
    //     '$hours hours, $minutes minutes, $seconds seconds',
    //     style: TextStyle(fontSize: 24),
    //   );
    // });

    // DateTime today = DateTime.now();

    // DateTime timer = StartTime - today.hour;

    // DateTime? checkInTime; // To store the check-in time
    // Timer? timer; // Timer to update the elapsed time
    // Duration elapsedTime = Duration.zero; // To track elapsed time

    // void startTimer(String signinTimeStr) {
    //   // Parse the signin string into a DateTime object
    //   checkInTime = DateTime.parse(signinTimeStr);

    //   // Cancel any existing timer
    //   timer?.cancel();

    //   // Start a new timer
    //   timer = Timer.periodic(Duration(seconds: 1), (_) {
    //     setState(() {
    //       elapsedTime = DateTime.now().difference(checkInTime!);
    //     });
    //   });
    // }

    // String getFormattedElapsedTime() {
    //   final hours = elapsedTime.inHours.toString().padLeft(2, '0');
    //   final minutes = (elapsedTime.inMinutes % 60).toString().padLeft(2, '0');
    //   final seconds = (elapsedTime.inSeconds % 60).toString().padLeft(2, '0');
    //   return "$hours:$minutes:$seconds";
    // }

    String formattedDate = DateFormat('dd MMM, yyyy').format(DateTime.now());

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          // physics: NeverScrollableScrollPhysics(),
          child: Obx(() {
            if (controller.isloading.value)
              return Column(
                children: List.generate(10, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Shimmer.fromColors(
                      direction: ShimmerDirection.ttb,
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  );
                }),
              );

            return Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Palette.Kmain,
                          Palette.Kmain,
                        ],
                        stops: [0.0, 0.8], // ✅ Correct stops
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.12,
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(8.0),
                          margin: const EdgeInsets.only(top: 10),
                          child: controller.isloading.value
                              ? Column(
                                  children: List.generate(10, (index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          height: 100,
                                          width: double.infinity,
                                          color: Colors.white,
                                          margin: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12),

                                      /// PROFILE IMAGE
                                      leading: CircleAvatar(
                                        radius:
                                            24, // ✅ correct size for ListTile
                                        backgroundColor: Colors.grey.shade300,
                                        child: profilecontroller.isLoading.value
                                            ? const CircularProgressIndicator(
                                                strokeWidth: 2)
                                            : ClipOval(
                                                child: CachedNetworkImage(
                                                  imageUrl: profilecontroller
                                                              .profilemodel
                                                              ?.userimage !=
                                                          null
                                                      ? "${Rs_hrms_config.imageLink}/${profilecontroller.profilemodel!.userimage}"
                                                      : "",
                                                  width: 48,
                                                  height: 48,
                                                  fit: BoxFit.cover,
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.person,
                                                          size: 28,
                                                          color: Colors.grey),
                                                ),
                                              ),
                                      ),

                                      /// NAME
                                      title: profilecontroller.isLoading.value
                                          ? const SizedBox(
                                              height: 16,
                                              width: 16,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2),
                                            )
                                          : Text(
                                              profilecontroller
                                                      .profilemodel.empname!
                                                      .contains(' ')
                                                  ? profilecontroller
                                                      .profilemodel.empname!
                                                      .split(' ')
                                                      .take(2)
                                                      .join(' ')
                                                  : profilecontroller
                                                      .profilemodel.empname!,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),

                                      /// DEPARTMENT
                                      subtitle: profilecontroller
                                              .isLoading.value
                                          ? null
                                          : Text(
                                              profilecontroller.profilemodel
                                                      .department ??
                                                  "",
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontFamily: 'Poppins-Medium',
                                              ),
                                            ),

                                      /// NOTIFICATION ICON
                                      trailing: Badge(
                                        label: Obx(
                                          () => Text(
                                              "${approvaldetailscontroller.count?.value ?? 0}"),
                                        ),
                                        child: InkWell(
                                          onTap: () {
                                            Get.to(() => NotificationsScreen());
                                          },
                                          child: Icon(
                                            Icons.notifications,
                                            color: Palette.Kwhite,
                                            size: 26,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                        Expanded(
                          child: Container(
                            height: MediaQuery.of(context).size.height * 2,
                            width: MediaQuery.of(context).size.width,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(35),
                                topRight: Radius.circular(35),
                              ),
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  //  height: 200,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(formattedDate,
                                              style: TextStyle(
                                                color: Colors.black,
                                              )),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          const SizedBox(width: 10),
                                          Container(
                                            height: 30,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(10)),

                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (controller.getTime.signin ==
                                                        null &&
                                                    controller
                                                            .getTime.signout ==
                                                        null)
                                                  SizedBox.shrink()
                                                else if (controller
                                                        .getTime.signout ==
                                                    null)
                                                  Lottie.asset(
                                                      "assets/lottie/Animation - 1732192021112.json")
                                                else
                                                  Container(
                                                    width: 20,
                                                    height: 20,
                                                    child: Image.asset(
                                                      "assets/images/timer.webp",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                if (controller.getTime.signin ==
                                                        null &&
                                                    controller
                                                            .getTime.signout ==
                                                        null)
                                                  Text("--:--")
                                                else if (controller
                                                        .getTime.signout ==
                                                    null)
                                                  Obx(() {
                                                    // Calculate hours, minutes, and seconds from Rx<int>
                                                    int totalSeconds =
                                                        controller
                                                            .differenceInSeconds
                                                            .value;

                                                    int hours =
                                                        totalSeconds ~/ 3600;
                                                    int minutes =
                                                        (totalSeconds % 3600) ~/
                                                            60;
                                                    int seconds =
                                                        totalSeconds % 60;

                                                    // Display the time difference
                                                    return Text(
                                                      ' $hours:$minutes:$seconds ',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Palette.Kmain,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    );
                                                  })
                                                else
                                                  Text(
                                                    "${controller.outputSeconds.value}:${controller.outputmin.value}  ",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Palette.Kmain,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                              ],
                                            ),
                                            // child: Center(
                                            //     // child: Text(
                                            //     //   // controller.getTime.signout ==
                                            //     //   //             null &&
                                            //     //   //         controller.getTime
                                            //     //   //                 .signin ==
                                            //     //   //             null
                                            //     //   //     ? "--:--"
                                            //     //   //     : output.toString(),
                                            //     //   timeOfDay.minute.toString(),
                                            //     //   style: TextStyle(
                                            //     //       color: Colors.black),
                                            //     // ),
                                            //     )
                                          ),
                                        ],
                                      ),
                                      Divider(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            "Start time  ",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          Text(
                                            "End time",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20),
                                            child: controller.getTime.signin ==
                                                    null
                                                ? Text(
                                                    "--:--",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    "${controller.dashboardmodel.getime!.signin}",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: controller.getTime.signout ==
                                                    null
                                                ? Text(
                                                    "--:--",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )
                                                : Text(
                                                    "${controller.dashboardmodel.getime!.signout}",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      controller.getTime.signin != null &&
                                              controller.getTime.signout != null
                                          ? Center(
                                              child: Container(
                                                padding: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: Text(
                                                  "Checked out! Your session has ended.",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 10),
                                                ),
                                              ),
                                            )
                                          : Obx(() {
                                              if (attendencecontroller
                                                  .loading.value) {
                                                return CircularProgressIndicator
                                                    .adaptive(
                                                  backgroundColor: Colors.white,
                                                ); // Show loader if loading
                                              } else {
                                                // If attendance is not marked (markatt is false)
                                                if (controller.dashboardmodel
                                                        .markatt ==
                                                    false) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // Check if attendance is already marked
                                                      if (controller
                                                              .dashboardmodel
                                                              .markatt ==
                                                          false) {
                                                        attendencecontroller
                                                                .GetMarkAttendence()
                                                            .then((_) {
                                                          // After marking attendance, update the screen
                                                          setState(
                                                              () {}); // Refresh the widget after marking attendance
                                                        });
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(0, 3),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Palette.Kmain,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Clock IN",
                                                          style: TextStyle(
                                                              color: Palette
                                                                  .Kwhite,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                } else {
                                                  // If attendance is already marked, show "" and the logout dialog
                                                  return GestureDetector(
                                                    onTap: () {
                                                      // Show the logout confirmation dialog

                                                      Get.defaultDialog(
                                                        title: "Logout",
                                                        middleText:
                                                            "Are you sure you want to logout?",
                                                        confirm:
                                                            checkoutcontroller
                                                                    .isloading
                                                                    .value
                                                                ? Center(
                                                                    child: CircularProgressIndicator
                                                                        .adaptive(),
                                                                  )
                                                                : ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      Get.snackbar(
                                                                        "Processing Checkout", // Title
                                                                        "Please wait...", // Message
                                                                        icon: Icon(
                                                                            Icons
                                                                                .check_circle,
                                                                            color:
                                                                                Colors.white), // Success icon
                                                                        snackPosition:
                                                                            SnackPosition.top, // Display position
                                                                        backgroundColor:
                                                                            Colors.green, // Green indicates success
                                                                        colorText:
                                                                            Colors.white, // Text color for better contrast
                                                                        borderRadius:
                                                                            8, // Rounded corners
                                                                        margin:
                                                                            EdgeInsets.all(10), // Padding around the snackbar
                                                                        duration:
                                                                            Duration(seconds: 3), // Visibility duration
                                                                      );

                                                                      checkoutcontroller
                                                                              .Logout()
                                                                          .then(
                                                                              (_) {
                                                                        // Refresh after logout if needed
                                                                        setState(
                                                                            () {});
                                                                      });
                                                                      // : Get.snackbar(
                                                                      //     "Session",
                                                                      //     "You are already logged out!",
                                                                      //     snackPosition:
                                                                      //         SnackPosition
                                                                      //             .top,
                                                                      //     backgroundColor:
                                                                      //         Colors
                                                                      //             .red,
                                                                      //     colorText:
                                                                      //         Colors
                                                                      //             .white,
                                                                      //   );

                                                                      Get.backLegacy();

                                                                      Get.back(); // Close the dialog
                                                                    },
                                                                    child: Text(
                                                                        "Yes"),
                                                                  ),
                                                        cancel: TextButton(
                                                          onPressed: () {
                                                            Get.back(); // Close the dialog

                                                            Get.backLegacy();
                                                          },
                                                          child: Text("No"),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 5,
                                                            blurRadius: 7,
                                                            offset:
                                                                Offset(0, 3),
                                                          ),
                                                        ],
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.white,
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "Clock Out",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            }),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5), 
                                Divider(
                                  indent: 20,
                                  endIndent: 20,
                                ),
                                SizedBox(height: 15),
                                controller.brithdayslist.isEmpty
                                    ? SizedBox.shrink()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align to the left

                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center, // 🔥 important
                                            children: [
                                              SizedBox(width: 10),
                                              Icon(
                                                Icons.cake,
                                                size: 24,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                "Wish Them",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.7,
                                                  height:
                                                      1.3, // 🔥 aligns text with icon
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 10.0,
                                          //       top: 4.0,
                                          //       bottom:
                                          //           8.0), // Reduced top padding
                                          //   child: Container(
                                          //     height:
                                          //         1.5, // Slightly thicker line
                                          //     width: 120,
                                          //     color: Palette.Ksecondary,
                                          //   ),
                                          // ),

                                          // Underline with reduced spacing
                                        ],
                                      ),
                                controller.brithdayslist.isEmpty
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 120,
                                        child: BirthdayWidget(),
                                      ),
                                SizedBox(
                                  height: 25,
                                ),
                                controller.activitieslist.isEmpty
                                    ? SizedBox.shrink()
                                    : Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start, // Align to the left

                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .center, // 🔥 key line
                                            children: [
                                              const SizedBox(width: 10),
                                              const Icon(
                                                Icons.calendar_month,
                                                size: 24, // match text visually
                                              ),
                                              const SizedBox(width: 10),
                                              const Text(
                                                "Upcoming Activities",
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17,
                                                  fontFamily: 'Poppins-Medium',
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.7,
                                                  height:
                                                      1.3, // 🔥 aligns text vertically
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Underline with reduced spacing
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 10.0,
                                          //       top: 4.0,
                                          //       bottom:
                                          //           8.0), // Reduced top padding
                                          //   child: Container(
                                          //     height:
                                          //         1.5, // Slightly thicker line
                                          //     width: 220,
                                          //     color: Palette.Ksecondary,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                SizedBox(
                                  height: 10,
                                ),
                                controller.activitieslist.isEmpty
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Activities(),
                                      )
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 60,
                )
              ],
            );
          }),
        ),
      ),
    );
  }
}
