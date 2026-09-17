import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/Halfdaylistmodel.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/Themecolor/Palette.dart';
import 'package:hrapp/common/Textfromfield.dart';
import 'package:hrapp/features/leave/controllers/HalfDayleavecontroller.dart';
import 'package:hrapp/view/navbar.dart';

import 'package:intl/intl.dart';

class Halffrom extends StatelessWidget {
  Halffrom({super.key});

  @override
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    void fromsubmit(Leaverequestmodel leavemodel) {
      if (_key.currentState!.validate()) {
        Get.snackbar(
          'Success', 'Leave request submitted successfully',

          snackPosition: SnackPosition.top, // Position of the snackbar
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Navigator.pushNamed(context, '/leavedashboard');
      } else {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    Leaverequestmodel leaverequestmodel = Leaverequestmodel();
    final halfday = Get.put(Halfdayleavecontroller());
    Halfdaylistmodel halfdaylistmodel = Halfdaylistmodel();

    String txtDate = DateFormat('d MMM yyyy').format(DateTime.now());

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

        halfday.fromdatecontroller.text = txtDate;

        // setState(() {
        //   fromdate.text = txtDate;

        //   //set foratted date to TextField value.
        // });
      } else {
        print("Date is not SELECT");
      }
    }

    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Palette.KmainLight1.withOpacity(0.15),
        title: Text("Half day "),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _key,
          child: Column(
            children: [
              Textfromfield(
                validator: (Value) {
                  if (Value == null || Value.isEmpty) {
                    return " Please enter the date";
                  }
                  return null;
                },
                controller: halfday.fromdatecontroller,
                onTap: _fromDate,
                label: "Select date",
              ),
              SizedBox(
                height: 30,
              ),
              Textfromfield(
                validator: (Value) {
                  if (Value == null || Value.isEmpty) {
                    return "Please enter the Remarks";
                  }
                  return null;
                },
                controller: halfday.remarkcontroller,
                label: "Remarks",
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                      color: Palette.KmainDark1,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        leaverequestmodel.ishalfday = halfday.ishalfday = true;
                        leaverequestmodel.ishalfday = halfday.issubmit = true;

                        halfday.ishalfday = true;
                        halfday.issubmit = true;

                        leaverequestmodel.wFStatus =
                            halfday.WFStatuscontroller.text = 'P';
                        halfday.Postleaverequest(halfdaylistmodel);

                        fromsubmit(leaverequestmodel);
                        if (halfday.fromdatecontroller.text.isNotEmpty &&
                            halfday.fromdatecontroller.text.isNotEmpty) {
                          Get.offAll(() => Navbar());
                        }
                      }),
                  MaterialButton(
                      color: Palette.Ksecondary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      height: 50,
                      minWidth: MediaQuery.of(context).size.width * 0.4,
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        leaverequestmodel.ishalfday = halfday.ishalfday = true;
                        leaverequestmodel.ishalfday = halfday.issubmit = false;

                        halfday.ishalfday = true;
                        halfday.issubmit = false;

                        leaverequestmodel.wFStatus =
                            halfday.WFStatuscontroller.text = 'P';
                        halfday.Postleaverequest(halfdaylistmodel);

                        fromsubmit(leaverequestmodel);
                        if (halfday.fromdatecontroller.text.isNotEmpty &&
                            halfday.fromdatecontroller.text.isNotEmpty) {
                          Get.offAll(() => Navbar());
                        }
                      })
                ],
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       MaterialButton(
      //           color: Colors.green,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(50)),
      //           height: 50,
      //           minWidth: MediaQuery.of(context).size.width * 0.4,
      //           child: Text(
      //             "Submit",
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           onPressed: () {
      //             leaverequestmodel.ishalfday = halfday.ishalfday = true;
      //             leaverequestmodel.ishalfday = halfday.issubmit = true;

      //             leaverequestmodel.wFStatus =
      //                 halfday.WFStatuscontroller.text = 'P';
      //             halfday.Postleaverequest(halfdaylistmodel);

      //             fromsubmit(leaverequestmodel);
      //           }),
      //       MaterialButton(
      //           color: Colors.blue,
      //           shape: RoundedRectangleBorder(
      //               borderRadius: BorderRadius.circular(50)),
      //           height: 50,
      //           minWidth: MediaQuery.of(context).size.width * 0.4,
      //           child: Text(
      //             "Save",
      //             style: TextStyle(color: Colors.white),
      //           ),
      //           onPressed: () {
      //             leaverequestmodel.ishalfday = halfday.ishalfday = true;
      //             leaverequestmodel.ishalfday = halfday.issubmit = false;

      //             leaverequestmodel.wFStatus =
      //                 halfday.WFStatuscontroller.text = 'P';
      //             halfday.Postleaverequest(halfdaylistmodel);

      //             fromsubmit(leaverequestmodel);
      //           })
      //     ],
      //   ),
      // ),
    );
  }
}
