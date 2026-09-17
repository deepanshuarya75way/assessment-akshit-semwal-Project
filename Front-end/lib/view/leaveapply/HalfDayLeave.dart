import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:hrapp/features/leave/models/Halfdaylistmodel.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/features/leave/controllers/HalfDayleavecontroller.dart';
import 'package:hrapp/view/navbar.dart';
import 'package:hrapp/view/pages/approvedpage.dart';
import 'package:hrapp/view/pages/leavedashboard.dart';
import 'package:intl/intl.dart';

class Halfdayleave extends StatelessWidget {
  const Halfdayleave({super.key});

  @override
  Widget build(BuildContext context) {
    final halfday = Get.put(Halfdayleavecontroller());
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
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
        print("Date is not selected");
      }
    }
    // Leaverequestmodel leaverequestmodel = Leaverequestmodel();

    Halfdaylistmodel halfdaylistmodel = Halfdaylistmodel();

    void fromsubmit(Halfdaylistmodel halfdaymodel) async {
      if (_formkey.currentState!.validate()) {
        Get.snackbar(
          'Success', 'Leave request submitted successfully',

          snackPosition: SnackPosition.top, // Position of the snackbar
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAll(() => Navbar());
      } else {
        Get.snackbar(
          "Error",
          "Please fill all required fields",
          snackPosition: SnackPosition.top,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      ;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Half day"),
        centerTitle: true,
      ),
      body: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  onTap: _fromDate,
                  controller: halfday.fromdatecontroller,
                  // controller: Addfulldayleave.fromdatecontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    label: const Text("From date"),
                  ),
                  validator: (Value) {
                    if (Value == null || Value.isEmpty) {
                      return "Please enter the dat";
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: halfday.remarkcontroller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    label: const Text("remarks"),
                  ),
                  validator: (Value) {
                    if (Value == null || Value.isEmpty) {
                      return "Please enter the your remarks";
                    }
                    return null;
                  },
                ),
              ),
            ],
          )),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            MaterialButton(
              onPressed: () {
                halfdaylistmodel.wfstatus =
                    halfday.WFStatuscontroller.text = "P";

                halfday.ishalfday = true;
                halfday.issubmit = true;
                halfday.Postleaverequest(halfdaylistmodel);

                fromsubmit(halfdaylistmodel);
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              height: 50,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              child: const Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 20,
            ),
            MaterialButton(
              onPressed: () {
                halfdaylistmodel.wfstatus =
                    halfday.WFStatuscontroller.text = "P";

                halfday.ishalfday = true;
                halfday.issubmit = false;
                halfday.Postleaverequest(halfdaylistmodel);

                fromsubmit(halfdaylistmodel);
              },
              color: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              height: 50,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
