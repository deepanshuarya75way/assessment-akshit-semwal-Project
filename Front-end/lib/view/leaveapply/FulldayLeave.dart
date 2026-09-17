import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/leave/controllers/LeaveRequestController.dart';
import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
import 'package:hrapp/main.dart';
import 'package:hrapp/view/navbar.dart';

import 'package:intl/intl.dart';

class Fulldayleave extends StatelessWidget {
  Fulldayleave({super.key});

  @override
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    final Addfulldayleave = Get.put(Leaverequestcontroller());
    // Addfulldayleave.Getdayscal();
    // LeaveTypeController leaveTypeController = Get.put(LeaveTypeController());

// get .find<LeaveTypeController>();
    // final leaveTypeController = Get.find<LeaveTypeController>();

    LeaveTypeController leaveTypeController =
        Get.put(LeaveTypeController(), permanent: true);

    // Addfulldayleave.Getdayscal();

    Future<void> scheduleNotification(String msg) async {
      int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'leave_channel_id',
        'Leave Notifications',
        channelDescription: 'Notifications about leave requests',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        ticker: 'ticker',
      );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      await flutterLocalNotificationsPlugin.show(
        id,
        'Leave Submitted Successfully',
        msg,
        details,
      );
    }

    String txtDate = DateFormat('d MMM yyyy').format(DateTime.now());
    Leaverequestmodel leaverequestmodel = Leaverequestmodel();

    Future<bool> fromsubmit(Leaverequestmodel leaverequest, String msg) async {
      if (_formkey.currentState!.validate()) {
        await Addfulldayleave.Postleaverequest(leaverequest);

        Get.snackbar(
          'Success',
          'Leave request $msg successfully',
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        return true; // ✅ success
      } else {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return false; // ❌ failed
      }
    }

    void _fromDate() async {
      final now = DateTime.now();
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now, //get today's date
          firstDate: DateTime
              .now(), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2101));

      if (pickedDate != null) {
        print(pickedDate);
        DateFormat('yyyy-MM-dd');

        //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('d MMM yyyy').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        print(
            formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need
        txtDate = formattedDate;

        Addfulldayleave.fromdatecontroller.text = txtDate;
      } else {
        print("Date is not selected");
      }
    }

    // Addfulldayleave.fromdatecontroller.text = txtDate;

    void _toDate() async {
      final now = DateTime.now();
      final DateTime? fromDate = DateFormat('d MMM yyyy')
          .parse(Addfulldayleave.fromdatecontroller.text);

      // final firstdate = DateTime(now.year - 1, now.month, now.day);
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate:
              fromDate!.add(const Duration(days: 1)), //get today's date

          firstDate: fromDate.add(const Duration(
              days: 1)), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2050));

      if (pickedDate != null) {
        print(
            pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('d MMM yyyy').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        print(
            formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need

        Addfulldayleave.todatecontroller.text = formattedDate;
      } else {
        print("Date is not selected");
      }
    }

    Future<void> pickDateRange(BuildContext context) async {
      final DateTime now = DateTime.now();

      // Start from the current date
      final DateTime startDate = now;
      final DateTime startDate1 = DateTime(now.year - 1, now.month, now.day);

      // Allow up to 6 months in the future
      final DateTime endDate = DateTime(now.year, now.month + 6, now.day);

      // End 6 months from the current date
      final DateTime endDate1 = DateTime(now.year, now.month + 6, now.day);

      final DateTimeRange? pickedRange = await showDateRangePicker(
        context: context,
        firstDate: startDate1, // Disable past dates
        lastDate: endDate1, // Extend up to 6 months
      );

      if (pickedRange != null) {
        // Use intl to format the dates
        final DateFormat formatter = DateFormat('d MMM yyyy');
        final String formattedStartDate = formatter.format(pickedRange.start);
        final String formattedEndDate = formatter.format(pickedRange.end);

        // Update the controller with the selected range
        Addfulldayleave.todatecontroller.text =
            "$formattedStartDate - $formattedEndDate";

        // Update individual start and end dates
        Addfulldayleave.startdate = formattedStartDate;
        Addfulldayleave.enddate = formattedEndDate;

        // Call your Getdayscal method
        Addfulldayleave.Getdayscal();
      }
    }

    //

    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Fullday Leave",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// DATE FIELD
                    TextFormField(
                      onTap: () async {
                        await pickDateRange(context);
                      },
                      controller: Addfulldayleave.todatecontroller,
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.calendar_today),
                        labelText: "Select Date",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter to date";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// LEAVE DAYS
                    Obx(() => Addfulldayleave.isloading.value
                        ? const Center(child: CircularProgressIndicator())
                        : TextFormField(
                            readOnly: true,
                            controller: Addfulldayleave.Leavesdays,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.date_range),
                              labelText: "Leave Days",
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          )),

                    const SizedBox(height: 20),

                    /// DROPDOWN
                    DropDownTextField(
                      enableSearch: true,
                      controller: Addfulldayleave.cnt,
                      dropDownItemCount:
                          leaveTypeController.leaveTypeList.length,
                      dropDownList: leaveTypeController.leaveTypeList
                          .map((e) => DropDownValueModel(
                              name: e.leavetype!, value: e.id!))
                          .toList(),
                      textFieldDecoration: InputDecoration(
                        prefixIcon: const Icon(Icons.list),
                        hintText: "Select Leave Type",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please select leave type";
                        }
                        return null;
                      },
                      onChanged: (val) {
                        Addfulldayleave.Leavestype =
                            Addfulldayleave.cnt.dropDownValue!.value;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// REMARK
                    TextFormField(
                      controller: Addfulldayleave.remarkcontroller,
                      maxLines: 3,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.edit),
                        labelText: "Remarks",
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your remarks";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),

        /// BOTTOM BUTTONS (MODERN STYLE)
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 10,
                offset: const Offset(0, -3),
              )
            ],
          ),
          child: Row(
            children: [
              /// SUBMIT
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        leaverequestmodel.wFStatus =
                            Addfulldayleave.WFStatuscontroller.text = "P";

                        Addfulldayleave.ishalfday = false;
                        Addfulldayleave.issubmit = true;

                        bool isValid =
                            await fromsubmit(leaverequestmodel, "submitted");

                        if (isValid) {
                          scheduleNotification(
                              "Your leave request has been submitted successfully and is waiting for approval.");

                          Get.offAll(() => Navbar());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.KmainDark1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Obx(
                        () => Addfulldayleave.isloadingSummit.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : const Text("Submit"),
                      )),
                ),
              ),

              const SizedBox(width: 12),

              /// SAVE
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () async {
                        leaverequestmodel.wFStatus =
                            Addfulldayleave.WFStatuscontroller.text = "P";

                        Addfulldayleave.ishalfday = false;
                        Addfulldayleave.issubmit = false;

                        bool isValid =
                            await fromsubmit(leaverequestmodel, 'saved');

                        if (isValid) {
                          // scheduleNotification(
                          //     "Your leave request has been saved successfully and is waiting for approval.");

                          Get.offAll(() => Navbar());
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.Ksecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Obx(
                        () => Addfulldayleave.isloadingSave.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator.adaptive(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : const Text("Save"),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
