import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hrapp/features/leave/models/DayCalmodel.dart';
import 'package:hrapp/features/leave/models/LeaveRequestModel.dart';
import 'package:hrapp/common/Textfromfield.dart';
import 'package:hrapp/features/leave/controllers/LeaveRequestController.dart';
import 'package:hrapp/view/pages/leavedashboard.dart';
import 'package:intl/intl.dart';

class Fulldayleavefrom extends StatelessWidget {
  const Fulldayleavefrom({super.key});

  @override
  Widget build(BuildContext context) {
    Leaverequestmodel leaverequestmodel = Leaverequestmodel();
    final leaverequest = Get.put(Leaverequestcontroller());

    String txtDate = DateFormat('d MMM yyyy').format(DateTime.now());

    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    void fromsubmit(Leaverequestmodel leaverequest) async {
      if (_formkey.currentState!.validate()) {
        Get.snackbar(
          'Success', 'Leave request submitted successfully',

          snackPosition: SnackPosition.top, // Position of the snackbar
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.offAll(() => Leavedashboard());
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

    // final SingleValueDropDownController _cnt = SingleValueDropDownController();

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

        leaverequest.fromdatecontroller.text = txtDate;

        // setState(() {
        //   fromdate.text = txtDate;

        //   //set foratted date to TextField value.
        // });
      } else {
        print("Date is not selected");
      }
    }

    void _toDate() async {
      final now = DateTime.now();

      // final firstdate = DateTime(now.year - 1, now.month, now.day);
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: now, //get today's date
          firstDate: DateTime
              .now(), //DateTime.now() - not to allow to choose before today.
          lastDate: DateTime(2050));

      if (pickedDate != null) {
        print(
            pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000
        String formattedDate = DateFormat('d MMM yyyy').format(
            pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
        print(
            formattedDate); //formatted date output using intl package =>  2022-07-04
        //You can format date as per your need

        leaverequest.todatecontroller.text = formattedDate;
        // setState(() {
        //   todate.text = formattedDate;
        //   daysCalModel.fromdate = fromdate.text;
        //   daysCalModel.todate = todate.text;
        // });

        // DaysCalResponson daysCalResponson =
        //     await dayService.postdaycount(daysCalModel);
        // setState(() {
        //   //set foratted date to TextField value.

        //   leaveday.text = daysCalResponson.dayscalculate.toString();
        // });
      } else {
        print("Date is not selected");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Full day Leave"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Textfromfield(
                        controller: leaverequest.fromdatecontroller,
                        onTap: _fromDate,
                        label: "Enter your from date",
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "Please enter the date";
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Textfromfield(
                        validator: (Value) {
                          if (Value == null || Value.isEmpty) {
                            return "Please enter the date";
                          }
                          return null;
                        },
                        onTap: _toDate,
                        controller: leaverequest.todatecontroller,
                        label: "Enter your to date",
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: leaverequest.Leavesdays,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      labelText: 'Remarks',
                      //lable style
                      labelStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: "verdana_regular ",
                        fontWeight: FontWeight.w400,
                      ),
                      hintText: "Remarks"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your Remarks';
                    }
                    return null;
                  },
                ),
              ),

              SizedBox(
                height: 20,
              ),
              DropDownTextField(
                enableSearch: true,
                clearIconProperty: IconProperty(color: Colors.green),
                searchTextStyle: const TextStyle(color: Colors.red),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter your leave type ";
                  } else {
                    return null;
                  }
                },
                controller: leaverequest.cnt,
                dropDownItemCount: 13,
                dropDownList: const [
                  DropDownValueModel(name: "Annual Leave", value: 1),
                  DropDownValueModel(name: "Sick", value: 2),
                  DropDownValueModel(name: "Sick Leave Half Pay", value: 4),
                  DropDownValueModel(name: "Unpaid Leave", value: 10004),
                  DropDownValueModel(
                      name: "Sick Leave Without Pay", value: 20013),
                  DropDownValueModel(name: "Half Day Leave", value: 40015),
                  DropDownValueModel(name: "Covid Leave", value: 20005),
                  DropDownValueModel(name: "Bereavement Leave", value: 20008),
                  DropDownValueModel(name: "Marriage Leave", value: 20011),
                  DropDownValueModel(name: "Maternity Leave", value: 20012),
                  DropDownValueModel(name: "Emergency Leave", value: 30015),
                  DropDownValueModel(name: "Hajj Leave", value: 20014),
                  DropDownValueModel(name: "Umrah Leave", value: 20015)
                ],
                // clearOption: true,
                textFieldDecoration: InputDecoration(
                  hintText: "Select an option",
                ),
                onChanged: (val) {
                  // int? leaveid = _cnt.dropDownValue!.value;
                  leaverequest.cnt.dropDownValue = val;
                  // leaverequest.cnt.dropDownValue = val;

                  print(leaverequest.cnt.dropDownValue);

                  // Handle the selected value
                  // print(_cnt.dropDownValue!.value);
                  // leaveTypeId = _cnt.dropDownValue!.value;
                  //   leavetypecon.text = val;
                },
              ),
              // Textfromfield(
              //   label: "Drop down",
              //   readOnly: false,
              // ),
              SizedBox(
                height: 40,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: leaverequest.remarkcontroller,
              //     keyboardType: TextInputType.text,
              //     decoration: InputDecoration(
              //         border: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         enabledBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         focusedBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //           borderSide: const BorderSide(color: Colors.grey),
              //         ),
              //         errorBorder: OutlineInputBorder(
              //           borderRadius: BorderRadius.circular(10),
              //           borderSide: const BorderSide(color: Colors.red),
              //         ),
              //         labelText: 'Remarks',
              //         //lable style
              //         labelStyle: TextStyle(
              //           color: Colors.grey,
              //           fontSize: 16,
              //           fontFamily: "verdana_regular ",
              //           fontWeight: FontWeight.w400,
              //         ),
              //         hintText: "Remarks"),
              //     validator: (value) {
              //       if (value!.isEmpty) {
              //         return 'please enter your Remarks';
              //       }
              //       return null;
              //     },
              //   ),
              // ),

              // Textfromfield(
              //   controller: leaverequest.remarkcontroller,
              //   label: "Remarks",
              //   validator: (Value) {
              //     if (Value == null || Value.isEmpty) {
              //       return "Please enter the remarks";
              //     }
              //     return null;
              //   },
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.green,
              height: 50,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              onPressed: () {
                // leaverequestmodel.remarks = leaverequest.remarkcontroller.text;

                leaverequestmodel.wFStatus =
                    leaverequest.WFStatuscontroller.text = "P";

                leaverequest.ishalfday = false;
                // leaverequestmodel.ishalfday = false;
                leaverequest.issubmit = true;
                Get.snackbar(
                  'Success', 'Leave request submitted successfully',

                  snackPosition: SnackPosition.top, // Position of the snackbar
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Get.offAll(() => Leavedashboard());

                // leaverequest.Postleaverequest(leaverequestmodel);

                // leaverequestmodel.ishalfday = leaverequest.ishalfday.value = false;
                // leaverequestmodel.issubmit = leaverequest.issubmit.value = false;
                // fromsubmit(leaverequestmodel);
              },
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white),
              ),
            ),
            MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              color: Colors.blue,
              height: 50,
              minWidth: MediaQuery.of(context).size.width * 0.4,
              onPressed: () {
                leaverequestmodel.remarks = leaverequest.remarkcontroller.text;

                leaverequestmodel.wFStatus =
                    leaverequest.WFStatuscontroller.text = "P";

                leaverequest.ishalfday = false;
                // leaverequestmodel.ishalfday = false;
                leaverequest.issubmit = false;

                // leaverequestmodel.ishalfday = leaverequest.ishalfday.value = false;
                // leaverequestmodel.issubmit = leaverequest.issubmit.value = false;
                fromsubmit(leaverequestmodel);
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
