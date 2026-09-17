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

class HafyDayWidget extends StatelessWidget {
  HafyDayWidget({super.key});

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final halfday = Get.put(Halfdayleavecontroller());
    Leaverequestmodel leaverequestmodel = Leaverequestmodel();
    Halfdaylistmodel halfdaylistmodel = Halfdaylistmodel();

    Future<void> fromsubmit(Halfdaylistmodel halfdaymodel) async {
      if (_key.currentState!.validate()) {
        try {
          await halfday.Postleaverequest(halfdaymodel); // ✅ API first

          Get.snackbar(
            'Success',
            'Leave request submitted successfully',
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Get.offAll(() => Navbar()); // ✅ then navigate
          Navigator.pop(context); // close sheet
        } catch (e) {
          Get.snackbar(
            "Error",
            "Something went wrong",
            snackPosition: SnackPosition.top,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
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

    void _fromDate() async {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        String formattedDate = DateFormat('d MMM yyyy').format(pickedDate);

        halfday.fromdatecontroller.text = formattedDate;
      }
    }

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min, // important
            children: [
              Text(
                "Half Day Leave",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Textfromfield(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter the date";
                  }
                  return null;
                },
                controller: halfday.fromdatecontroller,
                onTap: _fromDate,
                label: "Select date",
              ),
              SizedBox(height: 20),
              Textfromfield(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter remarks";
                  }
                  return null;
                },
                controller: halfday.remarkcontroller,
                label: "Remarks",
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MaterialButton(
                      color: Palette.KmainDark1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      child:
                          Text("Submit", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        halfday.ishalfday = true;
                        halfday.issubmit = true;

                        leaverequestmodel.wFStatus =
                            halfday.WFStatuscontroller.text = 'P';
                        await fromsubmit(halfdaylistmodel);

                        // Navigator.pop(context); // close sheet
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: MaterialButton(
                      color: Palette.Ksecondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      height: 50,
                      child:
                          Text("Save", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        halfday.ishalfday = true;
                        halfday.issubmit = false;

                        leaverequestmodel.wFStatus =
                            halfday.WFStatuscontroller.text = 'P';

                        await fromsubmit(halfdaylistmodel);

                        // Navigator.pop(context); // close sheet
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
