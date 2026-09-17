import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hrapp/features/leave/models/AllLeavemodel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/features/leave/controllers/Leave_Type_Controller.dart';
import 'package:hrapp/features/leave/controllers/updatedleavecontroller.dart';
import 'package:hrapp/main.dart';
import 'package:hrapp/view/navbar.dart';

import 'package:intl/intl.dart';

class Fromeditscreen2 extends StatefulWidget {
  final Allleavemodel allleavemodel;

  final String leavedays;

  const Fromeditscreen2(
      {super.key, required this.allleavemodel, required this.leavedays});

  @override
  State<Fromeditscreen2> createState() => _Fromeditscreen2State();
}

class _Fromeditscreen2State extends State<Fromeditscreen2> {
  final updatedleavecontroller = Get.put(Updatedleavecontroller());
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final leaveTypeController = Get.find<LeaveTypeController>();
  @override
  void initState() {
    super.initState();

    // Set remarks
    updatedleavecontroller.remarkcontroller.text =
        widget.allleavemodel.Remarks ?? '';

    // Format and set dates
    final fromDateTime =
        DateTime.parse(widget.allleavemodel.fromDate.toString());
    final toDateTime = DateTime.parse(widget.allleavemodel.todate.toString());
    final fromDateFormatted = DateFormat('d MMM yyyy').format(fromDateTime);
    final toDateFormatted = DateFormat('d MMM yyyy').format(toDateTime);

    String todate = DateFormat('d MMM yyyy').format(toDateTime).toLowerCase();

    String? newtodate;

    String? to;

    if (todate == "1 jan 0001") {
      newtodate = ""; // You don't need to assign todate again
      to = "";
    } else {
      newtodate = toDateFormatted;
      to = "-";
    }

    updatedleavecontroller.fromdatecontroller.text = fromDateFormatted;
    updatedleavecontroller.todatecontroller.text =
        "$fromDateFormatted $to $newtodate";
    updatedleavecontroller.startdate = fromDateFormatted;
    updatedleavecontroller.enddate = toDateFormatted;
    updatedleavecontroller.Leavesdays.text =
        widget.allleavemodel.Leavedays.toString();

    // Set default leave type for DropDownTextField
    final leaveTypeValue = widget.allleavemodel.LeaveType ?? 0;

    Future<void> scheduleNotification(String msg) async {
      // Android notification setup
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'leave_channel_id', // Channel ID
        'Leave Notifications', // Channel name
        channelDescription:
            'Notifications about leave requests', // Add this for Android 12+
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      );

      // iOS notification setup
      const DarwinNotificationDetails iosPlatformChannelSpecifics =
          DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      // Combine both
      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iosPlatformChannelSpecifics,
      );

      // Show notification
      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        'Leave Submitted Successfully',
        msg,
        platformChannelSpecifics,
      );
    }
    // Set the default value in the controller

    print("Selected Leave Type: ${updatedleavecontroller.selectedLeaveType}");
  }

  @override
  Widget build(BuildContext context) {
    void fromsubmit(bool isSummit, String msg) async {
      if (_formkey.currentState!.validate()) {
        updatedleavecontroller.WFStatuscontroller.text = 'P';
        updatedleavecontroller.ishalfday =
            widget.allleavemodel.ishalfday ?? false;
        updatedleavecontroller.issubmit = isSummit;
        await updatedleavecontroller.Updatedleave(widget.allleavemodel.id);

        Get.snackbar(
          'Success',
          'Leave successfully $msg',
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => Navbar());
      } else {
        Get.snackbar(
          'Error',
          'Please fill all required fields',
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    Future<void> pickDateRange(BuildContext context) async {
      final now = DateTime.now();

      // DateTime initial = widget.allleavemodel.fromDate != null
      //     ? DateTime.parse(widget.allleavemodel.fromDate!)
      //     : now;
      DateTime start = widget.allleavemodel.fromDate != null
          ? DateTime.parse(widget.allleavemodel.fromDate!)
          : now;

      DateTime end = widget.allleavemodel.todate != null
          ? DateTime.parse(widget.allleavemodel.todate!)
          : now.add(Duration(days: 1));

      final startDate = now;
      final endDate = DateTime(now.year, now.month + 6, now.day);

      final pickedRange = await showDateRangePicker(
        context: context,

        firstDate: DateTime(2000), // edit safe
        lastDate: endDate,
        initialDateRange: DateTimeRange(
          start: start,
          end: end,
        ),
      );

      if (pickedRange != null) {
        final formatter = DateFormat('d MMM yyyy');
        final formattedStartDate = formatter.format(pickedRange.start);
        final formattedEndDate = formatter.format(pickedRange.end);

        updatedleavecontroller.todatecontroller.text =
            "$formattedStartDate - $formattedEndDate";
        updatedleavecontroller.startdate = formattedStartDate;
        updatedleavecontroller.enddate = formattedEndDate;
        await updatedleavecontroller.Getdayscal();
      }
    }

    String txtDate = DateFormat('d MMM yyyy').format(DateTime.now());
    void _fromDate() async {
      final now = DateTime.now();

      DateTime initial = widget.allleavemodel.fromDate != null
          ? DateTime.parse(widget.allleavemodel.fromDate!)
          : now;

      //  String formattedDate =
      //   DateFormat('d MMM yyyy').format(widget.allleavemodel.fromDate);
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000), // edit safe
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

        updatedleavecontroller.todatecontroller.text = txtDate;

        // setState(() {
        //   fromdate.text = txtDate;

        //   //set foratted date to TextField value.
        // });
      } else {
        print("Date is not SELECT");
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
                size: 25,
                color: Colors.blue,
              ))
        ],
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Leave Edit",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                /// DATE FIELD
                TextFormField(
                  readOnly: true,
                  onTap: () => widget.allleavemodel.ishalfday == true
                      ? _fromDate()
                      : pickDateRange(context),
                  controller: updatedleavecontroller.todatecontroller,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: "Choose any date",
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter any date";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                /// LEAVE DAYS
                widget.allleavemodel.ishalfday == false
                    ? TextFormField(
                        readOnly: true,
                        controller: updatedleavecontroller.Leavesdays,
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
                      )
                    : const SizedBox.shrink(),

                widget.allleavemodel.ishalfday == false
                    ? const SizedBox(height: 20)
                    : const SizedBox.shrink(),

                /// DROPDOWN
                widget.allleavemodel.ishalfday == false
                    ? DropDownTextField(
                        // initialValue: widget.allleavemodel.LeaveType,
                        enableSearch: true,
                        controller: updatedleavecontroller.cnt,
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
                          if (value!.isEmpty) {
                            return "please enter your leave type";
                          }
                          return null;
                        },
                        onChanged: (val) {
                          updatedleavecontroller.selectedLeaveType = val.value;
                        },
                      )
                    : const SizedBox.shrink(),

                widget.allleavemodel.ishalfday == false
                    ? const SizedBox(height: 20)
                    : const SizedBox.shrink(),

                /// REMARK
                TextFormField(
                  controller: updatedleavecontroller.remarkcontroller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.edit),
                    labelText: "Enter remarks",
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

                /// BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      fromsubmit(true, 'Submitted');

                      // await  scheduleNotification();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        fromsubmit(false, 'Saved');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Palette.Ksecondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child:
                          Obx(() => updatedleavecontroller.isloadingSave.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
